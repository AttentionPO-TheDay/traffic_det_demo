@load trace
@load protocols
@load ./output/log
@load ./output/kafka
@load ./output/extract

module Sensor;

# 是否输出协议数据包内容（会大量增加输出长度）
redef IP::with_payload = T;
redef TCP::with_payload = T;
redef UDP::with_payload = T;
redef HTTP::with_payload = F;
redef IPSEC::with_payload = T;


redef SSL::with_certificate_content = T; # 是否对输出 SSL 证书内容

redef Sensor::source = "zeek-1";
redef Sensor::to_console = T; # 是否将裸元数据输出至命令行
redef Sensor::to_kafka = F; # 是否输出至 Kafka
redef Sensor::debug_print = F; # 调试开关：是否将 connection 转为 json，带上调试标记输出至命令行

redef extract_pcap   = T; # 是否提取 pcap 文件
redef extract_binary = F; # 是否提取二进制文件
redef extract_directory = "extract_files"; # 提取文件存放目录

event connection_state_remove(c: connection) {
    if (c?$meta) {
        Sensor::output(c$meta);
        Sensor::debug_print_connection(c);
    }
}
