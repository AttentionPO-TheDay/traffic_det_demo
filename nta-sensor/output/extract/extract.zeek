module Sensor;

export {
    const extract_pcap   = F                    &redef;
    const extract_binary = F                    &redef;
    const extract_directory = "extract_files"   &redef;

    redef record connection += {
        hash:                   string &log &optional;
        pcap_filename:          string &log &optional;
        binary_filename_orig:   string &log &optional;
        binary_filename_resp:   string &log &optional;
    };

    function get_connection_hash(c:connection):string {
        if (!c?$hash) {
            c$hash = md5_hash(c$id, c$start_time);
        }
        return c$hash;
    }
}

function get_pcap_name(c: connection):string {
    if (!c?$pcap_filename) {
        local hash = get_connection_hash(c);
        c$pcap_filename = fmt("%s/%s.pcap", extract_directory, hash);
    }
    return c$pcap_filename;
}

function get_binary_name(c: connection, is_orig: bool):string {
    local hash = c$uid;
    if (is_orig) {
        if (!c?$binary_filename_orig) {
            hash = get_connection_hash(c);
            c$binary_filename_orig = fmt("%s/%s_orig.bin", extract_directory, hash);
        }
        return c$binary_filename_orig;
    } else {
        if (!c?$binary_filename_resp) {
            hash = get_connection_hash(c);
            c$binary_filename_resp = fmt("%s/%s_resp.bin", extract_directory, hash);
        }
        return c$binary_filename_resp;
    }
}

function extract_packet_pcap(c: connection) {
    if (extract_pcap) {
        local filename = get_pcap_name(c);
        dump_current_packet(filename);
    }
}

event tcp_packet(c: connection, is_orig: bool, flags: string, seq: count, ack: count, len: count, payload: string) {
    extract_packet_pcap(c);
}

event udp_request(u: connection) {
    extract_packet_pcap(u);
}

event udp_reply(u: connection) {
    extract_packet_pcap(u);
}

event new_connection(c: connection) {
    # only tcp support set_contents_file
    if (extract_binary && get_conn_transport_proto(c$id) == tcp) {
        local filename_orig = get_binary_name(c, T);
        local f_orig = open_for_append(filename_orig);
        set_contents_file(c$id, CONTENTS_ORIG, f_orig);

        local filename_resp = get_binary_name(c, F);
        local f_resp = open_for_append(filename_resp);
        set_contents_file(c$id, CONTENTS_RESP, f_resp);
    }    
}

