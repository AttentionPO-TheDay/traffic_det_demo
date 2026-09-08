# Kafka 模块

该模块要求使用 [Apache/metron-bro-plugin-kafka](https://bitbucket.org/sdtbupt/sensor/src/master/protocols/) 插件。

## 编译教程

1. 拉取 Zeek、Kafka 插件源码
    ```bash
    git clone https://github.com/zeek/zeek.git
    git clone https://github.com/SeisoLLC/zeek-kafka.git
    ```
2. 编译 Zeek（这里将 Zeek 编译至 `/opt/zeek`，需要自己添加环境遍历，去掉 `--prefix` 可以正常编译）
    ```zeek
    git submodule update --recursive --init
    ./configure --prefix=/opt/zeek
    make -j8
    sudo make install
    ```
3. 编译 Kafka 插件到 Zeek
    ```zeek
    ./configure --with-librdkafka=$librdkafka_root
    make
    sudo make install
    ```