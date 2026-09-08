#!/bin/bash
#!/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)


VERSION="1.0.5"
IMAGE="ohyee/zeek:${VERSION}"

function func_help() {
    echo "- build       构建 Zeek 镜像"
    echo "- pull        拉取 Zeek 镜像"
    echo "- run         使用 Zeek 镜像"    
    echo "- patch       生成 diff 文件"
}

function make_patch() {
    git -C temp/zeek diff v4.0.2 > zeek.diff
    git -C temp/zeek-spicy-ipsec diff v0.2.6 > ipsec.diff
}

case $1 in
    "build")    cd ${SHELL_FOLDER} && docker build --network host -t "${IMAGE}" .;;
    "pull")     docker pull "${IMAGE}";;
    "clear")    cd ${SHELL_FOLDER}/kafka && docker-compose rm -fsv;;
    "run")      cd ${SHELL_FOLDER}/../.. && docker run --rm --net=host --privileged -v $(pwd):/data "${IMAGE}" ${@:2};;
    "patch")    cd ${SHELL_FOLDER} && make_patch;;
    *)          func_help;;
esac