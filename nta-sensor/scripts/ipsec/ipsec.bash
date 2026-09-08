#!/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export DATA_FOLDER="${SHELL_FOLDER}/../temp/ipsec_data"

ServerImage="hwdsl2/ipsec-vpn-server"
ClientImage="ohyee/ipsec-vpn-client:latest"

ServerContainerName="ipsec-vpn-server"
ClientContainerName="ipsec-vpn-client"


function func_cut_variable() {
    echo $(docker logs ipsec-vpn-server 2>>/dev/null | grep "$1" | cut -d ":" -f 2 | tr -d " ")
}

function func_start_ipsec_server() {
    # check if the ipsec-vpn-server is running
    if [ $(docker ps -a | grep "$ServerContainerName" | wc -l) -gt 0 ]; then
        echo "ipsec-vpn-server is already running."
    else
        docker run \
            --rm \
            --name ${ServerContainerName}\
            -v ikev2-vpn-data:/etc/ipsec.d \
            -p 500:500/udp \
            -p 4500:4500/udp \
            -d --privileged \
            ${ServerImage}

        echo "Waiting for the server to start..."

        # sleep for 1 seconds
        sleep 1
    fi
   
    export SERVER_IP=$(func_cut_variable "Server IP")
    export IPSEC_PSK=$(func_cut_variable "IPsec PSK")
    export USERNAME=$(func_cut_variable "Username")
    export PASSWORD=$(func_cut_variable "Password")
    export IKEv2_ADDRESS=$(func_cut_variable "VPN server address")
    export IKEv2_CLIENT=$(func_cut_variable "VPN client name")

    echo ${SERVER_IP}, ${IPSEC_PSK}, ${USERNAME}, ${PASSWORD}
}

function func_start_ipsec_client() {
    # SERVER_IP=$(ip addr show eth0 | grep 'inet ' | cut -f 6 -d ' ' | cut -f 1 -d '/')
    # SERVER_IP=$ServerContainerName
    SERVER_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $ServerContainerName)
    docker run \
        --rm \
        -it \
        -e SERVER_IP="${SERVER_IP}" \
        -e IPSEC_PSK="${IPSEC_PSK}" \
        -e USERNAME="${USERNAME}" \
        -e PASSWORD="${PASSWORD}" \
        --privileged \
        -v "${SHELL_FOLDER}/start.bash":"/data/start.bash" \
        --name ${ClientContainerName} \
        ${ClientImage}
}

function func_create_ipsec_client_docker() {
    # check if the image is exist
    if [[ $(docker images ${ClientImage} | wc -l) -eq 1 ]]; then
        echo "Docker image ${ClientImage} is not exist. Start to create..."
        docker build -t ${ClientImage} ${SHELL_FOLDER};
    fi
}

function func_main() {
    func_create_ipsec_client_docker
    func_start_ipsec_server
    func_start_ipsec_client
}

func_main