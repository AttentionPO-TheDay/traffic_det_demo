@load base/protocols/conn
@load base/protocols/dce-rpc
@load base/protocols/dhcp
@load base/protocols/dnp3
@load base/protocols/dns
@load base/protocols/ftp
@load base/protocols/http
@load base/protocols/imap
@load base/protocols/irc
@load base/protocols/krb
@load base/protocols/modbus
@load base/protocols/mqtt
@load base/protocols/mysql
@load base/protocols/ntlm
@load base/protocols/ntp
@load base/protocols/pop3
@load base/protocols/radius
@load base/protocols/rdp
@load base/protocols/rfb
@load base/protocols/sip
@load base/protocols/smb
@load base/protocols/smtp
@load base/protocols/snmp
@load base/protocols/socks
@load base/protocols/ssh
@load base/protocols/ssl
@load base/protocols/syslog
@load base/protocols/tunnels
@load base/protocols/xmpp

event zeek_init() {
    print fmt("[event] zeek_init()");
    print "";
    print "";
}

event zeek_done() {
    print fmt("[event] zeek_done()");
    print "";
    print "";
}

event net_done(t: time) {
    print fmt("[event] net_done(t = <%s>)", t);
    print "";
    print "";
}

event network_time_init() {
    print fmt("[event] network_time_init()");
    print "";
    print "";
}

event new_connection(c: connection) {
    print fmt("[event] new_connection()");
    print "";
    print "";
}

event tunnel_changed(c: connection, e: EncapsulatingConnVector) {
    print fmt("[event] tunnel_changed(e = <%s>)", e);
    print "";
    print "";
}

event connection_timeout(c: connection) {
    print fmt("[event] connection_timeout()");
    print "";
    print "";
}

event connection_state_remove(c: connection) {
    print fmt("[event] connection_state_remove()");
    print "";
    print "";
}

event connection_reused(c: connection) {
    print fmt("[event] connection_reused()");
    print "";
    print "";
}

event connection_status_update(c: connection) {
    print fmt("[event] connection_status_update()");
    print "";
    print "";
}

event connection_flow_label_changed(c: connection, is_orig: bool, old_label: count, new_label: count) {
    print fmt("[event] connection_flow_label_changed(is_orig = <%s>, old_label = <%s>, new_label = <%s>)", is_orig, old_label, new_label);
    print "";
    print "";
}

event udp_session_done(u: connection) {
    print fmt("[event] udp_session_done()");
    print "";
    print "";
}

event scheduled_analyzer_applied(c: connection, a: Analyzer::Tag) {
    print fmt("[event] scheduled_analyzer_applied(a = <%s>)", a);
    print "";
    print "";
}

event raw_packet(p: raw_pkt_hdr) {
    print fmt("[event] raw_packet(p = <%s>)", p);
    print "";
    print "";
}

event new_packet(c: connection, p: pkt_hdr) {
    print fmt("[event] new_packet(p = <%s>)", p);
    print "";
    print "";
}

event ipv6_ext_headers(c: connection, p: pkt_hdr) {
    print fmt("[event] ipv6_ext_headers(p = <%s>)", p);
    print "";
    print "";
}

event esp_packet(p: pkt_hdr) {
    print fmt("[event] esp_packet(p = <%s>)", p);
    print "";
    print "";
}

event mobile_ipv6_message(p: pkt_hdr) {
    print fmt("[event] mobile_ipv6_message(p = <%s>)", p);
    print "";
    print "";
}

event packet_contents(c: connection, contents: string) {
    print fmt("[event] packet_contents(contents = <%s>)", contents);
    print "";
    print "";
}

event rexmit_inconsistency(c: connection, t1: string, t2: string, tcp_flags: string) {
    print fmt("[event] rexmit_inconsistency(t1 = <%s>, t2 = <%s>, tcp_flags = <%s>)", t1, t2, tcp_flags);
    print "";
    print "";
}

event content_gap(c: connection, is_orig: bool, seq: count, length: count) {
    print fmt("[event] content_gap(is_orig = <%s>, seq = <%s>, length = <%s>)", is_orig, seq, length);
    print "";
    print "";
}

event analyzer_confirmation(c: connection, atype: Analyzer::Tag, aid: count) {
    print fmt("[event] analyzer_confirmation(atype = <%s>, aid = <%s>)", atype, aid);
    print "";
    print "";
}

event protocol_late_match(c: connection, atype: Analyzer::Tag) {
    print fmt("[event] protocol_late_match(atype = <%s>)", atype);
    print "";
    print "";
}

event analyzer_violation(c: connection, atype: Analyzer::Tag, aid: count, reason: string) {
    print fmt("[event] analyzer_violation(atype = <%s>, aid = <%s>, reason = <%s>)", atype, aid, reason);
    print "";
    print "";
}

event conn_stats(c: connection, os: endpoint_stats, rs: endpoint_stats) {
    print fmt("[event] conn_stats(os = <%s>, rs = <%s>)", os, rs);
    print "";
    print "";
}

event conn_weird(name: string, c: connection, addl: string, source: string) {
    print fmt("[event] conn_weird(name = <%s>, addl = <%s>, source = <%s>)", name, addl, source);
    print "";
    print "";
}

event conn_weird(name: string, c: connection, addl: string) {
    print fmt("[event] conn_weird(name = <%s>, addl = <%s>)", name, addl);
    print "";
    print "";
}

event expired_conn_weird(name: string, id: conn_id, uid: string, addl: string, source: string) {
    print fmt("[event] expired_conn_weird(name = <%s>, id = <%s>, uid = <%s>, addl = <%s>, source = <%s>)", name, id, uid, addl, source);
    print "";
    print "";
}

event expired_conn_weird(name: string, id: conn_id, uid: string, addl: string) {
    print fmt("[event] expired_conn_weird(name = <%s>, id = <%s>, uid = <%s>, addl = <%s>)", name, id, uid, addl);
    print "";
    print "";
}

event flow_weird(name: string, src: addr, dst: addr, addl: string, source: string) {
    print fmt("[event] flow_weird(name = <%s>, src = <%s>, dst = <%s>, addl = <%s>, source = <%s>)", name, src, dst, addl, source);
    print "";
    print "";
}

event flow_weird(name: string, src: addr, dst: addr, addl: string) {
    print fmt("[event] flow_weird(name = <%s>, src = <%s>, dst = <%s>, addl = <%s>)", name, src, dst, addl);
    print "";
    print "";
}

event net_weird(name: string, addl: string, source: string) {
    print fmt("[event] net_weird(name = <%s>, addl = <%s>, source = <%s>)", name, addl, source);
    print "";
    print "";
}

event net_weird(name: string, addl: string) {
    print fmt("[event] net_weird(name = <%s>, addl = <%s>)", name, addl);
    print "";
    print "";
}

event file_weird(name: string, f: fa_file, addl: string, source: string) {
    print fmt("[event] file_weird(name = <%s>, f = <%s>, addl = <%s>, source = <%s>)", name, f, addl, source);
    print "";
    print "";
}

event file_weird(name: string, f: fa_file, addl: string) {
    print fmt("[event] file_weird(name = <%s>, f = <%s>, addl = <%s>)", name, f, addl);
    print "";
    print "";
}

event load_sample(samples: load_sample_info, CPU: interval, dmem: int) {
    print fmt("[event] load_sample(samples = <%s>, CPU = <%s>, dmem = <%s>)", samples, CPU, dmem);
    print "";
    print "";
}

event signature_match(state: signature_state, msg: string, data: string) {
    print fmt("[event] signature_match(state = <%s>, msg = <%s>, data = <%s>)", state, msg, data);
    print "";
    print "";
}

event profiling_update(f: file, expensive: bool) {
    print fmt("[event] profiling_update(f = <%s>, expensive = <%s>)", f, expensive);
    print "";
    print "";
}

event zeek_script_loaded(path: string, level: count) {
    print fmt("[event] zeek_script_loaded(path = <%s>, level = <%s>)", path, level);
    print "";
    print "";
}

event file_opened(f: file) {
    print fmt("[event] file_opened(f = <%s>)", f);
    print "";
    print "";
}

event event_queue_flush_point() {
    print fmt("[event] event_queue_flush_point()");
    print "";
    print "";
}

event get_file_handle(tag: Analyzer::Tag, c: connection, is_orig: bool) {
    print fmt("[event] get_file_handle(tag = <%s>, is_orig = <%s>)", tag, is_orig);
    print "";
    print "";
}

event file_new(f: fa_file) {
    print fmt("[event] file_new(f = <%s>)", f);
    print "";
    print "";
}

event file_over_new_connection(f: fa_file, c: connection, is_orig: bool) {
    print fmt("[event] file_over_new_connection(f = <%s>, is_orig = <%s>)", f, is_orig);
    print "";
    print "";
}

event file_sniff(f: fa_file, meta: fa_metadata) {
    print fmt("[event] file_sniff(f = <%s>, meta = <%s>)", f, meta);
    print "";
    print "";
}

event file_timeout(f: fa_file) {
    print fmt("[event] file_timeout(f = <%s>)", f);
    print "";
    print "";
}

event file_gap(f: fa_file, offset: count, len: count) {
    print fmt("[event] file_gap(f = <%s>, offset = <%s>, len = <%s>)", f, offset, len);
    print "";
    print "";
}

event file_reassembly_overflow(f: fa_file, offset: count, skipped: count) {
    print fmt("[event] file_reassembly_overflow(f = <%s>, offset = <%s>, skipped = <%s>)", f, offset, skipped);
    print "";
    print "";
}

event file_state_remove(f: fa_file) {
    print fmt("[event] file_state_remove(f = <%s>)", f);
    print "";
    print "";
}

event dns_mapping_valid(dm: dns_mapping) {
    print fmt("[event] dns_mapping_valid(dm = <%s>)", dm);
    print "";
    print "";
}

event dns_mapping_unverified(dm: dns_mapping) {
    print fmt("[event] dns_mapping_unverified(dm = <%s>)", dm);
    print "";
    print "";
}

event dns_mapping_new_name(dm: dns_mapping) {
    print fmt("[event] dns_mapping_new_name(dm = <%s>)", dm);
    print "";
    print "";
}

event dns_mapping_lost_name(dm: dns_mapping) {
    print fmt("[event] dns_mapping_lost_name(dm = <%s>)", dm);
    print "";
    print "";
}

event dns_mapping_name_changed(prev: dns_mapping, latest: dns_mapping) {
    print fmt("[event] dns_mapping_name_changed(prev = <%s>, latest = <%s>)", prev, latest);
    print "";
    print "";
}

event dns_mapping_altered(dm: dns_mapping, old_addrs: addr_set, new_addrs: addr_set) {
    print fmt("[event] dns_mapping_altered(dm = <%s>, old_addrs = <%s>, new_addrs = <%s>)", dm, old_addrs, new_addrs);
    print "";
    print "";
}

event anonymization_mapping(orig: addr, mapped: addr) {
    print fmt("[event] anonymization_mapping(orig = <%s>, mapped = <%s>)", orig, mapped);
    print "";
    print "";
}

event unknown_protocol(analyzer_name: string, protocol: count, first_bytes: string) {
    print fmt("[event] unknown_protocol(analyzer_name = <%s>, protocol = <%s>, first_bytes = <%s>)", analyzer_name, protocol, first_bytes);
    print "";
    print "";
}

event packet_not_processed(pkt: pcap_packet) {
    print fmt("[event] packet_not_processed(pkt = <%s>)", pkt);
    print "";
    print "";
}

event arp_request(mac_src: string, mac_dst: string, SPA: addr, SHA: string, TPA: addr, THA: string) {
    print fmt("[Zeek_ARP] arp_request(mac_src = <%s>, mac_dst = <%s>, SPA = <%s>, SHA = <%s>, TPA = <%s>, THA = <%s>)", mac_src, mac_dst, SPA, SHA, TPA, THA);
    print "";
    print "";
}

event arp_reply(mac_src: string, mac_dst: string, SPA: addr, SHA: string, TPA: addr, THA: string) {
    print fmt("[Zeek_ARP] arp_reply(mac_src = <%s>, mac_dst = <%s>, SPA = <%s>, SHA = <%s>, TPA = <%s>, THA = <%s>)", mac_src, mac_dst, SPA, SHA, TPA, THA);
    print "";
    print "";
}

event bad_arp(SPA: addr, SHA: string, TPA: addr, THA: string, explanation: string) {
    print fmt("[Zeek_ARP] bad_arp(SPA = <%s>, SHA = <%s>, TPA = <%s>, THA = <%s>, explanation = <%s>)", SPA, SHA, TPA, THA, explanation);
    print "";
    print "";
}

event bittorrent_peer_handshake(c: connection, is_orig: bool, reserved: string, info_hash: string, peer_id: string) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_handshake(is_orig = <%s>, reserved = <%s>, info_hash = <%s>, peer_id = <%s>)", is_orig, reserved, info_hash, peer_id);
    print "";
    print "";
}

event bittorrent_peer_keep_alive(c: connection, is_orig: bool) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_keep_alive(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event bittorrent_peer_choke(c: connection, is_orig: bool) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_choke(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event bittorrent_peer_unchoke(c: connection, is_orig: bool) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_unchoke(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event bittorrent_peer_interested(c: connection, is_orig: bool) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_interested(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event bittorrent_peer_not_interested(c: connection, is_orig: bool) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_not_interested(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event bittorrent_peer_have(c: connection, is_orig: bool, piece_index: count) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_have(is_orig = <%s>, piece_index = <%s>)", is_orig, piece_index);
    print "";
    print "";
}

event bittorrent_peer_bitfield(c: connection, is_orig: bool, bitfield: string) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_bitfield(is_orig = <%s>, bitfield = <%s>)", is_orig, bitfield);
    print "";
    print "";
}

event bittorrent_peer_request(c: connection, is_orig: bool, index: count, begin: count, length: count) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_request(is_orig = <%s>, index = <%s>, begin = <%s>, length = <%s>)", is_orig, index, begin, length);
    print "";
    print "";
}

event bittorrent_peer_piece(c: connection, is_orig: bool, index: count, begin: count, piece_length: count) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_piece(is_orig = <%s>, index = <%s>, begin = <%s>, piece_length = <%s>)", is_orig, index, begin, piece_length);
    print "";
    print "";
}

event bittorrent_peer_cancel(c: connection, is_orig: bool, index: count, begin: count, length: count) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_cancel(is_orig = <%s>, index = <%s>, begin = <%s>, length = <%s>)", is_orig, index, begin, length);
    print "";
    print "";
}

event bittorrent_peer_port(c: connection, is_orig: bool, listen_port: port) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_port(is_orig = <%s>, listen_port = <%s>)", is_orig, listen_port);
    print "";
    print "";
}

event bittorrent_peer_unknown(c: connection, is_orig: bool, message_id: count, data: string) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_unknown(is_orig = <%s>, message_id = <%s>, data = <%s>)", is_orig, message_id, data);
    print "";
    print "";
}

event bittorrent_peer_weird(c: connection, is_orig: bool, msg: string) {
    print fmt("[Zeek_BitTorrent] bittorrent_peer_weird(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event bt_tracker_request(c: connection, uri: string, headers: bt_tracker_headers) {
    print fmt("[Zeek_BitTorrent] bt_tracker_request(uri = <%s>, headers = <%s>)", uri, headers);
    print "";
    print "";
}

event bt_tracker_response(c: connection, status: count, headers: bt_tracker_headers, peers: bittorrent_peer_set, benc: bittorrent_benc_dir) {
    print fmt("[Zeek_BitTorrent] bt_tracker_response(status = <%s>, headers = <%s>, peers = <%s>, benc = <%s>)", status, headers, peers, benc);
    print "";
    print "";
}

event bt_tracker_response_not_ok(c: connection, status: count, headers: bt_tracker_headers) {
    print fmt("[Zeek_BitTorrent] bt_tracker_response_not_ok(status = <%s>, headers = <%s>)", status, headers);
    print "";
    print "";
}

event bt_tracker_weird(c: connection, is_orig: bool, msg: string) {
    print fmt("[Zeek_BitTorrent] bt_tracker_weird(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event conn_bytes_threshold_crossed(c: connection, threshold: count, is_orig: bool) {
    print fmt("[Zeek_ConnSize] conn_bytes_threshold_crossed(threshold = <%s>, is_orig = <%s>)", threshold, is_orig);
    print "";
    print "";
}

event conn_packets_threshold_crossed(c: connection, threshold: count, is_orig: bool) {
    print fmt("[Zeek_ConnSize] conn_packets_threshold_crossed(threshold = <%s>, is_orig = <%s>)", threshold, is_orig);
    print "";
    print "";
}

event conn_duration_threshold_crossed(c: connection, threshold: interval, is_orig: bool) {
    print fmt("[Zeek_ConnSize] conn_duration_threshold_crossed(threshold = <%s>, is_orig = <%s>)", threshold, is_orig);
    print "";
    print "";
}

event dce_rpc_message(c: connection, is_orig: bool, fid: count, ptype_id: count, ptype: DCE_RPC::PType) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_message(is_orig = <%s>, fid = <%s>, ptype_id = <%s>, ptype = <%s>)", is_orig, fid, ptype_id, ptype);
    print "";
    print "";
}

event dce_rpc_bind(c: connection, fid: count, ctx_id: count, uuid: string, ver_major: count, ver_minor: count) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_bind(fid = <%s>, ctx_id = <%s>, uuid = <%s>, ver_major = <%s>, ver_minor = <%s>)", fid, ctx_id, uuid, ver_major, ver_minor);
    print "";
    print "";
}

event dce_rpc_alter_context(c: connection, fid: count, ctx_id: count, uuid: string, ver_major: count, ver_minor: count) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_alter_context(fid = <%s>, ctx_id = <%s>, uuid = <%s>, ver_major = <%s>, ver_minor = <%s>)", fid, ctx_id, uuid, ver_major, ver_minor);
    print "";
    print "";
}

event dce_rpc_bind_ack(c: connection, fid: count, sec_addr: string) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_bind_ack(fid = <%s>, sec_addr = <%s>)", fid, sec_addr);
    print "";
    print "";
}

