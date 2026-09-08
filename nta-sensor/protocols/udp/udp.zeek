@load ../type

module UDP;

redef udp_content_deliver_all_orig = T;
redef udp_content_deliver_all_resp = T;


export {
    const with_payload = T &redef;
}


event udp_contents(c: connection, is_orig: bool, contents: string) {
    local src = c$id$orig_p;
    local dst = c$id$resp_p;
    if (!is_orig) {
        src = c$id$resp_p;
        dst = c$id$orig_p;
    }
    
    if (!c$meta?$udp) {
        c$meta$udp = UDP::Meta(
            $src=port_to_count(src),
            $dst=port_to_count(dst)
        );
    }

    if (is_orig) {
        c$meta$udp$packet_up += 1;
        c$meta$udp$byte_up += |contents|;
    } else {
        c$meta$udp$packet_dn += 1;
        c$meta$udp$byte_dn += |contents|;
    }

    if (with_payload) {
        c$meta$udp$payload += utils::Payload(
            $timestamp=network_time(),
            $length=|contents|,
            $is_orig=is_orig
        );
    }
}
