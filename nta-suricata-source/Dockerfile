########################
#        依赖部分       #
########################
FROM ubuntu:22.04 AS suricata-deps

ARG thread=8

# 关闭 CLI 交互
ENV DEBIAN_FRONTEND=noninteractive
# SSL 证书地址
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt    

RUN apt-get update
RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

RUN apt-get install -y iproute2 \
    tzdata \
    ca-certificates \
    git \
    python3 \
    python3-distutils \
    python3-yaml \
    curl \
    wget \
    g++ \
    make \
    m4 \
    autoconf \
    autotools-dev \
    automake \
    libtool \
    pkg-config \
    libpcre3-dev \
    libyaml-dev \
    libjansson-dev \
    libpcap-dev \
    libcap-ng-dev \
    libmagic-dev \
    libluajit-5.1-dev \
    liblz4-dev \
    zlib1g-dev \
    rustc \
    cargo

########################
#        构建部分       #
########################
FROM suricata-deps AS builder

# 可执行文件目录
ENV PATH="${PATH}:/root/.cargo/bin"
ENV CMAKE_BUILD_PARALLEL_LEVEL=$thread

# librdkafka
COPY --chown=root:root ./librdkafka /data/librdkafka/
WORKDIR /data/librdkafka/
RUN ./configure --enable-sasl
RUN make -j${CMAKE_BUILD_PARALLEL_LEVEL}
RUN make install

# suricata
COPY ./suricata /data/suricata/
RUN cargo install --force cbindgen 
WORKDIR /data/suricata
RUN ./autogen.sh
RUN ./configure --prefix=/opt/suricata --enable-luajit --enable-rdkafka
RUN make install -j${CMAKE_BUILD_PARALLEL_LEVEL}

#############################
#  分阶段构建，下面是真正的镜像  #
#############################
FROM ubuntu:22.04 AS prod

# 拷贝动态链接库
COPY --from=builder /opt/suricata/bin/suricata /opt/suricata/bin/suricata
COPY --from=builder /opt/suricata/lib/libhtp.so.2 /opt/suricata/lib/libhtp.so.2
COPY --from=builder /lib/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/
COPY --from=builder /usr/local/lib/ /usr/local/lib/

RUN ldconfig

# 重定向文件
RUN ln -s /opt/suricata/bin/suricata /usr/bin/suricata

ENTRYPOINT [ "/usr/bin/suricata" ]