event dce_rpc_alter_context_resp(c: connection, fid: count) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_alter_context_resp(fid = <%s>)", fid);
    print "";
    print "";
}

event dce_rpc_request(c: connection, fid: count, ctx_id: count, opnum: count, stub_len: count) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_request(fid = <%s>, ctx_id = <%s>, opnum = <%s>, stub_len = <%s>)", fid, ctx_id, opnum, stub_len);
    print "";
    print "";
}

event dce_rpc_response(c: connection, fid: count, ctx_id: count, opnum: count, stub_len: count) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_response(fid = <%s>, ctx_id = <%s>, opnum = <%s>, stub_len = <%s>)", fid, ctx_id, opnum, stub_len);
    print "";
    print "";
}

event dce_rpc_request_stub(c: connection, fid: count, ctx_id: count, opnum: count, stub: string) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_request_stub(fid = <%s>, ctx_id = <%s>, opnum = <%s>, stub = <%s>)", fid, ctx_id, opnum, stub);
    print "";
    print "";
}

event dce_rpc_response_stub(c: connection, fid: count, ctx_id: count, opnum: count, stub: string) {
    print fmt("[Zeek_DCE_RPC] dce_rpc_response_stub(fid = <%s>, ctx_id = <%s>, opnum = <%s>, stub = <%s>)", fid, ctx_id, opnum, stub);
    print "";
    print "";
}

event dhcp_message(c: connection, is_orig: bool, msg: DHCP::Msg, options: DHCP::Options) {
    print fmt("[Zeek_DHCP] dhcp_message(is_orig = <%s>, msg = <%s>, options = <%s>)", is_orig, msg, options);
    print "";
    print "";
}

event dnp3_application_request_header(c: connection, is_orig: bool, application: count, fc: count) {
    print fmt("[Zeek_DNP3] dnp3_application_request_header(is_orig = <%s>, application = <%s>, fc = <%s>)", is_orig, application, fc);
    print "";
    print "";
}

event dnp3_application_response_header(c: connection, is_orig: bool, application: count, fc: count, iin: count) {
    print fmt("[Zeek_DNP3] dnp3_application_response_header(is_orig = <%s>, application = <%s>, fc = <%s>, iin = <%s>)", is_orig, application, fc, iin);
    print "";
    print "";
}

event dnp3_object_header(c: connection, is_orig: bool, obj_type: count, qua_field: count, number: count, rf_low: count, rf_high: count) {
    print fmt("[Zeek_DNP3] dnp3_object_header(is_orig = <%s>, obj_type = <%s>, qua_field = <%s>, number = <%s>, rf_low = <%s>, rf_high = <%s>)", is_orig, obj_type, qua_field, number, rf_low, rf_high);
    print "";
    print "";
}

event dnp3_object_prefix(c: connection, is_orig: bool, prefix_value: count) {
    print fmt("[Zeek_DNP3] dnp3_object_prefix(is_orig = <%s>, prefix_value = <%s>)", is_orig, prefix_value);
    print "";
    print "";
}

event dnp3_header_block(c: connection, is_orig: bool, len: count, ctrl: count, dest_addr: count, src_addr: count) {
    print fmt("[Zeek_DNP3] dnp3_header_block(is_orig = <%s>, len = <%s>, ctrl = <%s>, dest_addr = <%s>, src_addr = <%s>)", is_orig, len, ctrl, dest_addr, src_addr);
    print "";
    print "";
}

event dnp3_response_data_object(c: connection, is_orig: bool, data_value: count) {
    print fmt("[Zeek_DNP3] dnp3_response_data_object(is_orig = <%s>, data_value = <%s>)", is_orig, data_value);
    print "";
    print "";
}

event dnp3_attribute_common(c: connection, is_orig: bool, data_type_code: count, leng: count, attribute_obj: string) {
    print fmt("[Zeek_DNP3] dnp3_attribute_common(is_orig = <%s>, data_type_code = <%s>, leng = <%s>, attribute_obj = <%s>)", is_orig, data_type_code, leng, attribute_obj);
    print "";
    print "";
}

event dnp3_crob(c: connection, is_orig: bool, control_code: count, count8: count, on_time: count, off_time: count, status_code: count) {
    print fmt("[Zeek_DNP3] dnp3_crob(is_orig = <%s>, control_code = <%s>, count8 = <%s>, on_time = <%s>, off_time = <%s>, status_code = <%s>)", is_orig, control_code, count8, on_time, off_time, status_code);
    print "";
    print "";
}

event dnp3_pcb(c: connection, is_orig: bool, control_code: count, count8: count, on_time: count, off_time: count, status_code: count) {
    print fmt("[Zeek_DNP3] dnp3_pcb(is_orig = <%s>, control_code = <%s>, count8 = <%s>, on_time = <%s>, off_time = <%s>, status_code = <%s>)", is_orig, control_code, count8, on_time, off_time, status_code);
    print "";
    print "";
}

event dnp3_counter_32wFlag(c: connection, is_orig: bool, flag: count, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_counter_32wFlag(is_orig = <%s>, flag = <%s>, count_value = <%s>)", is_orig, flag, count_value);
    print "";
    print "";
}

event dnp3_counter_16wFlag(c: connection, is_orig: bool, flag: count, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_counter_16wFlag(is_orig = <%s>, flag = <%s>, count_value = <%s>)", is_orig, flag, count_value);
    print "";
    print "";
}

event dnp3_counter_32woFlag(c: connection, is_orig: bool, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_counter_32woFlag(is_orig = <%s>, count_value = <%s>)", is_orig, count_value);
    print "";
    print "";
}

event dnp3_counter_16woFlag(c: connection, is_orig: bool, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_counter_16woFlag(is_orig = <%s>, count_value = <%s>)", is_orig, count_value);
    print "";
    print "";
}

event dnp3_frozen_counter_32wFlag(c: connection, is_orig: bool, flag: count, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_32wFlag(is_orig = <%s>, flag = <%s>, count_value = <%s>)", is_orig, flag, count_value);
    print "";
    print "";
}

event dnp3_frozen_counter_16wFlag(c: connection, is_orig: bool, flag: count, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_16wFlag(is_orig = <%s>, flag = <%s>, count_value = <%s>)", is_orig, flag, count_value);
    print "";
    print "";
}

event dnp3_frozen_counter_32wFlagTime(c: connection, is_orig: bool, flag: count, count_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_32wFlagTime(is_orig = <%s>, flag = <%s>, count_value = <%s>, time48 = <%s>)", is_orig, flag, count_value, time48);
    print "";
    print "";
}

event dnp3_frozen_counter_16wFlagTime(c: connection, is_orig: bool, flag: count, count_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_16wFlagTime(is_orig = <%s>, flag = <%s>, count_value = <%s>, time48 = <%s>)", is_orig, flag, count_value, time48);
    print "";
    print "";
}

event dnp3_frozen_counter_32woFlag(c: connection, is_orig: bool, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_32woFlag(is_orig = <%s>, count_value = <%s>)", is_orig, count_value);
    print "";
    print "";
}

event dnp3_frozen_counter_16woFlag(c: connection, is_orig: bool, count_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_counter_16woFlag(is_orig = <%s>, count_value = <%s>)", is_orig, count_value);
    print "";
    print "";
}

