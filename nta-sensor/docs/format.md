# 格式文档

本文档主要描述了目前支持的协议元数据格式

## 公共格式

### 负载(Payload)

通常用于描述时间序列

```typescript
type Payload = {
  timestamp: time; // 流量发生的时间
  length: number; // 数据包长度
  is_orig: boolean; // 从源端发出的数据包
  type_id?: number; // 数据包类型，部分协议可能不存在该字段
  type_name?: string; // 数据包类型名称，部分协议可能不存在该字段
  optional?: any; // 附加数据，根据格式不同可能是不同内容，部分协议可能不存在该字段
};
```

### 键值对数据(KV)

主要用于保存类型及内容，比如 2 代表“域名”，内容是 `www.baidu.com`

```typescript
type KV = {
  id?: string | number; // ID，部分协议可能不存在
  name: string; // 名称
  value?: any; // 数据，部分协议可能不存在
};
```

### 证书

```typescript
type PublicKey = {
      key_type?:   string;
      key_length?: number;
      curve?:      string;

      // for rsa
      n?:          string; // module
      e?:          string; // exponent

      // for ecdsa
      x?:          string;
      y?:          string;
  };

type Certificate = {
  id?: string; // 证书 ID
  is_orig?: boolean;
  trans_flag?: boolean; // 是否传输过
  thumb_print: string; // sha1 指纹
  version?: number; // 证书版本号
  len?: number; // 证书长度
  serial_number?: string; // 证书序列号
  serial_number_len?: number; // 证书序列号长度
  time_start?: time; // 证书有效期开始时间
  time_stop?: time; // 证书有效期结束时间
  period?: double; // 证书有效期
  self_signed?: boolean; // 自签名
  level?: string; // 证书等级
  sig_nid?: string; // 签名算法 NID
  sig_key_size?: number; // 签名算法 key size 原始值
  pk_nid?: string; // 公钥算法 nid
  pk_keysize?: number; // 证书公钥算法 nid
  cn_wildcard?: boolean; // 使用者 common name 有无通配符
  san_wildcard?: boolean; // san 是否包含通配符
  subject_nid?: string; // 使用者项列表
  subject_common_name?: string; // 使用者 common name
  subject_country_name?: string; // 使用者国家
  subject_org_name?: string; // 使用者组织
  subject_orgunit_name?: string; // 使用者组织unit
  subject_state_name?: string; // 使用者 state 或 province
  subject_local_name?: string; // 使用者 locality
  issuer_nid?: string; // 颁发者列表
  issuer_common_name?: string; // 颁发者 common name
  issuer_country_name?: string; // 颁发者 country
  issuer_org_name?: string; // 颁发者组织
  issuer_org_orgunit_name?: string; // 颁发者组织 unit
  issuer_state_name?: string; // 把拿着 state 或 province
  issuer_local_name?: string; // 颁发者 locality
  extensions_len?: number; // 扩展长度
  extensions_nid?: string; // 扩展项列表
  num_sans?: number; // san 数量
  sans?: string[]; // 证书的有效列表
  is_ca?: boolean; // 是否为 ca
  content?: string; //证书内容
  public_key?: PublicKey; // 公钥部分
};
```

### 基本格式

每个会话的基本格式，

```typescript
type SensorSession = {
  uid: string; // 唯一 ID
  hash: string; // 五元组+时间戳 哈希值，用于标记存储该会话的文件
  source: string; // 产生该数据的 zeek 标记

  // 具体协议
  ip?: IP;
  tcp?: TCP;
  udp?: UDP;
}
```

```json
{
  "uid": "Czi5TO2e59QMQz7T29",
  "hash": "7c71862a4a1178780eaffcd88cfb1cce",
  "source": "zeek-1"
}
```


## 明文协议

### IP

```typescript
type IP = {
  src: string; // 源 IP
  dst: string; // 目标 IP
  proto: number; // 协议
  version: number; // 版本
  length: number; // 长度
  payload: Payload[]; // 时间序列， optional 字段为 TTL
};
```

```json
{
  "uid": "Czi5TO2e59QMQz7T29",
  "hash": "7c71862a4a1178780eaffcd88cfb1cce",
  "source": "zeek-1",
  "ip": {
    "src": "172.21.253.198",
    "dst": "172.21.240.1",
    "protocol": 17,
    "version": 4,
    "length": 370,
    "payload": [
      {
        "timestamp": 1623981474.339115,
        "length": 59,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1623981474.33912,
        "length": 59,
        "is_orig": true,
        "optional": 64
      }
      // ...
    ]
  }
}
```

### UDP

```typescript
type Meta = {
  src: number; // 客户端端口
  dst: number; // 服务端端口
  packet_up: int; // 上行载荷包数
  packet_dn: int; // 下行载荷包数
  byte_up: int; // 上行载荷字节数
  byte_dn: int; // 下行载荷字节数
  payload: Payload[]; // 时间序列
};
```

```json
{
  "uid": "CjLFaB4mIULeXnGzGg",
  "ip": {
    "src": "172.21.253.198",
    "dst": "172.21.240.1",
    "protocol": 17,
    "version": 4,
    "length": 370,
    "payload": [
      {
        "timestamp": 1623981474.339115,
        "length": 59,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1623981474.33912,
        "length": 59,
        "is_orig": true,
        "optional": 64
      }
      // ...
    ]
  },
  "udp": {
    "src": 46040,
    "dst": 53,
    "packet_up": 2,
    "packet_dn": 2,
    "byte_up": 62,
    "byte_dn": 196,
    "payload": [
      {
        "timestamp": 1623981474.339115,
        "length": 31,
        "is_orig": true
      },
      {
        "timestamp": 1623981474.33912,
        "length": 31,
        "is_orig": true
      }

      // ...
    ]
  }
}
```

