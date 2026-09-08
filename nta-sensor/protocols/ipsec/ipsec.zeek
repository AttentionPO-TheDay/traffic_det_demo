@load ../utils
@load base/frameworks/files
@load base/protocols/ssl/main
@load ../../output/log
@load ../ip
@load ./consts
@load ../ssl

@load IPSEC/ipsec

module IPSEC;

export {
    const with_payload = T &redef;

    type IpsecExtraInfo: record {
        # 国密 IPSec 中用于加密的证书，其中由服务端发送的
        dst_enc_certs:   vector of X509::Certificate &default=vector();
    };

    redef record connection += {
        ipsec_extra: IpsecExtraInfo &log &optional;
    };
}

function init_ipsec_meta(c: connection): IPSEC::Meta {
    Protocols::init_protocol_meta(c);
    if (!c$meta?$ipsec) {
        c$meta$ipsec = IPSEC::Meta();
    }
    if (!c?$ipsec_extra) {
        c$ipsec_extra = IpsecExtraInfo();
    }
    return c$meta$ipsec;
}

function init_ipsec_message(c: connection, message_id: count): IPSEC::ISAKMP {
    local meta = init_ipsec_meta(c);
    if (!meta?$isakmp) {
        meta$isakmp = table();
    }
    if (message_id !in meta$isakmp) {
        meta$isakmp[message_id] = IPSEC::ISAKMP();
    }
    return meta$isakmp[message_id];
}


# function get_vendor_name(vendor_id: string):string {
#     local vendor_id_friendly_name = fmt("UNKNOWN:%s", bytestring_to_hexstr(vendor_id));

#     for (i in IPSEC::vendor_ids) {
#         if(IPSEC::vendor_ids[i] in bytestring_to_hexstr(vendor_id)) {
#             vendor_id_friendly_name = i;
#             break;
#         }
#     }

#     return vendor_id_friendly_name;
# }


event IPSEC::ike_message(c: connection, is_orig: bool, msg: IPSEC::IKEMsg) {
    local m = init_ipsec_message(c, msg$message_id);

    if (!m$has_major_info) {
        # 把第一条 ISAKMP 握手信息写到元数据里

        m$has_major_info = T;
        
        m$id = msg$message_id;

        if (is_orig) {
            m$init_spi = encode_base64(msg$initiator_spi);
            m$resp_spi = encode_base64(msg$responder_spi);
        } else {
            m$init_spi = encode_base64(msg$responder_spi);
            m$resp_spi = encode_base64(msg$initiator_spi);
        }
        
        m$maj_version = msg$maj_ver;
        m$min_version = msg$min_ver;
        m$length = msg$length;

        if (is_orig) {
            m$src_key_exchange_dh = utils::KV(
                $id     = msg$exchange_type,
                $name   = IPSEC::exchange_type[msg$exchange_type]
            );
        } else {
            m$dst_key_exchange_dh = utils::KV(
                $id     = msg$exchange_type,
                $name   = IPSEC::exchange_type[msg$exchange_type]
            );
        }

        m$flag_encryption = msg$flag_e;
        m$flag_commit = msg$flag_c;
        m$flag_authentication = msg$flag_a;
        m$flag_i = msg$flag_i;
        m$flag_v = msg$flag_v;
        m$flag_r = msg$flag_r;
    }

    if (with_payload) {
        local m_ipsec = init_ipsec_meta(c);

        m_ipsec$payloads += utils::Payload(
            $timestamp=network_time(),
            $is_orig=is_orig,
            $type_name=fmt("IKEv%d", msg$maj_ver),
            $length=msg$length
        );
    }
}


event IPSEC::esp_message(c: connection, is_orig: bool, msg: IPSEC::ESPMsg){
    if (with_payload) {
        local m_ipsec = init_ipsec_meta(c);

        m_ipsec$payloads += utils::Payload(
            $timestamp=network_time(),
            $is_orig=is_orig,
            $type_name="ESP",
            $length=msg$payload_len
        );
    }
}


# event IPSEC::esp_message_over_ip(p: raw_pkt_hdr, spi: count, seq: count, payload_len: count){
    # local esp = IPSEC::ESP(
    #     $timestamp=network_time(),
    #     $spi=spi,
    #     $seq=seq,
    #     $len=payload_len,
    #     $l2_encap=fmt("%s", p$l2$encap),
    #     $l2_src=p$l2$src,
    #     $l2_dst=p$l2$dst,
    #     $l2_eth_type=p$l2$eth_type,
    #     $l2_proto=fmt("%s", p$l2$proto)
    # );
    # local ipsec = IPSEC::Meta(
    #     $esp=esp
    # );
    # local meta = Protocols::Meta(
    #     $ip=IP::Meta(
    #         $src=p$ip$src,
    #         $dst=p$ip$dst
    #     ),
    #     $ipsec=ipsec
    # );
    # Sensor::output(meta);
