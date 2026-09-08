FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y strongswan xl2tpd net-tools curl systemctl

# COPY start.bash /data/start.bash

CMD [ "bash", "/data/start.bash" ]