### TCP

```typescript
type TCP = {
  client_port: number; // 客户端端口
  server_port: number; // 服务端端口
  packet_up: int; // 上行载荷包数
  packet_dn: int; // 下行载荷包数
  byte_up: int; // 上行载荷字节数
  byte_dn: int; // 下行载荷字节数
  packet_retrans_up: int; // 上行重传包数
  byte_retrans_up: int; // 上行重传字节数
  packet_retrans_dn: int; // 下行重传包数
  byte_retrans_dn: int; // 下行重传字节数
  payload: Payload[]; // 时间序列;
};
```

### DNS

```typescript
type Query = {
  query?: string; // 查询的域名
  qtype?: string; // 查询类型
  qclass?: string; // 查询类别
  answers?: string[]; // 回复的域名、IP
};

type DNS = {
  queries: Query[]; // 查询列表
};
```

```json
{
  "uid": "CjLFaB4mIULeXnGzGg",
  "ip": {
    "src": "172.21.253.198",
    "dst": "172.21.240.1",
    "protocol": 17,
    "version": 4,
    "length": 370,
    "payload": [
      {
        "timestamp": 1623981474.339115,
        "length": 59,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1623981474.33912,
        "length": 59,
        "is_orig": true,
        "optional": 64
      }
      // ...
    ]
  },
  "udp": {
    "src": 46040,
    "dst": 53,
    "packet_up": 2,
    "packet_dn": 2,
    "byte_up": 62,
    "byte_dn": 196,
    "payload": [
      {
        "timestamp": 1623981474.339115,
        "length": 31,
        "is_orig": true
      },
      {
        "timestamp": 1623981474.33912,
        "length": 31,
        "is_orig": true
      }

      // ...
    ]
  },
  "dns": {
    "queries": [
      {
        "query": "www.baidu.com",
        "qtype": "A",
        "qclass": "C_INTERNET",
        "answers": ["www.a.shifen.com", "110.242.68.3", "110.242.68.4"]
      },
      {
        "query": "www.baidu.com",
        "qtype": "AAAA",
        "qclass": "C_INTERNET",
        "answers": ["www.a.shifen.com"]
      }
    ]
  }
}
```

### SMTP

```typescript
type SMTP = {
  helo: string; // HELO 命令
  mailfrom: string; // MAIL FROM 命令
  recptto: string; // RCPT TO 命令
  date: string; // DATA 命令
  user_agent: string; // USER AGENT 命令
  subject: string; // SUBJECT 命令
  charset: string; // CHARSET 命令
  subject_base64: string; // SUBJECT 命令，base64 编码
  data: string; // DATA 命令
  auth_type: string; // AUTH 命令内容
  auth_content: string; // AUTH 命令内容（密码）
};
```

```json
{
  "uid": "CO7U0PklHGe9IVi03",
  "ip": {
    "src": "172.19.16.65",
    "dst": "109.244.196.69",
    "protocol": 6,
    "version": 4,
    "length": 1841,
    "payload": [
      {
        "timestamp": 1625883295.461517,
        "length": 60,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1625883295.512664,
        "length": 52,
        "is_orig": false,
        "optional": 49
      }
      // ...
    ]
  },
  "tcp": {
    "client_port": 53934,
    "server_port": 25,
    "packet_up": 13,
    "packet_dn": 15,
    "byte_up": 411,
    "byte_dn": 278,
    "packet_retrans_up": 0,
    "byte_retrans_up": 0,
    "packet_retrans_dn": 0,
    "byte_retrans_dn": 0,
    "payload": [
      {
        "timestamp": 1625883295.461517,
        "length": 0,
        "is_orig": true,
        "type_name": "S",
        "optional": [0, 0]
      },
      {
        "timestamp": 1625883295.512664,
        "length": 0,
        "is_orig": false,
        "type_name": "SA",
        "optional": [0, 1]
      }
      // ...
    ]
  },
  "smtp": {
    "helo": "OhYee.localdomain",
    "mailfrom": "oyohyee@oyohyee.com",
    "rcptto": ["oyohyee@oyohyee.com"],
    "date": "",
    "user_agent": "",
    "charset": "utf-8",
    "subject_base64": "5rWL6K+V",
    "data": "<a href='www.oyohyee.com'>OhYee</a>",
    "auth_type": "PLAIN",
    "auth_content": "AG95b2h5ZWVAb3lvaHllZS5jb20AcGFzc3dvcmQxMg=="
  }
}
```

### HTTP

```typescript
type HTTP = {
  method: string; // 请求方法
  host: string; // 请求的主机
  uri: string; // 请求的 URI
  version: string; // 请求的 HTTP 版本
  content_type: string; // 请求的内容类型
  upgrade: string; // 请求的升级协议
  status: KV; // 请求的状态码
  src_headers: { [key: string]: string }; // 请求的头部
  dst_headers: { [key: string]: string }; // 响应的头部
  payload: Payload[]; // 时间序列（大部分情况下应该是一个请求和一个响应两个包）
};
```

