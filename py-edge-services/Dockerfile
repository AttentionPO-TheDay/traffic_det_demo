FROM apache/spark-py:3.3.1

USER root
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/g' /etc/apt/sources.list && \
    apt-get update && \
    mkdir /root/dataframes && \
    apt install -y nmap ncat && \
    pip3 install pyspark==3.3.1 elasticsearch==6.8.1 python-nmap==0.7.1 flask==2.2.3 werkzeug==2.2.3 numpy==1.22.4 nistrng==1.2.3

WORKDIR /root/dataframes
EXPOSE 8888

ENTRYPOINT ["python3", "/py-code/main.py"]
