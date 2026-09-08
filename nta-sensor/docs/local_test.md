# 本地测试环境

项目地址：https://git.oyohyee.com/ETIDS/sensor

项目依赖：Zeek Docker 镜像、Kafka Docker 镜像

1. 启动 Kafka: `bash s.bash kafka start`
2. 启动一个 kafka 消费者: `bash s.bash kafka consumer`
3. 启动一个 kafka 生产者: `bash s.bash kafka producer`
    在生产者输入文字后回车，可以在消费者看到内容（只用于测试，测试完就可以关掉生产者了）
4. 拉取 Zeek 镜像: `bash s.zeek zeek-docker pull` (已经编译到 Docker Hub 了)
5. 使用 Zeek `bash s.zeek zeek -i eth0` 或 `bash s.zeek zeek-docker run -i eth0`
    （默认使用 Docker 内的 Zeek，可以在目录下建立 `.env` 文件，并写入 `ZEEK_BIN=/opt/zeek/bin/zeek` 指定本地安装的 Zeek）
6. 使用 `bash s.zeek run` 可以进行一个简单的调试，同时元数据会输出到 Kafka
7. 根据正常 zeek 使用方式使用 zeek 即可