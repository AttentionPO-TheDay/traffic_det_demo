# 补全 HTTP 的缺失头部

@load base/protocols/ssl/main
@load policy/protocols/ssl/validate-certs
@load ./asn1
@load ./ssl

module SSL;

redef SSL::ssl_store_valid_chain = T;


export {
    # 为 X509::Certificate 添加 content 字段
    redef record X509::Certificate += {
        is_orig:                    bool &log &optional;
        content:                    string &log &optional;
        pk:                         string &log &optional;
        pk_exponent:                count  &log &optional;
    };
    const with_certificate_content = T &redef;
    const with_certificate_pk = T &redef;    

    # 解析颁发者、使用者信息
    const subject_keys: set[string] = { "CN", "O", "OU", "L", "ST", "S", "C", "SERIALNUMBER" };
}

function parse_subject_string(s: string): table[string] of string {
    local subject: table[string] of string;

    # 使用中文逗号作为转义字符，避免原本字符串内本身就有用于分割的字符
    s = gsub(s, /\\,/, "\xef\xbc\x8c");
    local subject_list = split_string(s, /,/);
    
    for (i in subject_list) {
        local item = gsub(subject_list[i], /\xef\xbc\x8c/, ",");
        item = gsub(subject_list[i], /\\=/, "\xef\xbc\x8c");
        
        local kv = split_string(item, /=/);
        local key = sub(kv[0], /\xef\xbc\x8c/, "=");
        local value = sub(kv[1], /\xef\xbc\x8c/, "=");
        subject[key] = value;
    }

    # 补全需要用到，但是缺失的其他部分
    for (k in subject_keys) {
        if (k !in subject) {
            subject[k] = "";
        }
    }
    return subject;
}

export {
    function fill_cert(ssl_cert: Files::Info): SSL::Certificate {
        local subject = parse_subject_string(ssl_cert$x509$certificate$subject);
        local issuer = parse_subject_string(ssl_cert$x509$certificate$issuer);

        local level = "DV";
        if (|subject["O"]| > 0) {
            level = "OV";
        }
        if (|subject["SERIALNUMBER"]| > 0) {
            level = "EV";
        }
        
        local _cert = Certificate(
            $id = ssl_cert$fuid,
            $trans_flag = F,
            $version = ssl_cert$x509$certificate$version,
            $len = ssl_cert$seen_bytes,
            $serial_number = ssl_cert$x509$certificate$serial,
            $serial_number_len = |ssl_cert$x509$certificate$serial|,
            $time_start = ssl_cert$x509$certificate$not_valid_before,
            $time_stop = ssl_cert$x509$certificate$not_valid_after,
            $period = time_to_double(ssl_cert$x509$certificate$not_valid_after) - time_to_double(ssl_cert$x509$certificate$not_valid_before),
            $level = level,
            $sig_nid = ssl_cert$x509$certificate$sig_alg,
            $sig_key_size = 0,
            $pk_nid = ssl_cert$x509$certificate$key_alg,
            $cn_wildcard = "*" in ssl_cert$x509$certificate$cn,
            $subject_nid = ssl_cert$x509$certificate$subject,
            $subject_common_name = subject["CN"],
            $subject_country_name = subject["C"],
            $subject_org_name = subject["O"],
            $subject_orgunit_name = subject["OU"],
            $subject_state_name = subject["ST"],
            $subject_local_name = subject["L"],
            $issuer_nid = ssl_cert$x509$certificate$issuer,
            $issuer_common_name = issuer["CN"],
            $issuer_country_name = issuer["C"],
            $issuer_org_name = issuer["O"],
            $issuer_org_orgunit_name = issuer["OU"],
            $issuer_state_name = issuer["ST"],
            $issuer_local_name = issuer["L"],
            $extensions_len = |ssl_cert$x509$extensions|,
            $extensions_nid = "",
            $is_orig = ssl_cert$is_orig,
            $public_key = SSL::PublicKey()
        );

        if (ssl_cert$x509$certificate?$key_length) {            
            _cert$pk_keysize = ssl_cert$x509$certificate$key_length;
        }

        if (ssl_cert$x509?$basic_constraints) {
            _cert$is_ca = ssl_cert$x509$basic_constraints$ca;
        }
        if (ssl_cert$x509$certificate?$content) {
            _cert$content = encode_base64(ssl_cert$x509$certificate$content);
        }
        # if (ssl_cert$x509$certificate?$pk) {
        #     cert$pk = encode_base64(ssl_cert$x509$certificate$pk);
        #     cert$pk_exponent = ssl_cert$x509$certificate$pk_exponent;
        # }

        # 读入加密参数
        if (ssl_cert$x509$certificate?$key_type && ssl_cert$x509$certificate?$key_length) {
            _cert$public_key$key_type = ssl_cert$x509$certificate$key_type;
            _cert$public_key$key_length = ssl_cert$x509$certificate$key_length;
            _cert$public_key$raw = encode_base64(ssl_cert$x509$certificate$raw_pkey);
            
            if (ssl_cert$x509$certificate$key_type == "rsa") {
                # RSA 算法
                if (ssl_cert$x509$certificate?$exponent) {
                    _cert$public_key$e = encode_base64(ssl_cert$x509$certificate$exponent);
                }
                if (ssl_cert$x509$certificate?$modulus) {
                    _cert$public_key$n = encode_base64(ssl_cert$x509$certificate$modulus);
                }
            }
            if (ssl_cert$x509$certificate$key_type == "ecdsa") {
                # ECDSA 算法（国密 SM2 属于 ecdsa）
                if (ssl_cert$x509$certificate?$curve) {
                    _cert$public_key$curve = ssl_cert$x509$certificate$curve;
                }
                if (ssl_cert$x509$certificate?$x) {
                    _cert$public_key$x = encode_base64(ssl_cert$x509$certificate$x);
                }
                if (ssl_cert$x509$certificate?$y) {
                    _cert$public_key$y = encode_base64(ssl_cert$x509$certificate$y);
                }
            }
        }
        
        return _cert;
    }
}

