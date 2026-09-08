# Zeek IPSec 协议解析

## 简介

我曾经发布了一片关于 Zeek OpenVPN  Binpac 和 Spicy 协议解析的博客，但是他们只是常见 VPN 协议的一小部分。根据我观测到的结果来看，最常见的四种 VPN 协议是
1. Wireguard
2. OpenVPN
3. IPSec
4. DTLS(通常使用 SSL/TLS 作为备用)

大部分我所遇到的 VPN 客户端都是用上述的四种协议。至今为止，IPSec 是 Zeek 不支持的协议中最复杂的一个，因此我决定使用 Spicy 来对其进行解析。如果你想要使用本文描述的功能，需要安装 Spicy 以及其解析器: https://github.com/zeek/spicy-analyzers

如果你想了解更多关于 OpenVPN 的内容，可以查看博客中的其他文章。DTLS、Wireguard 目前还没有在博客中撰写文章，但是他们的相关源码月可以找到链接。本文的剩余部分，将会对 IPSec 协议进行介绍，并且使用 Spicy 对 IPSec 进行解析

## IPSec 协议

IPSec 是一个很重要的协议，在很多事件下，必须花费时间阅读 RFC 规范来理解协议内容，为实现解析器奠定基础。在本文中涉及的规范如下:
1. https://tools.ietf.org/html/rfc2406 (ESP)
2. https://tools.ietf.org/html/rfc2408 (IKE v1)
3. https://tools.ietf.org/html/rfc2409 (IKE v1)
4. https://tools.ietf.org/html/rfc3948 (ESP packets encapsulated in UDP)
5. https://tools.ietf.org/html/rfc4306 (IKE v2)
6. https://tools.ietf.org/html/rfc7296 (IKE v2)
7. https://tools.ietf.org/html/rfc8229 (ESP packets encapsulated in TCP)

阅读 RFC 规范非常无趣，因此本文将会对重要部分进行高亮。同时还会特别提及在 Binpac 实现过的 IKEv2: https://github.com/ukncsc/zeek-plugin-ikev2/blob/master/src/IKEv2-protocol.pac。本文用到了该项目使用的部分常数和签名

Zeek 可以看到的 IPSec 是通过 UDP、TCP 的部分内容，而不会看到 ISP 的 ESP 数据包，除非这些数据包使用 UDP 或 TCP 封装（通常在 4500 端口）。在 IKE 握手过程中，一旦 NAT 设备位于客户端和服务端之间的任何地方，IPSec 将会切换到封装的 ESP 数据包。此外，IPSec 还需要 IKE 协议，IKE 本身使用 UDP 通信。因此即使我们无法看到本地 ESP 数据包（加密），我们至少也能看到密钥交换的尝试。在绝大多数情况下，当 NAT 设备在路径上时，我们将看到通过 UDP 封装的 ESP 数据包。值得注意的是，在直接点对点传输，未经过地址转换的连接中，不会看到封装的数据包。移动 IPSec 使用 road warrior VPN 配置，导致无法连接至未知网络，因此无法控制是否存在地址转换设备

目前有两个 IPSec 常用端口: 
- 500/UDP: IKE 流量
- 4500/UDP: 封闭 IPSec
- 4500/TCP: 封闭 IPSec

在 IPSec 中，连接使用 IKE 协议在 500/UDP 建立，而后切换至 4500/UDP 进行通信（如果发现 NAT 设备）

一个简单的 IPSec PCAP 文件如下: https://github.com/zeek/spicy-analyzers/blob/main/tests/Traces/ipsec_client.pcap

从 PCAP 文件可见，IPSec 的基础协议时 IKE，而后切换至 ESP。需要明确的是，IKE 拥有两个版本，尽管大部分新设备都使用版本 2，而网络中仍然存在大量使用版本 1 的设备。尽管在 IPSec 中只需要一个协议，但解析器仍然需要对两个协议都进行解析。

### IKE v1

首先要说明的时 IKE 版本 1，其在 RFC 2408 的第 21 页进行描述: https://tools.ietf.org/html/rfc2408#page-21

在 spicy 中，其结构如下

