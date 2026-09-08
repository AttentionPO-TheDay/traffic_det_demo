# Zeek

编译安装 Zeek

```bash
git submodule update --recursive --init
./configure --prefix=/opt/zeek
make -j8
sudo make install
```

## Zeek Scripts

Zeek 是一个流量分析系统，重点在于分析。分析的过程依赖于自带的功能函数以及用户自定义的 Zeek Scripts

使用 `zeek xxxx.zeek` 就可以运行 `xxxx.zeek` 脚本

整个 Zeek Scripts 包含三部分内容：

- 第一部分是以`@load` 开始的模块引入部分，并且使用`module` 配置命名空间
- 第二部分是以`export` 开始的导出部分（可替换常量部分）
- 第三部分是对事件的处理部分（真正的处理逻辑部分）

万物起源于 "Hello World!"，下面这段代码就是 Zeek Scripts 的起始

```zeek
event zeek_init() {
    print "Hello World!";
}
```

Zeek 是由事件驱动，每个时间如同一个触发器，当 Zeek 发现存在对应的事件发生时，就会触发对应的代码，执行逻辑。那么，这里自然而然地想法就是，如果有一个事件包含多种不同的处理逻辑，应该怎么办。

很简单，只需要设定多个事件即可，实际上这里是将事件放到有序的事件队列中，逐个处理。

```zeek
event zeek_init() {
    print "Hello World!";
}

event zeek_init() {
    print "Hello World2!";
}
```

这里会输出

```bash
Hello World2!
Hello World
```

### 基础语法

尽管 Zeek Scripts 与大部分语言不同为事件驱动，但是我们仍然可以如同 Python 等语言一样，进行普通的逻辑操作

#### 常量

与其他语言一样，Zeek 也有常量类型，但是这里的常量是 **运行前可变** 的。也即在 Zeek 启动前，可以借助 `redef HTTP::default_capture_password = T` 的语法，重新定义其他模块的常量。当 Zeek 启动完毕后（开始处理事件后），无法再次修改常量。（可被修改的变量，需要在最后添加 `&redef` 标识符）

```zeek
module HTTP;

export {
    ## This setting changes if passwords used in Basic-Auth are captured or
    ## not.
    const default_capture_password = F &redef;
}
```

这里常量本质上实际上是一个 “不可变的变量”，如使用 `+=` 实际上会在原本基础上修改常量

#### 类型

|    类型    |       解释        |        例子         |
| :--------: | :---------------: | :-----------------: |
|   `int`    |  64 位有符号整数  |         `1`         |
|  `count`   |  64 位无符号整数  |         `1`         |
|  `double`  |    双精度浮点     |        `1.2`        |
|   `bool`   |     布尔类型      |         `T`         |
|   `addr`   |      IP 地址      |     `127.0.0.1`     |
|   `port`   |    传输层端口     |      `22/tcp`       |
|  `subnet`  | CIDR 格式子网掩码 |   `172.16.0.0/20`   |
|   `time`   |     绝对时间      | `1623591787.552373` |
| `interval` |     时间间隔      |      `2.2sec`       |
| `pattern`  |    正则表达式     |      `/quick`       |

- **集合**: 可用 `add`、`delete`、`for in` 对集合进行操作（遍历无法保证顺序）

  ```zeek
   local s1: set[port];
   local s2 = set( 23/tcp, 80/tcp, 143/tcp, 25/tcp );
  ```

- **表**: 键值对数据

  ```zeek
  local t1: table[string] of port;
  local t2 = table(["SSH"] = 22/tcp, ["HTTPS"] = 443/tcp)
  ```

- **向量**: 有序列表

  ```zeek
  local v1: vector of count;
  local v2 = vector(1, 2, 3, 4);
  ```

- **结构体**

  ```zeek
  type Service: record {	name: string;	ports: set[port];	rfc: count;}
  ```

#### 作用域

通常而言，变量应该使用 `local` 声明为局部变量，只在 `{}` 内有效

#### 函数

以实现加法函数为例

