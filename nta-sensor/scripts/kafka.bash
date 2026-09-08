#!/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

function func_help() {
    echo "- start       启动 kafka Docker"
    echo "- stop        关闭 kafka Docker"
    echo "- clear        清理 kafka Docker 缓存"
    echo "- producer    打开 kafka 生产者"
    echo "- consumer    打开 kafka 消费者"
    # echo "- install     "
}

case $1 in
    "start")    cd ${SHELL_FOLDER}/kafka && docker-compose up -d;;
    "stop")     cd ${SHELL_FOLDER}/kafka && docker-compose down;;
    "clear")    cd ${SHELL_FOLDER}/kafka && docker-compose rm -fsv;;
    # "install")  git clone https://github.com/apache/metron-bro-plugin-kafka.git && \
    #             cd metron-bro-plugin-kafka && \
    #             echo "Run code below" && \
    #             echo './configure --with-librdkafka=$librdkafka_root' \
    #             echo 'make' \
    #             echo 'sudo make install';;
    "consumer") docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server 140.82.10.193:9094 --topic=zeek;;
    "producer") docker exec -i kafka /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server 140.82.10.193:9094 --topic=aimodeltopic;;
    *)          func_help;;
esac