```spicy
public type IPSecIKE = unit {
	# Use this to track state
	var shared_info: SharedInfo;

	initiator_spi: bytes &size=8;
	responder_spi: bytes &size=8;
	next_payload: uint8 &convert=PayloadType($$) { self.shared_info.next_payload = $$; }
	version: bitfield(8) {
		maj: 4..7;
		min: 0..3;
	};
	exchange_type: uint8 &convert=ExchangeType($$);
	flags: bitfield(8) {
		E: 0;
		C: 1;
		A: 2;
		I: 3;
		V: 4;
		R: 5;
		X2: 6..7;
	};
	message_id: uint32;
	length: uint32;
	payloads_v1: IPSecIKEv1_Payload(self.shared_info, self.message_id)[] &size=self.length-28 if (self.version.maj == 1 && !self.flags.E);
	payloads_v2: IPSecIKEv2_Payload(self.shared_info, self.message_id)[] &size=self.length-28 if (self.version.maj == 2);
} &requires=( (self.version.maj == 1 || self.version.maj == 2) && self.version.min == 0 );
```

这里按照 RFC 定义实现了 IKE 数据包的解析，根据 `self.version.maj`，来决定使用 `payloads_v1` 或是 `payloads_v2`。对于 IKEv1，如果 `flags.E` 被设置，那么说明 payload 部分为加密数据，将会忽略对其的解析。

```spicy
type IPSecIKEv1_Payload = unit(inout shared_info: SharedInfo, message_id: uint32) {
	var message_id: uint32 = message_id;

	var this_payload: PayloadType = shared_info.next_payload;

	header: IPSecIKE_Payload_Header { shared_info.next_payload = $$.next_payload; }

	switch ( self.this_payload ) {
		PayloadType::SA_v1 -> payload_sa: IPSecIKEv1_SA_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::P_v1 -> payload_p: IPSecIKEv1_P_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::T_v1 -> payload_t: IPSecIKEv1_T_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::KE_v1 -> payload_ke: IPSecIKEv1_KE_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::ID_v1 -> payload_id: IPSecIKEv1_ID_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::CERT_v1 -> payload_cert: IPSecIKEv1_CERT_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::CR_v1 -> payload_cr: IPSecIKEv1_CR_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::HASH_v1 -> payload_hash: IPSecIKEv1_HASH_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::SIG_v1 -> payload_sig: IPSecIKEv1_SIG_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::NONCE_v1 -> payload_nonce: IPSecIKEv1_NONCE_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::N_v1 -> payload_n: IPSecIKEv1_N_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::D_v1 -> payload_d: IPSecIKEv1_D_Payload(message_id, self.header) &size=self.header.payload_length-4;
		PayloadType::VID_v1 -> payload_vid: IPSecIKEv1_VID_Payload(message_id, self.header) &size=self.header.payload_length-4;
		* -> : bytes &eod;
	};
};
```

IPSecIKE Payload 具有一个固定的头部

```spicy
type IPSecIKE_Payload_Header = unit {
	next_payload: uint8 &convert=PayloadType($$);
	reserved: bitfield(8) {
	  critical: 7;
	};
	payload_length: uint16;
};
```

共有 13 种类型可被解析：
1. SA - Security Association
2. P - Proposal
3. T - Transform
4. KE - Key Exchange
5. ID - Identification
6. CERT - Certificate
7. CR - Certificate Request
8. HASH - Hash
9. SIG - Signature
10. NONCE - Nonce
11. N - Notification
12. D - Delete
13. VID - Vendor ID

IKEv1 包含多种 payloads，每一个都会与下一个包连接，因此需要使用一个共享字段记录包之间的关系

### IKEv2

IKEv2 与 IKEv1 很像，但是对结构顺序重新进行了排序，并且添加了新的类型支持
1. SA - Security Association
2. KE - Key Exchange
3. IDi - Initiator Identification
4. IDr - Responder Identification
5. CERT - Certificate
6. CERTREQ - Certificate Request
7. AUTH - Authentication
8. Ni - Nonce
9. N - Notify
10. D - Delete
11. VID - Vendor ID
12. TSI - Initiator Traffic Selector
13. TSr - Responder Traffic Selector
14. E - Encrypted Payload
15. CP - Configuration
16. EAP - Extensible Authentication Protocol
17. NO_NEXT_PAYLOAD - No next payload

在 IKE 协商完成后，数据将会通过 ESP 发送。由于 Zeek 无法解析通过 IP 传输的 ESP，因此后面以通过 UDP 传输的 ESP 为例。