```zeek
function sum(a: count, b: count): count {
    local result = a + b;
    print fmt("%d + %d = %d", a, b, result);
    return result;
}

event zeek_init() {
    local result = sum(5, 8);
    print result;
}
```

可以将 Zeek 启动事件 `zeek_init` 作为通常语言的 `main()` 函数。在该事件下完成函数，即可如同其他语言一样运行逻辑（可以不从网卡或文件读入文件，因为不需要对流量处理）

需要注意的是，这里的打印函数类似于 Python2，不带括号，并且如果需要格式化输出，要使用 `fmt` 函数拼接字符串

### 日志

尽管 `print` 也可以完成输出，但是在很多情况下使用日志系统更为通用性

要使用日志系统，需要首先初始化日志流，而后写入日志

```zeek
Log::create_stream(LOG, [ $columns = Record, $path="logfile" ])
Log::write( Factor::LOG, [ $num=1 ])
```

这里，在初始化时，需要为 `columns` 设定一个结构体。而后续打印日志则需要传入对应的结构体变量。日志的函数的第一个参数为操作的 “日志对象”，类似于面对对象的操作，只是使用类 C 的语法以参数传入。

所有的日志输出，将会被输出至运行目录 `$path` 设定的文件内（会补充 `.log` 结尾）

除去基本的日志打印外，还可以添加过滤器对打印内容进行过滤

### 通知

Zeek 本身包含各种已经预设的功能，通知策略可以方便用户自定义自己的功能。当 Zeek 发现用户可能感兴趣的内容时，会发送一条 `Notice::Info` 记录。用户通过配置 `Notice::policy` 钩子，可以对通知执行大量的操作（也可以什么都不做）

通知包含下述几种动作

|          动作          |          描述          |
| :--------------------: | :--------------------: |
|  `Notice::ACTION_LOG`  |  写出到`Notice::LOG`   |
| `Notice::ACTION_ALARM` |  按小时记录发送到邮箱  |
| `Notice::ACTION_EMAIL` |       发送到邮件       |
| `Notice::ACTION_PAGE`  | 发送到邮件或是其他地址 |

### 事件

事件本质上是一系列按照优先级排序的函数，当事件被触发时，优先队列的函数会按照顺序被触发

下面我们声明了一个名为 `myevent` 的事件，并且对其声明了两个实现（优先级分别为 `-10` 和 `10`），在 `zeek_init()` 会对他们进行调用，运行后可以看出优先级为 `10` 的事件触发会更早被调用。

同时，事件本身并非同步执行的，执行时可以发现 `zeek_done()` 早于 `event myevent("done");`。也即事件队列的触发为 **异步** 的

除此之外，事件可以使用 `schedule 5 sec {}` 使其延迟 5 秒触发。但是如果 Zeek 提前结束（实测是函数体提前结束），则可能提前在结束时触发

```zeek
global myevent: event(s: string);
global n = 0;

event myevent(s: string) &priority = -10 {
    ++n;
}

event myevent(s: string) &priority = 10 {
    print "myevent", s, n;
}

event zeek_init() {
    print "zeek_init()";
    event myevent("hi");
    schedule 5 sec { myevent("bye") };
}

event zeek_done() {
    event myevent("done");
    print "zeek_done()";
}
```

对于 Zeek 本身而言，有两个重要的声明周期 `zeek_init()` 和 `zeek_done()`，分别会在 Zeek 启动和结束时调用，对应构造函数和析构函数。

首先是对声明周期的事件触发

