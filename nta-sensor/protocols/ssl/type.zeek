@load ../utils

module SSL;

export {
    type PublicKey: record {
        raw:        string &optional &log;
        key_type:   string &optional &log;
		key_length: count &optional &log;
		curve:      string &optional &log;

        # rsa
        n:          string &log &optional; # module
        e:          string &log &optional; # exponent

        # ecdsa
        x:          string &log &optional;
        y:          string &log &optional;
    };

    type Certificate: record {
        id:                         string  &log &optional;     # 编号
        is_orig:                    bool    &log &optional;     # 是否是客户端证书
        trans_flag:                 bool    &log &optional;     # 是否传输过
        thumb_print:                string  &log &optional;     # sha1 指纹
        version:                    int     &log &optional;     # 证书版本号
        len:                        int     &log &optional;     # 证书长度
        serial_number:              string  &log &optional;     # 证书序列号
        serial_number_len:          int     &log &optional;     # 证书序列号长度
        time_start:                 time    &log &optional;     # 证书有效期开始时间
        time_stop:                  time    &log &optional;     # 证书有效期结束时间
        period:                     double  &log &optional;     # 证书有效期
        self_signed:                bool    &log &optional;    # 自签名
        level:                      string  &log &optional;     # 证书等级
        sig_nid:                    string  &log &optional;     # 签名算法 NID
        sig_key_size:               int     &log &optional;     # 签名算法 key size 原始值
        pk_nid:                     string  &log &optional;     # 公钥算法 nid
        pk_keysize:                 int     &log &optional;     # 证书公钥算法 nid
        cn_wildcard:                bool    &log &optional;     # 使用者 common name 有无通配符
        san_wildcard:               bool    &log &optional;     # san 是否包含通配符
        subject_nid:                string  &log &optional;     # 使用者项列表
        subject_common_name:        string  &log &optional;     # 使用者 common name
        subject_country_name:       string  &log &optional;     # 使用者国家
        subject_org_name:           string  &log &optional;     # 使用者组织
        subject_orgunit_name:       string  &log &optional;     # 使用者组织unit
        subject_state_name:         string  &log &optional;     # 使用者 state 或 province
        subject_local_name:         string  &log &optional;     # 使用者 locality
        issuer_nid:                 string  &log &optional;     # 颁发者列表
        issuer_common_name:         string  &log &optional;     # 颁发者 common name
        issuer_country_name:        string  &log &optional;     # 颁发者 country
        issuer_org_name:            string  &log &optional;     # 颁发者组织
        issuer_org_orgunit_name:    string  &log &optional;     # 颁发者组织 unit
        issuer_state_name:          string  &log &optional;     # 把拿着 state 或 province
        issuer_local_name:          string  &log &optional;     # 颁发者 locality
        extensions_len:             int     &log &optional;     # 扩展长度
        extensions_nid:             string  &log &optional;     # 扩展项列表
        num_sans:                   int     &log &optional;     # san 数量
        sans:                       vector of string &log &optional; # san 列表
        is_ca:                      bool    &log &optional;     # 是否为 ca
        content:                    string  &log &optional;     # 证书内容
        public_key:                SSL::PublicKey &optional;   # public key
        cert_usage:                 string  &log &optional;     # 证书用途，例如国密：加密 or 签名
    };

    # type IdName: record {
    #     id:     count   &log    &default=0;
    #     name:   string  &log    &default="";
    # };

    # type KeyValue: record {
    #     key:    IdName  &log    &default=IdName();
    #     value:  any             &default = "";
    # };

    type HashSignature: record {
        hash: utils::KV &default=utils::KV();
        signature: utils::KV &default=utils::KV();
    };

    type SSLValidity: record {
        established: bool   &default=F;     # SSL 连接是否成功建立

        # 参考：https://www.openssl.org/docs/man1.1.1/man1/verify.html
        cert_available:         bool   &default=F;     # 证书是否为明文，是否可提取
        has_valid_chain:        bool   &default=F;     # 是否有有效的证书链
        cert_validation_code:   int    &default=0;     # OpenSSL 的 verify(1) 状态码
        cert_validation_status: string &default="";    # 若 cert_validation_code 非 0，那么这里写原因
    };

    type GuoMiValidityResult: record {
        from:         int     &default=0;      # 被验签的证书，序号与 server_certs/client_certs 下标对应
        to:           int     &default=0;      # 签名所使用的公钥所在的证书，即 from 的上一级证书的序号；有可能为 -1，表示根证书
        status:       int     &default=10000;  # 验证结果，参照 GuoMiVerify_ 开头的常数
        from_subject: string  &optional;       # from 证书的 subject nid
        from_issuer:  string  &optional;       # from 证书的 issuer nid
        to_subject:   string  &optional;       # to 证书的 subject nid
    };

    type Meta: record {
        src_hello:            bool                &log    &default=F;
        dst_hello:            bool                &log    &default=F;
        src_version:          count               &log    &default=0;
        src_record_version:   count               &log    &default=0;
        src_hello_random:   string  &log    &default="";
        src_hello_session_id:   string  &log    &default="";
        src_ciphers:          vector of utils::KV         &default=vector();
        src_compressions:     vector of utils::KV         &default=vector();
        dst_version:          count                       &default=0;
        dst_record_version:   count               &log    &default=0;
        dst_hello_random:   string  &log    &default="";
        dst_hello_session_id:   string  &log    &default="";
        dst_cipher:           utils::KV                   &default=utils::KV();
        dst_compression:      utils::KV                   &default=utils::KV();
        client_certs:              vector of Certificate       &default=vector();
        server_certs:              vector of Certificate       &default=vector();
        src_extensions:       vector of utils::KV         &default=vector();
        dst_extensions:       vector of utils::KV         &default=vector();
        server_names:         set[string]          &default=set();
        inner_protocols:     set[string]    &default=set();

        # 支持的哈希、签名算法
        src_hash_signature:       vector of HashSignature    &default=vector();
        dst_hash_signature:  vector of HashSignature    &default=vector();
        hash_signature: HashSignature &default=HashSignature();

        # 支持的版本
        src_support_versions: set[count] &default=set();
        dst_support_versions: set[count] &default=set();

        # 握手消息
        handshake: vector of utils::KV    &default=vector();
        
        # 时间序列
        plaintext_payloads:  vector of utils::Payload &default=vector();
        encrypted_payloads: vector of utils::Payload    &default=vector();

        # 密钥交换曲线参数
        dh_params: utils::KV &default=utils::KV();
        src_dh_params: string &default="";
        dst_dh_params: string &default="";

        # 密钥交换
        src_key_share: vector of utils::KV &default=vector();
        dst_key_share: vector of utils::KV &default=vector();

        # 告警
        alerts: vector of utils::Payload &default=vector();

        # 证书合规性检测相关
        validity:             SSLValidity                    &default=SSLValidity();
        guomi_verify_result:  vector of GuoMiValidityResult  &default=vector();

        # 证书请求
        cert_request:         vector of string               &default=vector();
    };
}