```json
{
  "uid": "CqiTLU3FWHy78ef5he",
  "ip": {
    "src": "172.21.253.198",
    "dst": "27.211.197.171",
    "protocol": 6,
    "version": 4,
    "length": 1090,
    "payload": [
      {
        "timestamp": 1623981472.019806,
        "length": 60,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1623981472.155282,
        "length": 52,
        "is_orig": false,
        "optional": 52
      }
      // ...
    ]
  },
  "tcp": {
    "client_port": 43854,
    "server_port": 80,
    "packet_up": 7,
    "packet_dn": 4,
    "byte_up": 78,
    "byte_dn": 540,
    "packet_retrans_up": 0,
    "byte_retrans_up": 0,
    "packet_retrans_dn": 0,
    "byte_retrans_dn": 0,
    "payload": [
      {
        "timestamp": 1623981472.019806,
        "length": 0,
        "is_orig": true,
        "type_name": "S",
        "optional": [0, 0]
      },
      {
        "timestamp": 1623981472.155282,
        "length": 0,
        "is_orig": false,
        "type_name": "SA",
        "optional": [0, 1]
      }
      // ...
    ]
  },
  "http": {
    "method": "GET",
    "uri": "/",
    "version": "1.1",
    "content_type": "text/plain",
    "status": {
      "id": 301,
      "name": "Moved Permanently"
    },
    "src_headers": {
      "ACCEPT": "*/*",
      "USER-AGENT": "curl/7.75.0",
      "HOST": "www.taobao.com"
    },
    "dst_headers": {
      "CONTENT-TYPE": "text/html",
      "EAGLEID": "1bd3c51d16239814755493918e",
      "LOCATION": "https://www.taobao.com/",
      "CONNECTION": "keep-alive",
      "CONTENT-LENGTH": "262",
      "TIMING-ALLOW-ORIGIN": "*",
      "DATE": "Fri, 18 Jun 2021 01:57:55 GMT",
      "VIA": "cache9.cn2147[,0]",
      "SERVER": "Tengine"
    },
    "payload": [
      {
        "timestamp": 1623981472.216309,
        "length": 262,
        "is_orig": false,
        "optional": "PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9JRVRGLy9EVEQgSFRNTCAyLjAvL0VOIj4NCjxodG1sPg0KPGhlYWQ+PHRpdGxlPjMwMSBNb3ZlZCBQZXJtYW5lbnRseTwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8aDE+MzAxIE1vdmVkIFBlcm1hbmVudGx5PC9oMT4NCjxwPlRoZSByZXF1ZXN0ZWQgcmVzb3VyY2UgaGFzIGJlZW4gYXNzaWduZWQgYSBuZXcgcGVybWFuZW50IFVSSS48L3A+DQo8aHIvPlBvd2VyZWQgYnkgVGVuZ2luZTwvYm9keT4NCjwvaHRtbD4NCg=="
      }
    ]
  }
}
```

## 加密协议

### SSH

```typescript
type SSH = {
  version: string; // SSH 版本
  success: boolean; // 是否成功
  attempts: number; // 尝试次数
  client_packets: number; // 客户端发送的包数
  client_bytes: number; // 客户端发送的字节数
  server_packets: number; // 服务端发送的包数
  server_bytes: number; // 服务端发送的字节数
  client: string; // 客户端名称
  server: string; // 服务端名称
  cipher_algorithm: string; // 加密算法
  mac_algorithm: string; // MAC 算法
  compression_algorithm: string; // 压缩算法
  key_exchange_algorithm: string; // 密钥交换算法
  host_key_algorithm: string; // 主机密钥算法
  host_key: string; // 主机密钥
  support_key_exchange_algorithms: string[]; // 支持的密钥交换算法
  support_host_key_algorithms: string[]; // 支持的主机密钥算法
  support_client_encryption_algorithms: string[]; // 支持的客户端加密算法
  support_server_encryption_algorithms: string[]; // 支持的服务端加密算法
  support_client_mac_algorithms: string[]; // 支持的客户端 MAC 算法
  support_server_mac_algorithms: string[]; // 支持的服务端 MAC 算法
  client_ecc_key: string; // 客户端 ECC 密钥
  server_ecc_key: string; // 服务端 ECC 密钥
};
```

```json
{
  "uid": "CSCX9t4Rx9lNbzY5Q5",
  "ip": {
    "src": "172.30.233.254",
    "dst": "119.45.6.103",
    "protocol": 6,
    "version": 4,
    "length": 6574,
    "payload": [
      {
        "timestamp": 1625499701.010068,
        "length": 60,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1625499701.058807,
        "length": 60,
        "is_orig": false,
        "optional": 47
      }
      // ...
    ]
  },
  "tcp": {
    "client_port": 52096,
    "server_port": 22,
    "packet_up": 21,
    "packet_dn": 18,
    "byte_up": 2653,
    "byte_dn": 1877,
    "packet_retrans_up": 0,
    "byte_retrans_up": 0,
    "packet_retrans_dn": 0,
    "byte_retrans_dn": 0,
    "payload": [
      {
        "timestamp": 1625499701.010068,
        "length": 0,
        "is_orig": true,
        "type_name": "S",
        "optional": [0, 0]
      },
      {
        "timestamp": 1625499701.058807,
        "length": 0,
        "is_orig": false,
        "type_name": "SA",
        "optional": [0, 1]
      }
      //...
    ]
  },
  "ssh": {
    "version": 2,
    "success": false,
    "attempts": 4,
    "client_packet": 6,
    "client_byte": 1056,
    "server_packet": 7,
    "server_byte": 476,
    "client": "SSH-2.0-OpenSSH_8.4",
    "server": "SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3",
    "cipher_algorithm": "chacha20-poly1305@openssh.com",
    "mac_algorithm": "umac-64-etm@openssh.com",
    "compression_algorithm": "none",
    "key_exchange_algorithm": "curve25519-sha256",
    "host_key_algorithm": "ecdsa-sha2-nistp256",
    "host_key": "e5:a1:13:52:25:6f:e6:c6:74:76:b8:44:0b:2e:b0:02",
    "support_key_exchange_algorithms": [
      "curve25519-sha256",
      "curve25519-sha256@libssh.org",
      "ecdh-sha2-nistp256",
      "ecdh-sha2-nistp384",
      "ecdh-sha2-nistp521",
      "diffie-hellman-group-exchange-sha256",
      "diffie-hellman-group16-sha512",
      "diffie-hellman-group18-sha512",
      "diffie-hellman-group14-sha256",
      "ext-info-c"
    ],
    "support_host_key_algorithms": [
      "ecdsa-sha2-nistp256-cert-v01@openssh.com",
      "ecdsa-sha2-nistp384-cert-v01@openssh.com",
      "ecdsa-sha2-nistp521-cert-v01@openssh.com",
      "sk-ecdsa-sha2-nistp256-cert-v01@openssh.com",
      "ssh-ed25519-cert-v01@openssh.com",
      "sk-ssh-ed25519-cert-v01@openssh.com",
      "rsa-sha2-512-cert-v01@openssh.com",
      "rsa-sha2-256-cert-v01@openssh.com",
      "ssh-rsa-cert-v01@openssh.com",
      "ecdsa-sha2-nistp256",
      "ecdsa-sha2-nistp384",
      "ecdsa-sha2-nistp521",
      "sk-ecdsa-sha2-nistp256@openssh.com",
      "ssh-ed25519",
      "sk-ssh-ed25519@openssh.com",
      "rsa-sha2-512",
      "rsa-sha2-256",
      "ssh-rsa"
    ],
    "support_client_encryption_algorithms": [
      "chacha20-poly1305@openssh.com",
      "aes128-ctr",
      "aes192-ctr",
      "aes256-ctr",
      "aes128-gcm@openssh.com",
      "aes256-gcm@openssh.com"
    ],
    "support_server_encryption_algorithms": [
      "chacha20-poly1305@openssh.com",
      "aes128-ctr",
      "aes192-ctr",
      "aes256-ctr",
      "aes128-gcm@openssh.com",
      "aes256-gcm@openssh.com"
    ],
    "support_client_mac_algorithms": ["none", "zlib@openssh.com", "zlib"],
    "support_server_mac_algorithms": ["none", "zlib@openssh.com", "zlib"],
    "client_ecc_key": "r9F5Xmd+30QQkl86hmpVBK08WGjMg7z50jyBiQXDswk=",
    "server_ecc_key": "fzndIzui184jiw66M1bqJ6+IufjsUfsAdP9ffaivbXg="
  }
}
```