function verify_cert_chain_guomi(guomi_chain: vector of X509::Certificate, ignore_first: bool): vector of GuoMiValidityResult {
    # print fmt("!!DEBUG-PRINT!! [verify_cert_chain_guomi] guomi_chain = %s, ignore_first = %s", guomi_chain, ignore_first);

    local guomi_verify_result: vector of GuoMiValidityResult = vector();
    local min_cert_num = 1;
    if (ignore_first) {
        min_cert_num = 2;
    }

    if (|guomi_chain| < min_cert_num) {
        print "";
        print fmt("!!DEBUG-PRINT!! [verify_cert_chain_guomi] Stop verify because |guomi_chain| = %d < %d", |guomi_chain|, min_cert_num);
        print "";
        
        return guomi_verify_result;
    }

    local the_first_cert = guomi_chain[0];
    if (ignore_first) {
        the_first_cert = guomi_chain[1];
    }

    if (!is_cert_correct_and_sm2_signed(the_first_cert$content)) {
        print "";
        print fmt("!!DEBUG-PRINT!! [verify_cert_chain_guomi] Stop verify because guomi_chain #%d is not correct or not sm2 signed", min_cert_num);
        print "";            

        return guomi_verify_result;
    }

    local now = network_time();
    
    if (time_to_double(now) < 10000000) {
        now = current_time();        
    }

    local cert_index = 0;
    if (ignore_first) {
        cert_index = 1;
    }
    local end: int = |guomi_chain|;
    end -= 2;

    local verifyResult: int;
    local result_record: GuoMiValidityResult;

    while (cert_index <= end) {
        print fmt("!!DEBUG-PRINT!! cert_index = %d, end = %d", cert_index, end);
        local currCert = guomi_chain[cert_index];
        local upperCert = guomi_chain[cert_index + 1];

        if (currCert$issuer == currCert$subject) {
            verifyResult = GuoMiVerify_SELF_SIGNED;
        } else {
            if (currCert$issuer != upperCert$subject) {
                verifyResult = GuoMiVerify_CERT_NOT_CHAINED;
            } else {
                verifyResult = x509_verify_with_gmssl(currCert$content, upperCert$content, now);
            }
        }

        result_record = GuoMiValidityResult(
            $from = cert_index,
            $to = cert_index + 1,
            $status = verifyResult,
            $from_subject = currCert$subject,
            $from_issuer = currCert$issuer,
            $to_subject = upperCert$subject
        );
        guomi_verify_result += result_record;

        ++cert_index;
    }

    local lastCert = guomi_chain[|guomi_chain| - 1];
    result_record = GuoMiValidityResult(
        $from = |guomi_chain| - 1,
        $to = -1,
        $status = 10000,
        $from_subject = lastCert$subject,
        $from_issuer = lastCert$issuer
    );

    if (lastCert$issuer == lastCert$subject) {
        if (lastCert$subject in root_certs) {
            result_record$status = GuoMiVerify_IS_TRUSTED_CA;
        } else {
            result_record$status = GuoMiVerify_SELF_SIGNED;
        }
    } else {
        if (lastCert$issuer in root_certs) {
            local root_ca = root_certs[lastCert$issuer];
            result_record$status = x509_verify_with_gmssl(lastCert$content, root_ca, now);
            result_record$to_subject = lastCert$issuer;
        } else {
            result_record$status = GuoMiVerify_CA_NOT_FOUND;
        }
    }
    
    guomi_verify_result += result_record;

    return guomi_verify_result;
}

