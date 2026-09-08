#!/bin/bash

docker run -it -p 127.0.0.1:8888:8888 -v /root/dataframes:/root/dataframes -v $(pwd)/py-code:/py-code py-edge-services 185.239.209.233