### SSL

```typescript
type HashSignature = {
  hash: KV; // 哈希算法
  signature: KV; // 签名算法
};

type SSL = {
  src_hello: boolean; // 存在源端 hello
  dst_hello: boolean; // 存在目的端 hello
  src_version: count; // 源版本
  src_record_version: count; // 源记录层版本
  src_hello_random: string; // 源 hello 随机字符
  src_hello_session_id: string; // 源 hello 会话 ID
  src_ciphers: KV[]; // 源加密算法
  src_compressions: KV[]; // 源压缩算法
  dst_version: count; // 目的版本
  dst_record_version: count; // 目的记录层版本
  dst_hello_random: string; // 目的 hello 随机字符
  dst_hello_session_id: string; //  目的 hello 会话 ID
  dst_cipher: KV; // 目的加密算法
  dst_compression: KV; // 目的压缩算法
  certs: Certificate[]; // 证书列表
  src_extensions: KV[]; // 源插件列表
  dst_extensions: KV[]; // 目的插件列表
  server_names: set[string]; // 服务器名称列表（SNI）
  inner_protocols: set[string]; // 内部协议列表

  src_hash_signature: HashSignature[]; // 源支持的哈希、签名算法
  dst_hash_signature: HashSignature[]; // 目的支持的哈希、签名算法
  hash_signature: HashSignature; // 哈希、签名算法

  src_support_versions: set[count]; // 源支持的版本
  dst_support_versions: set[count]; // 目的支持的版本

  src_handshake: KV[]; // 源握手消息
  dst_handshake: KV[]; // 目的握手消息

  plaintext_payloads: Payload[]; // 明文时间序列
  encrypted_payloads: Payload[]; // 密文时间序列

  dh_params: KV; // 密钥交换曲线参数
  src_dh_params: string; // 源端密钥交换曲线参数
  dst_dh_params: string; // 目的端密钥交换曲线参数

  src_key_share: KV[]; // 密钥交换
  dst_key_share: KV[]; // 密钥交换

  alerts: Payload[]; // 告警时间序列
};
```

