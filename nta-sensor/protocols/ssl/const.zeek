module SSL;

export {
    const handshake_types: table[count] of string = {
        [HELLO_REQUEST] = "HELLO_REQUEST",
        [CLIENT_HELLO] = "CLIENT_HELLO",
        [SERVER_HELLO] = "SERVER_HELLO",
        [HELLO_VERIFY_REQUEST] = "HELLO_VERIFY_REQUEST",
        [SESSION_TICKET] = "SESSION_TICKET",
        [HELLO_RETRY_REQUEST] = "HELLO_RETRY_REQUEST",
        [ENCRYPTED_EXTENSIONS] = "ENCRYPTED_EXTENSIONS",
        [CERTIFICATE] = "CERTIFICATE",
        [SERVER_KEY_EXCHANGE] = "SERVER_KEY_EXCHANGE",
        [CERTIFICATE_REQUEST] = "CERTIFICATE_REQUEST",
        [SERVER_HELLO_DONE] = "SERVER_HELLO_DONE",
        [CERTIFICATE_VERIFY] = "CERTIFICATE_VERIFY",
        [CLIENT_KEY_EXCHANGE] = "CLIENT_KEY_EXCHANGE",
        [FINISHED] = "FINISHED",
        [CERTIFICATE_URL] = "CERTIFICATE_URL",
        [CERTIFICATE_STATUS] = "CERTIFICATE_STATUS",
        [SUPPLEMENTAL_DATA] = "SUPPLEMENTAL_DATA",
        [KEY_UPDATE] = "KEY_UPDATE"
    } &default=function(i: count):string {
        return fmt("unknown-%d", i);
    };

    const content_types: table[count] of string = {
        [CHANGE_CIPHER_SPEC]="CHANGE_CIPHER_SPEC",
        [ALERT]="ALERT",
        [HANDSHAKE]="HANDSHAKE",
        [APPLICATION_DATA]="APPLICATION_DATA",
        [HEARTBEAT]="HEARTBEAT",
        [V2_ERROR]="V2_ERROR",
        [V2_CLIENT_HELLO]="V2_CLIENT_HELLO",
        [V2_CLIENT_MASTER_KEY]="V2_CLIENT_MASTER_KEY",
        [V2_SERVER_HELLO]="V2_SERVER_HELLO",
    } &default=function(i: count):string {
        return fmt("unknown-%d", i);
    };    

    # 证书链断裂，当前的 from 证书的 issuer 不等于 to 证书的 subject
    const GuoMiVerify_CERT_NOT_CHAINED = -4;

    # 最后一个证书（from）是自签名，但是是受信任的根证书（最后一个证书的 subject 能在 root_certs 里找到）
    const GuoMiVerify_IS_TRUSTED_CA = -3;

    # from 为证书链中最后一个证书，但是它的 issuer 在 root_certs 里找不到；此时 to 为 -1
    const GuoMiVerify_CA_NOT_FOUND = -2;

    # from 证书为自签名证书
    # 当 from 为最后一个证书时，表示它不受信任（subject 在 root_certs 里找不到）
    const GuoMiVerify_SELF_SIGNED = -1;

    # from 证书有效，在有效期内，非自签名，且 from 证书的签名用 to 证书的公钥验证有效
    const GuoMiVerify_OK = 0;

    # from 证书还没到有效期
    const GuoMiVerify_CERT_NOT_YET_VALID = 1;

    # from 证书已经过期
    const GuoMiVerify_CERT_EXPIRED = 2;

    # from 证书的签名用 to 证书的公钥验证无效
    const GuoMiVerify_CERT_SIGN_INVALID = 3;

    # from 证书格式非法
    const GuoMiVerify_CERT_INVALID = 4;

    # from 证书格式有效，但 to 证书格式非法
    const GuoMiVerify_CA_CERT_INVALID = 5;
}

