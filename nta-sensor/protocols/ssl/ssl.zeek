@load ./type
@load ./const

module SSL;

function init_ssl_meta(c: connection):SSL::Meta {
    Protocols::init_protocol_meta(c);
    if (!c$meta?$ssl) {
        c$meta$ssl = SSL::Meta();
    }
    return c$meta$ssl;
}

event ssl_server_hello(c: connection, version: count, record_version: count, possible_ts: time, server_random: string, session_id: string, cipher: count, comp_method: count) { 
    local meta = init_ssl_meta(c);

    meta$dst_hello = T;
    meta$dst_version = version;
    meta$dst_record_version = record_version;

    meta$dst_cipher = utils::KV(
        $id=cipher, 
        $name=SSL::cipher_desc[cipher]
    );
    meta$dst_compression = utils::KV(
        $id=comp_method, 
        $name=""
    );  
}

event ssl_client_hello(c: connection, version: count, record_version: count, possible_ts: time, client_random: string, session_id: string, ciphers: index_vec, comp_methods: index_vec) {   
    local meta = init_ssl_meta(c);
    meta$src_hello = T;
    meta$src_version = version;
    meta$src_record_version = record_version;
    meta$src_hello_random = encode_base64(client_random);
    meta$src_hello_session_id = encode_base64(session_id);

    local id = 0;
    # 客户端支持的密码套件
    for (i in ciphers) {
        id = ciphers[i];
        meta$src_ciphers += utils::KV(
            $id=id, 
            $name=SSL::cipher_desc[i]
        );
    }

    # 客户端支持的压缩算法
    for (i in comp_methods) {
        id = comp_methods[i];
        meta$src_compressions += utils::KV(
            $id=id, 
            $name=""
        );
    }
}

event ssl_ecdh_server_params(c: connection, curve: count, point: string) {
    local meta = init_ssl_meta(c);
    meta$dh_params = utils::KV(
        $id=curve,
        $name=SSL::ec_curves[curve]
    );
    meta$dst_dh_params = encode_base64(point);
}

event ssl_ecdh_client_params(c: connection, point: string) {
    local meta = init_ssl_meta(c);
    meta$src_dh_params = encode_base64(point);
}

event ssl_dh_server_params(c: connection, p: string, q: string, Ys: string) {
     local meta = init_ssl_meta(c);
    meta$dh_params = utils::KV(
        $id=-1,
        $name="DH",#SSL::ec_curves[curve]
        $value=vector(encode_base64(p), encode_base64(q))
    );
    meta$dst_dh_params = encode_base64(Ys);
}

event ssl_dh_client_params(c: connection, Yc: string) {
    local meta = init_ssl_meta(c);
    meta$src_dh_params = encode_base64(Yc);
}


event ssl_alert(c: connection, is_orig: bool, level: count, desc: count) {
    local meta = init_ssl_meta(c);
    meta$alerts += utils::Payload(
        $timestamp=network_time(),
        $is_orig=is_orig,
        $type_id=desc,
        $type_name=alert_descriptions[desc],
        $optional=level
    );
}

event ssl_encrypted_data(c: connection, is_orig: bool, record_version: count, content_type: count, length: count) {
    local meta = init_ssl_meta(c);
    meta$encrypted_payloads += utils::Payload(
        $timestamp=network_time(),
        $length=length,
        $is_orig=is_orig,
        $type_id=content_type,
        $type_name=content_types[content_type],
        $optional=record_version
    );
}

event ssl_extension(c: connection, is_orig: bool, code: count, val: string) {
    local meta = init_ssl_meta(c);

    if (is_orig) {
        meta$src_extensions += utils::KV(
            $id=code,
            $name=SSL::extensions[code],
            $value=encode_base64(val)
        );
    } else {
        meta$dst_extensions += utils::KV(
            $id=code,
            $name=SSL::extensions[code],
            $value=encode_base64(val)
        );
    }
}

# 获取内层协议的类型，因为客户端和服务端都会解析，可能会重复，使用 set 存储
event ssl_extension_application_layer_protocol_negotiation(c: connection, is_orig: bool, protocols: string_vec) {
    local meta = init_ssl_meta(c);

    for (i in protocols) {
        add meta$inner_protocols[protocols[i]];
    }
}

event ssl_extension_esrc_point_formats(c: connection, is_orig: bool, point_formats: index_vec) {
    print "ssl_extension_esrc_point_formats", is_orig, point_formats;
}

event ssl_extension_elliptisrc_curves(c: connection, is_orig: bool, curves: index_vec) {
    print "ssl_extension_elliptisrc_curves", is_orig, curves;
}