```json
{
  "uid": "CJVZR34Hs2jmMHwh78",
  "ip": {
    "src": "172.26.253.114",
    "dst": "220.181.38.149",
    "protocol": 6,
    "version": 4,
    "length": 9496,
    "payload": [
      {
        "timestamp": 1624007713.303857,
        "length": 60,
        "is_orig": true,
        "optional": 64
      },
      {
        "timestamp": 1624007713.327848,
        "length": 60,
        "is_orig": false,
        "optional": 51
      }
      // ...
    ]
  },
  "tcp": {
    "client_port": 55094,
    "server_port": 443,
    "packet_up": 11,
    "packet_dn": 12,
    "byte_up": 643,
    "byte_dn": 4240,
    "packet_retrans_up": 7,
    "byte_retrans_up": 137,
    "packet_retrans_dn": 7,
    "byte_retrans_dn": 2932,
    "payload": [
      {
        "timestamp": 1624007713.303857,
        "length": 0,
        "is_orig": true,
        "type_name": "S",
        "optional": [0, 0]
      },
      {
        "timestamp": 1624007713.327848,
        "length": 0,
        "is_orig": false,
        "type_name": "SA",
        "optional": [0, 1]
      }
      //...
    ]
  },
  "ssl": {
    "src_hello": true,
    "dst_hello": true,
    "src_version": 771,
    "src_record_version": 769,
    "src_hello_random": "EMFX/yHQhnfnOUfAvSlP7CG4un8ITaHhlpGzCw==",
    "src_hello_session_id": "7wt8yBIeD/gTXH+qpDV0xfhF1M72kQV8xVlD48lNZWA=",
    "src_ciphers": [
      {
        "id": 4866,
        "name": "TLS_NULL_WITH_NULL_NULL"
      },
      {
        "id": 4867,
        "name": "TLS_RSA_WITH_NULL_MD5"
      },
      {
        "id": 4865,
        "name": "TLS_RSA_WITH_NULL_SHA"
      }
      // ...
    ],
    "src_compressions": [
      {
        "id": 4866,
        "name": ""
      }
    ],
    "dst_version": 771,
    "dst_record_version": 771,
    "dst_hello_random": "YMxkIQLxbu2EPbgEcknBZji+XpA/c0UqDnfQV0nW95E=",
    "dst_hello_session_id": "SN0Sm6TKN8Pj6W6M2UfxRDm07eYPJSOcnMPscVD6YW8=",
    "dst_cipher": {
      "id": 49199,
      "name": "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
    },
    "dst_compression": {
      "id": 0,
      "name": ""
    },
    "certs": [
      {
        "id": "FAwBno20u01UaNSZWh",
        "trans_flag": false,
        "thumb_print": "fcb40a45f27eb391adb13f34a625968735ceddcb",
        "version": 3,
        "len": 2610,
        "serial_number": "725878366E9F56E81D418848",
        "serial_number_len": 24,
        "time_start": 1585782298,
        "time_stop": 1627248662,
        "period": 41466364,
        "self_signed": false,
        "level": "OV",
        "sig_nid": "sha256WithRSAEncryption",
        "sig_key_size": 0,
        "pk_nid": "rsaEncryption",
        "pk_keysize": 2048,
        "cn_wildcard": false,
        "san_wildcard": true,
        "subject_nid": "CN=baidu.com,O=Beijing Baidu Netcom Science Technology Co.\\, Ltd,OU=service operation department,L=beijing,ST=beijing,C=CN",
        "subject_common_name": "baidu.com",
        "subject_country_name": "CN",
        "subject_org_name": "Beijing Baidu Netcom Science Technology Co.= Ltd",
        "subject_orgunit_name": "service operation department",
        "subject_state_name": "beijing",
        "subject_local_name": "beijing",
        "issuer_nid": "CN=GlobalSign Organization Validation CA - SHA256 - G2,O=GlobalSign nv-sa,C=BE",
        "issuer_common_name": "GlobalSign Organization Validation CA - SHA256 - G2",
        "issuer_country_name": "BE",
        "issuer_org_name": "GlobalSign nv-sa",
        "issuer_org_orgunit_name": "",
        "issuer_state_name": "",
        "issuer_local_name": "",
        "extensions_len": 10,
        "extensions_nid": "",
        "num_sans": 52,
        "is_ca": false,
        "content": "MIIKLjCCCRagAwIBAgIMclh4Nm6fVugdQYhIMA0GCSqGSIb3DQEBCwUAMGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTwwOgYDVQQDEzNHbG9iYWxTaWduIE9yZ2FuaXphdGlvbiBWYWxpZGF0aW9uIENBIC0gU0hBMjU2IC0gRzIwHhcNMjAwNDAyMDcwNDU4WhcNMjEwNzI2MDUzMTAyWjCBpzELMAkGA1UEBhMCQ04xEDAOBgNVBAgTB2JlaWppbmcxEDAOBgNVBAcTB2JlaWppbmcxJTAjBgNVBAsTHHNlcnZpY2Ugb3BlcmF0aW9uIGRlcGFydG1lbnQxOTA3BgNVBAoTMEJlaWppbmcgQmFpZHUgTmV0Y29tIFNjaWVuY2UgVGVjaG5vbG9neSBDby4sIEx0ZDESMBAGA1UEAxMJYmFpZHUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwamwrkca0lfrHRUfblyy5PgLINvqAN8p/6RriSZLnyMv7FewirhGQCp+vNxaRZdPrUEOvCCGSwxdVSFH4jE8V6fsmUfrRw1y18gWVHXv00URD0vOYHpGXCh0ro4bvthwZnuok0ko0qN2lFXefCfyD/eYDK2G2sau/Z/w2YEympfjIe4EkpbkeBHlxBAOEDF6Speg68ebxNqJN6nDN9dWsX9Sx9kmCtavOBaxbftzebFoeQOQ64h7jEiRmFGlB5SGpXhGeY9Ym+k1Wafxe1cxCpDPJM4NJOeSsmrp5pY3Crh8hy900lzoSwpfZhinQYbPJqYIjqVJF5JTs5Glz1OwMQIDAQABo4IGmDCCBpQwDgYDVR0PAQH/BAQDAgWgMIGgBggrBgEFBQcBAQSBkzCBkDBNBggrBgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3Nvcmdhbml6YXRpb252YWxzaGEyZzJyMS5jcnQwPwYIKwYBBQUHMAGGM2h0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc29yZ2FuaXphdGlvbnZhbHNoYTJnMjBWBgNVHSAETzBNMEEGCSsGAQQBoDIBFDA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAIBgZngQwBAgIwCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzL2dzb3JnYW5pemF0aW9udmFsc2hhMmcyLmNybDCCA04GA1UdEQSCA0UwggNBggliYWlkdS5jb22CDGJhaWZ1YmFvLmNvbYIMd3d3LmJhaWR1LmNughB3d3cuYmFpZHUuY29tLmNugg9tY3QueS5udW9taS5jb22CC2Fwb2xsby5hdXRvggZkd3ouY26CCyouYmFpZHUuY29tgg4qLmJhaWZ1YmFvLmNvbYIRKi5iYWlkdXN0YXRpYy5jb22CDiouYmRzdGF0aWMuY29tggsqLmJkaW1nLmNvbYIMKi5oYW8xMjMuY29tggsqLm51b21pLmNvbYINKi5jaHVhbmtlLmNvbYINKi50cnVzdGdvLmNvbYIPKi5iY2UuYmFpZHUuY29tghAqLmV5dW4uYmFpZHUuY29tgg8qLm1hcC5iYWlkdS5jb22CDyoubWJkLmJhaWR1LmNvbYIRKi5mYW55aS5iYWlkdS5jb22CDiouYmFpZHViY2UuY29tggwqLm1pcGNkbi5jb22CECoubmV3cy5iYWlkdS5jb22CDiouYmFpZHVwY3MuY29tggwqLmFpcGFnZS5jb22CCyouYWlwYWdlLmNugg0qLmJjZWhvc3QuY29tghAqLnNhZmUuYmFpZHUuY29tgg4qLmltLmJhaWR1LmNvbYISKi5iYWlkdWNvbnRlbnQuY29tggsqLmRsbmVsLmNvbYILKi5kbG5lbC5vcmeCEiouZHVlcm9zLmJhaWR1LmNvbYIOKi5zdS5iYWlkdS5jb22CCCouOTEuY29tghIqLmhhbzEyMy5iYWlkdS5jb22CDSouYXBvbGxvLmF1dG+CEioueHVlc2h1LmJhaWR1LmNvbYIRKi5iai5iYWlkdWJjZS5jb22CESouZ3ouYmFpZHViY2UuY29tgg4qLnNtYXJ0YXBwcy5jboINKi5iZHRqcmN2LmNvbYIMKi5oYW8yMjIuY29tggwqLmhhb2thbi5jb22CDyoucGFlLmJhaWR1LmNvbYIRKi52ZC5iZHN0YXRpYy5jb22CEmNsaWNrLmhtLmJhaWR1LmNvbYIQbG9nLmhtLmJhaWR1LmNvbYIQY20ucG9zLmJhaWR1LmNvbYIQd24ucG9zLmJhaWR1LmNvbYIUdXBkYXRlLnBhbi5iYWlkdS5jb20wHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMB8GA1UdIwQYMBaAFJbeYfG9HBYpUxzAzH07gwBA5hp8MB0GA1UdDgQWBBSeyXnX6VurihbMMo7GmeafIEI1hzCCAX4GCisGAQQB1nkCBAIEggFuBIIBagFoAHYAXNxDkv7mq0VEsV6a1FbmEDf71fpH3KFzlLJe5vbHDsoAAAFxObU8ugAABAMARzBFAiBphmgxIbNZXaPWiUqXRWYLaRST38KecoekKIof5fXmsgIhAMkZtF8XyKCu/nZll1e9vIlKbW8RrUr/74HpmScVRRsBAHYAb1N2rDHwMRnYmQCkURX/dxUcEdkCwQApBo2yCJo32RMAAAFxObU85AAABAMARzBFAiBURWwwTgXZ+9IV3mhmE0EOzbg901DLRszbLIpafDY/XgIhALsvEGqbBVrpGxhKoTVlz7+GWom8SrfUeHcn4+9Dn7xGAHYA9lyUL9F3MCIUVBgIMJRWjuNNExkzv98MLyALzE7xZOMAAAFxObU8qwAABAMARzBFAiBFBYPxKEdhlf6bqbwxQY7tskgdoFulPxPmdrzS5tNpPwIhAKnKqwzch98lINQYzLAV52+C8GXZPXFZNfhfpM4tQ6xbMA0GCSqGSIb3DQEBCwUAA4IBAQC83ALQ2d6MxeLZ/k3vutEiizRCWYSSMYLVCrxANdsGshNuyM8B8V/A57c0NzqoCPKfMtX5IICfv9P/bUecdtHL8cfx24MzN+U/GKcA4r3a/k8pRVeHeF9ThQ2zo1xjk/7gJl75koztdqNfOeYiBTbFMnPQzVGqyMMfqKxbJrfZlGAIgYHT9bd6T985IVgztRVjAoy4IurZenTsWkG7PafJ4kAh6jQaSu1zYEbHljuZ5PXlkhPO9DwW1WIPug6ZrlylLTTYmlW3WETOATi70HYsZN6NACuZ4t1hEO3AsF7lqjdA2HwTN10FX2HuaUvf5OzP+PKupV9VKw8x8mQKU6vr"
      },
      {
        "id": "F1ETbA21Kuk0yFpdQc",
        "trans_flag": false,
        "thumb_print": "902ef2deeb3c5b13ea4c3d5193629309e231ae55",
        "version": 3,
        "len": 1133,
        "serial_number": "040000000001444EF04247",
        "serial_number_len": 22,
        "time_start": 1392861600,
        "time_stop": 1708394400,
        "period": 315532800,
        "self_signed": false,
        "level": "OV",
        "sig_nid": "sha256WithRSAEncryption",
        "sig_key_size": 0,
        "pk_nid": "rsaEncryption",
        "pk_keysize": 2048,
        "cn_wildcard": false,
        "san_wildcard": false,
        "subject_nid": "CN=GlobalSign Organization Validation CA - SHA256 - G2,O=GlobalSign nv-sa,C=BE",
        "subject_common_name": "GlobalSign Organization Validation CA - SHA256 - G2",
        "subject_country_name": "BE",
        "subject_org_name": "GlobalSign nv-sa",
        "subject_orgunit_name": "",
        "subject_state_name": "",
        "subject_local_name": "",
        "issuer_nid": "CN=GlobalSign Root CA,OU=Root CA,O=GlobalSign nv-sa,C=BE",
        "issuer_common_name": "GlobalSign Root CA",
        "issuer_country_name": "BE",
        "issuer_org_name": "GlobalSign nv-sa",
        "issuer_org_orgunit_name": "Root CA",
        "issuer_state_name": "",
        "issuer_local_name": "",
        "extensions_len": 7,
        "extensions_nid": "",
        "num_sans": 0,
        "is_ca": true,
        "content": "MIIEaTCCA1GgAwIBAgILBAAAAAABRE7wQkcwDQYJKoZIhvcNAQELBQAwVzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xNDAyMjAxMDAwMDBaFw0yNDAyMjAxMDAwMDBaMGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTwwOgYDVQQDEzNHbG9iYWxTaWduIE9yZ2FuaXphdGlvbiBWYWxpZGF0aW9uIENBIC0gU0hBMjU2IC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHDmw/I5N/zHClnSDDDlM/fsBOwphJykfVI+8DNIV0yKMCLkZcC33JiJ1Pi/D4nGyMVTXbv/Kz6vvjVudKRtkTIso21ZvBqOOWQ5PyDLzm+ebomchjSHh/VzZpGhkdWtHUfcKc1H/hgBKueuqI6lfYygoKOhJJomIZeg0k9zfrtHOSewUjmxK1zusp36QUArkBpdSmnENkiN74fv7j9R7l/tyjqORmMdlMJekYuYlZCa7pnRxtNw9KHjUgKOKv1CGLAcRFrW4rY6uSa2EKTSDtc7p8zv4WtdufgPDWi2zZCHlKT3hl2pK8vjX5s8T5J4BO/5ZS5gIg4Qdz6V0rvbLxAgMBAAGjggElMIIBITAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUlt5h8b0cFilTHMDMfTuDAEDmGnwwRwYDVR0gBEAwPjA8BgRVHSAAMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDMGA1UdHwQsMCowKKAmoCSGImh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5uZXQvcm9vdC5jcmwwPQYIKwYBBQUHAQEEMTAvMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9yb290cjEwHwYDVR0jBBgwFoAUYHtmGkUNl8qJUC99BM00qP/8/UswDQYJKoZIhvcNAQELBQADggEBAEYq7l69rgFgNzERhnF0tkZJyBAW/i9iIxerH4f4gu3K3w4s32R1juUYcqeMOovJrKV3UPfvnqTgoI8UV6MqX+x+bRDmuo2wCId2Dkyy2VG7EQLyXN0cvfNVlg/UBsD84iOKJHDTu/B5GqdhcIOKrwbFINihY9Bsrk8y1658GEV1BSl330JAZGSGvip2CTFvHST0mdCF/vIhCPnG9vHQWe3WVjwIKANnuvD58ZAWR65n5ryASOlCdjSXVWkkDoPWoC209fN5ikkodBpBocLTJIg1MGCUF7ThBCIxPTsvFwayuJ2GK1pp74P1S8SqtCr4fKGxhZSM9AyHDPSsQPhZSZg="
      }
    ],
    "src_extensions": [
      {
        "id": 0,
        "name": "server_name",
        "value": "ABAAAA13d3cuYmFpZHUuY29t"
      },
      {
        "id": 11,
        "name": "ec_point_formats",
        "value": "AwABAg=="
      }
      // ...
    ],
    "dst_extensions": [
      {
        "id": 65281,
        "name": "renegotiation_info",
        "value": "AA=="
      },
      {
        "id": 16,
        "name": "application_layer_protocol_negotiation",
        "value": "AAkIaHR0cC8xLjE="
      }
    ],
    "server_names": ["www.baidu.com"],
    "inner_protocols": ["h2", "http/1.1"],
    "src_hash_signature": [
      {
        "hash": {
          "id": 4,
          "name": "sha256"
        },
        "signature": {
          "id": 3,
          "name": "ecdsa"
        }
      },
      {
        "hash": {
          "id": 5,
          "name": "sha384"
        },
        "signature": {
          "id": 3,
          "name": "ecdsa"
        }
      }
      // ...
    ],
    "dst_hash_signature": [],
    "hash_signature": {
      "hash": {
        "id": 4,
        "name": "sha256"
      },
      "signature": {
        "id": 1,
        "name": "rsa",
        "value": "sY6/+/x9O9LHAo30/A4Z0Fm1rG/XtFtJ7OW7YTzqUyz7uxNkro0V3fh88fE0/vmQM2k67UwPnUcxQ9WvJo0dk3KTC6sHBMwst/j3mJliuC8VyL3Z9JjFR30x+ERiO2txjQFwRIzlmpv13H/7JnIM1/sI5xO2siEGl9xNI33WZosKs75ZaaZEcFbUEbmN4K0fFdpUZdu0ZGO8gM7bOFkhYYn5/2SFfbhobdjmgyympGD9VaSHJ/Rz5u7cgX+BINzE1q1JffYWqtIUv+P696D4iIXIuWSkYIkV3merEPXkJFR6hVCuo1BYCDCD7MnCn7VBWSgROoD8UtdqmbgVxM7xtw=="
      }
    },
    "src_support_versions": [771, 770, 769, 772],
    "dst_support_versions": [],
    "src_handshake": [
      {
        "id": 1,
        "name": "CLIENT_HELLO",
        "value": 508
      },
      {
        "id": 16,
        "name": "CLIENT_KEY_EXCHANGE",
        "value": 66
      }
    ],
    "dst_handshake": [
      {
        "id": 2,
        "name": "SERVER_HELLO",
        "value": 92
      },
      {
        "id": 11,
        "name": "CERTIFICATE",
        "value": 3752
      }
      // ...
    ],
    "plaintext_payloads": [
      {
        "timestamp": 1624007713.335667,
        "length": 512,
        "is_orig": true,
        "type_id": 22,
        "type_name": "HANDSHAKE",
        "optional": 769
      },
      {
        "timestamp": 1624007713.365408,
        "length": 96,
        "is_orig": false,
        "type_id": 22,
        "type_name": "HANDSHAKE",
        "optional": 771
      }
      // ...
    ],
    "encrypted_payloads": [
      {
        "timestamp": 1624007713.372434,
        "length": 40,
        "is_orig": true,
        "type_id": 22,
        "type_name": "HANDSHAKE",
        "optional": 771
      },
      {
        "timestamp": 1624007713.397599,
        "length": 40,
        "is_orig": false,
        "type_id": 22,
        "type_name": "HANDSHAKE",
        "optional": 771
      }
    ],
    "dh_params": {
      "id": 23,
      "name": "secp256r1"
    },
    "src_dh_params": "QQT3wSI8Oi+ehdBfD056Lt+BSUR+1oJXq96tqkkxigIVFBngogrxdD8PG6xLRF9kBBltVrYoy/FdKiduxi9jWxA5",
    "dst_dh_params": "BFtauJg3RDX9mIrrcw03DGB3uCRHAm3ZI6AlVQbfjxOlQ+Rq8hb0F4Ur5JnNIh5h/Y+7bTe7HDqgcsAtiU+USUg=",
    "src_key_share": [
      {
        "id": 29,
        "name": "x25519"
      }
    ],
    "dst_key_share": [],
    "alerts": []
  }
}
```

