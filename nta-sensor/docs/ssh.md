# SSH 协议

通常而言，我们将 SSH 当作一种远程连接协议。尽管 SSH 确实可以用于远程连接，但是从本质上而言， SSH（The Secure Shell）是 **安全外壳**，是加密传输的 Shell。当然，如果是本地连接，加密传输实际上没有意义。

因为是 Shell，所以其数据传输可能与下意识的想法 [不太一样](#encrypted)。


## 握手阶段

加密数据传输必然需要协商加密参数，握手阶段包含如下几部分

### 版本交换

TCP 连接建立后，首先需要由双方发送自己的 SSH 版本

在 [RFC 4253 版本交换](https://www.rfc-editor.org/rfc/rfc4253.html#section-4.2) 一章中[^rfc]，实际上并未规定版本交换谁先发送（部分文章中提到服务端先发[^guozet][^juejin]），在实际抓包中双方都有先发送的情况存在

版本的格式为 `SSH－<主协议版本号>.<次协议版本号>－<软件版本号>`

如果双方的协议可以兼容，则继续通信，否则可以由认为不兼容的一方断开连接

### 密钥交换

双方首先需要使用 `Key Exchange Init` 包告诉对方自己支持的非对称加密、对称加密、消息验证码、压缩算法列表。

接下来，双方使用选择的协议，交换密钥。以 EC-DH 为例，密钥交换阶段，双方发送的顺序如下:
1. Client - Key Exchange Init
2. Server - Key Exchange Init
3. Client - Elliptic Curve Diffie-Hellman Key Exchange Init
4. Server - Elliptic Curve Diffie-Hellman Key Exchange Init
5. Server - New Key
6. Server - Encrypted packet
7. Client - New Key

当发送 New Key 后，说明自己后续将会使用协商的对称密钥进行加密


<a name="encrypted"></a>

### 加密内容

无论是身份验证还是实际数据传输，都使用协商的对称密钥加密，加密数据包包含长度、密文、消息验证码三部分

由于 SSH 是一个 Shell，因此所有的操作实际都是在服务端执行的，每打一个字符，都会同步至服务端，在服务端响应后，将结果响应至客户端 Terminal（所以，如果网络情况不好，打字会很卡）

同样由于这个原因，实际很难根据客户端发往服务端的内容来解析出用户行为，但是理论上服务端发往客户端的数据仍然存在特征（根据长度和支持自动刷新的命令）


## 一些迷惑内容

- 密码验证、公钥验证内容，都使用协商的对称密钥加密，与公私钥无关（只用于身份验证）
- DH 密钥交换体系无法进行身份验证，因此在第一次连接服务器时，会将服务器公钥存入本地 `~/.ssh/known_hosts` 内，后续会使用该值验证（如果服务端重置了 sshd，可以删除对应的行避免失败）
- 公钥登录方法使用类似消息验证的形式进行验证，本身并不参与加密[^walkerdu]


## 参考资料

[^rfc]: [RFC 4253 The Secure Shell (SSH) Transport Layer Protocol](https://www.rfc-editor.org/rfc/rfc4253.html)
[^guozet]: [SSH 协议解析](http://www.guozet.me/post/Linux-SSH-introduce/)
[^juejin]: [SSH 协议基本原理及 wireshark 抓包分析](https://juejin.cn/post/6844903685047189512)
[^walkerdu]: [SSH 协议和原理浅析](http://walkerdu.com/2019/10/24/ssh/)