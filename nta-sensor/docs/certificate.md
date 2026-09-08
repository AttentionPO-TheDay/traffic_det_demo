# 公钥证书

在使用 SSL 等协议时，需要通过证书来验证对端的身份。

要查看一个 `.cer` 文件，可以使用下面的命令查看其内容

```bash
openssl x509 -in F2giRo29iMlijZg5U.cer -inform der -text -noout
```

