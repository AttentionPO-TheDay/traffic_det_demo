@load ../type

module SSH;

# event ssh_auth_result(c: connection, result: bool, auth_attempts: count) {
#     if (!c$meta?$ssh) {
#         c$meta$ssh = SSH::Meta();
#     }
#     c$meta$ssh$result = result;
#     c$meta$ssh$auth_attempts = auth_attempts;
# }

event connection_state_remove(c: connection) {
    if (!c$meta?$ssh && c?$ssh) {
        c$meta$ssh = SSH::Meta();
    }

    if (c?$ssh) {
        local ssh = c$ssh;

        c$meta$ssh$version=ssh$version;
        c$meta$ssh$success=ssh$auth_success;
        c$meta$ssh$attempts=ssh$auth_attempts;
        c$meta$ssh$client=ssh$client;
        c$meta$ssh$server=ssh$server;
        c$meta$ssh$cipher_algorithm=ssh$cipher_alg;
        c$meta$ssh$mac_algorithm=ssh$mac_alg;
        c$meta$ssh$compression_algorithm=ssh$compression_alg;
        c$meta$ssh$key_exchange_algorithm=ssh$kex_alg;
        c$meta$ssh$host_key_algorithm=ssh$host_key_alg;
        c$meta$ssh$host_key=ssh$host_key;
        c$meta$ssh$support_key_exchange_algorithms=ssh$capabilities$kex_algorithms;
        c$meta$ssh$support_host_key_algorithms=ssh$capabilities$server_host_key_algorithms;
        c$meta$ssh$support_client_encryption_algorithms=ssh$capabilities$encryption_algorithms$client_to_server;
        c$meta$ssh$support_server_encryption_algorithms=ssh$capabilities$encryption_algorithms$server_to_client;
        c$meta$ssh$support_client_mac_algorithms=ssh$capabilities$mac_algorithms$client_to_server;
        c$meta$ssh$support_server_mac_algorithms=ssh$capabilities$mac_algorithms$server_to_client;
        c$meta$ssh$support_client_mac_algorithms=ssh$capabilities$compression_algorithms$client_to_server;
        c$meta$ssh$support_server_mac_algorithms=ssh$capabilities$compression_algorithms$server_to_client;
    }
}

event ssh_encrypted_packet(c: connection, orig: bool, len: count) {
    if (!c$meta?$ssh) {
        c$meta$ssh = SSH::Meta();
    }

    if (orig) {
        c$meta$ssh$client_byte += len;
        c$meta$ssh$client_packet += 1;
    } else {
        c$meta$ssh$server_byte += len;
        c$meta$ssh$server_packet += 1;
    }
}

# event ssh2_dh_server_params(c: connection, p: string, q: string) {
#     print "ssh2_dh_server_params", p, q;
# }

# event ssh2_gss_error(c: connection, major_status: count, minor_status: count, err_msg: string) {
#     print "ssh2_gss_error", major_status, minor_status, err_msg;
# }

event ssh2_ecc_key(c: connection, is_orig: bool, q: string) {
    if (!c$meta?$ssh) {
        c$meta$ssh = SSH::Meta();
    }
    if (is_orig) {
        c$meta$ssh$client_ecc_key = encode_base64(q);
    } else {
        c$meta$ssh$server_ecc_key = encode_base64(q);
    }
}