# }


event IPSEC::ikev2_sa_proposal(c: connection, is_orig: bool, msg: IPSEC::IKE_SA_Proposal_Msg) {}

event IPSEC::ikev2_sa_transform(c: connection, is_orig: bool, msg: IPSEC::IKE_SA_Transform_Msg) {}

event IPSEC::ike_data_attribute(c: connection, is_orig: bool, msg: IPSEC::IKE_SA_Transform_Attribute_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    local attr_vec = m$src_attributes;
    if (!is_orig) {
        attr_vec = m$dst_attributes;
    }

    attr_vec += IPSEC::Attribute(
        $attr   =   utils::KV(
            $id         =   msg$attribute_type,
            $name       =   IPSEC::attribute_types[msg$attribute_type],
            $value      =   bytestring_to_count(msg$attribute_val)
        ),
        $auto_format    =   msg$AF
    );
}

event ipsec::ikev2_ke_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_KE_Msg){
}

event IPSEC::ikev2_idi_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_ID_Msg){
}

event IPSEC::ikev2_idr_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_ID_Msg){
}

function add_cert_to_meta(c: connection, is_orig: bool, msg: IPSEC::IKE_CERT_Msg) {
    # 实际上只有当连接是国密的时候才会触发这个函数

    local m = init_ipsec_message(c, msg$message_id);
    
    local cert_vec = m$src_certs;    
    if (!is_orig) {
        cert_vec = m$dst_certs;
    }

    local cert_op = x509_from_der(msg$cert_data);
    local cert = x509_parse(cert_op);
    cert$content = x509_get_certificate_string(cert_op);

    # 把证书添加到元信息中
    local sensor_cert = SSL::fill_cert(Files::Info(
        $ts = network_time(),
        $fuid = "",
        $is_orig = is_orig,
        $x509 = X509::Info(
            $ts = network_time(),
            $id = "",
            $certificate = cert,
            $handle = cert_op
        )
    ));
    sensor_cert$cert_usage = CERT_USAGE[msg$cert_encoding];

    if (SSL::with_certificate_content) {
        sensor_cert$content = encode_base64(msg$cert_data);
    }

    cert_vec += sensor_cert;

    # 储存服务器发送的国密加密证书
    if (msg$cert_encoding == CERT_USAGE_ENC && !is_orig) {
        c$ipsec_extra$dst_enc_certs += cert;
    }
}

event IPSEC::ikev2_cert_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_CERT_Msg){
    add_cert_to_meta(c, is_orig, msg);
}

event IPSEC::ikev2_certreq_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_CERTREQ_Msg){
}

event IPSEC::ikev2_auth_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_AUTH_Msg){
}

event IPSEC::ikev2_nonce_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_NONCE_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$nonce_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$nonce_data|,
        $payload = encode_base64(msg$nonce_data)
    );
}

event IPSEC::ikev2_notify_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_NOTIFY_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$notify_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length = |msg$notification_data|,
        $optional = encode_base64(msg$spi),             # spi
        $payload = encode_base64(msg$notification_data)
    );
}

event IPSEC::ikev2_delete_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_DELETE_Msg){
}

event IPSEC::ikev2_vendorid_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_VENDORID_Msg){
    # local m = init_ipsec_message(c, msg$message_id);
    # local sa_vec = m$src_vendors;
    # if (!is_orig) {
    #     sa_vec = m$dst_vendors;
    # }

    # sa_vec += utils::KV(
    #     $id     = encode_base64(msg$vendor_id),
    #     $name   = get_vendor_name(msg$vendor_id)
    # );
}

event IPSEC::ikev2_trafficselector_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_TRAFFICSELECTOR_Msg){
}

event IPSEC::ikev2_encrypted_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_ENCRYPTED_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    local p = utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$payload|
    );
    # if (with_payload) {
    #     p$payload = encode_base64(msg$payload);
    # }
    m$encrypted += p;
}

event IPSEC::ikev2_configuration_attribute(c: connection, is_orig: bool, msg: IPSEC::IKE_CONFIG_ATTR_Msg){
}