### IPSec

```typescript
 type SA = {
  doi: number;
  situation: string;
};

type Attribute = {
  attr:           KV;
  auto_format:    boolean;
};

type ISAKMP = {
  id: string; // ID
  is_orig: boolean;
  init_spi: string; // 初始 SPI
  resp_spi: string; // 响应 SPI
  maj_version: number; // 主版本
  min_version: number; // 次版本
  length: number; // 长度
  ike_exchange_type: KV; // ike 交换类型
  src_nonce: number; // 源随机数长度
  dst_nonce: number; // 目标随机数长度
  sa_doi: number; // sa 协议类型
  sa_situation: string; // sa 的情况
  src_key_exchange: string; // 源密钥交换
  src_key_exchange_dh?: KV; // 源密钥交换
  dst_key_exchange: string; // 目标密钥交换
  dst_key_exchange_dh?: KV; // 目标密钥交换

  src_vendors: string[]; // 源支持的组件
  dst_vendors: string[]; // 目标支持的组件

  src_attribtues: Attribute[];
  dst_attributes: Attribute[];

  src_sa: SA[];
  dst_sa: SA[];

  src_certs: Certificate[];
  dst_certs: Certificate[];
  // src_proposals: { [key: number]: Proposal }; // 源提议
  // dst_proposals: { [key: number]: Proposal }; // 目标提议
  src_notify: KV[]; // 源通知
  dst_notify: KV[]; // 目标通知

  // cert_req?: KV; // 证书请求
  encrypted: Payload[]; // 加密数据

  flag_encryption: boolean; 
  flag_commit: boolean; 
  flag_authenticationy: boolean; 
  flag_i: boolean; 
  flag_v: boolean; 
  flag_r: boolean; 
  
};

type IPSec = {
  isakmp: { [id: number]: ISAKMP }; // ike 数据
};
```

