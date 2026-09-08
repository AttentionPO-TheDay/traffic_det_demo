@load ..
@load ../utils

module IP;


export {
    const with_payload = T &redef;
}

# event new_connection(c: connection) {
#     if (!c?$meta) {
#         c$meta = Protocol::Meta(
#             $ip=IP::Meta(
#                 $client=c$id$orig_h,
#                 $server=c$id$resp_h
#             )
#         );
#     }
# }

function init_ip_meta(c: connection) {
    Protocols::init_protocol_meta(c);
    if (!c$meta?$ip) {
        c$meta$ip = IP::Meta();
    }
}

event new_packet(c: connection, p: pkt_hdr) {
    init_ip_meta(c);

    if (p?$ip) {
        if (c$meta$ip$version == 0) {
            c$meta$ip$src = p$ip$src;
            c$meta$ip$dst = p$ip$dst;
            c$meta$ip$version = 4;
            c$meta$ip$protocol = p$ip$p;
        }
        c$meta$ip$length += p$ip$len;
    
        if (with_payload) {
            c$meta$ip$payload += utils::Payload(
                $timestamp=network_time(),
                $length=p$ip$len,
                $is_orig=p$ip$src==c$meta$ip$src,
                $optional=p$ip$p
            );
        }
    }
    if (p?$ip6) {
        c$meta$ip$version = 6;
        # c$meta$ip$length = p$ip6$len;
        c$meta$ip$src = p$ip6$src;
        c$meta$ip$dst = p$ip6$dst;
        c$meta$ip$protocol = p$ip6$nxt;

        c$meta$ip$length += p$ip6$len;
    
        if (with_payload) {
            c$meta$ip$payload += utils::Payload(
                $timestamp=network_time(),
                $length=p$ip6$len,
                $is_orig=p$ip6$src==c$meta$ip$src
            );
        }
    }
}