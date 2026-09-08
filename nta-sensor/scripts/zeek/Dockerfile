FROM ohyee/zeek:source AS gmssl

WORKDIR /data/GmSSL

RUN mkdir build
WORKDIR /data/GmSSL/build
RUN cmake ..
RUN make -j8
RUN make install
RUN ldconfig

###########################################
# zeek   
# Zeek 本体编译，用于生成 Zeek 二进制        
###########################################
FROM ohyee/zeek:source AS zeek

COPY --from=gmssl /usr/local /usr/local
RUN ldconfig

WORKDIR /data/zeek
COPY zeek.diff /data/zeek.diff
RUN git apply /data/zeek.diff
RUN ./configure --prefix=/opt/zeek
RUN make -j8
RUN make install

# spicy
RUN dpkg --install /data/spicy_linux_ubuntu20.deb
ENV PATH="/opt/zeek/bin:/opt/spicy/bin:${PATH}"

# spicy-plugin
RUN mkdir -p /data/spicy-plugin/build
WORKDIR /data/spicy-plugin/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/spicy ..
RUN make -j8
WORKDIR /data/spicy-plugin
RUN make -C build install

# spicy-analyzers
# RUN mkdir -p /data/spicy-analyzers/build
# WORKDIR /data/spicy-analyzers/build 
# RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/spicy ..
# RUN make -j8
# WORKDIR /data/spicy-analyzers
# RUN make -C build install

# zeek-spicy-ipsec
WORKDIR /data/zeek-spicy-ipsec
COPY ipsec.diff /data/ipsec.diff
RUN git apply /data/ipsec.diff
RUN mkdir -p /data/zeek-spicy-ipsec/build
WORKDIR /data/zeek-spicy-ipsec/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/spicy ..
RUN make -j8
WORKDIR /data/zeek-spicy-ipsec
RUN make -C build install

# librdkafka
RUN tar xvzf /data/v1.4.2.tar.gz --directory=/data 
WORKDIR /data/librdkafka-1.4.2/
RUN ./configure --enable-sasl
RUN make
RUN make install

# zeek-kafka
WORKDIR /data/zeek-kafka
RUN ./configure --with-librdkafka=$librdkafka_root 
RUN make 
RUN make install 
RUN ldconfig

# 分阶段构建，下面是真正的镜像
FROM ubuntu:latest AS prod

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