event dnp3_analog_input_32wFlag(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_32wFlag(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_16wFlag(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_16wFlag(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_32woFlag(c: connection, is_orig: bool, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_32woFlag(is_orig = <%s>, value = <%s>)", is_orig, value);
    print "";
    print "";
}

event dnp3_analog_input_16woFlag(c: connection, is_orig: bool, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_16woFlag(is_orig = <%s>, value = <%s>)", is_orig, value);
    print "";
    print "";
}

event dnp3_analog_input_SPwFlag(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_SPwFlag(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_DPwFlag(c: connection, is_orig: bool, flag: count, value_low: count, value_high: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_DPwFlag(is_orig = <%s>, flag = <%s>, value_low = <%s>, value_high = <%s>)", is_orig, flag, value_low, value_high);
    print "";
    print "";
}

event dnp3_frozen_analog_input_32wFlag(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_32wFlag(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_16wFlag(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_16wFlag(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_32wTime(c: connection, is_orig: bool, flag: count, frozen_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_32wTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>, time48 = <%s>)", is_orig, flag, frozen_value, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_16wTime(c: connection, is_orig: bool, flag: count, frozen_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_16wTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>, time48 = <%s>)", is_orig, flag, frozen_value, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_32woFlag(c: connection, is_orig: bool, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_32woFlag(is_orig = <%s>, frozen_value = <%s>)", is_orig, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_16woFlag(c: connection, is_orig: bool, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_16woFlag(is_orig = <%s>, frozen_value = <%s>)", is_orig, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_SPwFlag(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_SPwFlag(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_DPwFlag(c: connection, is_orig: bool, flag: count, frozen_value_low: count, frozen_value_high: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_DPwFlag(is_orig = <%s>, flag = <%s>, frozen_value_low = <%s>, frozen_value_high = <%s>)", is_orig, flag, frozen_value_low, frozen_value_high);
    print "";
    print "";
}

event dnp3_analog_input_event_32woTime(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_32woTime(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_event_16woTime(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_16woTime(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_event_32wTime(c: connection, is_orig: bool, flag: count, value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_32wTime(is_orig = <%s>, flag = <%s>, value = <%s>, time48 = <%s>)", is_orig, flag, value, time48);
    print "";
    print "";
}

event dnp3_analog_input_event_16wTime(c: connection, is_orig: bool, flag: count, value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_16wTime(is_orig = <%s>, flag = <%s>, value = <%s>, time48 = <%s>)", is_orig, flag, value, time48);
    print "";
    print "";
}

event dnp3_analog_input_event_SPwoTime(c: connection, is_orig: bool, flag: count, value: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_SPwoTime(is_orig = <%s>, flag = <%s>, value = <%s>)", is_orig, flag, value);
    print "";
    print "";
}

event dnp3_analog_input_event_DPwoTime(c: connection, is_orig: bool, flag: count, value_low: count, value_high: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_DPwoTime(is_orig = <%s>, flag = <%s>, value_low = <%s>, value_high = <%s>)", is_orig, flag, value_low, value_high);
    print "";
    print "";
}

event dnp3_analog_input_event_SPwTime(c: connection, is_orig: bool, flag: count, value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_SPwTime(is_orig = <%s>, flag = <%s>, value = <%s>, time48 = <%s>)", is_orig, flag, value, time48);
    print "";
    print "";
}

event dnp3_analog_input_event_DPwTime(c: connection, is_orig: bool, flag: count, value_low: count, value_high: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_analog_input_event_DPwTime(is_orig = <%s>, flag = <%s>, value_low = <%s>, value_high = <%s>, time48 = <%s>)", is_orig, flag, value_low, value_high, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_32woTime(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_32woTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_16woTime(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_16woTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_32wTime(c: connection, is_orig: bool, flag: count, frozen_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_32wTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>, time48 = <%s>)", is_orig, flag, frozen_value, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_16wTime(c: connection, is_orig: bool, flag: count, frozen_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_16wTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>, time48 = <%s>)", is_orig, flag, frozen_value, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_SPwoTime(c: connection, is_orig: bool, flag: count, frozen_value: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_SPwoTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>)", is_orig, flag, frozen_value);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_DPwoTime(c: connection, is_orig: bool, flag: count, frozen_value_low: count, frozen_value_high: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_DPwoTime(is_orig = <%s>, flag = <%s>, frozen_value_low = <%s>, frozen_value_high = <%s>)", is_orig, flag, frozen_value_low, frozen_value_high);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_SPwTime(c: connection, is_orig: bool, flag: count, frozen_value: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_SPwTime(is_orig = <%s>, flag = <%s>, frozen_value = <%s>, time48 = <%s>)", is_orig, flag, frozen_value, time48);
    print "";
    print "";
}

event dnp3_frozen_analog_input_event_DPwTime(c: connection, is_orig: bool, flag: count, frozen_value_low: count, frozen_value_high: count, time48: count) {
    print fmt("[Zeek_DNP3] dnp3_frozen_analog_input_event_DPwTime(is_orig = <%s>, flag = <%s>, frozen_value_low = <%s>, frozen_value_high = <%s>, time48 = <%s>)", is_orig, flag, frozen_value_low, frozen_value_high, time48);
    print "";
    print "";
}

event dnp3_file_transport(c: connection, is_orig: bool, file_handle: count, block_num: count, file_data: string) {
    print fmt("[Zeek_DNP3] dnp3_file_transport(is_orig = <%s>, file_handle = <%s>, block_num = <%s>, file_data = <%s>)", is_orig, file_handle, block_num, file_data);
    print "";
    print "";
}

event dnp3_debug_byte(c: connection, is_orig: bool, debug: string) {
    print fmt("[Zeek_DNP3] dnp3_debug_byte(is_orig = <%s>, debug = <%s>)", is_orig, debug);
    print "";
    print "";
}

event dns_message(c: connection, is_orig: bool, msg: dns_msg, len: count) {
    print fmt("[Zeek_DNS] dns_message(is_orig = <%s>, msg = <%s>, len = <%s>)", is_orig, msg, len);
    print "";
    print "";
}

event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count, original_query: string) {
    print fmt("[Zeek_DNS] dns_request(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>, original_query = <%s>)", msg, query, qtype, qclass, original_query);
    print "";
    print "";
}

event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count) {
    print fmt("[Zeek_DNS] dns_request(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>)", msg, query, qtype, qclass);
    print "";
    print "";
}

event dns_rejected(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count, original_query: string) {
    print fmt("[Zeek_DNS] dns_rejected(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>, original_query = <%s>)", msg, query, qtype, qclass, original_query);
    print "";
    print "";
}

event dns_rejected(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count) {
    print fmt("[Zeek_DNS] dns_rejected(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>)", msg, query, qtype, qclass);
    print "";
    print "";
}

event dns_query_reply(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count, original_query: string) {
    print fmt("[Zeek_DNS] dns_query_reply(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>, original_query = <%s>)", msg, query, qtype, qclass, original_query);
    print "";
    print "";
}

event dns_query_reply(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count) {
    print fmt("[Zeek_DNS] dns_query_reply(msg = <%s>, query = <%s>, qtype = <%s>, qclass = <%s>)", msg, query, qtype, qclass);
    print "";
    print "";
}

event dns_A_reply(c: connection, msg: dns_msg, ans: dns_answer, a: addr) {
    print fmt("[Zeek_DNS] dns_A_reply(msg = <%s>, ans = <%s>, a = <%s>)", msg, ans, a);
    print "";
    print "";
}

event dns_AAAA_reply(c: connection, msg: dns_msg, ans: dns_answer, a: addr) {
    print fmt("[Zeek_DNS] dns_AAAA_reply(msg = <%s>, ans = <%s>, a = <%s>)", msg, ans, a);
    print "";
    print "";
}

event dns_A6_reply(c: connection, msg: dns_msg, ans: dns_answer, a: addr) {
    print fmt("[Zeek_DNS] dns_A6_reply(msg = <%s>, ans = <%s>, a = <%s>)", msg, ans, a);
    print "";
    print "";
}

event dns_NS_reply(c: connection, msg: dns_msg, ans: dns_answer, name: string) {
    print fmt("[Zeek_DNS] dns_NS_reply(msg = <%s>, ans = <%s>, name = <%s>)", msg, ans, name);
    print "";
    print "";
}

event dns_CNAME_reply(c: connection, msg: dns_msg, ans: dns_answer, name: string) {
    print fmt("[Zeek_DNS] dns_CNAME_reply(msg = <%s>, ans = <%s>, name = <%s>)", msg, ans, name);
    print "";
    print "";
}

event dns_PTR_reply(c: connection, msg: dns_msg, ans: dns_answer, name: string) {
    print fmt("[Zeek_DNS] dns_PTR_reply(msg = <%s>, ans = <%s>, name = <%s>)", msg, ans, name);
    print "";
    print "";
}

event dns_SOA_reply(c: connection, msg: dns_msg, ans: dns_answer, soa: dns_soa) {
    print fmt("[Zeek_DNS] dns_SOA_reply(msg = <%s>, ans = <%s>, soa = <%s>)", msg, ans, soa);
    print "";
    print "";
}

event dns_WKS_reply(c: connection, msg: dns_msg, ans: dns_answer) {
    print fmt("[Zeek_DNS] dns_WKS_reply(msg = <%s>, ans = <%s>)", msg, ans);
    print "";
    print "";
}

event dns_MX_reply(c: connection, msg: dns_msg, ans: dns_answer, name: string, preference: count) {
    print fmt("[Zeek_DNS] dns_MX_reply(msg = <%s>, ans = <%s>, name = <%s>, preference = <%s>)", msg, ans, name, preference);
    print "";
    print "";
}

event dns_TXT_reply(c: connection, msg: dns_msg, ans: dns_answer, strs: string_vec) {
    print fmt("[Zeek_DNS] dns_TXT_reply(msg = <%s>, ans = <%s>, strs = <%s>)", msg, ans, strs);
    print "";
    print "";
}

event dns_SPF_reply(c: connection, msg: dns_msg, ans: dns_answer, strs: string_vec) {
    print fmt("[Zeek_DNS] dns_SPF_reply(msg = <%s>, ans = <%s>, strs = <%s>)", msg, ans, strs);
    print "";
    print "";
}

event dns_CAA_reply(c: connection, msg: dns_msg, ans: dns_answer, flags: count, tag: string, value: string) {
    print fmt("[Zeek_DNS] dns_CAA_reply(msg = <%s>, ans = <%s>, flags = <%s>, tag = <%s>, value = <%s>)", msg, ans, flags, tag, value);
    print "";
    print "";
}

event dns_SRV_reply(c: connection, msg: dns_msg, ans: dns_answer, target: string, priority: count, weight: count, p: count) {
    print fmt("[Zeek_DNS] dns_SRV_reply(msg = <%s>, ans = <%s>, target = <%s>, priority = <%s>, weight = <%s>, p = <%s>)", msg, ans, target, priority, weight, p);
    print "";
    print "";
}

event dns_unknown_reply(c: connection, msg: dns_msg, ans: dns_answer) {
    print fmt("[Zeek_DNS] dns_unknown_reply(msg = <%s>, ans = <%s>)", msg, ans);
    print "";
    print "";
}

event dns_EDNS_addl(c: connection, msg: dns_msg, ans: dns_edns_additional) {
    print fmt("[Zeek_DNS] dns_EDNS_addl(msg = <%s>, ans = <%s>)", msg, ans);
    print "";
    print "";
}

event dns_EDNS_ecs(c: connection, msg: dns_msg, opt: dns_edns_ecs) {
    print fmt("[Zeek_DNS] dns_EDNS_ecs(msg = <%s>, opt = <%s>)", msg, opt);
    print "";
    print "";
}

event dns_EDNS_tcp_keepalive(c: connection, msg: dns_msg, opt: dns_edns_tcp_keepalive) {
    print fmt("[Zeek_DNS] dns_EDNS_tcp_keepalive(msg = <%s>, opt = <%s>)", msg, opt);
    print "";
    print "";
}

event dns_EDNS_cookie(c: connection, msg: dns_msg, opt: dns_edns_cookie) {
    print fmt("[Zeek_DNS] dns_EDNS_cookie(msg = <%s>, opt = <%s>)", msg, opt);
    print "";
    print "";
}

event dns_TSIG_addl(c: connection, msg: dns_msg, ans: dns_tsig_additional) {
    print fmt("[Zeek_DNS] dns_TSIG_addl(msg = <%s>, ans = <%s>)", msg, ans);
    print "";
    print "";
}

event dns_RRSIG(c: connection, msg: dns_msg, ans: dns_answer, rrsig: dns_rrsig_rr) {
    print fmt("[Zeek_DNS] dns_RRSIG(msg = <%s>, ans = <%s>, rrsig = <%s>)", msg, ans, rrsig);
    print "";
    print "";
}

event dns_DNSKEY(c: connection, msg: dns_msg, ans: dns_answer, dnskey: dns_dnskey_rr) {
    print fmt("[Zeek_DNS] dns_DNSKEY(msg = <%s>, ans = <%s>, dnskey = <%s>)", msg, ans, dnskey);
    print "";
    print "";
}

event dns_NSEC(c: connection, msg: dns_msg, ans: dns_answer, next_name: string, bitmaps: string_vec) {
    print fmt("[Zeek_DNS] dns_NSEC(msg = <%s>, ans = <%s>, next_name = <%s>, bitmaps = <%s>)", msg, ans, next_name, bitmaps);
    print "";
    print "";
}

event dns_NSEC3(c: connection, msg: dns_msg, ans: dns_answer, nsec3: dns_nsec3_rr) {
    print fmt("[Zeek_DNS] dns_NSEC3(msg = <%s>, ans = <%s>, nsec3 = <%s>)", msg, ans, nsec3);
    print "";
    print "";
}

event dns_NSEC3PARAM(c: connection, msg: dns_msg, ans: dns_answer, nsec3param: dns_nsec3param_rr) {
    print fmt("[Zeek_DNS] dns_NSEC3PARAM(msg = <%s>, ans = <%s>, nsec3param = <%s>)", msg, ans, nsec3param);
    print "";
    print "";
}

event dns_DS(c: connection, msg: dns_msg, ans: dns_answer, ds: dns_ds_rr) {
    print fmt("[Zeek_DNS] dns_DS(msg = <%s>, ans = <%s>, ds = <%s>)", msg, ans, ds);
    print "";
    print "";
}

event dns_BINDS(c: connection, msg: dns_msg, ans: dns_answer, binds: dns_binds_rr) {
    print fmt("[Zeek_DNS] dns_BINDS(msg = <%s>, ans = <%s>, binds = <%s>)", msg, ans, binds);
    print "";
    print "";
}

event dns_SSHFP(c: connection, msg: dns_msg, ans: dns_answer, algo: count, fptype: count, fingerprint: string) {
    print fmt("[Zeek_DNS] dns_SSHFP(msg = <%s>, ans = <%s>, algo = <%s>, fptype = <%s>, fingerprint = <%s>)", msg, ans, algo, fptype, fingerprint);
    print "";
    print "";
}

event dns_LOC(c: connection, msg: dns_msg, ans: dns_answer, loc: dns_loc_rr) {
    print fmt("[Zeek_DNS] dns_LOC(msg = <%s>, ans = <%s>, loc = <%s>)", msg, ans, loc);
    print "";
    print "";
}

event dns_end(c: connection, msg: dns_msg) {
    print fmt("[Zeek_DNS] dns_end(msg = <%s>)", msg);
    print "";
    print "";
}

event file_transferred(c: connection, prefix: string, descr: string, mime_type: string) {
    print fmt("[Zeek_File] file_transferred(prefix = <%s>, descr = <%s>, mime_type = <%s>)", prefix, descr, mime_type);
    print "";
    print "";
}

event file_entropy(f: fa_file, ent: entropy_test_result) {
    print fmt("[Zeek_FileEntropy] file_entropy(f = <%s>, ent = <%s>)", f, ent);
    print "";
    print "";
}

event file_extraction_limit(f: fa_file, args: Files::AnalyzerArgs, limit: count, len: count) {
    print fmt("[Zeek_FileExtract] file_extraction_limit(f = <%s>, args = <%s>, limit = <%s>, len = <%s>)", f, args, limit, len);
    print "";
    print "";
}

event file_hash(f: fa_file, kind: string, hash: string) {
    print fmt("[Zeek_FileHash] file_hash(f = <%s>, kind = <%s>, hash = <%s>)", f, kind, hash);
    print "";
    print "";
}

event finger_request(c: connection, full: bool, username: string, hostname: string) {
    print fmt("[Zeek_Finger] finger_request(full = <%s>, username = <%s>, hostname = <%s>)", full, username, hostname);
    print "";
    print "";
}

event finger_reply(c: connection, reply_line: string) {
    print fmt("[Zeek_Finger] finger_reply(reply_line = <%s>)", reply_line);
    print "";
    print "";
}

event ftp_request(c: connection, command: string, arg: string) {
    print fmt("[Zeek_FTP] ftp_request(command = <%s>, arg = <%s>)", command, arg);
    print "";
    print "";
}

event ftp_reply(c: connection, code: count, msg: string, cont_resp: bool) {
    print fmt("[Zeek_FTP] ftp_reply(code = <%s>, msg = <%s>, cont_resp = <%s>)", code, msg, cont_resp);
    print "";
    print "";
}

event geneve_packet(outer: connection, inner: pkt_hdr, vni: count) {
    print fmt("[Zeek_Geneve] geneve_packet(inner = <%s>, vni = <%s>)", inner, vni);
    print "";
    print "";
}

event gnutella_text_msg(c: connection, orig: bool, headers: string) {
    print fmt("[Zeek_Gnutella] gnutella_text_msg(orig = <%s>, headers = <%s>)", orig, headers);
    print "";
    print "";
}

event gnutella_binary_msg(c: connection, orig: bool, msg_type: count, ttl: count, hops: count, msg_len: count, payload: string, payload_len: count, trunc: bool, complete: bool) {
    print fmt("[Zeek_Gnutella] gnutella_binary_msg(orig = <%s>, msg_type = <%s>, ttl = <%s>, hops = <%s>, msg_len = <%s>, payload = <%s>, payload_len = <%s>, trunc = <%s>, complete = <%s>)", orig, msg_type, ttl, hops, msg_len, payload, payload_len, trunc, complete);
    print "";
    print "";
}

event gnutella_partial_binary_msg(c: connection, orig: bool, msg: string, len: count) {
    print fmt("[Zeek_Gnutella] gnutella_partial_binary_msg(orig = <%s>, msg = <%s>, len = <%s>)", orig, msg, len);
    print "";
    print "";
}

event gnutella_establish(c: connection) {
    print fmt("[Zeek_Gnutella] gnutella_establish()");
    print "";
    print "";
}

event gnutella_not_establish(c: connection) {
    print fmt("[Zeek_Gnutella] gnutella_not_establish()");
    print "";
    print "";
}

event gnutella_http_notify(c: connection) {
    print fmt("[Zeek_Gnutella] gnutella_http_notify()");
    print "";
    print "";
}

event gssapi_neg_result(c: connection, state: count) {
    print fmt("[Zeek_GSSAPI] gssapi_neg_result(state = <%s>)", state);
    print "";
    print "";
}

event gtpv1_message(c: connection, hdr: gtpv1_hdr) {
    print fmt("[Zeek_GTPv1] gtpv1_message(hdr = <%s>)", hdr);
    print "";
    print "";
}

event gtpv1_g_pdu_packet(outer: connection, inner_gtp: gtpv1_hdr, inner_ip: pkt_hdr) {
    print fmt("[Zeek_GTPv1] gtpv1_g_pdu_packet(inner_gtp = <%s>, inner_ip = <%s>)", inner_gtp, inner_ip);
    print "";
    print "";
}

event gtpv1_create_pdp_ctx_request(c: connection, hdr: gtpv1_hdr, elements: gtp_create_pdp_ctx_request_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_create_pdp_ctx_request(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event gtpv1_create_pdp_ctx_response(c: connection, hdr: gtpv1_hdr, elements: gtp_create_pdp_ctx_response_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_create_pdp_ctx_response(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event gtpv1_update_pdp_ctx_request(c: connection, hdr: gtpv1_hdr, elements: gtp_update_pdp_ctx_request_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_update_pdp_ctx_request(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event gtpv1_update_pdp_ctx_response(c: connection, hdr: gtpv1_hdr, elements: gtp_update_pdp_ctx_response_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_update_pdp_ctx_response(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event gtpv1_delete_pdp_ctx_request(c: connection, hdr: gtpv1_hdr, elements: gtp_delete_pdp_ctx_request_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_delete_pdp_ctx_request(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event gtpv1_delete_pdp_ctx_response(c: connection, hdr: gtpv1_hdr, elements: gtp_delete_pdp_ctx_response_elements) {
    print fmt("[Zeek_GTPv1] gtpv1_delete_pdp_ctx_response(hdr = <%s>, elements = <%s>)", hdr, elements);
    print "";
    print "";
}

event http_request(c: connection, method: string, original_URI: string, unescaped_URI: string, version: string) {
    print fmt("[Zeek_HTTP] http_request(method = <%s>, original_URI = <%s>, unescaped_URI = <%s>, version = <%s>)", method, original_URI, unescaped_URI, version);
    print "";
    print "";
}

event http_reply(c: connection, version: string, code: count, reason: string) {
    print fmt("[Zeek_HTTP] http_reply(version = <%s>, code = <%s>, reason = <%s>)", version, code, reason);
    print "";
    print "";
}

event http_header(c: connection, is_orig: bool, original_name: string, name: string, value: string) {
    print fmt("[Zeek_HTTP] http_header(is_orig = <%s>, original_name = <%s>, name = <%s>, value = <%s>)", is_orig, original_name, name, value);
    print "";
    print "";
}

event http_header(c: connection, is_orig: bool, name: string, value: string) {
    print fmt("[Zeek_HTTP] http_header(is_orig = <%s>, name = <%s>, value = <%s>)", is_orig, name, value);
    print "";
    print "";
}

event http_all_headers(c: connection, is_orig: bool, hlist: mime_header_list) {
    print fmt("[Zeek_HTTP] http_all_headers(is_orig = <%s>, hlist = <%s>)", is_orig, hlist);
    print "";
    print "";
}

event http_begin_entity(c: connection, is_orig: bool) {
    print fmt("[Zeek_HTTP] http_begin_entity(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event http_end_entity(c: connection, is_orig: bool) {
    print fmt("[Zeek_HTTP] http_end_entity(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event http_entity_data(c: connection, is_orig: bool, length: count, data: string) {
    print fmt("[Zeek_HTTP] http_entity_data(is_orig = <%s>, length = <%s>, data = <%s>)", is_orig, length, data);
    print "";
    print "";
}

event http_content_type(c: connection, is_orig: bool, ty: string, subty: string) {
    print fmt("[Zeek_HTTP] http_content_type(is_orig = <%s>, ty = <%s>, subty = <%s>)", is_orig, ty, subty);
    print "";
    print "";
}

event http_message_done(c: connection, is_orig: bool, stat: http_message_stat) {
    print fmt("[Zeek_HTTP] http_message_done(is_orig = <%s>, stat = <%s>)", is_orig, stat);
    print "";
    print "";
}

event http_event(c: connection, event_type: string, detail: string) {
    print fmt("[Zeek_HTTP] http_event(event_type = <%s>, detail = <%s>)", event_type, detail);
    print "";
    print "";
}

event http_stats(c: connection, stats: http_stats_rec) {
    print fmt("[Zeek_HTTP] http_stats(stats = <%s>)", stats);
    print "";
    print "";
}

event http_connection_upgrade(c: connection, protocol: string) {
    print fmt("[Zeek_HTTP] http_connection_upgrade(protocol = <%s>)", protocol);
    print "";
    print "";
}

event icmp_sent(c: connection, info: icmp_info) {
    print fmt("[Zeek_ICMP] icmp_sent(info = <%s>)", info);
    print "";
    print "";
}

event icmp_sent_payload(c: connection, info: icmp_info, payload: string) {
    print fmt("[Zeek_ICMP] icmp_sent_payload(info = <%s>, payload = <%s>)", info, payload);
    print "";
    print "";
}

event icmp_echo_request(c: connection, info: icmp_info, id: count, seq: count, payload: string) {
    print fmt("[Zeek_ICMP] icmp_echo_request(info = <%s>, id = <%s>, seq = <%s>, payload = <%s>)", info, id, seq, payload);
    print "";
    print "";
}

event icmp_echo_reply(c: connection, info: icmp_info, id: count, seq: count, payload: string) {
    print fmt("[Zeek_ICMP] icmp_echo_reply(info = <%s>, id = <%s>, seq = <%s>, payload = <%s>)", info, id, seq, payload);
    print "";
    print "";
}

event icmp_error_message(c: connection, info: icmp_info, code: count, context: icmp_context) {
    print fmt("[Zeek_ICMP] icmp_error_message(info = <%s>, code = <%s>, context = <%s>)", info, code, context);
    print "";
    print "";
}

event icmp_unreachable(c: connection, info: icmp_info, code: count, context: icmp_context) {
    print fmt("[Zeek_ICMP] icmp_unreachable(info = <%s>, code = <%s>, context = <%s>)", info, code, context);
    print "";
    print "";
}

event icmp_packet_too_big(c: connection, info: icmp_info, code: count, context: icmp_context) {
    print fmt("[Zeek_ICMP] icmp_packet_too_big(info = <%s>, code = <%s>, context = <%s>)", info, code, context);
    print "";
    print "";
}

event icmp_time_exceeded(c: connection, info: icmp_info, code: count, context: icmp_context) {
    print fmt("[Zeek_ICMP] icmp_time_exceeded(info = <%s>, code = <%s>, context = <%s>)", info, code, context);
    print "";
    print "";
}

event icmp_parameter_problem(c: connection, info: icmp_info, code: count, context: icmp_context) {
    print fmt("[Zeek_ICMP] icmp_parameter_problem(info = <%s>, code = <%s>, context = <%s>)", info, code, context);
    print "";
    print "";
}

event icmp_router_solicitation(c: connection, info: icmp_info, options: icmp6_nd_options) {
    print fmt("[Zeek_ICMP] icmp_router_solicitation(info = <%s>, options = <%s>)", info, options);
    print "";
    print "";
}

event icmp_router_advertisement(c: connection, info: icmp_info, cur_hop_limit: count, managed: bool, other: bool, home_agent: bool, pref: count, proxy: bool, rsv: count, router_lifetime: interval, reachable_time: interval, retrans_timer: interval, options: icmp6_nd_options) {
    print fmt("[Zeek_ICMP] icmp_router_advertisement(info = <%s>, cur_hop_limit = <%s>, managed = <%s>, other = <%s>, home_agent = <%s>, pref = <%s>, proxy = <%s>, rsv = <%s>, router_lifetime = <%s>, reachable_time = <%s>, retrans_timer = <%s>, options = <%s>)", info, cur_hop_limit, managed, other, home_agent, pref, proxy, rsv, router_lifetime, reachable_time, retrans_timer, options);
    print "";
    print "";
}

event icmp_neighbor_solicitation(c: connection, info: icmp_info, tgt: addr, options: icmp6_nd_options) {
    print fmt("[Zeek_ICMP] icmp_neighbor_solicitation(info = <%s>, tgt = <%s>, options = <%s>)", info, tgt, options);
    print "";
    print "";
}

event icmp_neighbor_advertisement(c: connection, info: icmp_info, router: bool, solicited: bool, override: bool, tgt: addr, options: icmp6_nd_options) {
    print fmt("[Zeek_ICMP] icmp_neighbor_advertisement(info = <%s>, router = <%s>, solicited = <%s>, override = <%s>, tgt = <%s>, options = <%s>)", info, router, solicited, override, tgt, options);
    print "";
    print "";
}

event icmp_redirect(c: connection, info: icmp_info, tgt: addr, dest: addr, options: icmp6_nd_options) {
    print fmt("[Zeek_ICMP] icmp_redirect(info = <%s>, tgt = <%s>, dest = <%s>, options = <%s>)", info, tgt, dest, options);
    print "";
    print "";
}

event ident_request(c: connection, lport: port, rport: port) {
    print fmt("[Zeek_Ident] ident_request(lport = <%s>, rport = <%s>)", lport, rport);
    print "";
    print "";
}

event ident_reply(c: connection, lport: port, rport: port, user_id: string, system: string) {
    print fmt("[Zeek_Ident] ident_reply(lport = <%s>, rport = <%s>, user_id = <%s>, system = <%s>)", lport, rport, user_id, system);
    print "";
    print "";
}

event ident_error(c: connection, lport: port, rport: port, line: string) {
    print fmt("[Zeek_Ident] ident_error(lport = <%s>, rport = <%s>, line = <%s>)", lport, rport, line);
    print "";
    print "";
}

event imap_capabilities(c: connection, capabilities: string_vec) {
    print fmt("[Zeek_IMAP] imap_capabilities(capabilities = <%s>)", capabilities);
    print "";
    print "";
}

event imap_starttls(c: connection) {
    print fmt("[Zeek_IMAP] imap_starttls()");
    print "";
    print "";
}

event irc_request(c: connection, is_orig: bool, prefix: string, command: string, arguments: string) {
    print fmt("[Zeek_IRC] irc_request(is_orig = <%s>, prefix = <%s>, command = <%s>, arguments = <%s>)", is_orig, prefix, command, arguments);
    print "";
    print "";
}

event irc_reply(c: connection, is_orig: bool, prefix: string, code: count, params: string) {
    print fmt("[Zeek_IRC] irc_reply(is_orig = <%s>, prefix = <%s>, code = <%s>, params = <%s>)", is_orig, prefix, code, params);
    print "";
    print "";
}

event irc_message(c: connection, is_orig: bool, prefix: string, command: string, message: string) {
    print fmt("[Zeek_IRC] irc_message(is_orig = <%s>, prefix = <%s>, command = <%s>, message = <%s>)", is_orig, prefix, command, message);
    print "";
    print "";
}

event irc_quit_message(c: connection, is_orig: bool, nick: string, message: string) {
    print fmt("[Zeek_IRC] irc_quit_message(is_orig = <%s>, nick = <%s>, message = <%s>)", is_orig, nick, message);
    print "";
    print "";
}

event irc_privmsg_message(c: connection, is_orig: bool, source: string, target: string, message: string) {
    print fmt("[Zeek_IRC] irc_privmsg_message(is_orig = <%s>, source = <%s>, target = <%s>, message = <%s>)", is_orig, source, target, message);
    print "";
    print "";
}

event irc_notice_message(c: connection, is_orig: bool, source: string, target: string, message: string) {
    print fmt("[Zeek_IRC] irc_notice_message(is_orig = <%s>, source = <%s>, target = <%s>, message = <%s>)", is_orig, source, target, message);
    print "";
    print "";
}

event irc_squery_message(c: connection, is_orig: bool, source: string, target: string, message: string) {
    print fmt("[Zeek_IRC] irc_squery_message(is_orig = <%s>, source = <%s>, target = <%s>, message = <%s>)", is_orig, source, target, message);
    print "";
    print "";
}

event irc_join_message(c: connection, is_orig: bool, info_list: irc_join_list) {
    print fmt("[Zeek_IRC] irc_join_message(is_orig = <%s>, info_list = <%s>)", is_orig, info_list);
    print "";
    print "";
}

event irc_part_message(c: connection, is_orig: bool, nick: string, chans: string_set, message: string) {
    print fmt("[Zeek_IRC] irc_part_message(is_orig = <%s>, nick = <%s>, chans = <%s>, message = <%s>)", is_orig, nick, chans, message);
    print "";
    print "";
}

event irc_nick_message(c: connection, is_orig: bool, who: string, newnick: string) {
    print fmt("[Zeek_IRC] irc_nick_message(is_orig = <%s>, who = <%s>, newnick = <%s>)", is_orig, who, newnick);
    print "";
    print "";
}

event irc_invalid_nick(c: connection, is_orig: bool) {
    print fmt("[Zeek_IRC] irc_invalid_nick(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event irc_network_info(c: connection, is_orig: bool, users: count, services: count, servers: count) {
    print fmt("[Zeek_IRC] irc_network_info(is_orig = <%s>, users = <%s>, services = <%s>, servers = <%s>)", is_orig, users, services, servers);
    print "";
    print "";
}

event irc_server_info(c: connection, is_orig: bool, users: count, services: count, servers: count) {
    print fmt("[Zeek_IRC] irc_server_info(is_orig = <%s>, users = <%s>, services = <%s>, servers = <%s>)", is_orig, users, services, servers);
    print "";
    print "";
}

event irc_channel_info(c: connection, is_orig: bool, chans: count) {
    print fmt("[Zeek_IRC] irc_channel_info(is_orig = <%s>, chans = <%s>)", is_orig, chans);
    print "";
    print "";
}

event irc_who_line(c: connection, is_orig: bool, target_nick: string, channel: string, user: string, host: string, server: string, nick: string, params: string, hops: count, real_name: string) {
    print fmt("[Zeek_IRC] irc_who_line(is_orig = <%s>, target_nick = <%s>, channel = <%s>, user = <%s>, host = <%s>, server = <%s>, nick = <%s>, params = <%s>, hops = <%s>, real_name = <%s>)", is_orig, target_nick, channel, user, host, server, nick, params, hops, real_name);
    print "";
    print "";
}

event irc_names_info(c: connection, is_orig: bool, c_type: string, channel: string, users: string_set) {
    print fmt("[Zeek_IRC] irc_names_info(is_orig = <%s>, c_type = <%s>, channel = <%s>, users = <%s>)", is_orig, c_type, channel, users);
    print "";
    print "";
}

event irc_whois_operator_line(c: connection, is_orig: bool, nick: string) {
    print fmt("[Zeek_IRC] irc_whois_operator_line(is_orig = <%s>, nick = <%s>)", is_orig, nick);
    print "";
    print "";
}

event irc_whois_channel_line(c: connection, is_orig: bool, nick: string, chans: string_set) {
    print fmt("[Zeek_IRC] irc_whois_channel_line(is_orig = <%s>, nick = <%s>, chans = <%s>)", is_orig, nick, chans);
    print "";
    print "";
}

event irc_whois_user_line(c: connection, is_orig: bool, nick: string, user: string, host: string, real_name: string) {
    print fmt("[Zeek_IRC] irc_whois_user_line(is_orig = <%s>, nick = <%s>, user = <%s>, host = <%s>, real_name = <%s>)", is_orig, nick, user, host, real_name);
    print "";
    print "";
}

event irc_oper_response(c: connection, is_orig: bool, got_oper: bool) {
    print fmt("[Zeek_IRC] irc_oper_response(is_orig = <%s>, got_oper = <%s>)", is_orig, got_oper);
    print "";
    print "";
}

event irc_global_users(c: connection, is_orig: bool, prefix: string, msg: string) {
    print fmt("[Zeek_IRC] irc_global_users(is_orig = <%s>, prefix = <%s>, msg = <%s>)", is_orig, prefix, msg);
    print "";
    print "";
}

event irc_channel_topic(c: connection, is_orig: bool, channel: string, topic: string) {
    print fmt("[Zeek_IRC] irc_channel_topic(is_orig = <%s>, channel = <%s>, topic = <%s>)", is_orig, channel, topic);
    print "";
    print "";
}

event irc_who_message(c: connection, is_orig: bool, mask: string, oper: bool) {
    print fmt("[Zeek_IRC] irc_who_message(is_orig = <%s>, mask = <%s>, oper = <%s>)", is_orig, mask, oper);
    print "";
    print "";
}

event irc_whois_message(c: connection, is_orig: bool, server: string, users: string) {
    print fmt("[Zeek_IRC] irc_whois_message(is_orig = <%s>, server = <%s>, users = <%s>)", is_orig, server, users);
    print "";
    print "";
}

event irc_oper_message(c: connection, is_orig: bool, user: string, password: string) {
    print fmt("[Zeek_IRC] irc_oper_message(is_orig = <%s>, user = <%s>, password = <%s>)", is_orig, user, password);
    print "";
    print "";
}

event irc_kick_message(c: connection, is_orig: bool, prefix: string, chans: string, users: string, comment: string) {
    print fmt("[Zeek_IRC] irc_kick_message(is_orig = <%s>, prefix = <%s>, chans = <%s>, users = <%s>, comment = <%s>)", is_orig, prefix, chans, users, comment);
    print "";
    print "";
}

event irc_error_message(c: connection, is_orig: bool, prefix: string, message: string) {
    print fmt("[Zeek_IRC] irc_error_message(is_orig = <%s>, prefix = <%s>, message = <%s>)", is_orig, prefix, message);
    print "";
    print "";
}

event irc_invite_message(c: connection, is_orig: bool, prefix: string, nickname: string, channel: string) {
    print fmt("[Zeek_IRC] irc_invite_message(is_orig = <%s>, prefix = <%s>, nickname = <%s>, channel = <%s>)", is_orig, prefix, nickname, channel);
    print "";
    print "";
}

event irc_mode_message(c: connection, is_orig: bool, prefix: string, params: string) {
    print fmt("[Zeek_IRC] irc_mode_message(is_orig = <%s>, prefix = <%s>, params = <%s>)", is_orig, prefix, params);
    print "";
    print "";
}

event irc_squit_message(c: connection, is_orig: bool, prefix: string, server: string, message: string) {
    print fmt("[Zeek_IRC] irc_squit_message(is_orig = <%s>, prefix = <%s>, server = <%s>, message = <%s>)", is_orig, prefix, server, message);
    print "";
    print "";
}

event irc_dcc_message(c: connection, is_orig: bool, prefix: string, target: string, dcc_type: string, argument: string, address: addr, dest_port: count, size: count) {
    print fmt("[Zeek_IRC] irc_dcc_message(is_orig = <%s>, prefix = <%s>, target = <%s>, dcc_type = <%s>, argument = <%s>, address = <%s>, dest_port = <%s>, size = <%s>)", is_orig, prefix, target, dcc_type, argument, address, dest_port, size);
    print "";
    print "";
}

event irc_user_message(c: connection, is_orig: bool, user: string, host: string, server: string, real_name: string) {
    print fmt("[Zeek_IRC] irc_user_message(is_orig = <%s>, user = <%s>, host = <%s>, server = <%s>, real_name = <%s>)", is_orig, user, host, server, real_name);
    print "";
    print "";
}

event irc_password_message(c: connection, is_orig: bool, password: string) {
    print fmt("[Zeek_IRC] irc_password_message(is_orig = <%s>, password = <%s>)", is_orig, password);
    print "";
    print "";
}

event irc_starttls(c: connection) {
    print fmt("[Zeek_IRC] irc_starttls()");
    print "";
    print "";
}

event krb_as_request(c: connection, msg: KRB::KDC_Request) {
    print fmt("[Zeek_KRB] krb_as_request(msg = <%s>)", msg);
    print "";
    print "";
}

event krb_as_response(c: connection, msg: KRB::KDC_Response) {
    print fmt("[Zeek_KRB] krb_as_response(msg = <%s>)", msg);
    print "";
    print "";
}

event krb_tgs_request(c: connection, msg: KRB::KDC_Request) {
    print fmt("[Zeek_KRB] krb_tgs_request(msg = <%s>)", msg);
    print "";
    print "";
}

event krb_tgs_response(c: connection, msg: KRB::KDC_Response) {
    print fmt("[Zeek_KRB] krb_tgs_response(msg = <%s>)", msg);
    print "";
    print "";
}

event krb_ap_request(c: connection, ticket: KRB::Ticket, opts: KRB::AP_Options) {
    print fmt("[Zeek_KRB] krb_ap_request(ticket = <%s>, opts = <%s>)", ticket, opts);
    print "";
    print "";
}

event krb_ap_response(c: connection) {
    print fmt("[Zeek_KRB] krb_ap_response()");
    print "";
    print "";
}

event krb_priv(c: connection, is_orig: bool) {
    print fmt("[Zeek_KRB] krb_priv(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event krb_safe(c: connection, is_orig: bool, msg: KRB::SAFE_Msg) {
    print fmt("[Zeek_KRB] krb_safe(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event krb_cred(c: connection, is_orig: bool, tickets: KRB::Ticket_Vector) {
    print fmt("[Zeek_KRB] krb_cred(is_orig = <%s>, tickets = <%s>)", is_orig, tickets);
    print "";
    print "";
}

event krb_error(c: connection, msg: KRB::Error_Msg) {
    print fmt("[Zeek_KRB] krb_error(msg = <%s>)", msg);
    print "";
    print "";
}

event rsh_request(c: connection, client_user: string, server_user: string, line: string, new_session: bool) {
    print fmt("[Zeek_Login] rsh_request(client_user = <%s>, server_user = <%s>, line = <%s>, new_session = <%s>)", client_user, server_user, line, new_session);
    print "";
    print "";
}

event rsh_reply(c: connection, client_user: string, server_user: string, line: string) {
    print fmt("[Zeek_Login] rsh_reply(client_user = <%s>, server_user = <%s>, line = <%s>)", client_user, server_user, line);
    print "";
    print "";
}

event login_failure(c: connection, user: string, client_user: string, password: string, line: string) {
    print fmt("[Zeek_Login] login_failure(user = <%s>, client_user = <%s>, password = <%s>, line = <%s>)", user, client_user, password, line);
    print "";
    print "";
}

event login_success(c: connection, user: string, client_user: string, password: string, line: string) {
    print fmt("[Zeek_Login] login_success(user = <%s>, client_user = <%s>, password = <%s>, line = <%s>)", user, client_user, password, line);
    print "";
    print "";
}

event login_input_line(c: connection, line: string) {
    print fmt("[Zeek_Login] login_input_line(line = <%s>)", line);
    print "";
    print "";
}

event login_output_line(c: connection, line: string) {
    print fmt("[Zeek_Login] login_output_line(line = <%s>)", line);
    print "";
    print "";
}

event login_confused(c: connection, msg: string, line: string) {
    print fmt("[Zeek_Login] login_confused(msg = <%s>, line = <%s>)", msg, line);
    print "";
    print "";
}

event login_confused_text(c: connection, line: string) {
    print fmt("[Zeek_Login] login_confused_text(line = <%s>)", line);
    print "";
    print "";
}

event login_terminal(c: connection, terminal: string) {
    print fmt("[Zeek_Login] login_terminal(terminal = <%s>)", terminal);
    print "";
    print "";
}

event login_display(c: connection, display: string) {
    print fmt("[Zeek_Login] login_display(display = <%s>)", display);
    print "";
    print "";
}

event authentication_accepted(name: string, c: connection) {
    print fmt("[Zeek_Login] authentication_accepted(name = <%s>)", name);
    print "";
    print "";
}

event authentication_rejected(name: string, c: connection) {
    print fmt("[Zeek_Login] authentication_rejected(name = <%s>)", name);
    print "";
    print "";
}

event authentication_skipped(c: connection) {
    print fmt("[Zeek_Login] authentication_skipped()");
    print "";
    print "";
}

event login_prompt(c: connection, prompt: string) {
    print fmt("[Zeek_Login] login_prompt(prompt = <%s>)", prompt);
    print "";
    print "";
}

event activating_encryption(c: connection) {
    print fmt("[Zeek_Login] activating_encryption()");
    print "";
    print "";
}

event inconsistent_option(c: connection) {
    print fmt("[Zeek_Login] inconsistent_option()");
    print "";
    print "";
}

event bad_option(c: connection) {
    print fmt("[Zeek_Login] bad_option()");
    print "";
    print "";
}

event bad_option_termination(c: connection) {
    print fmt("[Zeek_Login] bad_option_termination()");
    print "";
    print "";
}

event mime_begin_entity(c: connection) {
    print fmt("[Zeek_MIME] mime_begin_entity()");
    print "";
    print "";
}

event mime_end_entity(c: connection) {
    print fmt("[Zeek_MIME] mime_end_entity()");
    print "";
    print "";
}

event mime_one_header(c: connection, h: mime_header_rec) {
    print fmt("[Zeek_MIME] mime_one_header(h = <%s>)", h);
    print "";
    print "";
}

event mime_all_headers(c: connection, hlist: mime_header_list) {
    print fmt("[Zeek_MIME] mime_all_headers(hlist = <%s>)", hlist);
    print "";
    print "";
}

event mime_segment_data(c: connection, length: count, data: string) {
    print fmt("[Zeek_MIME] mime_segment_data(length = <%s>, data = <%s>)", length, data);
    print "";
    print "";
}

event mime_entity_data(c: connection, length: count, data: string) {
    print fmt("[Zeek_MIME] mime_entity_data(length = <%s>, data = <%s>)", length, data);
    print "";
    print "";
}

event mime_all_data(c: connection, length: count, data: string) {
    print fmt("[Zeek_MIME] mime_all_data(length = <%s>, data = <%s>)", length, data);
    print "";
    print "";
}

event mime_event(c: connection, event_type: string, detail: string) {
    print fmt("[Zeek_MIME] mime_event(event_type = <%s>, detail = <%s>)", event_type, detail);
    print "";
    print "";
}

event mime_content_hash(c: connection, content_len: count, hash_value: string) {
    print fmt("[Zeek_MIME] mime_content_hash(content_len = <%s>, hash_value = <%s>)", content_len, hash_value);
    print "";
    print "";
}

event modbus_message(c: connection, headers: ModbusHeaders, is_orig: bool) {
    print fmt("[Zeek_Modbus] modbus_message(headers = <%s>, is_orig = <%s>)", headers, is_orig);
    print "";
    print "";
}

event modbus_exception(c: connection, headers: ModbusHeaders, code: count) {
    print fmt("[Zeek_Modbus] modbus_exception(headers = <%s>, code = <%s>)", headers, code);
    print "";
    print "";
}

event modbus_read_coils_request(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_read_coils_request(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_read_coils_response(c: connection, headers: ModbusHeaders, coils: ModbusCoils) {
    print fmt("[Zeek_Modbus] modbus_read_coils_response(headers = <%s>, coils = <%s>)", headers, coils);
    print "";
    print "";
}

event modbus_read_discrete_inputs_request(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_read_discrete_inputs_request(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_read_discrete_inputs_response(c: connection, headers: ModbusHeaders, coils: ModbusCoils) {
    print fmt("[Zeek_Modbus] modbus_read_discrete_inputs_response(headers = <%s>, coils = <%s>)", headers, coils);
    print "";
    print "";
}

event modbus_read_holding_registers_request(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_read_holding_registers_request(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_read_holding_registers_response(c: connection, headers: ModbusHeaders, registers: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_read_holding_registers_response(headers = <%s>, registers = <%s>)", headers, registers);
    print "";
    print "";
}

event modbus_read_input_registers_request(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_read_input_registers_request(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_read_input_registers_response(c: connection, headers: ModbusHeaders, registers: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_read_input_registers_response(headers = <%s>, registers = <%s>)", headers, registers);
    print "";
    print "";
}

event modbus_write_single_coil_request(c: connection, headers: ModbusHeaders, address: count, value: bool) {
    print fmt("[Zeek_Modbus] modbus_write_single_coil_request(headers = <%s>, address = <%s>, value = <%s>)", headers, address, value);
    print "";
    print "";
}

event modbus_write_single_coil_response(c: connection, headers: ModbusHeaders, address: count, value: bool) {
    print fmt("[Zeek_Modbus] modbus_write_single_coil_response(headers = <%s>, address = <%s>, value = <%s>)", headers, address, value);
    print "";
    print "";
}

event modbus_write_single_register_request(c: connection, headers: ModbusHeaders, address: count, value: count) {
    print fmt("[Zeek_Modbus] modbus_write_single_register_request(headers = <%s>, address = <%s>, value = <%s>)", headers, address, value);
    print "";
    print "";
}

event modbus_write_single_register_response(c: connection, headers: ModbusHeaders, address: count, value: count) {
    print fmt("[Zeek_Modbus] modbus_write_single_register_response(headers = <%s>, address = <%s>, value = <%s>)", headers, address, value);
    print "";
    print "";
}

event modbus_write_multiple_coils_request(c: connection, headers: ModbusHeaders, start_address: count, coils: ModbusCoils) {
    print fmt("[Zeek_Modbus] modbus_write_multiple_coils_request(headers = <%s>, start_address = <%s>, coils = <%s>)", headers, start_address, coils);
    print "";
    print "";
}

event modbus_write_multiple_coils_response(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_write_multiple_coils_response(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_write_multiple_registers_request(c: connection, headers: ModbusHeaders, start_address: count, registers: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_write_multiple_registers_request(headers = <%s>, start_address = <%s>, registers = <%s>)", headers, start_address, registers);
    print "";
    print "";
}

event modbus_write_multiple_registers_response(c: connection, headers: ModbusHeaders, start_address: count, quantity: count) {
    print fmt("[Zeek_Modbus] modbus_write_multiple_registers_response(headers = <%s>, start_address = <%s>, quantity = <%s>)", headers, start_address, quantity);
    print "";
    print "";
}

event modbus_read_file_record_request(c: connection, headers: ModbusHeaders) {
    print fmt("[Zeek_Modbus] modbus_read_file_record_request(headers = <%s>)", headers);
    print "";
    print "";
}

event modbus_read_file_record_response(c: connection, headers: ModbusHeaders) {
    print fmt("[Zeek_Modbus] modbus_read_file_record_response(headers = <%s>)", headers);
    print "";
    print "";
}

event modbus_write_file_record_request(c: connection, headers: ModbusHeaders) {
    print fmt("[Zeek_Modbus] modbus_write_file_record_request(headers = <%s>)", headers);
    print "";
    print "";
}

event modbus_write_file_record_response(c: connection, headers: ModbusHeaders) {
    print fmt("[Zeek_Modbus] modbus_write_file_record_response(headers = <%s>)", headers);
    print "";
    print "";
}

event modbus_mask_write_register_request(c: connection, headers: ModbusHeaders, address: count, and_mask: count, or_mask: count) {
    print fmt("[Zeek_Modbus] modbus_mask_write_register_request(headers = <%s>, address = <%s>, and_mask = <%s>, or_mask = <%s>)", headers, address, and_mask, or_mask);
    print "";
    print "";
}

event modbus_mask_write_register_response(c: connection, headers: ModbusHeaders, address: count, and_mask: count, or_mask: count) {
    print fmt("[Zeek_Modbus] modbus_mask_write_register_response(headers = <%s>, address = <%s>, and_mask = <%s>, or_mask = <%s>)", headers, address, and_mask, or_mask);
    print "";
    print "";
}

event modbus_read_write_multiple_registers_request(c: connection, headers: ModbusHeaders, read_start_address: count, read_quantity: count, write_start_address: count, write_registers: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_read_write_multiple_registers_request(headers = <%s>, read_start_address = <%s>, read_quantity = <%s>, write_start_address = <%s>, write_registers = <%s>)", headers, read_start_address, read_quantity, write_start_address, write_registers);
    print "";
    print "";
}

event modbus_read_write_multiple_registers_response(c: connection, headers: ModbusHeaders, written_registers: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_read_write_multiple_registers_response(headers = <%s>, written_registers = <%s>)", headers, written_registers);
    print "";
    print "";
}

event modbus_read_fifo_queue_request(c: connection, headers: ModbusHeaders, start_address: count) {
    print fmt("[Zeek_Modbus] modbus_read_fifo_queue_request(headers = <%s>, start_address = <%s>)", headers, start_address);
    print "";
    print "";
}

event modbus_read_fifo_queue_response(c: connection, headers: ModbusHeaders, fifos: ModbusRegisters) {
    print fmt("[Zeek_Modbus] modbus_read_fifo_queue_response(headers = <%s>, fifos = <%s>)", headers, fifos);
    print "";
    print "";
}

event mqtt_connect(c: connection, msg: MQTT::ConnectMsg) {
    print fmt("[Zeek_MQTT] mqtt_connect(msg = <%s>)", msg);
    print "";
    print "";
}

event mqtt_connack(c: connection, msg: MQTT::ConnectAckMsg) {
    print fmt("[Zeek_MQTT] mqtt_connack(msg = <%s>)", msg);
    print "";
    print "";
}

event mqtt_publish(c: connection, is_orig: bool, msg_id: count, msg: MQTT::PublishMsg) {
    print fmt("[Zeek_MQTT] mqtt_publish(is_orig = <%s>, msg_id = <%s>, msg = <%s>)", is_orig, msg_id, msg);
    print "";
    print "";
}

event mqtt_puback(c: connection, is_orig: bool, msg_id: count) {
    print fmt("[Zeek_MQTT] mqtt_puback(is_orig = <%s>, msg_id = <%s>)", is_orig, msg_id);
    print "";
    print "";
}

event mqtt_pubrec(c: connection, is_orig: bool, msg_id: count) {
    print fmt("[Zeek_MQTT] mqtt_pubrec(is_orig = <%s>, msg_id = <%s>)", is_orig, msg_id);
    print "";
    print "";
}

event mqtt_pubrel(c: connection, is_orig: bool, msg_id: count) {
    print fmt("[Zeek_MQTT] mqtt_pubrel(is_orig = <%s>, msg_id = <%s>)", is_orig, msg_id);
    print "";
    print "";
}

event mqtt_pubcomp(c: connection, is_orig: bool, msg_id: count) {
    print fmt("[Zeek_MQTT] mqtt_pubcomp(is_orig = <%s>, msg_id = <%s>)", is_orig, msg_id);
    print "";
    print "";
}

event mqtt_subscribe(c: connection, msg_id: count, topics: string_vec, requested_qos: index_vec) {
    print fmt("[Zeek_MQTT] mqtt_subscribe(msg_id = <%s>, topics = <%s>, requested_qos = <%s>)", msg_id, topics, requested_qos);
    print "";
    print "";
}

event mqtt_suback(c: connection, msg_id: count, granted_qos: count) {
    print fmt("[Zeek_MQTT] mqtt_suback(msg_id = <%s>, granted_qos = <%s>)", msg_id, granted_qos);
    print "";
    print "";
}

event mqtt_unsubscribe(c: connection, msg_id: count, topics: string_vec) {
    print fmt("[Zeek_MQTT] mqtt_unsubscribe(msg_id = <%s>, topics = <%s>)", msg_id, topics);
    print "";
    print "";
}

event mqtt_unsuback(c: connection, msg_id: count) {
    print fmt("[Zeek_MQTT] mqtt_unsuback(msg_id = <%s>)", msg_id);
    print "";
    print "";
}

event mqtt_pingreq(c: connection) {
    print fmt("[Zeek_MQTT] mqtt_pingreq()");
    print "";
    print "";
}

event mqtt_pingresp(c: connection) {
    print fmt("[Zeek_MQTT] mqtt_pingresp()");
    print "";
    print "";
}

event mqtt_disconnect(c: connection) {
    print fmt("[Zeek_MQTT] mqtt_disconnect()");
    print "";
    print "";
}

event mysql_command_request(c: connection, command: count, arg: string) {
    print fmt("[Zeek_MySQL] mysql_command_request(command = <%s>, arg = <%s>)", command, arg);
    print "";
    print "";
}

event mysql_error(c: connection, code: count, msg: string) {
    print fmt("[Zeek_MySQL] mysql_error(code = <%s>, msg = <%s>)", code, msg);
    print "";
    print "";
}

event mysql_ok(c: connection, affected_rows: count) {
    print fmt("[Zeek_MySQL] mysql_ok(affected_rows = <%s>)", affected_rows);
    print "";
    print "";
}

event mysql_result_row(c: connection, row: string_vec) {
    print fmt("[Zeek_MySQL] mysql_result_row(row = <%s>)", row);
    print "";
    print "";
}

event mysql_server_version(c: connection, ver: string) {
    print fmt("[Zeek_MySQL] mysql_server_version(ver = <%s>)", ver);
    print "";
    print "";
}

event mysql_handshake(c: connection, username: string) {
    print fmt("[Zeek_MySQL] mysql_handshake(username = <%s>)", username);
    print "";
    print "";
}

event ncp_request(c: connection, frame_type: count, length: count, func: count) {
    print fmt("[Zeek_NCP] ncp_request(frame_type = <%s>, length = <%s>, func = <%s>)", frame_type, length, func);
    print "";
    print "";
}

event ncp_reply(c: connection, frame_type: count, length: count, req_frame: count, req_func: count, completion_code: count) {
    print fmt("[Zeek_NCP] ncp_reply(frame_type = <%s>, length = <%s>, req_frame = <%s>, req_func = <%s>, completion_code = <%s>)", frame_type, length, req_frame, req_func, completion_code);
    print "";
    print "";
}

event netbios_session_message(c: connection, is_orig: bool, msg_type: count, data_len: count) {
    print fmt("[Zeek_NetBIOS] netbios_session_message(is_orig = <%s>, msg_type = <%s>, data_len = <%s>)", is_orig, msg_type, data_len);
    print "";
    print "";
}

event netbios_session_request(c: connection, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_request(msg = <%s>)", msg);
    print "";
    print "";
}

event netbios_session_accepted(c: connection, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_accepted(msg = <%s>)", msg);
    print "";
    print "";
}

event netbios_session_rejected(c: connection, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_rejected(msg = <%s>)", msg);
    print "";
    print "";
}

event netbios_session_raw_message(c: connection, is_orig: bool, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_raw_message(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event netbios_session_ret_arg_resp(c: connection, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_ret_arg_resp(msg = <%s>)", msg);
    print "";
    print "";
}

event netbios_session_keepalive(c: connection, msg: string) {
    print fmt("[Zeek_NetBIOS] netbios_session_keepalive(msg = <%s>)", msg);
    print "";
    print "";
}

event ntlm_negotiate(c: connection, negotiate: NTLM::Negotiate) {
    print fmt("[Zeek_NTLM] ntlm_negotiate(negotiate = <%s>)", negotiate);
    print "";
    print "";
}

event ntlm_challenge(c: connection, challenge: NTLM::Challenge) {
    print fmt("[Zeek_NTLM] ntlm_challenge(challenge = <%s>)", challenge);
    print "";
    print "";
}

event ntlm_authenticate(c: connection, request: NTLM::Authenticate) {
    print fmt("[Zeek_NTLM] ntlm_authenticate(request = <%s>)", request);
    print "";
    print "";
}

event ntp_message(c: connection, is_orig: bool, msg: NTP::Message) {
    print fmt("[Zeek_NTP] ntp_message(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event pe_dos_header(f: fa_file, h: PE::DOSHeader) {
    print fmt("[Zeek_PE] pe_dos_header(f = <%s>, h = <%s>)", f, h);
    print "";
    print "";
}

event pe_dos_code(f: fa_file, code: string) {
    print fmt("[Zeek_PE] pe_dos_code(f = <%s>, code = <%s>)", f, code);
    print "";
    print "";
}

event pe_file_header(f: fa_file, h: PE::FileHeader) {
    print fmt("[Zeek_PE] pe_file_header(f = <%s>, h = <%s>)", f, h);
    print "";
    print "";
}

event pe_optional_header(f: fa_file, h: PE::OptionalHeader) {
    print fmt("[Zeek_PE] pe_optional_header(f = <%s>, h = <%s>)", f, h);
    print "";
    print "";
}

event pe_section_header(f: fa_file, h: PE::SectionHeader) {
    print fmt("[Zeek_PE] pe_section_header(f = <%s>, h = <%s>)", f, h);
    print "";
    print "";
}

event pop3_request(c: connection, is_orig: bool, command: string, arg: string) {
    print fmt("[Zeek_POP3] pop3_request(is_orig = <%s>, command = <%s>, arg = <%s>)", is_orig, command, arg);
    print "";
    print "";
}

event pop3_reply(c: connection, is_orig: bool, cmd: string, msg: string) {
    print fmt("[Zeek_POP3] pop3_reply(is_orig = <%s>, cmd = <%s>, msg = <%s>)", is_orig, cmd, msg);
    print "";
    print "";
}

event pop3_data(c: connection, is_orig: bool, data: string) {
    print fmt("[Zeek_POP3] pop3_data(is_orig = <%s>, data = <%s>)", is_orig, data);
    print "";
    print "";
}

event pop3_unexpected(c: connection, is_orig: bool, msg: string, detail: string) {
    print fmt("[Zeek_POP3] pop3_unexpected(is_orig = <%s>, msg = <%s>, detail = <%s>)", is_orig, msg, detail);
    print "";
    print "";
}

event pop3_starttls(c: connection) {
    print fmt("[Zeek_POP3] pop3_starttls()");
    print "";
    print "";
}

event pop3_login_success(c: connection, is_orig: bool, user: string, password: string) {
    print fmt("[Zeek_POP3] pop3_login_success(is_orig = <%s>, user = <%s>, password = <%s>)", is_orig, user, password);
    print "";
    print "";
}

event pop3_login_failure(c: connection, is_orig: bool, user: string, password: string) {
    print fmt("[Zeek_POP3] pop3_login_failure(is_orig = <%s>, user = <%s>, password = <%s>)", is_orig, user, password);
    print "";
    print "";
}

event radius_message(c: connection, result: RADIUS::Message) {
    print fmt("[Zeek_RADIUS] radius_message(result = <%s>)", result);
    print "";
    print "";
}

event radius_attribute(c: connection, attr_type: count, value: string) {
    print fmt("[Zeek_RADIUS] radius_attribute(attr_type = <%s>, value = <%s>)", attr_type, value);
    print "";
    print "";
}

event rdpeudp_syn(c: connection) {
    print fmt("[Zeek_RDP] rdpeudp_syn()");
    print "";
    print "";
}

event rdpeudp_synack(c: connection) {
    print fmt("[Zeek_RDP] rdpeudp_synack()");
    print "";
    print "";
}

event rdpeudp_established(c: connection, version: count) {
    print fmt("[Zeek_RDP] rdpeudp_established(version = <%s>)", version);
    print "";
    print "";
}

event rdpeudp_data(c: connection, is_orig: bool, version: count, data: string) {
    print fmt("[Zeek_RDP] rdpeudp_data(is_orig = <%s>, version = <%s>, data = <%s>)", is_orig, version, data);
    print "";
    print "";
}

event rdp_native_encrypted_data(c: connection, orig: bool, len: count) {
    print fmt("[Zeek_RDP] rdp_native_encrypted_data(orig = <%s>, len = <%s>)", orig, len);
    print "";
    print "";
}

event rdp_connect_request(c: connection, cookie: string, flags: count) {
    print fmt("[Zeek_RDP] rdp_connect_request(cookie = <%s>, flags = <%s>)", cookie, flags);
    print "";
    print "";
}

event rdp_connect_request(c: connection, cookie: string) {
    print fmt("[Zeek_RDP] rdp_connect_request(cookie = <%s>)", cookie);
    print "";
    print "";
}

event rdp_negotiation_response(c: connection, security_protocol: count, flags: count) {
    print fmt("[Zeek_RDP] rdp_negotiation_response(security_protocol = <%s>, flags = <%s>)", security_protocol, flags);
    print "";
    print "";
}

event rdp_negotiation_response(c: connection, security_protocol: count) {
    print fmt("[Zeek_RDP] rdp_negotiation_response(security_protocol = <%s>)", security_protocol);
    print "";
    print "";
}

event rdp_negotiation_failure(c: connection, failure_code: count, flags: count) {
    print fmt("[Zeek_RDP] rdp_negotiation_failure(failure_code = <%s>, flags = <%s>)", failure_code, flags);
    print "";
    print "";
}

event rdp_negotiation_failure(c: connection, failure_code: count) {
    print fmt("[Zeek_RDP] rdp_negotiation_failure(failure_code = <%s>)", failure_code);
    print "";
    print "";
}

event rdp_client_core_data(c: connection, data: RDP::ClientCoreData) {
    print fmt("[Zeek_RDP] rdp_client_core_data(data = <%s>)", data);
    print "";
    print "";
}

event rdp_client_security_data(c: connection, data: RDP::ClientSecurityData) {
    print fmt("[Zeek_RDP] rdp_client_security_data(data = <%s>)", data);
    print "";
    print "";
}

event rdp_client_network_data(c: connection, channels: RDP::ClientChannelList) {
    print fmt("[Zeek_RDP] rdp_client_network_data(channels = <%s>)", channels);
    print "";
    print "";
}

event rdp_client_cluster_data(c: connection, data: RDP::ClientClusterData) {
    print fmt("[Zeek_RDP] rdp_client_cluster_data(data = <%s>)", data);
    print "";
    print "";
}

event rdp_gcc_server_create_response(c: connection, result: count) {
    print fmt("[Zeek_RDP] rdp_gcc_server_create_response(result = <%s>)", result);
    print "";
    print "";
}

event rdp_server_security(c: connection, encryption_method: count, encryption_level: count) {
    print fmt("[Zeek_RDP] rdp_server_security(encryption_method = <%s>, encryption_level = <%s>)", encryption_method, encryption_level);
    print "";
    print "";
}

event rdp_server_certificate(c: connection, cert_type: count, permanently_issued: bool) {
    print fmt("[Zeek_RDP] rdp_server_certificate(cert_type = <%s>, permanently_issued = <%s>)", cert_type, permanently_issued);
    print "";
    print "";
}

event rdp_begin_encryption(c: connection, security_protocol: count) {
    print fmt("[Zeek_RDP] rdp_begin_encryption(security_protocol = <%s>)", security_protocol);
    print "";
    print "";
}

event rfb_authentication_type(c: connection, authtype: count) {
    print fmt("[Zeek_RFB] rfb_authentication_type(authtype = <%s>)", authtype);
    print "";
    print "";
}

event rfb_auth_result(c: connection, result: bool) {
    print fmt("[Zeek_RFB] rfb_auth_result(result = <%s>)", result);
    print "";
    print "";
}

event rfb_share_flag(c: connection, flag: bool) {
    print fmt("[Zeek_RFB] rfb_share_flag(flag = <%s>)", flag);
    print "";
    print "";
}

event rfb_client_version(c: connection, major_version: string, minor_version: string) {
    print fmt("[Zeek_RFB] rfb_client_version(major_version = <%s>, minor_version = <%s>)", major_version, minor_version);
    print "";
    print "";
}

event rfb_server_version(c: connection, major_version: string, minor_version: string) {
    print fmt("[Zeek_RFB] rfb_server_version(major_version = <%s>, minor_version = <%s>)", major_version, minor_version);
    print "";
    print "";
}

event rfb_server_parameters(c: connection, name: string, width: count, height: count) {
    print fmt("[Zeek_RFB] rfb_server_parameters(name = <%s>, width = <%s>, height = <%s>)", name, width, height);
    print "";
    print "";
}

event nfs_proc_null(c: connection, info: NFS3::info_t) {
    print fmt("[Zeek_RPC] nfs_proc_null(info = <%s>)", info);
    print "";
    print "";
}

event nfs_proc_getattr(c: connection, info: NFS3::info_t, fh: string, attrs: NFS3::fattr_t) {
    print fmt("[Zeek_RPC] nfs_proc_getattr(info = <%s>, fh = <%s>, attrs = <%s>)", info, fh, attrs);
    print "";
    print "";
}

event nfs_proc_sattr(c: connection, info: NFS3::info_t, req: NFS3::sattrargs_t, rep: NFS3::sattr_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_sattr(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_lookup(c: connection, info: NFS3::info_t, req: NFS3::diropargs_t, rep: NFS3::lookup_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_lookup(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_read(c: connection, info: NFS3::info_t, req: NFS3::readargs_t, rep: NFS3::read_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_read(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_readlink(c: connection, info: NFS3::info_t, fh: string, rep: NFS3::readlink_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_readlink(info = <%s>, fh = <%s>, rep = <%s>)", info, fh, rep);
    print "";
    print "";
}

event nfs_proc_symlink(c: connection, info: NFS3::info_t, req: NFS3::symlinkargs_t, rep: NFS3::newobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_symlink(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_link(c: connection, info: NFS3::info_t, req: NFS3::linkargs_t, rep: NFS3::link_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_link(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_write(c: connection, info: NFS3::info_t, req: NFS3::writeargs_t, rep: NFS3::write_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_write(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_create(c: connection, info: NFS3::info_t, req: NFS3::diropargs_t, rep: NFS3::newobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_create(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_mkdir(c: connection, info: NFS3::info_t, req: NFS3::diropargs_t, rep: NFS3::newobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_mkdir(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_remove(c: connection, info: NFS3::info_t, req: NFS3::diropargs_t, rep: NFS3::delobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_remove(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_rmdir(c: connection, info: NFS3::info_t, req: NFS3::diropargs_t, rep: NFS3::delobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_rmdir(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_rename(c: connection, info: NFS3::info_t, req: NFS3::renameopargs_t, rep: NFS3::renameobj_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_rename(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_readdir(c: connection, info: NFS3::info_t, req: NFS3::readdirargs_t, rep: NFS3::readdir_reply_t) {
    print fmt("[Zeek_RPC] nfs_proc_readdir(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event nfs_proc_not_implemented(c: connection, info: NFS3::info_t, proc: NFS3::proc_t) {
    print fmt("[Zeek_RPC] nfs_proc_not_implemented(info = <%s>, proc = <%s>)", info, proc);
    print "";
    print "";
}

event nfs_reply_status(n: connection, info: NFS3::info_t) {
    print fmt("[Zeek_RPC] nfs_reply_status(info = <%s>)", info);
    print "";
    print "";
}

event pm_request_null(r: connection) {
    print fmt("[Zeek_RPC] pm_request_null()");
    print "";
    print "";
}

event pm_request_set(r: connection, m: pm_mapping, success: bool) {
    print fmt("[Zeek_RPC] pm_request_set(m = <%s>, success = <%s>)", m, success);
    print "";
    print "";
}

event pm_request_unset(r: connection, m: pm_mapping, success: bool) {
    print fmt("[Zeek_RPC] pm_request_unset(m = <%s>, success = <%s>)", m, success);
    print "";
    print "";
}

event pm_request_getport(r: connection, pr: pm_port_request, p: port) {
    print fmt("[Zeek_RPC] pm_request_getport(pr = <%s>, p = <%s>)", pr, p);
    print "";
    print "";
}

event pm_request_dump(r: connection, m: pm_mappings) {
    print fmt("[Zeek_RPC] pm_request_dump(m = <%s>)", m);
    print "";
    print "";
}

event pm_request_callit(r: connection, call: pm_callit_request, p: port) {
    print fmt("[Zeek_RPC] pm_request_callit(call = <%s>, p = <%s>)", call, p);
    print "";
    print "";
}

event pm_attempt_null(r: connection, status: rpc_status) {
    print fmt("[Zeek_RPC] pm_attempt_null(status = <%s>)", status);
    print "";
    print "";
}

event pm_attempt_set(r: connection, status: rpc_status, m: pm_mapping) {
    print fmt("[Zeek_RPC] pm_attempt_set(status = <%s>, m = <%s>)", status, m);
    print "";
    print "";
}

event pm_attempt_unset(r: connection, status: rpc_status, m: pm_mapping) {
    print fmt("[Zeek_RPC] pm_attempt_unset(status = <%s>, m = <%s>)", status, m);
    print "";
    print "";
}

event pm_attempt_getport(r: connection, status: rpc_status, pr: pm_port_request) {
    print fmt("[Zeek_RPC] pm_attempt_getport(status = <%s>, pr = <%s>)", status, pr);
    print "";
    print "";
}

event pm_attempt_dump(r: connection, status: rpc_status) {
    print fmt("[Zeek_RPC] pm_attempt_dump(status = <%s>)", status);
    print "";
    print "";
}

event pm_attempt_callit(r: connection, status: rpc_status, call: pm_callit_request) {
    print fmt("[Zeek_RPC] pm_attempt_callit(status = <%s>, call = <%s>)", status, call);
    print "";
    print "";
}

event pm_bad_port(r: connection, bad_p: count) {
    print fmt("[Zeek_RPC] pm_bad_port(bad_p = <%s>)", bad_p);
    print "";
    print "";
}

event rpc_dialogue(c: connection, prog: count, ver: count, proc: count, status: rpc_status, start_time: time, call_len: count, reply_len: count) {
    print fmt("[Zeek_RPC] rpc_dialogue(prog = <%s>, ver = <%s>, proc = <%s>, status = <%s>, start_time = <%s>, call_len = <%s>, reply_len = <%s>)", prog, ver, proc, status, start_time, call_len, reply_len);
    print "";
    print "";
}

event rpc_call(c: connection, xid: count, prog: count, ver: count, proc: count, call_len: count) {
    print fmt("[Zeek_RPC] rpc_call(xid = <%s>, prog = <%s>, ver = <%s>, proc = <%s>, call_len = <%s>)", xid, prog, ver, proc, call_len);
    print "";
    print "";
}

event rpc_reply(c: connection, xid: count, status: rpc_status, reply_len: count) {
    print fmt("[Zeek_RPC] rpc_reply(xid = <%s>, status = <%s>, reply_len = <%s>)", xid, status, reply_len);
    print "";
    print "";
}

event mount_proc_null(c: connection, info: MOUNT3::info_t) {
    print fmt("[Zeek_RPC] mount_proc_null(info = <%s>)", info);
    print "";
    print "";
}

event mount_proc_mnt(c: connection, info: MOUNT3::info_t, req: MOUNT3::dirmntargs_t, rep: MOUNT3::mnt_reply_t) {
    print fmt("[Zeek_RPC] mount_proc_mnt(info = <%s>, req = <%s>, rep = <%s>)", info, req, rep);
    print "";
    print "";
}

event mount_proc_umnt(c: connection, info: MOUNT3::info_t, req: MOUNT3::dirmntargs_t) {
    print fmt("[Zeek_RPC] mount_proc_umnt(info = <%s>, req = <%s>)", info, req);
    print "";
    print "";
}

event mount_proc_umnt_all(c: connection, info: MOUNT3::info_t, req: MOUNT3::dirmntargs_t) {
    print fmt("[Zeek_RPC] mount_proc_umnt_all(info = <%s>, req = <%s>)", info, req);
    print "";
    print "";
}

event mount_proc_not_implemented(c: connection, info: MOUNT3::info_t, proc: MOUNT3::proc_t) {
    print fmt("[Zeek_RPC] mount_proc_not_implemented(info = <%s>, proc = <%s>)", info, proc);
    print "";
    print "";
}

event mount_reply_status(n: connection, info: MOUNT3::info_t) {
    print fmt("[Zeek_RPC] mount_reply_status(info = <%s>)", info);
    print "";
    print "";
}

event sip_request(c: connection, method: string, original_URI: string, version: string) {
    print fmt("[Zeek_SIP] sip_request(method = <%s>, original_URI = <%s>, version = <%s>)", method, original_URI, version);
    print "";
    print "";
}

event sip_reply(c: connection, version: string, code: count, reason: string) {
    print fmt("[Zeek_SIP] sip_reply(version = <%s>, code = <%s>, reason = <%s>)", version, code, reason);
    print "";
    print "";
}

event sip_header(c: connection, is_orig: bool, name: string, value: string) {
    print fmt("[Zeek_SIP] sip_header(is_orig = <%s>, name = <%s>, value = <%s>)", is_orig, name, value);
    print "";
    print "";
}

event sip_all_headers(c: connection, is_orig: bool, hlist: mime_header_list) {
    print fmt("[Zeek_SIP] sip_all_headers(is_orig = <%s>, hlist = <%s>)", is_orig, hlist);
    print "";
    print "";
}

event sip_begin_entity(c: connection, is_orig: bool) {
    print fmt("[Zeek_SIP] sip_begin_entity(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event sip_end_entity(c: connection, is_orig: bool) {
    print fmt("[Zeek_SIP] sip_end_entity(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event smb_pipe_connect_heuristic(c: connection) {
    print fmt("[Zeek_SMB] smb_pipe_connect_heuristic()");
    print "";
    print "";
}

event smb1_check_directory_request(c: connection, hdr: SMB1::Header, directory_name: string) {
    print fmt("[Zeek_SMB] smb1_check_directory_request(hdr = <%s>, directory_name = <%s>)", hdr, directory_name);
    print "";
    print "";
}

event smb1_check_directory_response(c: connection, hdr: SMB1::Header) {
    print fmt("[Zeek_SMB] smb1_check_directory_response(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb1_close_request(c: connection, hdr: SMB1::Header, file_id: count) {
    print fmt("[Zeek_SMB] smb1_close_request(hdr = <%s>, file_id = <%s>)", hdr, file_id);
    print "";
    print "";
}

event smb1_create_directory_request(c: connection, hdr: SMB1::Header, directory_name: string) {
    print fmt("[Zeek_SMB] smb1_create_directory_request(hdr = <%s>, directory_name = <%s>)", hdr, directory_name);
    print "";
    print "";
}

event smb1_create_directory_response(c: connection, hdr: SMB1::Header) {
    print fmt("[Zeek_SMB] smb1_create_directory_response(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb1_echo_request(c: connection, echo_count: count, data: string) {
    print fmt("[Zeek_SMB] smb1_echo_request(echo_count = <%s>, data = <%s>)", echo_count, data);
    print "";
    print "";
}

event smb1_echo_response(c: connection, seq_num: count, data: string) {
    print fmt("[Zeek_SMB] smb1_echo_response(seq_num = <%s>, data = <%s>)", seq_num, data);
    print "";
    print "";
}

event smb1_logoff_andx(c: connection, is_orig: bool) {
    print fmt("[Zeek_SMB] smb1_logoff_andx(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event smb1_negotiate_request(c: connection, hdr: SMB1::Header, dialects: string_vec) {
    print fmt("[Zeek_SMB] smb1_negotiate_request(hdr = <%s>, dialects = <%s>)", hdr, dialects);
    print "";
    print "";
}

event smb1_negotiate_response(c: connection, hdr: SMB1::Header, response: SMB1::NegotiateResponse) {
    print fmt("[Zeek_SMB] smb1_negotiate_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb1_nt_cancel_request(c: connection, hdr: SMB1::Header) {
    print fmt("[Zeek_SMB] smb1_nt_cancel_request(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb1_nt_create_andx_request(c: connection, hdr: SMB1::Header, file_name: string) {
    print fmt("[Zeek_SMB] smb1_nt_create_andx_request(hdr = <%s>, file_name = <%s>)", hdr, file_name);
    print "";
    print "";
}

event smb1_nt_create_andx_response(c: connection, hdr: SMB1::Header, file_id: count, file_size: count, times: SMB::MACTimes) {
    print fmt("[Zeek_SMB] smb1_nt_create_andx_response(hdr = <%s>, file_id = <%s>, file_size = <%s>, times = <%s>)", hdr, file_id, file_size, times);
    print "";
    print "";
}

event smb1_query_information_request(c: connection, hdr: SMB1::Header, filename: string) {
    print fmt("[Zeek_SMB] smb1_query_information_request(hdr = <%s>, filename = <%s>)", hdr, filename);
    print "";
    print "";
}

event smb1_read_andx_request(c: connection, hdr: SMB1::Header, file_id: count, offset: count, length: count) {
    print fmt("[Zeek_SMB] smb1_read_andx_request(hdr = <%s>, file_id = <%s>, offset = <%s>, length = <%s>)", hdr, file_id, offset, length);
    print "";
    print "";
}

event smb1_read_andx_response(c: connection, hdr: SMB1::Header, data_len: count) {
    print fmt("[Zeek_SMB] smb1_read_andx_response(hdr = <%s>, data_len = <%s>)", hdr, data_len);
    print "";
    print "";
}

event smb1_session_setup_andx_request(c: connection, hdr: SMB1::Header, request: SMB1::SessionSetupAndXRequest) {
    print fmt("[Zeek_SMB] smb1_session_setup_andx_request(hdr = <%s>, request = <%s>)", hdr, request);
    print "";
    print "";
}

event smb1_session_setup_andx_response(c: connection, hdr: SMB1::Header, response: SMB1::SessionSetupAndXResponse) {
    print fmt("[Zeek_SMB] smb1_session_setup_andx_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb1_transaction_request(c: connection, hdr: SMB1::Header, name: string, sub_cmd: count, parameters: string, data: string) {
    print fmt("[Zeek_SMB] smb1_transaction_request(hdr = <%s>, name = <%s>, sub_cmd = <%s>, parameters = <%s>, data = <%s>)", hdr, name, sub_cmd, parameters, data);
    print "";
    print "";
}

event smb1_transaction_response(c: connection, hdr: SMB1::Header, parameters: string, data: string) {
    print fmt("[Zeek_SMB] smb1_transaction_response(hdr = <%s>, parameters = <%s>, data = <%s>)", hdr, parameters, data);
    print "";
    print "";
}

event smb1_transaction2_request(c: connection, hdr: SMB1::Header, args: SMB1::Trans2_Args, sub_cmd: count) {
    print fmt("[Zeek_SMB] smb1_transaction2_request(hdr = <%s>, args = <%s>, sub_cmd = <%s>)", hdr, args, sub_cmd);
    print "";
    print "";
}

event smb1_trans2_find_first2_request(c: connection, hdr: SMB1::Header, args: SMB1::Find_First2_Request_Args) {
    print fmt("[Zeek_SMB] smb1_trans2_find_first2_request(hdr = <%s>, args = <%s>)", hdr, args);
    print "";
    print "";
}

event smb1_trans2_query_path_info_request(c: connection, hdr: SMB1::Header, file_name: string) {
    print fmt("[Zeek_SMB] smb1_trans2_query_path_info_request(hdr = <%s>, file_name = <%s>)", hdr, file_name);
    print "";
    print "";
}

event smb1_trans2_get_dfs_referral_request(c: connection, hdr: SMB1::Header, file_name: string) {
    print fmt("[Zeek_SMB] smb1_trans2_get_dfs_referral_request(hdr = <%s>, file_name = <%s>)", hdr, file_name);
    print "";
    print "";
}

event smb1_transaction2_secondary_request(c: connection, hdr: SMB1::Header, args: SMB1::Trans2_Sec_Args, parameters: string, data: string) {
    print fmt("[Zeek_SMB] smb1_transaction2_secondary_request(hdr = <%s>, args = <%s>, parameters = <%s>, data = <%s>)", hdr, args, parameters, data);
    print "";
    print "";
}

event smb1_transaction_secondary_request(c: connection, hdr: SMB1::Header, args: SMB1::Trans_Sec_Args, parameters: string, data: string) {
    print fmt("[Zeek_SMB] smb1_transaction_secondary_request(hdr = <%s>, args = <%s>, parameters = <%s>, data = <%s>)", hdr, args, parameters, data);
    print "";
    print "";
}

event smb1_tree_connect_andx_request(c: connection, hdr: SMB1::Header, path: string, service: string) {
    print fmt("[Zeek_SMB] smb1_tree_connect_andx_request(hdr = <%s>, path = <%s>, service = <%s>)", hdr, path, service);
    print "";
    print "";
}

event smb1_tree_connect_andx_response(c: connection, hdr: SMB1::Header, service: string, native_file_system: string) {
    print fmt("[Zeek_SMB] smb1_tree_connect_andx_response(hdr = <%s>, service = <%s>, native_file_system = <%s>)", hdr, service, native_file_system);
    print "";
    print "";
}

event smb1_tree_disconnect(c: connection, hdr: SMB1::Header, is_orig: bool) {
    print fmt("[Zeek_SMB] smb1_tree_disconnect(hdr = <%s>, is_orig = <%s>)", hdr, is_orig);
    print "";
    print "";
}

event smb1_write_andx_request(c: connection, hdr: SMB1::Header, file_id: count, offset: count, data_len: count) {
    print fmt("[Zeek_SMB] smb1_write_andx_request(hdr = <%s>, file_id = <%s>, offset = <%s>, data_len = <%s>)", hdr, file_id, offset, data_len);
    print "";
    print "";
}

event smb1_write_andx_response(c: connection, hdr: SMB1::Header, written_bytes: count) {
    print fmt("[Zeek_SMB] smb1_write_andx_response(hdr = <%s>, written_bytes = <%s>)", hdr, written_bytes);
    print "";
    print "";
}

event smb1_message(c: connection, hdr: SMB1::Header, is_orig: bool) {
    print fmt("[Zeek_SMB] smb1_message(hdr = <%s>, is_orig = <%s>)", hdr, is_orig);
    print "";
    print "";
}

event smb1_empty_response(c: connection, hdr: SMB1::Header) {
    print fmt("[Zeek_SMB] smb1_empty_response(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb1_error(c: connection, hdr: SMB1::Header, is_orig: bool) {
    print fmt("[Zeek_SMB] smb1_error(hdr = <%s>, is_orig = <%s>)", hdr, is_orig);
    print "";
    print "";
}

event smb2_close_request(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID) {
    print fmt("[Zeek_SMB] smb2_close_request(hdr = <%s>, file_id = <%s>)", hdr, file_id);
    print "";
    print "";
}

event smb2_close_response(c: connection, hdr: SMB2::Header, response: SMB2::CloseResponse) {
    print fmt("[Zeek_SMB] smb2_close_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb2_create_request(c: connection, hdr: SMB2::Header, request: SMB2::CreateRequest) {
    print fmt("[Zeek_SMB] smb2_create_request(hdr = <%s>, request = <%s>)", hdr, request);
    print "";
    print "";
}

event smb2_create_response(c: connection, hdr: SMB2::Header, response: SMB2::CreateResponse) {
    print fmt("[Zeek_SMB] smb2_create_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb2_negotiate_request(c: connection, hdr: SMB2::Header, dialects: index_vec) {
    print fmt("[Zeek_SMB] smb2_negotiate_request(hdr = <%s>, dialects = <%s>)", hdr, dialects);
    print "";
    print "";
}

event smb2_negotiate_response(c: connection, hdr: SMB2::Header, response: SMB2::NegotiateResponse) {
    print fmt("[Zeek_SMB] smb2_negotiate_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb2_read_request(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, offset: count, length: count) {
    print fmt("[Zeek_SMB] smb2_read_request(hdr = <%s>, file_id = <%s>, offset = <%s>, length = <%s>)", hdr, file_id, offset, length);
    print "";
    print "";
}

event smb2_session_setup_request(c: connection, hdr: SMB2::Header, request: SMB2::SessionSetupRequest) {
    print fmt("[Zeek_SMB] smb2_session_setup_request(hdr = <%s>, request = <%s>)", hdr, request);
    print "";
    print "";
}

event smb2_session_setup_response(c: connection, hdr: SMB2::Header, response: SMB2::SessionSetupResponse) {
    print fmt("[Zeek_SMB] smb2_session_setup_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb2_file_rename(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, dst_filename: string) {
    print fmt("[Zeek_SMB] smb2_file_rename(hdr = <%s>, file_id = <%s>, dst_filename = <%s>)", hdr, file_id, dst_filename);
    print "";
    print "";
}

event smb2_file_delete(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, delete_pending: bool) {
    print fmt("[Zeek_SMB] smb2_file_delete(hdr = <%s>, file_id = <%s>, delete_pending = <%s>)", hdr, file_id, delete_pending);
    print "";
    print "";
}

event smb2_file_sattr(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, times: SMB::MACTimes, attrs: SMB2::FileAttrs) {
    print fmt("[Zeek_SMB] smb2_file_sattr(hdr = <%s>, file_id = <%s>, times = <%s>, attrs = <%s>)", hdr, file_id, times, attrs);
    print "";
    print "";
}

event smb2_file_allocation(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, alloc_size: int) {
    print fmt("[Zeek_SMB] smb2_file_allocation(hdr = <%s>, file_id = <%s>, alloc_size = <%s>)", hdr, file_id, alloc_size);
    print "";
    print "";
}

event smb2_file_endoffile(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, end_of_file: int) {
    print fmt("[Zeek_SMB] smb2_file_endoffile(hdr = <%s>, file_id = <%s>, end_of_file = <%s>)", hdr, file_id, end_of_file);
    print "";
    print "";
}

event smb2_file_mode(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, mode: count) {
    print fmt("[Zeek_SMB] smb2_file_mode(hdr = <%s>, file_id = <%s>, mode = <%s>)", hdr, file_id, mode);
    print "";
    print "";
}

event smb2_file_pipe(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, read_mode: count, completion_mode: count) {
    print fmt("[Zeek_SMB] smb2_file_pipe(hdr = <%s>, file_id = <%s>, read_mode = <%s>, completion_mode = <%s>)", hdr, file_id, read_mode, completion_mode);
    print "";
    print "";
}

event smb2_file_position(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, current_byte_offset: int) {
    print fmt("[Zeek_SMB] smb2_file_position(hdr = <%s>, file_id = <%s>, current_byte_offset = <%s>)", hdr, file_id, current_byte_offset);
    print "";
    print "";
}

event smb2_file_shortname(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, file_name: string) {
    print fmt("[Zeek_SMB] smb2_file_shortname(hdr = <%s>, file_id = <%s>, file_name = <%s>)", hdr, file_id, file_name);
    print "";
    print "";
}

event smb2_file_validdatalength(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, valid_data_length: int) {
    print fmt("[Zeek_SMB] smb2_file_validdatalength(hdr = <%s>, file_id = <%s>, valid_data_length = <%s>)", hdr, file_id, valid_data_length);
    print "";
    print "";
}

event smb2_file_fullea(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, file_eas: SMB2::FileEAs) {
    print fmt("[Zeek_SMB] smb2_file_fullea(hdr = <%s>, file_id = <%s>, file_eas = <%s>)", hdr, file_id, file_eas);
    print "";
    print "";
}

event smb2_file_link(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, root_directory: count, file_name: string) {
    print fmt("[Zeek_SMB] smb2_file_link(hdr = <%s>, file_id = <%s>, root_directory = <%s>, file_name = <%s>)", hdr, file_id, root_directory, file_name);
    print "";
    print "";
}

event smb2_file_fscontrol(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, fs_control: SMB2::Fscontrol) {
    print fmt("[Zeek_SMB] smb2_file_fscontrol(hdr = <%s>, file_id = <%s>, fs_control = <%s>)", hdr, file_id, fs_control);
    print "";
    print "";
}

event smb2_file_fsobjectid(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, object_id: SMB2::GUID, extended_info: string) {
    print fmt("[Zeek_SMB] smb2_file_fsobjectid(hdr = <%s>, file_id = <%s>, object_id = <%s>, extended_info = <%s>)", hdr, file_id, object_id, extended_info);
    print "";
    print "";
}

event smb2_transform_header(c: connection, hdr: SMB2::Transform_header) {
    print fmt("[Zeek_SMB] smb2_transform_header(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb2_tree_connect_request(c: connection, hdr: SMB2::Header, path: string) {
    print fmt("[Zeek_SMB] smb2_tree_connect_request(hdr = <%s>, path = <%s>)", hdr, path);
    print "";
    print "";
}

event smb2_tree_connect_response(c: connection, hdr: SMB2::Header, response: SMB2::TreeConnectResponse) {
    print fmt("[Zeek_SMB] smb2_tree_connect_response(hdr = <%s>, response = <%s>)", hdr, response);
    print "";
    print "";
}

event smb2_tree_disconnect_request(c: connection, hdr: SMB2::Header) {
    print fmt("[Zeek_SMB] smb2_tree_disconnect_request(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb2_tree_disconnect_response(c: connection, hdr: SMB2::Header) {
    print fmt("[Zeek_SMB] smb2_tree_disconnect_response(hdr = <%s>)", hdr);
    print "";
    print "";
}

event smb2_write_request(c: connection, hdr: SMB2::Header, file_id: SMB2::GUID, offset: count, length: count) {
    print fmt("[Zeek_SMB] smb2_write_request(hdr = <%s>, file_id = <%s>, offset = <%s>, length = <%s>)", hdr, file_id, offset, length);
    print "";
    print "";
}

event smb2_write_response(c: connection, hdr: SMB2::Header, length: count) {
    print fmt("[Zeek_SMB] smb2_write_response(hdr = <%s>, length = <%s>)", hdr, length);
    print "";
    print "";
}

event smb2_message(c: connection, hdr: SMB2::Header, is_orig: bool) {
    print fmt("[Zeek_SMB] smb2_message(hdr = <%s>, is_orig = <%s>)", hdr, is_orig);
    print "";
    print "";
}

event smtp_request(c: connection, is_orig: bool, command: string, arg: string) {
    print fmt("[Zeek_SMTP] smtp_request(is_orig = <%s>, command = <%s>, arg = <%s>)", is_orig, command, arg);
    print "";
    print "";
}

event smtp_reply(c: connection, is_orig: bool, code: count, cmd: string, msg: string, cont_resp: bool) {
    print fmt("[Zeek_SMTP] smtp_reply(is_orig = <%s>, code = <%s>, cmd = <%s>, msg = <%s>, cont_resp = <%s>)", is_orig, code, cmd, msg, cont_resp);
    print "";
    print "";
}

event smtp_data(c: connection, is_orig: bool, data: string) {
    print fmt("[Zeek_SMTP] smtp_data(is_orig = <%s>, data = <%s>)", is_orig, data);
    print "";
    print "";
}

event smtp_unexpected(c: connection, is_orig: bool, msg: string, detail: string) {
    print fmt("[Zeek_SMTP] smtp_unexpected(is_orig = <%s>, msg = <%s>, detail = <%s>)", is_orig, msg, detail);
    print "";
    print "";
}

event smtp_starttls(c: connection) {
    print fmt("[Zeek_SMTP] smtp_starttls()");
    print "";
    print "";
}

event snmp_get_request(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_get_request(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_get_next_request(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_get_next_request(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_response(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_response(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_set_request(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_set_request(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_trap(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::TrapPDU) {
    print fmt("[Zeek_SNMP] snmp_trap(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_get_bulk_request(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::BulkPDU) {
    print fmt("[Zeek_SNMP] snmp_get_bulk_request(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_inform_request(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_inform_request(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_trapV2(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_trapV2(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_report(c: connection, is_orig: bool, header: SNMP::Header, pdu: SNMP::PDU) {
    print fmt("[Zeek_SNMP] snmp_report(is_orig = <%s>, header = <%s>, pdu = <%s>)", is_orig, header, pdu);
    print "";
    print "";
}

event snmp_unknown_pdu(c: connection, is_orig: bool, header: SNMP::Header, tag: count) {
    print fmt("[Zeek_SNMP] snmp_unknown_pdu(is_orig = <%s>, header = <%s>, tag = <%s>)", is_orig, header, tag);
    print "";
    print "";
}

event snmp_unknown_scoped_pdu(c: connection, is_orig: bool, header: SNMP::Header, tag: count) {
    print fmt("[Zeek_SNMP] snmp_unknown_scoped_pdu(is_orig = <%s>, header = <%s>, tag = <%s>)", is_orig, header, tag);
    print "";
    print "";
}

event snmp_encrypted_pdu(c: connection, is_orig: bool, header: SNMP::Header) {
    print fmt("[Zeek_SNMP] snmp_encrypted_pdu(is_orig = <%s>, header = <%s>)", is_orig, header);
    print "";
    print "";
}

event snmp_unknown_header_version(c: connection, is_orig: bool, version: count) {
    print fmt("[Zeek_SNMP] snmp_unknown_header_version(is_orig = <%s>, version = <%s>)", is_orig, version);
    print "";
    print "";
}

event socks_request(c: connection, version: count, request_type: count, sa: SOCKS::Address, p: port, user: string) {
    print fmt("[Zeek_SOCKS] socks_request(version = <%s>, request_type = <%s>, sa = <%s>, p = <%s>, user = <%s>)", version, request_type, sa, p, user);
    print "";
    print "";
}

event socks_reply(c: connection, version: count, reply: count, sa: SOCKS::Address, p: port) {
    print fmt("[Zeek_SOCKS] socks_reply(version = <%s>, reply = <%s>, sa = <%s>, p = <%s>)", version, reply, sa, p);
    print "";
    print "";
}

event socks_login_userpass_request(c: connection, user: string, password: string) {
    print fmt("[Zeek_SOCKS] socks_login_userpass_request(user = <%s>, password = <%s>)", user, password);
    print "";
    print "";
}

event socks_login_userpass_reply(c: connection, code: count) {
    print fmt("[Zeek_SOCKS] socks_login_userpass_reply(code = <%s>)", code);
    print "";
    print "";
}

event max_file_depth_exceeded(f: fa_file, args: Files::AnalyzerArgs, limit: count) {
    print fmt("[Zeek_Spicy] max_file_depth_exceeded(f = <%s>, args = <%s>, limit = <%s>)", f, args, limit);
    print "";
    print "";
}

event ssh_server_version(c: connection, version: string) {
    print fmt("[Zeek_SSH] ssh_server_version(version = <%s>)", version);
    print "";
    print "";
}

event ssh_client_version(c: connection, version: string) {
    print fmt("[Zeek_SSH] ssh_client_version(version = <%s>)", version);
    print "";
    print "";
}

event ssh_auth_successful(c: connection, auth_method_none: bool) {
    print fmt("[Zeek_SSH] ssh_auth_successful(auth_method_none = <%s>)", auth_method_none);
    print "";
    print "";
}

event ssh_auth_attempted(c: connection, authenticated: bool) {
    print fmt("[Zeek_SSH] ssh_auth_attempted(authenticated = <%s>)", authenticated);
    print "";
    print "";
}

event ssh_capabilities(c: connection, cookie: string, capabilities: SSH::Capabilities) {
    print fmt("[Zeek_SSH] ssh_capabilities(cookie = <%s>, capabilities = <%s>)", cookie, capabilities);
    print "";
    print "";
}

event ssh2_server_host_key(c: connection, key: string) {
    print fmt("[Zeek_SSH] ssh2_server_host_key(key = <%s>)", key);
    print "";
    print "";
}

event ssh1_server_host_key(c: connection, modulus: string, exponent: string) {
    print fmt("[Zeek_SSH] ssh1_server_host_key(modulus = <%s>, exponent = <%s>)", modulus, exponent);
    print "";
    print "";
}

event ssh_server_host_key(c: connection, hash: string) {
    print fmt("[Zeek_SSH] ssh_server_host_key(hash = <%s>)", hash);
    print "";
    print "";
}

event ssh_encrypted_packet(c: connection, orig: bool, len: count) {
    print fmt("[Zeek_SSH] ssh_encrypted_packet(orig = <%s>, len = <%s>)", orig, len);
    print "";
    print "";
}

event ssh2_dh_server_params(c: connection, p: string, q: string) {
    print fmt("[Zeek_SSH] ssh2_dh_server_params(p = <%s>, q = <%s>)", p, q);
    print "";
    print "";
}

event ssh2_gss_error(c: connection, major_status: count, minor_status: count, err_msg: string) {
    print fmt("[Zeek_SSH] ssh2_gss_error(major_status = <%s>, minor_status = <%s>, err_msg = <%s>)", major_status, minor_status, err_msg);
    print "";
    print "";
}

event ssh2_ecc_key(c: connection, is_orig: bool, q: string) {
    print fmt("[Zeek_SSH] ssh2_ecc_key(is_orig = <%s>, q = <%s>)", is_orig, q);
    print "";
    print "";
}

event ssl_client_hello(c: connection, version: count, record_version: count, possible_ts: time, client_random: string, session_id: string, ciphers: index_vec, comp_methods: index_vec) {
    print fmt("[Zeek_SSL] ssl_client_hello(version = <%s>, record_version = <%s>, possible_ts = <%s>, client_random = <%s>, session_id = <%s>, ciphers = <%s>, comp_methods = <%s>)", version, record_version, possible_ts, client_random, session_id, ciphers, comp_methods);
    print "";
    print "";
}

event ssl_server_hello(c: connection, version: count, record_version: count, possible_ts: time, server_random: string, session_id: string, cipher: count, comp_method: count) {
    print fmt("[Zeek_SSL] ssl_server_hello(version = <%s>, record_version = <%s>, possible_ts = <%s>, server_random = <%s>, session_id = <%s>, cipher = <%s>, comp_method = <%s>)", version, record_version, possible_ts, server_random, session_id, cipher, comp_method);
    print "";
    print "";
}

event ssl_extension(c: connection, is_orig: bool, code: count, val: string) {
    print fmt("[Zeek_SSL] ssl_extension(is_orig = <%s>, code = <%s>, val = <%s>)", is_orig, code, val);
    print "";
    print "";
}

event ssl_extension_elliptic_curves(c: connection, is_orig: bool, curves: index_vec) {
    print fmt("[Zeek_SSL] ssl_extension_elliptic_curves(is_orig = <%s>, curves = <%s>)", is_orig, curves);
    print "";
    print "";
}

event ssl_extension_ec_point_formats(c: connection, is_orig: bool, point_formats: index_vec) {
    print fmt("[Zeek_SSL] ssl_extension_ec_point_formats(is_orig = <%s>, point_formats = <%s>)", is_orig, point_formats);
    print "";
    print "";
}

event ssl_extension_signature_algorithm(c: connection, is_orig: bool, signature_algorithms: signature_and_hashalgorithm_vec) {
    print fmt("[Zeek_SSL] ssl_extension_signature_algorithm(is_orig = <%s>, signature_algorithms = <%s>)", is_orig, signature_algorithms);
    print "";
    print "";
}

event ssl_extension_key_share(c: connection, is_orig: bool, curves: index_vec) {
    print fmt("[Zeek_SSL] ssl_extension_key_share(is_orig = <%s>, curves = <%s>)", is_orig, curves);
    print "";
    print "";
}

event ssl_extension_pre_shared_key_client_hello(c: connection, is_orig: bool, identities: psk_identity_vec, binders: string_vec) {
    print fmt("[Zeek_SSL] ssl_extension_pre_shared_key_client_hello(is_orig = <%s>, identities = <%s>, binders = <%s>)", is_orig, identities, binders);
    print "";
    print "";
}

event ssl_extension_pre_shared_key_server_hello(c: connection, is_orig: bool, selected_identity: count) {
    print fmt("[Zeek_SSL] ssl_extension_pre_shared_key_server_hello(is_orig = <%s>, selected_identity = <%s>)", is_orig, selected_identity);
    print "";
    print "";
}

event ssl_ecdh_server_params(c: connection, curve: count, point: string) {
    print fmt("[Zeek_SSL] ssl_ecdh_server_params(curve = <%s>, point = <%s>)", curve, point);
    print "";
    print "";
}

event ssl_dh_server_params(c: connection, p: string, q: string, Ys: string) {
    print fmt("[Zeek_SSL] ssl_dh_server_params(p = <%s>, q = <%s>, Ys = <%s>)", p, q, Ys);
    print "";
    print "";
}

event ssl_server_signature(c: connection, signature_and_hashalgorithm: SSL::SignatureAndHashAlgorithm, signature: string) {
    print fmt("[Zeek_SSL] ssl_server_signature(signature_and_hashalgorithm = <%s>, signature = <%s>)", signature_and_hashalgorithm, signature);
    print "";
    print "";
}

event ssl_ecdh_client_params(c: connection, point: string) {
    print fmt("[Zeek_SSL] ssl_ecdh_client_params(point = <%s>)", point);
    print "";
    print "";
}

event ssl_dh_client_params(c: connection, Yc: string) {
    print fmt("[Zeek_SSL] ssl_dh_client_params(Yc = <%s>)", Yc);
    print "";
    print "";
}

event ssl_rsa_client_pms(c: connection, pms: string) {
    print fmt("[Zeek_SSL] ssl_rsa_client_pms(pms = <%s>)", pms);
    print "";
    print "";
}

event ssl_extension_application_layer_protocol_negotiation(c: connection, is_orig: bool, protocols: string_vec) {
    print fmt("[Zeek_SSL] ssl_extension_application_layer_protocol_negotiation(is_orig = <%s>, protocols = <%s>)", is_orig, protocols);
    print "";
    print "";
}

event ssl_extension_server_name(c: connection, is_orig: bool, names: string_vec) {
    print fmt("[Zeek_SSL] ssl_extension_server_name(is_orig = <%s>, names = <%s>)", is_orig, names);
    print "";
    print "";
}

event ssl_extension_signed_certificate_timestamp(c: connection, is_orig: bool, version: count, logid: string, timestamp: count, signature_and_hashalgorithm: SSL::SignatureAndHashAlgorithm, signature: string) {
    print fmt("[Zeek_SSL] ssl_extension_signed_certificate_timestamp(is_orig = <%s>, version = <%s>, logid = <%s>, timestamp = <%s>, signature_and_hashalgorithm = <%s>, signature = <%s>)", is_orig, version, logid, timestamp, signature_and_hashalgorithm, signature);
    print "";
    print "";
}

event ssl_extension_supported_versions(c: connection, is_orig: bool, versions: index_vec) {
    print fmt("[Zeek_SSL] ssl_extension_supported_versions(is_orig = <%s>, versions = <%s>)", is_orig, versions);
    print "";
    print "";
}

event ssl_extension_psk_key_exchange_modes(c: connection, is_orig: bool, modes: index_vec) {
    print fmt("[Zeek_SSL] ssl_extension_psk_key_exchange_modes(is_orig = <%s>, modes = <%s>)", is_orig, modes);
    print "";
    print "";
}

event ssl_established(c: connection) {
    print fmt("[Zeek_SSL] ssl_established()");
    print "";
    print "";
}

event ssl_alert(c: connection, is_orig: bool, level: count, desc: count) {
    print fmt("[Zeek_SSL] ssl_alert(is_orig = <%s>, level = <%s>, desc = <%s>)", is_orig, level, desc);
    print "";
    print "";
}

event ssl_session_ticket_handshake(c: connection, ticket_lifetime_hint: count, ticket: string) {
    print fmt("[Zeek_SSL] ssl_session_ticket_handshake(ticket_lifetime_hint = <%s>, ticket = <%s>)", ticket_lifetime_hint, ticket);
    print "";
    print "";
}

event ssl_heartbeat(c: connection, is_orig: bool, length: count, heartbeat_type: count, payload_length: count, payload: string) {
    print fmt("[Zeek_SSL] ssl_heartbeat(is_orig = <%s>, length = <%s>, heartbeat_type = <%s>, payload_length = <%s>, payload = <%s>)", is_orig, length, heartbeat_type, payload_length, payload);
    print "";
    print "";
}

event ssl_plaintext_data(c: connection, is_orig: bool, record_version: count, content_type: count, length: count) {
    print fmt("[Zeek_SSL] ssl_plaintext_data(is_orig = <%s>, record_version = <%s>, content_type = <%s>, length = <%s>)", is_orig, record_version, content_type, length);
    print "";
    print "";
}

event ssl_encrypted_data(c: connection, is_orig: bool, record_version: count, content_type: count, length: count) {
    print fmt("[Zeek_SSL] ssl_encrypted_data(is_orig = <%s>, record_version = <%s>, content_type = <%s>, length = <%s>)", is_orig, record_version, content_type, length);
    print "";
    print "";
}

event ssl_probable_encrypted_handshake_message(c: connection, is_orig: bool, length: count) {
    print fmt("[Zeek_SSL] ssl_probable_encrypted_handshake_message(is_orig = <%s>, length = <%s>)", is_orig, length);
    print "";
    print "";
}

event ssl_stapled_ocsp(c: connection, is_orig: bool, response: string) {
    print fmt("[Zeek_SSL] ssl_stapled_ocsp(is_orig = <%s>, response = <%s>)", is_orig, response);
    print "";
    print "";
}

event ssl_handshake_message(c: connection, is_orig: bool, msg_type: count, length: count) {
    print fmt("[Zeek_SSL] ssl_handshake_message(is_orig = <%s>, msg_type = <%s>, length = <%s>)", is_orig, msg_type, length);
    print "";
    print "";
}

event ssl_change_cipher_spec(c: connection, is_orig: bool) {
    print fmt("[Zeek_SSL] ssl_change_cipher_spec(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event syslog_message(c: connection, facility: count, severity: count, msg: string) {
    print fmt("[Zeek_Syslog] syslog_message(facility = <%s>, severity = <%s>, msg = <%s>)", facility, severity, msg);
    print "";
    print "";
}

event new_connection_contents(c: connection) {
    print fmt("[Zeek_TCP] new_connection_contents()");
    print "";
    print "";
}

event connection_attempt(c: connection) {
    print fmt("[Zeek_TCP] connection_attempt()");
    print "";
    print "";
}

event connection_established(c: connection) {
    print fmt("[Zeek_TCP] connection_established()");
    print "";
    print "";
}

event partial_connection(c: connection) {
    print fmt("[Zeek_TCP] partial_connection()");
    print "";
    print "";
}

event connection_partial_close(c: connection) {
    print fmt("[Zeek_TCP] connection_partial_close()");
    print "";
    print "";
}

event connection_finished(c: connection) {
    print fmt("[Zeek_TCP] connection_finished()");
    print "";
    print "";
}

event connection_half_finished(c: connection) {
    print fmt("[Zeek_TCP] connection_half_finished()");
    print "";
    print "";
}

event connection_rejected(c: connection) {
    print fmt("[Zeek_TCP] connection_rejected()");
    print "";
    print "";
}

event connection_reset(c: connection) {
    print fmt("[Zeek_TCP] connection_reset()");
    print "";
    print "";
}

event connection_pending(c: connection) {
    print fmt("[Zeek_TCP] connection_pending()");
    print "";
    print "";
}

event connection_SYN_packet(c: connection, pkt: SYN_packet) {
    print fmt("[Zeek_TCP] connection_SYN_packet(pkt = <%s>)", pkt);
    print "";
    print "";
}

event connection_first_ACK(c: connection) {
    print fmt("[Zeek_TCP] connection_first_ACK()");
    print "";
    print "";
}

event connection_EOF(c: connection, is_orig: bool) {
    print fmt("[Zeek_TCP] connection_EOF(is_orig = <%s>)", is_orig);
    print "";
    print "";
}

event tcp_packet(c: connection, is_orig: bool, flags: string, seq: count, ack: count, len: count, payload: string) {
    print fmt("[Zeek_TCP] tcp_packet(is_orig = <%s>, flags = <%s>, seq = <%s>, ack = <%s>, len = <%s>, payload = <%s>)", is_orig, flags, seq, ack, len, payload);
    print "";
    print "";
}

event tcp_option(c: connection, is_orig: bool, opt: count, optlen: count) {
    print fmt("[Zeek_TCP] tcp_option(is_orig = <%s>, opt = <%s>, optlen = <%s>)", is_orig, opt, optlen);
    print "";
    print "";
}

event tcp_options(c: connection, is_orig: bool, options: TCP::OptionList) {
    print fmt("[Zeek_TCP] tcp_options(is_orig = <%s>, options = <%s>)", is_orig, options);
    print "";
    print "";
}

event tcp_contents(c: connection, is_orig: bool, seq: count, contents: string) {
    print fmt("[Zeek_TCP] tcp_contents(is_orig = <%s>, seq = <%s>, contents = <%s>)", is_orig, seq, contents);
    print "";
    print "";
}

event tcp_rexmit(c: connection, is_orig: bool, seq: count, len: count, data_in_flight: count, window: count) {
    print fmt("[Zeek_TCP] tcp_rexmit(is_orig = <%s>, seq = <%s>, len = <%s>, data_in_flight = <%s>, window = <%s>)", is_orig, seq, len, data_in_flight, window);
    print "";
    print "";
}

event tcp_multiple_checksum_errors(c: connection, is_orig: bool, threshold: count) {
    print fmt("[Zeek_TCP] tcp_multiple_checksum_errors(is_orig = <%s>, threshold = <%s>)", is_orig, threshold);
    print "";
    print "";
}

event tcp_multiple_zero_windows(c: connection, is_orig: bool, threshold: count) {
    print fmt("[Zeek_TCP] tcp_multiple_zero_windows(is_orig = <%s>, threshold = <%s>)", is_orig, threshold);
    print "";
    print "";
}

event tcp_multiple_retransmissions(c: connection, is_orig: bool, threshold: count) {
    print fmt("[Zeek_TCP] tcp_multiple_retransmissions(is_orig = <%s>, threshold = <%s>)", is_orig, threshold);
    print "";
    print "";
}

event tcp_multiple_gap(c: connection, is_orig: bool, threshold: count) {
    print fmt("[Zeek_TCP] tcp_multiple_gap(is_orig = <%s>, threshold = <%s>)", is_orig, threshold);
    print "";
    print "";
}

event contents_file_write_failure(c: connection, is_orig: bool, msg: string) {
    print fmt("[Zeek_TCP] contents_file_write_failure(is_orig = <%s>, msg = <%s>)", is_orig, msg);
    print "";
    print "";
}

event teredo_packet(outer: connection, inner: teredo_hdr) {
    print fmt("[Zeek_Teredo] teredo_packet(inner = <%s>)", inner);
    print "";
    print "";
}

event teredo_authentication(outer: connection, inner: teredo_hdr) {
    print fmt("[Zeek_Teredo] teredo_authentication(inner = <%s>)", inner);
    print "";
    print "";
}

event teredo_origin_indication(outer: connection, inner: teredo_hdr) {
    print fmt("[Zeek_Teredo] teredo_origin_indication(inner = <%s>)", inner);
    print "";
    print "";
}

event teredo_bubble(outer: connection, inner: teredo_hdr) {
    print fmt("[Zeek_Teredo] teredo_bubble(inner = <%s>)", inner);
    print "";
    print "";
}

event udp_request(u: connection) {
    print fmt("[Zeek_UDP] udp_request()");
    print "";
    print "";
}

event udp_reply(u: connection) {
    print fmt("[Zeek_UDP] udp_reply()");
    print "";
    print "";
}

event udp_contents(u: connection, is_orig: bool, contents: string) {
    print fmt("[Zeek_UDP] udp_contents(is_orig = <%s>, contents = <%s>)", is_orig, contents);
    print "";
    print "";
}

event udp_multiple_checksum_errors(u: connection, is_orig: bool, threshold: count) {
    print fmt("[Zeek_UDP] udp_multiple_checksum_errors(is_orig = <%s>, threshold = <%s>)", is_orig, threshold);
    print "";
    print "";
}

event unified2_event(f: fa_file, ev: Unified2::IDSEvent) {
    print fmt("[Zeek_Unified2] unified2_event(f = <%s>, ev = <%s>)", f, ev);
    print "";
    print "";
}

event unified2_packet(f: fa_file, pkt: Unified2::Packet) {
    print fmt("[Zeek_Unified2] unified2_packet(f = <%s>, pkt = <%s>)", f, pkt);
    print "";
    print "";
}

event vxlan_packet(outer: connection, inner: pkt_hdr, vni: count) {
    print fmt("[Zeek_VXLAN] vxlan_packet(inner = <%s>, vni = <%s>)", inner, vni);
    print "";
    print "";
}

event x509_certificate(f: fa_file, cert_ref: opaque of x509, cert: X509::Certificate) {
    print fmt("[Zeek_X509] x509_certificate(f = <%s>, cert_ref = <%s>, cert = <%s>)", f, cert_ref, cert);
    print "";
    print "";
}

event x509_extension(f: fa_file, ext: X509::Extension) {
    print fmt("[Zeek_X509] x509_extension(f = <%s>, ext = <%s>)", f, ext);
    print "";
    print "";
}

event x509_ext_basic_constraints(f: fa_file, ext: X509::BasicConstraints) {
    print fmt("[Zeek_X509] x509_ext_basic_constraints(f = <%s>, ext = <%s>)", f, ext);
    print "";
    print "";
}

event x509_ext_subject_alternative_name(f: fa_file, ext: X509::SubjectAlternativeName) {
    print fmt("[Zeek_X509] x509_ext_subject_alternative_name(f = <%s>, ext = <%s>)", f, ext);
    print "";
    print "";
}

event x509_ocsp_ext_signed_certificate_timestamp(f: fa_file, version: count, logid: string, timestamp: count, hash_algorithm: count, signature_algorithm: count, signature: string) {
    print fmt("[Zeek_X509] x509_ocsp_ext_signed_certificate_timestamp(f = <%s>, version = <%s>, logid = <%s>, timestamp = <%s>, hash_algorithm = <%s>, signature_algorithm = <%s>, signature = <%s>)", f, version, logid, timestamp, hash_algorithm, signature_algorithm, signature);
    print "";
    print "";
}

event ocsp_request(f: fa_file, version: count) {
    print fmt("[Zeek_X509] ocsp_request(f = <%s>, version = <%s>)", f, version);
    print "";
    print "";
}

event ocsp_request_certificate(f: fa_file, hashAlgorithm: string, issuerNameHash: string, issuerKeyHash: string, serialNumber: string) {
    print fmt("[Zeek_X509] ocsp_request_certificate(f = <%s>, hashAlgorithm = <%s>, issuerNameHash = <%s>, issuerKeyHash = <%s>, serialNumber = <%s>)", f, hashAlgorithm, issuerNameHash, issuerKeyHash, serialNumber);
    print "";
    print "";
}

event ocsp_response_status(f: fa_file, status: string) {
    print fmt("[Zeek_X509] ocsp_response_status(f = <%s>, status = <%s>)", f, status);
    print "";
    print "";
}

event ocsp_response_bytes(f: fa_file, status: string, version: count, responderId: string, producedAt: time, signatureAlgorithm: string, certs: x509_opaque_vector) {
    print fmt("[Zeek_X509] ocsp_response_bytes(f = <%s>, status = <%s>, version = <%s>, responderId = <%s>, producedAt = <%s>, signatureAlgorithm = <%s>, certs = <%s>)", f, status, version, responderId, producedAt, signatureAlgorithm, certs);
    print "";
    print "";
}

event ocsp_response_certificate(f: fa_file, hashAlgorithm: string, issuerNameHash: string, issuerKeyHash: string, serialNumber: string, certStatus: string, revokeTime: time, revokeReason: string, thisUpdate: time, nextUpdate: time) {
    print fmt("[Zeek_X509] ocsp_response_certificate(f = <%s>, hashAlgorithm = <%s>, issuerNameHash = <%s>, issuerKeyHash = <%s>, serialNumber = <%s>, certStatus = <%s>, revokeTime = <%s>, revokeReason = <%s>, thisUpdate = <%s>, nextUpdate = <%s>)", f, hashAlgorithm, issuerNameHash, issuerKeyHash, serialNumber, certStatus, revokeTime, revokeReason, thisUpdate, nextUpdate);
    print "";
    print "";
}

event ocsp_extension(f: fa_file, ext: X509::Extension, global_resp: bool) {
    print fmt("[Zeek_X509] ocsp_extension(f = <%s>, ext = <%s>, global_resp = <%s>)", f, ext, global_resp);
    print "";
    print "";
}

event xmpp_starttls(c: connection) {
    print fmt("[Zeek_XMPP] xmpp_starttls()");
    print "";
    print "";
}
