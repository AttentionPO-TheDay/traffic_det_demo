@load ../utils

module UDP;

export {
    type Meta: record {
        src:        count   &log &default=0;   # 客户端端口
        dst:        count   &log &default=0;   # 服务端端口
        packet_up:          int     &log &default=0;   # 上行载荷包数
        packet_dn:          int     &log &default=0;   # 下行载荷包数
        byte_up:            int     &log &default=0;   # 上行载荷字节数
        byte_dn:            int     &log &default=0;   # 下行载荷字节数
        payload:            vector of utils::Payload &default=vector();
    };
}