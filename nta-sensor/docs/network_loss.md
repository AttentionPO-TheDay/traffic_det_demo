# 使用 iptables 模拟丢包

在当今的网络环境下

```bash
sudo iptables -A INPUT -p udp -m statistic --mode random --probability 0.8 -j DROP
```

清除所有规则

```bash
sudo iptables -F
```
