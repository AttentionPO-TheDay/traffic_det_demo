#!/bin/bash

export ROOT_FOLDER=$(cd "$(dirname "$0")";pwd)
export SCIPTS_FOLDER=${ROOT_FOLDER}/scripts

source ${SCIPTS_FOLDER}/utils.bash $@

function func_helpText() {
    echo "$0 辅助脚本"
    echo "    debug     查看调试信息"
    echo "    zeek      调用 zeek 执行命令"
    echo "    clean     清理日志"
    echo "    kafka     启动/关闭 kafka"
    echo "    run       启动当前根目录的 zeek"
}

if [ $# -eq "0" ]; then
    func_helpText
else
    case $1 in
        "debug")    bash ${SCIPTS_FOLDER}/debug.bash $@;;
        "zeek")     bash ${SCIPTS_FOLDER}/zeek.bash $REAL_ARGS;;
        "clean")    bash ${SCIPTS_FOLDER}/clean_logs.bash $REAL_ARGS;;
        "kafka")    bash ${SCIPTS_FOLDER}/kafka.bash $REAL_ARGS;;
        "run")      PCAP_FILE="./pcap/ipsec/keyman_dpd.pcap"; bash ${SCIPTS_FOLDER}/zeek.bash -Cr "${PCAP_FILE}" . | jq -R -r '. as $line | try fromjson catch $line';;
        "zeek-docker") bash ${SCIPTS_FOLDER}/zeek/zeek.bash $REAL_ARGS;;
        *)          func_helpText    ;;
    esac
fi
