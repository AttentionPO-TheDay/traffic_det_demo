#/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export ROOT_FOLDER=$(cd "${SHELL_FOLDER}/../../";pwd)
export SCIPTS_FOLDER=${ROOT_FOLDER}/scripts
source ${ROOT_FOLDER}/scripts/utils.bash $@

PCAP_FILE=pcap/http_taobao_baidu.pcap
# PCAP_FILE=pcap/http_loss.pcap

# TITLE=特征样例测试
# got=$(${SCIPTS_FOLDER}/zeek.bash -r ${PCAP_FILE} ${SHELL_FOLDER})
# want="check_http_baidu: 172.21.253.198 -> 110.242.68.3"
# echo $got

${SCIPTS_FOLDER}/zeek.bash -r ${PCAP_FILE} ${SHELL_FOLDER}

# echo -e "\033[1m${TITLE}\033[0m"
# if [[ "${got}" == "${want}" ]]; then
#     echo -e "\033[32mCheck passed\033[0m"
# else
#     echo "\033[31mCheck failed\033[0m"
#     echo "Want|Got:"
#     echo "${want}"
#     echo "--------"
#     echo "${got}"
# fi