```json
{
  "uid": "CFalNC4nckQVAZXexd",
  "hash": "7c71862a4a1178780eaffcd88cfb1cce",
  "source": "zeek-1",
  "ip": {
    "src": "192.168.13.40",
    "dst": "192.168.13.200",
    "protocol": 17,
    "version": 4,
    "length": 240,
    "payload": []
  },
  "udp": {
    "src": 500,
    "dst": 500,
    "packet_up": 1,
    "packet_dn": 1,
    "byte_up": 92,
    "byte_dn": 92,
    "payload": []
  },
  "ipsec": {
    "isakmp": {
      "766307892": {
        "id": 766307892,
        "is_orig": true,
        "init_spi": "nIC2rPk6AQA=",
        "resp_spi": "iWEKiAXYq20=",
        "maj_version": 1,
        "min_version": 1,
        "length": 92,
        "src_nonce": 0,
        "dst_nonce": 0,
        "sa_doi": 0,
        "sa_situation": "",
        "src_key_exchange": "",
        "src_key_exchange_dh": {
          "id": 5,
          "name": "IKEv1_INFORMATIONAL"
        },
        "dst_key_exchange": "",
        "src_vendors": [],
        "dst_vendors": [],
        "src_attributes": [],
        "dst_attributes": [],
        "src_sa": [],
        "dst_sa": [],
        "src_notify": [],
        "dst_notify": [],
        "src_certs": [],
        "dst_certs": [],
        "encrypted": [],
        "flag_encryption": true,
        "flag_commit": false,
        "flag_authentication": false,
        "flag_i": false,
        "flag_v": false,
        "flag_r": false
      },
      "3485840194": {
        "id": 3485840194,
        "is_orig": true,
        "init_spi": "iWEKiAXYq20=",
        "resp_spi": "nIC2rPk6AQA=",
        "maj_version": 1,
        "min_version": 1,
        "length": 92,
        "src_nonce": 0,
        "dst_nonce": 0,
        "sa_doi": 0,
        "sa_situation": "",
        "src_key_exchange": "",
        "dst_key_exchange": "",
        "dst_key_exchange_dh": {
          "id": 5,
          "name": "IKEv1_INFORMATIONAL"
        },
        "src_vendors": [],
        "dst_vendors": [],
        "src_attributes": [],
        "dst_attributes": [],
        "src_sa": [],
        "dst_sa": [],
        "src_notify": [],
        "dst_notify": [],
        "src_certs": [],
        "dst_certs": [],
        "encrypted": [],
        "flag_encryption": true,
        "flag_commit": false,
        "flag_authentication": false,
        "flag_i": false,
        "flag_v": false,
        "flag_r": false
      }
    }
  }
}
```
