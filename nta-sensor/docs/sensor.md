# 探针模块

## 探针模块功能概述

该模块输入为抓包程序（基于 Suricata 或 Zeek(Bro) 实现）抓取的网卡流量，输出为输出到 Kafka 的元数据。在抓包程序上挂载特定的解析器，针对要求的特定协议进行解析。

在原本程序的基础上，需要添加

- 明文流量检测
  - 扫描爆破行为
  - 重放攻击
  - 密码合规性检测
- 加密流量协议（以插件形式引入，而非修改源码）
  - IPSec 协议的处理解析
  - 提取 ISAKMP、SSH、RDP、ESP、AH 元数据
  - 其他国密协议的识别
  - SSL/TLS 证书提取
  - 特定规则过滤
  - 加密合规性检测
  - 加密证书合规性检测
- 数据输出
  - 元数据输出至 Kafka
  - 全流量输出值 Kafka

## 技术路线

探针端主要需要完成的任务为
1. 对明文流量常见威胁进行识别
2. 对加密流量进行基础解析

对于前者，最广泛使用的方案为 Snort、Suricata 的规则。由于这些项目规则的通用性，已经拥有大量的基础规则可以方便地实现绝大部分功能。而对于后者，则使用 Bro/Zeek 拥有较大的优势。

综合考虑两者，我们认为 Suricata 在不修改源码的情况下，可配置性较差，只能通过 Lua 脚本进行功能增强；而 Zeek 自带的 Zeek Scripts 则可以拥有更高的可操作性。
同时，尽管 Zeek 本身不支持 rules 格式的规则检测，但是可以采用特征(signature)完成类似的功能。官方曾经推出过 `snort2bro`[^snort2bro] 工具进行自动转换，但考虑到工具仍然需要大量的人为介入，因此官方取消的维护。因此，我们需要进行一些 Snort、Suricata 规则的翻译工作。

