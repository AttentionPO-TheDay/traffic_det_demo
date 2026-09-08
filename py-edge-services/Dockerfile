# PySpark 用于 /dataFrame 生成 CSV。原 apache/spark-py:3.3.1 已退役下架，
# 这里改用 python:3.9-slim 基础镜像，自行安装 Java（供 PySpark 运行）与所需系统工具。
FROM python:3.9-slim

USER root
ENV DEBIAN_FRONTEND=noninteractive

# 使用 Debian 默认源（deb.debian.org），不再 sed 换源，避免不同基础镜像 sources 格式差异
RUN apt-get update && \
    apt-get install -y --no-install-recommends default-jre-headless nmap ncat && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/dataframes

ENV JAVA_HOME=/usr/lib/jvm/default-java

RUN pip3 install --no-cache-dir \
    pyspark==3.3.1 \
    elasticsearch==6.8.1 \
    python-nmap==0.7.1 \
    flask==2.2.3 \
    werkzeug==2.2.3 \
    numpy==1.22.4 \
    nistrng==1.2.3

# 把代码打进镜像（原独立 compose 是靠 volume 挂载 ./py-code，这里改为自包含）
COPY py-code /py-code

WORKDIR /root/dataframes
EXPOSE 8888

ENTRYPOINT ["python3", "/py-code/main.py"]