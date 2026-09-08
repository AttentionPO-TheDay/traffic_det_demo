#/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export ROOT_FOLDER=$(cd "${SHELL_FOLDER}/../../";pwd)
export SCIPTS_FOLDER=${ROOT_FOLDER}/scripts
source ${ROOT_FOLDER}/scripts/utils.bash $@

PCAP_FILE=pcap/caidao.pcap

TITLE="caidao webshell 测试"
got=$(${SCIPTS_FOLDER}/zeek.bash -r ${PCAP_FILE} ${SHELL_FOLDER})
want='caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response
caidao_response: 192.168.25.128 -> 192.168.43.83 webshell_caidao_response'

echo -e "\033[1m${TITLE}\033[0m"
if [[ "${got}" == "${want}" ]]; then
    echo -e "\033[32mCheck passed\033[0m"
else
    echo -e "\033[31mCheck failed\033[0m"
    echo "Want|Got:"
    echo -e "${want}"
    echo "--------"
    echo -e "${got}"
fi