- [`new_connection`](https://docs.zeek.org/en/master/scripts/base/bif/event.bif.zeek.html#id-new_connection): 连接建立时触发
- [`connection_timeout`](https://docs.zeek.org/en/master/scripts/base/bif/event.bif.zeek.html#id-connection_timeout): 连接超时时触发
- [`connection_state_remove`](https://docs.zeek.org/en/master/scripts/base/bif/event.bif.zeek.html#id-connection_state_remove): 连接结束时触发

### 钩子

Hook 可以认为是一种特殊的事件。与事件一样 Hook 也会按照优先级逐个调用，但是不同的是，在 Hook 内部，可以使用 `break` 中断后续的调用。通过返回值可以得知是否所有的钩子都被调用

```zeek
global myhook: hook(s: string);

hook myhook(s: string) &priority = 10 {
    print "priority 10 myhook handler", s;
    s = "bye";
}

hook myhook(s: string) {
    print "break out of myhook handling", s;
    break;
}

hook myhook(s: string) &priority = -5 {
    print "not going to happen", s;
}

event zeek_init()  {
    local ret: bool = hook myhook("hi");
    print(ret);
    if ( ret ) {
        print "all handlers ran";
    }
}
```

### 检测特定内容

以 DNS 为例，从 [DNS 文档](https://docs.zeek.org/en/master/scripts/base/protocols/dns/main.zeek.htm) 可知，这里共暴露了如下可操作的内容

- 常量
  - 日志 ID
  - 连接
  - 端口号
- 事件
  - `event DNS::log_dns()`
- 钩子
  - `hook DNS::do_reply()`
  - `hook DNS::finalize_dns()`
  - `hook DNS::log_policy()`
  - `hook DNS::set_session()`

假设我们希望打印 DNS 查询的域名，应该如何做呢？

查看下面的代码

```zeek
event DNS::log_dns(rec: DNS::Info) {
    print fmt("rec.query %s", rec$query);
}

hook DNS::do_reply(c: connection, msg: dns_msg, ans: dns_answer, reply: string) : bool {
    print fmt("c.dns.query %s", c$dns$query);
    print fmt("ans.query %s", ans$query);
}
```

当我们发出一条 DNS 请求时，首先会触发 `DNS::do_reply()`，在这里我们可以进行通过传入的参数，获取请求的信息。除此之外，我们还可以借助 `DNS::log_dns()` 实现在日志写出时添加自己的代码（日志的写出可能存在滞后性，可能不会立即触发）

借助这两种思路，我们可以实现对特定内容的检测，如检测是否访问了特定域名

## Zeek 使用

如果只是为了测试自己的 Zeek Scripts，那么只需要使用 `zeek -i eth0 xx.zeek` 或是 `zeek -r xxx.pcap xx.zeek` 即可[^zeek-base]

在正式使用中，Zeek 通常使用 `zeekctl` 启动，这时默认会加载 `/usr/local/zeek/share/zeek/site/local.zeek`。如果需要修改载入的脚本，则可以在这里修改代码。

通常情况下，应该添加 `redef ignore_checksums = T;` 声明不检查校验，否则会有大量的报错信息（很多情况下，校验字段由网卡生成，在设备内会被随机填充以提升效率）

为了安全起见，FTP 等明文密码不会被抓取，可以通过 `redef FTP::default_capture_password = T;` 开启对 FTP 密码的抓取

## 特征

类似于 Snort/Suricata 的规则，Zeek 可以定义特征并触发事件（存放在 `.sig` 文件内）[^signature]

```zeek
signature my-first-sig {	
    ip-proto == tcp	
    dst-port == 80	
    payload /.*root/	
    event "Found root!"
}
    
event signature_match(state: signature_state, msg: string, data: string)
```

条件由如下部分包含

- 条件
  - 头部:`event <proto>[<offset>:<size>] [& <integer>] <cmp> <value-list>`
  - 内容:`http-request /<regular expression>/`
  - 依赖: 两条规则的与或非关系
  - 上下文: 调用`.zeek` 中的函数，根据返回值判断匹配结果
- 动作: 满足条件时，触发事件

[^signature]: [Signature Framework — Book of Zeek (git/master)](https://docs.zeek.org/en/master/frameworks/signatures.html#basics)
[^zeek-base]: [实验 · 网络安全 (c4pr1c3.github.io)](https://c4pr1c3.github.io/cuc-ns/chap0x12/exp.html)
[^zeek-custom-protocol]: [在 Bro 中完成第一个协议分析器—RIP 协议 | Terry Tang (guozet.me)](http://www.guozet.me/post/Write-first-Analyzer-rip/)