event IPSEC::ikev2_eap_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_EAP_Msg){
}

event IPSEC::ikev1_sa_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_SA_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    local sa_vec = m$src_sa;
    if (!is_orig) {
        sa_vec = m$dst_sa;
    }

    sa_vec += IPSEC::SA(
        $doi = msg$doi,
        $situation = encode_base64(msg$situation)
    );
}

event IPSEC::ikev1_vid_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_VENDORID_Msg){
    # local m = init_ipsec_message(c, msg$message_id);
    # local sa_vec = m$src_vendors;
    # if (!is_orig) {
    #     sa_vec = m$dst_vendors;
    # }

    # sa_vec += utils::KV(
    #     $id     = encode_base64(msg$vendor_id),
    #     $name   = get_vendor_name(msg$vendor_id)
    # );
}

event IPSEC::ikev1_ke_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_KE_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$key_exchange_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$key_exchange_data|,
        $payload = encode_base64(msg$key_exchange_data)
    );
}

event IPSEC::ikev1_nonce_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_NONCE_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$nonce_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$nonce_data|,
        $payload = encode_base64(msg$nonce_data)
    );
}

event IPSEC::ikev1_cert_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_CERT_Msg){
    add_cert_to_meta(c, is_orig, msg);
}

event IPSEC::ikev1_certreq_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_CERTREQ_Msg){
}

event IPSEC::ikev1_id_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_ID_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$id_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$identification_data|,
        $payload = encode_base64(msg$identification_data)
    );
}

event IPSEC::ikev1_hash_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_HASH_Msg){
}

event IPSEC::ikev1_sig_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_SIG_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$sig_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$sig_data|,
        $payload = encode_base64(msg$sig_data)
    );
}

event IPSEC::ikev1_p_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_P_Msg) {}

event IPSEC::ikev1_t_payload(c: connection, is_orig: bool, msg: IPSEC::IKEv1_T_Msg) {}

event IPSEC::ikev1_notify_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_NOTIFY_Msg){
    local m = init_ipsec_message(c, msg$message_id);
    m$notify_payload += utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length = |msg$notification_data|,
        $optional = encode_base64(msg$spi),             # spi
        $payload = encode_base64(msg$notification_data)
    );
}

event IPSEC::ikev1_delete_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_DELETE_Msg){
}

event IPSEC::ikev1_encrypted_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_ENCRYPTED_Msg) {
    local m = init_ipsec_message(c, msg$message_id);
    local p = utils::Payload(
        $timestamp = network_time(),
        $is_orig = is_orig,
        $length=|msg$payload|
    );
    # if (with_payload) {
    #     p$payload = encode_base64(msg$payload);
    # }
    # m$encrypted += p;
}

event IPSEC::ike_unknown_payload(c: connection, is_orig: bool, msg: IPSEC::IKE_Unknown_Msg) {
    local m = init_ipsec_message(c, msg$message_id);

    if (msg$payload_type == 128) {
        # private use
        m$private_payload += utils::Payload(
            $timestamp = network_time(),
            $is_orig = is_orig,
            $type_id = msg$payload_type,
            $type_name = "Private Use",
            $payload = encode_base64(msg$payload)
        );
    } else if (msg$payload_type == 20) {
        m$nat_d_payload += utils::Payload(
            $timestamp = network_time(),
            $is_orig = is_orig,
            $type_id = msg$payload_type,
            $type_name = "NAT-D",
            $payload = encode_base64(msg$payload)
        );
    } else {
        m$unknown_payload += utils::Payload(
            $timestamp = network_time(),
            $is_orig = is_orig,
            $type_id = msg$payload_type,
            $type_name = "UNKNOWN",
            $payload = encode_base64(msg$payload)
        );
    }
}

event connection_state_remove(c: connection) &priority=10 {
    # 检查是否为 IPSec 连接
    if (!c?$ipsec_extra) {
        return;
    }
    local dst_enc_certs: vector of X509::Certificate = c$ipsec_extra$dst_enc_certs;

    # 检查是否有证书
    if (|dst_enc_certs| <= 0) {
        return;
    }

    # 检查是否为格式正确的、由 SM2 签名的证书
    if (!is_cert_correct_and_sm2_signed(dst_enc_certs[0]$content)) {
        return;
    }

    local verify_result = SSL::verify_cert_chain_guomi_exported(dst_enc_certs, F);
    c$meta$ipsec$guomi_verify_result = verify_result;
}