export {
    function verify_cert_chain_guomi_exported(
        guomi_chain_contains_sm2_certs: vector of X509::Certificate,
        ignore_first_cert_because_it_is_sig_cert: bool
    ): vector of GuoMiValidityResult {
        return verify_cert_chain_guomi(guomi_chain_contains_sm2_certs, ignore_first_cert_because_it_is_sig_cert);
    }
}

# 证书内容补全
event x509_certificate(f: fa_file, cert_ref: opaque of x509, cert: X509::Certificate) {
    local content = "";

    # 补全证书方向
    cert$is_orig = f$is_orig;

    if (with_certificate_content) {
        content = x509_get_certificate_string(cert_ref);
    }
   
    if (with_certificate_content) {
        cert$content = content;
    }

    # 解析代码移至 Zeek 内
    # if (with_certificate_pk) {
    #     local public_key = parse_public_key(content);
    #     cert$pk = public_key$pk;
    #     cert$pk_exponent = public_key$exponent;
    # }
}

function resolve_certs(c: connection, is_client_certs: bool, chains: vector of Files::Info, valid: bool) {
    local meta = init_ssl_meta(c);

    for ( i in chains) {
        local ssl_cert = chains[i];

        local san_len = 0;
        local san_with_wildcard = F;
        local sans : vector of string = vector();

        if (ssl_cert$x509?$san) {
            local san = ssl_cert$x509$san;

            if (san?$dns) for (s in san$dns) sans += san$dns[s];
            if (san?$uri) for (s in san$uri) sans += san$uri[s];
            if (san?$email) for (s in san$email) sans += san$email[s];
            if (san?$ip) for (s in san$ip) sans += fmt("%s", san$ip[s]);

            san_len = |sans|;

            for (san_i in sans) {
                if ("*" in cat(sans[san_i])) {
                    san_with_wildcard = T;
                    break;
                }
            }
        }

        local cert = fill_cert(ssl_cert);
        cert$self_signed = valid;
        cert$thumb_print = ssl_cert$sha1;
        cert$sans = sans;
        cert$num_sans = san_len;        
        cert$san_wildcard = san_with_wildcard;

        if (is_client_certs) {
            meta$client_certs += cert;
        } else {
            meta$server_certs += cert;
        }
        
    }
}

event ssl_established(c: connection) {
    local meta = init_ssl_meta(c);
    
    # -------- 证书合规性相关 -------

    # 记录 SSL 连接是否真的建立了
    meta$validity$established = T;

    if (c?$ssl && c$ssl?$cert_chain) {
        # 往元数据中输出证书链
        local chains = c$ssl$cert_chain;

        # 记录是否有证书链
        meta$validity$cert_available = T;

        local valid = c$ssl?$valid_chain && |c$ssl$valid_chain| > 0;

        if (valid) {
            # 如果有合法的证书链，且长度 > 0，就把元数据「cert_available」标记为 true
            meta$validity$has_valid_chain = T;
        }

        resolve_certs(c, F, c$ssl$cert_chain, valid);
        resolve_certs(c, T, c$ssl$client_cert_chain, valid);

        # 照抄 Zeek 自带的 cert_validation_code 到元数据中
        if (c$ssl?$validation_code) {
            meta$validity$cert_validation_code = c$ssl$validation_code;
        }
        if (c$ssl?$validation_status) {
            meta$validity$cert_validation_status = c$ssl$validation_status;
        }

        # 如果服务端用的是国密，就走国密验证流程
        if (meta$dst_version == 257) {
            # 提取出 X509::Certificate 信息
            local pure_chain: vector of X509::Certificate = vector();
            for (val in c$ssl$cert_chain) {
                pure_chain += c$ssl$cert_chain[val]$x509$certificate;
            }

            # 参数：忽略第 0 个证书，因为 SSL 里第 0 个证书是不需要验证的签名证书
            meta$guomi_verify_result = verify_cert_chain_guomi(pure_chain, T);
        }
    }
}