event ssl_extension_key_share(c: connection, is_orig: bool, curves: index_vec) {
    local meta = init_ssl_meta(c);
    local ks = meta$src_key_share;
    if (!is_orig) {
        ks = meta$dst_key_share;
    }
    for (i in curves) {
        local id = curves[i];  
        ks += utils::KV(
            $id=id,
            $name=ec_curves[id]
        );
    }
}



# 获取实际请求的域名，因为客户端和服务端都会解析，可能会重复，使用 set 存储
event ssl_extension_server_name(c: connection, is_orig: bool, names: string_vec) {
    local meta = init_ssl_meta(c);

    for (i in names) {
        add meta$server_names[names[i]];
    }
}

event ssl_extension_signature_algorithm(c: connection, is_orig: bool, algorithms: signature_and_hashalgorithm_vec) {
    local meta = init_ssl_meta(c);
    
    local hs = meta$src_hash_signature;
    if (!is_orig) {
        hs = meta$dst_hash_signature;
    }

    for (i in algorithms) {
        local cur = algorithms[i];
        hs += HashSignature(
            $hash=utils::KV(
                $id=cur$HashAlgorithm,
                $name=SSL::hash_algorithms[cur$HashAlgorithm]
            ),
            $signature=utils::KV(
                $id=cur$SignatureAlgorithm,
                $name=SSL::signature_algorithms[cur$SignatureAlgorithm]
            )
        );
    }
}


event ssl_extension_supported_versions(c: connection, is_orig: bool, versions: index_vec) {
    local meta = init_ssl_meta(c);

    local sv = meta$src_support_versions;
    if (!is_orig) {
        sv = meta$dst_support_versions;
    }

    for (i in versions) {
        add sv[versions[i]];
    }
}

event ssl_handshake_message(c: connection, is_client: bool, msg_type: count, length: count) {
    local meta = init_ssl_meta(c);
    
    local handshake_info: table[string] of any = {
        ["is_client"]=is_client,
        ["length"]=length
    };

    meta$handshake += utils::KV(
        $id=msg_type,
        $name=SSL::handshake_types[msg_type],
        $value=to_json(handshake_info)
    );
}

event ssl_heartbeat(c: connection, is_orig: bool, length: count, heartbeat_type: count, payload_length: count, payload: string) {
    print "ssl_heartbeat", is_orig, length, heartbeat_type, payload_length, payload;
}

event ssl_plaintext_data(c: connection, is_orig: bool, record_version: count, content_type: count, length: count) {
    local meta = init_ssl_meta(c);
    meta$plaintext_payloads += utils::Payload(
        $timestamp=network_time(),
        $length=length,
        $is_orig=is_orig,
        $type_id=content_type,
        $type_name=content_types[content_type],
        $optional=record_version
    );
}

event ssl_server_hello(c: connection, version: count, record_version: count, possible_ts: time, server_random: string, session_id: string, cipher: count, comp_method: count) {
    local meta = init_ssl_meta(c);
    meta$dst_hello = T;
    meta$dst_version = version;
    meta$dst_record_version = record_version;
    meta$dst_hello_random = encode_base64(server_random);
    meta$dst_hello_session_id = encode_base64(session_id);

    # 服务端支持的密码套件
    meta$dst_cipher = utils::KV(
        $id=cipher, 
        $name=SSL::cipher_desc[cipher]
    );

    # 服务端支持的压缩算法
    meta$dst_compression = utils::KV(
        $id=comp_method, 
        $name=""
    );
}

event ssl_server_signature(c: connection, signature_and_hashalgorithm: SSL::SignatureAndHashAlgorithm, signature: string) {
    local meta = init_ssl_meta(c);
    meta$hash_signature = HashSignature(
        $hash=utils::KV(
            $id=signature_and_hashalgorithm$HashAlgorithm,
            $name=SSL::hash_algorithms[signature_and_hashalgorithm$HashAlgorithm]
        ),
        $signature=utils::KV(
            $id=signature_and_hashalgorithm$SignatureAlgorithm,
            $name=SSL::signature_algorithms[signature_and_hashalgorithm$SignatureAlgorithm],
            $value=encode_base64(signature)
        )
    );
}

event ssl_session_ticket_handshake(c: connection, ticket_lifetime_hint: count, ticket: string) {
    print "ssl_session_ticket_handshake", ticket_lifetime_hint, ticket;
}

event ssl_stapled_ocsp(c: connection, is_orig: bool, response: string) {
    print "ssl_stapled_ocsp", is_orig, response;
}

event ssl_certificate_request(c: connection, data: string) {
    local meta = init_ssl_meta(c);
    meta$cert_request += encode_base64(data);
}
