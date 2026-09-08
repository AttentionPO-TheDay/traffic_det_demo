@load ../type

module TCP;

export {
    type Meta: record {
        client_port:        count   &log &default=0;   # 客户端端口
        server_port:        count   &log &default=0;   # 服务端端口
        packet_up:          int     &log &default=0;   # 上行载荷包数
        packet_dn:          int     &log &default=0;   # 下行载荷包数
        byte_up:            int     &log &default=0;   # 上行载荷字节数
        byte_dn:            int     &log &default=0;   # 下行载荷字节数
        packet_retrans_up:  int     &log &default=0;   # 上行重传包数
        byte_retrans_up:    int     &log &default=0;   # 上行重传字节数
        packet_retrans_dn:  int     &log &default=0;   # 下行重传包数
        byte_retrans_dn:    int     &log &default=0;   # 下行重传字节数
        payload:            vector of utils::Payload &default=vector();
    };
}