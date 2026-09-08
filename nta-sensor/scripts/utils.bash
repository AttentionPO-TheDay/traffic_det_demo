#!/bin/bash

export SHELL_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function func_check() {
    # 检查参数是否包含特定内容
    # $1    要检查的内容
    # $2... 参数
    if [[ ${@:2:$#} =~ ${1} ]]; then echo 1; else echo 0; fi
}

function func_args_cut() {
    l=$1
    args=(${@:2})
    echo ${args[*]:$l}
}

export REAL_ARGS=$(func_args_cut 1 $@)

export ZEEK_BIN="bash ${SHELL_FOLDER}/zeek/zeek.bash run"
export ZEEK_ARGS=""
export ZEEK_ARGS+="-C" # 取消校验和

export PATH=$PATH:/opt/zeek/bin:/opt/spicy/bin

export ZEEKPATH=$ZEEKPATH:$(zeek --help 2>&1 | grep "ZEEKPATH" | tr -s " " | cut -d " " -f 7 | sed 's/[\(\)]//g')
export ZEEKPATH=$ZEEKPATH:/opt/spicy/lib/spicy/zeek/scripts

if [[ -e ".env" ]]; then
    source .env
fi

export -f func_check
export -f func_args_cut