[^snort2bro]: [Zeek Signature](https://docs.zeek.org/en/master/frameworks/signatures.html#so-how-about-using-snort-signatures-with-zeek)

## 任务要求及进度安排

1. 一阶段任务安排：
   1. ~~构建 Zeek 测试环境，并完成基本测试 demo  **2021-06-20 @孔晨皓**~~
   2. 基础检测特征、事件检测（类似 Suricata 规则检测）库 **2021-07-10 @陶晓涵**
      1. 整理已有的开源 Zeek 检测规则
      2. 翻译部分 Suricata 检测规则
      3. 适配自主规则（结合后续的证书识别，告警弱证书？）
   3. 实现 IP、TCP、UDP 基本报文元数据解析 **2021-07-10 @孔晨皓**
      1. IP 层数据提取
      2. TCP 层数据提取
      3. UDP 层数据提取
   4. 完成各种加密协议元数据提取 **2021-08-15 @孔晨皓 @陶晓涵**
      1. ~~证书提取~~
      2. 各个协议提取
2. 二阶段任务安排：
   1. 对接其他模块
   2. ……

## 协议元数据

### 通用头部

|    字段名    |  类型   |                       解释                       |
| :----------: | :-----: | :----------------------------------------------: |
|     `id`     | `int64` |                    数据库编号                    |
| `stream_id`  | `int64` |                    流唯一标识                    |
|  `task_id`   | `int32` |          表示任务类型（用户自定义标签）          |
|    `fid`     | `int64` |                      文件id                      |
|    `oid`     | `int64` |                    位置信息id                    |
|  `tag_type`  | `int32` | 白名单类型: ip、dns、sni、证书指纹、TLS、临时 ip |
|   `tag_id`   | `int32` |                  白名单命中 ID                   |
|   `sig_id`   | `int32` |                   规则命中 ID                    |
|    `tag`     | `int32` |                       线路                       |
| `trans_flag` | `int8`  |                  表示是否传输过                  |
| `is_center`  | `int8`  |                表示是否是中心数据                |
| `time_start` | `int64` |                    流开始时间                    |
| `time_stop`  | `int64` |                    流结束时间                    |
|    `time`    | `int64` |                     入库时间                     |
| `packet_up`  | `int32` |                     上行包数                     |
| `packet_dn`  | `int32` |                     下行包数                     |
|  `byte_up`   | `int32` |                    上行字节数                    |
|  `byte_dn`   | `int32` |                    下行字节数                    |

### IP 通用头部

|   字段名    |  类型   |   解释    |
| :---------: | :-----: | :-------: |
| `ip_client` | `int32` | 客户端 IP |
| `ip_server` | `int32` | 服务端 IP |
| `direction` | `int8`  |   方向    |

### TCP 通用头部

|       字段名        |  类型   |     中文名     |
| :-----------------: | :-----: | :------------: |
|    `port_client`    | `int32` |   客户端端口   |
|    `port_server`    | `int32` |   服务端端口   |
| `payload_packet_up` | `int32` |  上行载荷包数  |
| `payload_packet_dn` | `int32` |  下行载荷包数  |
|  `payload_byte_up`  | `int32` | 上行载荷字节数 |
|  `payload_byte_dn`  | `int32` | 下行载荷字节数 |
| `packet_up_retrans` | `int32` | 上行重传报文数 |
| `packet_dn_retrans` | `int32` | 下行重传报文数 |
|  `byte_up_retrans`  | `int32` | 上行重传字节数 |
|  `byte_dn_retrans`  | `int32` | 下行重传字节数 |

### UDP 通用头部

|       字段名        |  类型   |      解释      |
| :-----------------: | :-----: | :------------: |
|    `port_client`    | `int32` |   客户端端口   |
|    `port_server`    | `int32` |   服务端端口   |
| `payload_packet_up` | `int32` |  上行载荷包数  |
| `payload_packet_dn` | `int32` |  下行载荷包数  |
|  `payload_byte_up`  | `int32` | 上行载荷字节数 |
|  `payload_byte_dn`  | `int32` | 下行载荷字节数 |

### 证书元数据

|          字段名           |  类型  |                  中文名                  |
| :-----------------------: | :----: | :--------------------------------------: |
|            `id`             | `int64`  |                   编号                   |
|        `trans_flag`         |  `int8`  |    标识是否传输过（默认值：0-未传输）    |
|     `CERT_THUMB_PRINT`      | `string` |                 SHA1指纹                 |
|       `CERT_VERSION`        |  `int8`  | 证书版本号  0，1，2,表示x509的v1，v2，v3 |
|         `CERT_LEN`          | `int16`  |                 证书长度                 |
|    `CERT_SERIAL_NUMBER`     | `string` |                证书序列号                |
|  `CERT_SERIAL_NUMBER_LEN`   |  `int8`  |              证书序列号长度              |
|      `CERT_TIME_START`      | `int64`  |            证书有效期开始时间            |
|      `CERT_TIME_STOP`       | `int64`  |            证书有效期结束时间            |
|        `CERT_PERIOD`        | `int64`  |              证书有效期天数              |
|     `CERT_SELF_SIGNED`      |  `int8`  |             证书是否为自签名             |
|        `CERT_LEVEL`         |  `int8`  |            证书等级：EV/OV/DV            |
|       `CERT_SIG_NID`        | `int16`  |               签名算法NID                |
|     `CERT_SIG_KEYSIZE`      | `int16`  |     签名算法KeySize（给原始值即可）      |
|        `CERT_PK_NID`        | `int16`  |             证书公钥算法NID              |
|      `CERT_PK_KEYSIZE`      | `int16`  |     证书公钥KeySize（给原始值即可）      |
|     `CERT_CN_WILDCARD`      |  `int8`  |       使用者common name有无通配符*       |
|     `CERT_SAN_WILDCARD`     |  `int8`  |            SAN是否包含通配符*            |
|     `CERT_SUBJECT_NID`      | `string` |               使用者项列表               |
| `CERT_SUBJECT_COMMON_NAME`  | `string` |            使用者common name             |
| `CERT_SUBJECT_COUNTRY_NAME` | `string` |              使用者country               |
|   `CERT_SUBJECT_ORG_NAME`   | `string` |            使用者organization            |
| `CERT_SUBJECT_ORGUNIT_NAME` | `string` |         使用者organization unit          |
|  `CERT_SUBJECT_STATE_NAME`  | `string` |         使用者state or province          |
|  `CERT_SUBJECT_LOCAL_NAME`  | `string` |              使用者locality              |
|      `CERT_ISSUER_NID`      | `string` |               颁发者项列表               |
|  `CERT_ISSUER_COMMON_NAME`  | `string` |            颁发者common name             |
| `CERT_ISSUER_COUNTRY_NAME`  | `string` |              颁发者country               |
|   `CERT_ISSUER_ORG_NAME`    | `string` |            颁发者organization            |
| `CERT_ISSUER_ORGUNIT_NAME`  | `string` |         颁发者organization unit          |
|  `CERT_ISSUER_STATE_NAME`   | `string` |         颁发者state or province          |
|  `CERT_ISSUER_LOCAL_NAME`   | `string` |              颁发者locality              |
|    `CERT_EXTENSIONS_LEN`    | `int16`  |                扩展总长度                |
|    `CERT_EXTENSIONS_NID`    | `string` |                扩展项列表                |
|       `CERT_NUM_SANS`       | `int16`  |                 SAN数量                  |
|         `CERT_SANS`         | `string` |        SAN列表，字符，用“\|”隔开         |
|        `CERT_IS_CA`         |  `int8`  |               证书是否为CA               |
|       `CERT_CONTENT`        | `string` |                 证书内容                 |

### SSL 

|              字段名              |  类型  |                            中文名                            |
| :------------------------------: | :----: | :----------------------------------------------------------: |
|             `TCP_INIT`             |  `int8`  |           TCP的发起方，0=未知，1=client  2=server            |
|             `TCP_FIN`              |  `int8`  |                                                              |
|               `DNS`                | `string` |                           关联DNS                            |
|          `DNS_STREAM_ID`           | `int64`  |                         关联DNS流ID                          |
|             `C_HELLO`              |  `int8`  |                     C端是否包含HELLO消息                     |
|             `S_HELLO`              |  `int8`  |                     S端是否包含HELLO消息                     |
|          `C_CERTIFICATE`           |  `int8`  |                  C端是否包含CERTIFICATE消息                  |
|          `S_CERTIFICATE`           |  `int8`  |                  S端是否包含CERTIFICATE消息                  |
|       `C_CERTIFICATE_VERIFY`       |  `int8`  |              C端是否包含CERTIFICATE_VERIFY消息               |
|       `S_CERTIFICATE_STATUS`       |  `int8`  |              S端是否包含CERTIFICATE_STATUS消息               |
|      `S_CERTIFICATE_REQUEST`       |  `int8`  |              S端是否包含CERTIFICATE_REQUEST消息              |
|          `C_KEY_EXCHANGE`          |  `int8`  |                 C端是否包含KEY_EXCHANGE消息                  |
|          `S_KEY_EXCHANGE`          |  `int8`  |                 S端是否包含KEY_EXCHANGE消息                  |
|       `C_CHANGE_CIPHER_SPEC`       |  `int8`  |              C端是否包含CHANGE_CIPHER_SPEC消息               |
|       `S_CHANGE_CIPHER_SPEC`       |  `int8`  |              S端是否包含CHANGE_CIPHER_SPEC消息               |
|       `S_NEW_SESSION_TICKET`       |  `int8`  |               S端是否包含NEWSESSIONTICKET消息                |
|           `S_HELLO_DONE`           |  `int8`  |                   S端是否包含HELLODONE消息                   |
|          `S_HELLOREQUEST`          |  `int8`  |                 S端是否包含HELLOREQUEST消息                  |
|            `C_FINISHED`            |  `int8`  |                   C端是否包含finished消息                    |
|            `S_FINISHED`            |  `int8`  |                   S端是否包含finished消息                    |
|            `C_APP_DATA`            |  `int8`  |               C端是否包含Application  Data消息               |
|            `S_APP_DATA`            |  `int8`  |               S端是否包含Application  Data消息               |
|           `C_HEARTBEAT`            |  `int8`  |                   C端是否包含HEARTBEAT消息                   |
|           `S_HEARTBEAT`            |  `int8`  |                   S端是否包含HEARTBEAT消息                   |
|      `C_SESSION_TICKET_INDEX`      |  `int8`  |                    C端SESSION_TICKET索引                     |
|       `C_SESSION_TICKET_LEN`       | `int16`  |                    C端SESSION_TICKET长度                     |
|      `S_SESSION_TICKET_INDEX`      |  `int8`  |                    S端SESSION_TICKET索引                     |
|       `S_SESSION_TICKET_LEN`       | `int16`  |                    S端SESSION_TICKET长度                     |
|             `C_ALERT`              |  `int8`  |                     C端是否包含ALERT消息                     |
|             `S_ALERT`              |  `int8`  |                     S端是否包含ALERT消息                     |
|           `ALERT_LEVEL`            |  `int8`  |                       出现错误时的级别                       |
|           `ALERT_DESCR`            |  `int8`  |                       出现错误时的原因                       |
|              `C_SNI`               | `string` |                          C端SNI的值                          |
|              `C_SID`               | `string` |                       C端SessionID的值                       |
|              `C_RAND`              | `string` |     C端random值（注：前4字节有可能是时间，只存后28字节）     |
|            `C_CS_LIST`             | `string` |                C端加密套件值列表（C端CS列表）                |
|            `C_CS_COUNT`            | `int32`  |                      C端加密套件值数量                       |
|         `C_RECORD_VERSION`         |  `int8`  |                        C端Record版本                         |
|        `C_COMPRESS_METHODS`        | `string` |                      C端压缩算法值列表                       |
|            `C_VERSION`             |  `int8`  |                      C端支持的最大版本                       |
|         `C_RECORD_NUMBER`          | `int16`  |                        C端RECORD数量                         |
|      `C_KEY_EXCHANGE_KEYLEN`       | `int16`  | C端Client_key_exchang  keylen （不同加密算法都要提 rsa/dh/ecdhe） |
|            `C_EXT_LIST`            | `string` |                         C端扩展列表                          |
|            `S_EXT_LIST`            | `string` |                         S端扩展列表                          |
|              `S_NAME`              | `string` |                           S端名称                            |
|              `S_SID`               | `string` |                       S端SessionID的值                       |
|              `S_RAND`              | `string` |     S端random值（注：前4字节有可能是时间，只存后28字节）     |
|              `S_SCS`               | `int32`  |                       S端密码套件的值                        |
|        `S_COMPRESS_METHODS`        | `int32`  |                        S端压缩算法值                         |
|            `S_VERSION`             |  `int8`  |                        S端选择的版本                         |
|         `S_RECORD_NUMBER`          | `int16`  |                        S端RECORD数量                         |
|      `S_KEY_EXCHANGE_KEYLEN`       | `int16`  | S端Server key_exchang  keylen （不同加密算法都要提 rsa/dh/ecdhe） |
|          `S_RSA_MODULUS`           | `int32`  |          Server key  exchange消息中，RSA算法的模数n          |
|          `S_RSA_EXPONENT`          | `int32`  |          Server key  exchange消息中，RSA算法的指数n          |
|           `S_DH_MODULUS`           | `int32`  |          Server key  exchange消息中，DH算法的模数p           |
|             `S_DH_GEN`             | `int32`  |          Server key  exchange消息中，DH算法的底数e           |
|           `S_DH_PUBKEY`            | `string` |            服务端发送给客户端的DH模乘运算后的数值            |
|           `C_DH_PUBKEY`            | `string` |            客户端发送给服务器的DH模乘运算后的数值            |
|     `C_ELLIPTIC_CURVES_POINT`      | `int32`  |                  客户端支持的椭圆曲线点格式                  |
|        `C_ELLIPTIC_CURVES`         | `int32`  |                   客户端支持的椭圆曲线名称                   |
|     `S_ELLIPTIC_CURVES_POINT`      | `int32`  |                  服务端支持的椭圆曲线点格式                  |
|        `S_ELLIPTIC_CURVES`         | `int32`  |                     服务端支持的椭圆曲线                     |
|       `S_ELLIPTIC_DH_PUBKEY`       | `string` |             服务端在椭圆曲线上计算得到的DH公钥值             |
|       `C_ELLIPTIC_DH_PUBKEY`       | `string` |             客户端在椭圆曲线上计算得到的DH公钥值             |
|        `C_CERTIFICATE_LEN`         | `int16`  |                          证书链长度                          |
|      `C_CERT_CHAIN_VALIDITY`       |  `int8`  |               证书链校验是否通过（不包括根CA）               |
| `C_CERT_CHAIN_VALIDITY_INCLUDE_CA` |  `int8`  |                证书链校验是否通过（包括根CA）                |
|        `C_CERTIFICATE_HASH`        | `string` |                         证书SHA1指纹                         |
|           `C_CERT_PATH`            | `string` |        叶证书存储路径：路径+HASH即可在文件中找到证书         |
|          `C_CA_CERT_PATH`          | `string` |        CA证书存储路径：路径+HASH即可在文件中找到证书         |
|         `C_CA_HASH_TABLE`          | `string` | 存储CA证书的hash，按流量中顺序，如：345324523535\|34534534532 |
|        `S_CERTIFICATE_LEN`         | `int16`  |                          证书链长度                          |
|      `S_CERT_CHAIN_VALIDITY`       |  `int8`  |               证书链校验是否通过（不包括根CA）               |
| `S_CERT_CHAIN_VALIDITY_INCLUDE_CA` |  `int8`  |                证书链校验是否通过（包括根CA）                |
|        `S_CERTIFICATE_HASH`        | `string` |                         证书SHA1指纹                         |
|           `S_CERT_PATH`            | `string` |        叶证书存储路径：路径+HASH即可在文件中找到证书         |
|          `S_CA_CERT_PATH`          | `string` |        CA证书存储路径：路径+HASH即可在文件中找到证书         |
|         `S_CA_HASH_TABLE`          | `string` | 存储CA证书的hash，按流量中顺序，如：345324523535\|34534534532 |
|        `CERT_REQUEST_TYPE`         |  `int8`  |              服务端向客户端发出的证书请求的类型              |
|          `C_FINISHED_LEN`          | `int16`  |                      C端Finish记录长度                       |
|          `S_FINISHED_LEN`          | `int16`  |                      S端Finish记录长度                       |
|          `C_APP_PACKAGE`           | `string` |   存储客户端->服务端第N个载荷（不是握手数据）的二进制数据    |
|          `S_APP_PACKAGE`           | `string` |   存储服务端->客户端第N个载荷（不是握手数据）的二进制数据    |
|         `TCP_MISS_PACKET`          |  `int8`  |                     握手阶段TCP丢包数量                      |
|         `FLAG_QUICK_MODE`          |  `int8`  |                       是否采用快速协商                       |
|           `FLAG_SUCCESS`           |  `int8`  |                         是否协商成功                         |
|      `FLAG_NONRANDOM_PACKETS`      | `int32`  |                         非随机包数量                         |

### ISAKMP

|      字段名      |  类型  |                           中文名                            |
| :--------------: | :----: | :---------------------------------------------------------: |
|    `port_4500`     | `uint8`  |            是否使用UDP的4500端口封装，0=否，1=是            |
|    `total_ike`     | `uint8`  |              是否包含完整的IKE协商，0=否，1=是              |
|      `index`       | `uint32` | 本分组在流内的次序（该流的第index次基于第一阶段的重新协商） |
|   `block_count`    | `uint32` |                     流切分的分组的数量                      |
|     `initVer`      | `string` |                         发起者版本                          |
|     `respVer`      | `string` |                         响应者版本                          |
|       `ipsi`       | `uint32` |                         发起方索引                          |
|       `rspi`       | `uint32` |                         接收方索引                          |
|    `ipsi_innor`    | `uint32` |           发起方内部索引（AH+ESP时该字段不为空）            |
|    `rspi_innor`    | `uint32` |           接收方内部索引（AH+ESP时该字段不为空）            |
|   `next_header`    | `uint8`  |        AH载荷类型标识（上层协议为AH时该字段不为空）         |
|   `running_mode`   | `uint8`  |   IPSec传输协议的运行模式，0=未知，1=传输模式，2=隧道模式   |
|     `icookie`      | `uint64` |       发起方  IP、端口、密钥、日期等计算得到的散列值        |
|     `rcookie`      | `uint64` |       接收方  IP、端口、密钥、日期等计算得到的散列值        |
|     `version`      | `uint8`  |                       ISAKMP协议版本                        |
|  `exchange_type`   | `uint8`  |                        交换类型列表                         |
|      `flags`       | `uint8`  |                           标志位                            |
|   `RespKey_Len`    | `uint8`  |                   响应者加密算法密钥长度                    |
|    `message_id`    | `uint32` |                         消息ID列表                          |
|   `notify_type`    | `uint8`  |         ISAKMP协议消息发生错误时生成的错误消息类型          |
|     `list_ipl`     | `uint8`  |                发起方ISAKMP协议载荷类型列表                 |
|     `list_rpl`     | `uint8`  |                响应方ISAKMP协议载荷类型列表                 |
| `I_SA_THUMB_PRINT` | `string` |           发起者SA载荷的MD5指纹（取代原策略指纹）           |
| `R_SA_THUMB_PRINT` | `string` |           响应者SA载荷的MD5指纹（取代原策略指纹）           |
|  `SA_THUMB_PRINT`  | `string` |         MD5指纹：MD5(发起者SA载荷 +  响应者SA载荷)          |
|  `I_THUMB_PRINT`   | `string` | 发起者用户指纹：MD5(SA载荷 +  厂商ID列表)（取代原imd5字段） |
|  `R_THUMB_PRINT`   | `string` | 响应者用户指纹：MD5(SA载荷 +  厂商ID列表)（取代原rmd5字段） |
|       `doi`        | `uint8`  |                  定义负载的格式、交换类型                   |
|       `situ`       | `uint32` |                     DOI 所处的环境属性                      |
|  `suggest_count`   | `uint8`  |        发起方发起的变换载荷(v1)/建议载荷（v2）的数量        |
|  `transform_num`   | `uint8`  |                     当前变换载荷的序号                      |
|   `transform_id`   | `uint8`  |                   当前变换载荷的类型标识                    |
|   `LIST_ENC_V2`    | `uint16` |       IKE2安全载荷关联消息的变换载荷中给出的加密算法        |
|    `ALG_ENC_V2`    | `uint16` |                        IKE2加密算法                         |
|   `LIST_PRF_V2`    | `uint16` |        IKE2安全关联消息的变换载荷中给出的伪随机函数         |
|    `ALG_PRF_V2`    | `uint16` |                       IKE2伪随机函数                        |
|   `LIST_INT_V2`    | `uint16` |      IKE2安全关联消息的变换载荷中给出的完整性校验算法       |
|    `ALG_INT_V2`    | `uint16` |                     IKE2完整性校验算法                      |
|     `LIST_ENC`     | `uint16` |                  发起者加密算法支持的列表                   |
|     `ALG_ENC`      | `uint16` |                       响应者加密算法                        |
|    `LIST_HASH`     | `uint16` |                  发起者hash算法支持的列表                   |
|     `ALG_HASH`     | `uint16` |                       响应者hash算法                        |
|    `LIST_AUTH`     | `uint16` |                  发起者认证算法支持的列表                   |
|     `ALG_AUTH`     | `uint16` |                       响应者认证算法                        |
|     `LIST_DH`      | `uint16` |          发起者IKE1变换消息指定的群类型支持的列表           |
|      `ALG_DH`      | `uint16` |               响应者IKE1变换消息指定的群类型                |
|  `LIST_GROUP_DES`  | `uint16` |  发起者IKE1变换消息指定的DH算法的群规模列表（dh交换bit数）  |
|  `ALG_GROUP_DES`   | `uint16` |    响应者IKE1变换消息指定的DH算法的群规模（dh交换bit数）    |
|   `LIST_KEY_LEN`   | `uint16` |       发起者IKE1变换消息指定的加密算法密钥长度的列表        |
|   `ALG_KEY_LEN`    | `uint16` |          响应者IKE1变换消息指定的加密算法密钥长度           |
|    `LIFE_UNIT`     | `uint16` |                  IKE变换参数的生存时间单位                  |
|       `LIFE`       | `uint32` |                   IKE 变换参数的生存时间                    |
|     `ipubkey`      | `string` |                     发起者发送的公钥值                      |
|     `rpubkey`      | `string` |                     响应者发送的公钥值                      |
|      `inonce`      | `string` |                     发起者发送的随机数                      |
|      `rnonce`      | `string` |                     响应者发送的随机数                      |
|     `icr_type`     | `uint8`  |                   发起者证书请求类型编码                    |
|     `icr_info`     | `string` |                发起者证书请求载荷的证书信息                 |
|     `rcr_type`     | `uint8`  |                   响应者证书请求类型编码                    |
|     `rcr_info`     | `string` |                响应者证书请求载荷的证书信息                 |
|    `icert_type`    | `uint8`  |                     发起者证书类型编码                      |
|    `icert_info`    | `string` |                  发起者证书载荷的证书信息                   |
|    `rcert_type`    | `uint8`  |                     响应者证书类型编码                      |
|    `rcert_info`    | `string` |                  响应者证书载荷的证书信息                   |
|     `iid_type`     | `uint8`  |        发起者身份标识类型（该值在野蛮模式下是明文）         |
|     `iid_info`     | `string` |          发起者身份标识（该值在野蛮模式下是明文）           |
|     `rid_type`     | `uint8`  |        响应者身份标识类型（该值在野蛮模式下是明文）         |
|     `rid_info`     | `string` |          响应者身份标识（该值在野蛮模式下是明文）           |
|      `ivids`       | `string` |               发起者VPN 生产商的唯一标识列表                |
|      `rvids`       | `string` |               响应者VPN 生产商的唯一标识列表                |
|     `iextern`      | `string` |                     发起者扩展信息列表                      |
|     `rextern`      | `string` |                     响应者扩展信息列表                      |
|    `nat_hash_1`    | `string` |                  NAT穿越，地址和端口的hash                  |
|    `nat_hash_2`    | `string` |                  NAT穿越，地址和端口的hash                  |
|    `iauthdata`     | `string` |      发起者认证数据（记录主模式的后两个包的加密数据）       |
|    `rauthdata`     | `string` |      响应者认证数据（记录主模式的后两个包的加密数据）       |

### ESP

|    字段名     |  类型  |                            中文名                            |
| :-----------: | :----: | :----------------------------------------------------------: |
| `protocol_type` | `uint8`  | 分组协议类型，0=未知，1=ESP，2=AH，3=AH+ESP，4=ISAKMP，5=ISAKMP+ESP |
|   `port_4500`   | `uint8`  |            是否使用UDP的4500端口封装，0=否，1=是             |
|  `byte_enc_up`  | `uint32` |                        上行加密字节数                        |
|  `byte_enc_dn`  | `uint32` |                        下行加密字节数                        |
|  `block_count`  | `uint32` |                      流切分的分组的数量                      |
|     `ipsi`      | `uint32` |                          发起方索引                          |
|     `rspi`      | `uint32` |                          接收方索引                          |
|  `ipsi_innor`   | `uint32` |            发起方内部索引（AH+ESP时该字段不为空）            |
|  `rspi_innor`   | `uint32` |            接收方内部索引（AH+ESP时该字段不为空）            |

### SSH

|       字段名        |  类型  |                  中文名                  |
| :-----------------: | :----: | :--------------------------------------: |
|   `version_client`    | `string` |                客户端版本                |
|   `version_server`    | `string` |                服务器版本                |
| `count_len_threshold` | `int32`  |                包长度阈值                |
|    `enc_packet_up`    | `int32`  |              上行加密包数量              |
|    `enc_packet_dn`    | `int32`  |              下行加密包数量              |
|       `VER_SRC`       |  `int8`  |            客户端 SSH协议版本            |
|       `VER_DST`       |  `int8`  |            服务器 SSH协议版本            |
|     `COOKIE_SRC`      | `string` | 服务器客户端参与计算生成会话密钥的随机数 |
|     `COOKIE_DST`      | `string` |       参与计算生成会话密钥的随机数       |
|  `SER_HOST_KEY_SRC`   | `string` |    客户端支持的服务器主机密钥算法列表    |
|  `SER_HOST_KEY_DST`   | `string` |    服务器支持的服务器主机密钥算法列表    |
|     `ENC_C2S_SRC`     | `string` |       客户端支持的加密算法列表C2S        |
|     `ENC_C2S_DST`     | `string` |       服务器支持的加密算法列表C2S        |
|     `ENC_S2C_SRC`     | `string` |       客户端支持的加密算法列表S2C        |
|     `ENC_S2C_DST`     | `string` |       服务器支持的加密算法列表S2C        |
|     `MAC_C2S_SRC`     | `string` |        客户端支持的MAC算法列表C2S        |
|     `MAC_C2S_DST`     | `string` |        服务器支持的MAC算法列表C2S        |
|     `MAC_S2C_SRC`     | `string` |        客户端支持的MAC算法列表S2C        |
|     `MAC_S2C_DST`     | `string` |        服务器支持的MAC算法列表S2C        |
|     `CMP_C2S_SRC`     | `string` |       客户端支持的压缩算法列表C2S        |
|     `CMP_C2S_DST`     | `string` |       服务器支持的压缩算法列表C2S        |
|     `CMP_S2C_SRC`     | `string` |       客户端支持的压缩算法列表S2C        |
|     `CMP_S2C_DST`     | `string` |       服务器支持的压缩算法列表S2C        |
|    `LANG_C2S_SRC`     | `string` |           客户端支持的语言C2S            |
|    `LANG_C2S_DST`     | `string` |           服务器支持的语言C2S            |
|    `LANG_S2C_SRC`     | `string` |           客户端支持的语言S2C            |
|    `LANG_S2C_DST`     | `string` |           服务器支持的语言S2C            |
|     `DH_KEY_SRC`      | `string` |            客户端支持的DH密钥            |
|     `DH_KEY_DST`      | `string` |            服务器支持的DH密钥            |
|  `SER_HOST_KEY_TYPE`  | `string` |              服务器主机密钥              |
|      `ECDSA_ID`       | `string` |              椭圆曲线标识符              |
|       `ECDSA_Q`       | `string` |               椭圆曲线公钥               |
|      `KEX_H_SIG`      | `string` |                 密钥签名                 |
|      `ENC_C2S_D`      | `string` |               加密算法C2S                |
|      `ENC_S2C_D`      | `string` |               加密算法S2C                |
|      `MAC_C2S_D`      | `string` |                MAC算法C2S                |
|      `MAC_S2C_D`      | `string` |                MAC算法S2C                |
|      `CMP_C2S_D`      | `string` |               压缩算法C2S                |
|      `CMP_S2C_D`      | `string` |               压缩算法S2C                |

### RDP

|       字段名        |  类型  |       中文名       |
| :-----------------: | :----: | :----------------: |
|    `ser_mstshash`     | `string` |       COOKIE       |
|    `cli_mstshash`     | `string` |       COOKIE       |
|     `ser_random`      | `string` | 服务端生成的随机数 |
|     `cli_random`      | `string` | 客户端生成的随机数 |
|   `cli_enc_method`    | `string` |  客户加密密钥信息  |
|     `cli_version`     | `string` |     客户端版本     |
|     `ser_version`     | `string` |     服务端版本     |
|    `cli_hostname`     | `string` |    客户端主机名    |
|    `ser_enc_level`    | `string` |   服务端加密等级   |
|   `ser_enc_method`    | `string` |   服务端加密类型   |
|    `ser_cert_ver`     | `int32`  |   服务端证书版本   |
| `ser_cert_key_alg_id` | `int32`  | 服务端证书密钥算法 |
| `ser_cert_sig_alg_id` | `int32`  | 服务端证书签名算法 |
|   `ser_cert_pubexp`   | `string` | 服务端证书公钥指数 |
|  `ser_cert_moudles`   | `string` | 服务端证书公钥模数 |
| `ser_cert_signature`  | `string` |   服务端证书签名   |
|       `domain`        | `string` |        域名        |
|      `username`       | `string` |       用户名       |
|      `password`       | `string` |        密码        |
|    `program_shell`    | `string` |   程序SHELL命令    |
|     `working_dir`     | `string` |      工作目录      |

### PPTP

|      字段名       |  类型  |              中文名              |
| :---------------: | :----: | :------------------------------: |
|   `hostname_src`    | `string` |           发起方主机名           |
|   `hostname_dst`    | `string` |           接收方主机名           |
|  `vendername_src`   | `string` |           发起方供应商           |
|  `vendername_dst`   | `string` |           接收方供应商           |
|   `dialed_number`   | `string` |             被叫号码             |
|  `dialing_number`   | `string` |             主叫号码             |
|    `callid_out`     | `int16`  |           呼出连接标识           |
|     `callid_in`     | `int16`  |           呼入连接标识           |
|  `flag_start_req`   |  `int8`  | Start-Control-Connection-Request |
| `flag_start_reply`  |  `int8`  |  Start-Control-Connection-Reply  |
|   `flag_stop_req`   |  `int8`  | Stop-Control-Connection-Request  |
|  `flag_stop_reply`  |  `int8`  |  Stop-Control-Connection-Reply   |
|   `flag_echo_req`   |  `int8`  |           Echo-Request           |
|  `flag_echo_reply`  |  `int8`  |            Echo-Reply            |
|   `flag_out_req`    |  `int8`  |      Outgoing-Call-Request       |
|  `flag_out_reply`   |  `int8`  |       Outgoing-Call-Reply        |
|    `flag_in_req`    |  `int8`  |      Incoming-Call-Request       |
|   `flag_in_reply`   |  `int8`  |       Incoming-Call-Reply        |
|    `flag_in_con`    |  `int8`  |     Incoming-Call-Connected      |
|  `flag_clear_req`   |  `int8`  |        Call-Clear-Request        |
| `flag_disc_notify`  |  `int8`  |      Call-Disconnect-Notify      |
| `flag_error_notify` |  `int8`  |         WAN-Error-Notify         |
|   `flag_set_link`   |  `int8`  |          Set-Link-Info           |

### L2TP

|     字段名     |  类型  |    中文名    |
| :------------: | :----: | :----------: |
|    `version`     |  `int8`  |     版本     |
|  `tunnelid_src`  | `int16`  | 上行隧道标识 |
|  `tunnelid_dst`  | `int16`  | 下行隧道标识 |
| `sessionid_src`  | `int16`  | 发起方会话ID |
| `sessionid_dst`  | `int16`  | 接收方会话ID |
|  `hostname_src`  | `string` | 发起方主机名 |
|  `hostname_dst`  | `string` | 接收方主机名 |
| `vendername_src` | `string` | 发起方供应商 |
| `vendername_dst` | `string` | 接收方供应商 |
| `called_number`  | `string` |   被叫号码   |
| `calling_number` | `string` |   主叫号码   |
| `challenge_src`  | `string` | 发起方挑战串 |
| `challenge_dst`  | `string` | 接收方挑战串 |
