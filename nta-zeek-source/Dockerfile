FROM ubuntu:20.04 AS zeek-deps

ARG thread=8

# 关闭 CLI 交互
ENV DEBIAN_FRONTEND=noninteractive
# SSL 证书地址
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# install the build dependencies
RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && apt-get install -y wget \
    curl \
    git \
    ca-certificates \
    build-essential \
    cmake \
    make \
    gcc \
    g++ \
    flex \
    bison \
    libpcap-dev \
    libssl-dev \
    python \
    python3 \
    python3-dev \
    swig \
    zlib1g-dev \
    libpthread-stubs0-dev && \
    mkdir /data

COPY --chown=root:root ./spicy_linux_ubuntu20.deb /data/

###########################################
# gmssl                
# GmSSL 编译，用于生成对应的 include 和 lib        
###########################################
FROM zeek-deps AS gmssl
ENV CMAKE_BUILD_PARALLEL_LEVEL=$thread
COPY --chown=root:root ./GmSSL /data/GmSSL/
WORKDIR /data/GmSSL

RUN mkdir build
WORKDIR /data/GmSSL/build
RUN cmake ..
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
RUN make install
RUN ldconfig

###########################################
# zeek   
# Zeek 本体编译，用于生成 Zeek 二进制        
###########################################
FROM zeek-deps AS zeek
ENV CMAKE_BUILD_PARALLEL_LEVEL=$thread

COPY --from=gmssl /usr/local /usr/local
RUN ldconfig

# zeek
COPY --chown=root:root ./zeek /data/zeek/
WORKDIR /data/zeek
RUN ./configure --prefix=/opt/zeek
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
RUN make install

# spicy
RUN dpkg --install /data/spicy_linux_ubuntu20.deb
ENV PATH="/opt/zeek/bin:/opt/spicy/bin:${PATH}"

# spicy-plugin
COPY --chown=root:root ./spicy-plugin /data/spicy-plugin/
RUN mkdir -p /data/spicy-plugin/build
WORKDIR /data/spicy-plugin/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/spicy ..
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
WORKDIR /data/spicy-plugin
RUN make -C build install

# zeek-spicy-ipsec
COPY --chown=root:root ./zeek-spicy-ipsec /data/zeek-spicy-ipsec/
WORKDIR /data/zeek-spicy-ipsec
RUN mkdir -p /data/zeek-spicy-ipsec/build
WORKDIR /data/zeek-spicy-ipsec/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/spicy ..
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
WORKDIR /data/zeek-spicy-ipsec
RUN make -C build install

# librdkafka
COPY --chown=root:root ./librdkafka /data/librdkafka/
WORKDIR /data/librdkafka/
RUN ./configure --enable-sasl
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
RUN make install

# zeek-kafka
COPY --chown=root:root ./zeek-kafka /data/zeek-kafka/
WORKDIR /data/zeek-kafka
RUN ./configure --with-librdkafka=$librdkafka_root 
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
RUN make install 
RUN ldconfig

###########################################
# zeek 镜像本体  
# 分阶段构建，下面是真正的镜像     
###########################################
FROM ubuntu:20.04 AS prod

# 关闭 CLI 交互
ENV DEBIAN_FRONTEND=noninteractive
# SSL 证书地址
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=zeek /opt /opt

COPY --from=zeek /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu
COPY --from=zeek /usr/local/lib /usr/local/lib
COPY --from=gmssl /usr/local/lib /usr/local/lib

RUN ldconfig

WORKDIR /data
ENV PATH=${PATH}:/opt/zeek/bin:/opt/spicy/bin
ENV ZEEKPATH=.:/opt/zeek/share/zeek:/opt/zeek/share/zeek/policy:/opt/zeek/share/zeek/site:/opt/spicy/lib/spicy/zeek/scripts:/opt/spicy/lib/zeek-spicy/scripts

ENTRYPOINT ["/opt/zeek/bin/zeek"]
