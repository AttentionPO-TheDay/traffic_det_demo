@load ../type

module TCP;

export {
    const with_payload = T &redef;
}

event tcp_packet(c: connection, is_orig: bool, flags: string, seq: count, ack: count, len: count, payload: string) {
    # t 或 T 代表报文重传标志
    if (!c$meta?$tcp) {
        c$meta$tcp = TCP::Meta(
            $client_port=port_to_count(c$id$orig_p),
            $server_port=port_to_count(c$id$resp_p)
        );
    }
    if (ends_with(to_lower(c$history), "t")) {
        if (is_orig) {
            c$meta$tcp$packet_retrans_up += 1;
            c$meta$tcp$byte_retrans_up += len;
        } else {
            c$meta$tcp$packet_retrans_dn += 1;
            c$meta$tcp$byte_retrans_dn += len;
        }
    } else {
        if (is_orig) {
            c$meta$tcp$packet_up += 1;
            c$meta$tcp$byte_up += len;
        } else {
            c$meta$tcp$packet_dn += 1;
            c$meta$tcp$byte_dn += len;
        }
    }

    if (with_payload) {
        c$meta$tcp$payload += utils::Payload(
            $timestamp=network_time(),
            $length=len,
            $is_orig=is_orig,
            $type_name=flags,
            $optional=vector(seq, ack)
        );
    }
}