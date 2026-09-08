@load ./ip/type
@load ./tcp/type
@load ./udp/type
@load ./ssl/type
@load ./dns/type
@load ./ssh/type
@load ./ipsec/type
@load ./http/type
@load ./smtp/type
@load ./rdp/type
@load ./imap/type
@load ./pop3/type

module Protocols;

export {
    type Meta: record {
        uid:    string      &log    &default="";
        hash:   string      &log    &default="";
        live:   bool        &log    &default=T;
        source: string      &log    &optional;  # 来源
        ip:     IP::Meta    &log    &optional;  # ip 协议
        tcp:    TCP::Meta   &log    &optional;  # tcp 协议
        udp:    UDP::Meta   &log    &optional;  # udp 协议
        ssl:    SSL::Meta   &log    &optional;  # ssl 协议
        dns:    DNS::Meta   &log    &optional;  # dns 协议
        ssh:    SSH::Meta   &log    &optional;  # ssh 协议
        ipsec:  IPSEC::Meta &log    &optional;  # ipsec 协议
        http:   HTTP::Meta  &log    &optional;  # http 协议
        smtp:   SMTP::Meta  &log    &optional;  # smtp 协议
        rdp:    RDP::Meta   &log    &optional;  # rdp 协议
        imap:   IMAP::Meta  &log    &optional;  # IMAP 协议
        pop3:   POP3::Meta  &log    &optional;  # POP3 协议
    };

    redef record connection += {
        meta:   Meta    &log    &optional;
    };
}