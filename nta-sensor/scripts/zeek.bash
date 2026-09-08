#!/bin/bash

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

if [[ $(func_check " -i" $@) -eq "1" ]] && [[ -z $(echo ${ZEEK_BIN} | g
rep "docker") ]]; then
    sudo $ZEEK_BIN $ZEEK_ARGS $@
else
    $ZEEK_BIN $ZEEK_ARGS $@
fi