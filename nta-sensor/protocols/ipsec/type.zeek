@load ..
@load ../utils

@load IPSEC/ipsec

module IPSEC;

export {
    type ESP: record {
        timestamp:  time    &log    &default=network_time();
        spi:        count   &log    &default=0;
        seq:        count   &log    &default=0;
        len:        count   &log    &default=0;

        l2_encap:       string  &log    &default="";
        l2_src:         string  &log    &default="";
        l2_dst:         string  &log    &default="";
        l2_eth_type:    count   &log    &default=0;
        l2_proto:       string  &log    &default="";
    };

    type SA: record {
        doi:            count       &log    &default=0;
		situation:      string      &log    &default="";
    };

    type Attribute: record {
        attr:           utils::KV   &default=utils::KV();
        auto_format:    bool        &log    &default=F;
    };

    type ISAKMP: record {
        id:                         count                                       &log    &default=0;
        has_major_info:             bool                                        &log    &default=F;
        init_spi:                   string                                      &log    &default=""; 
        resp_spi:                   string                                      &log    &default=""; 
        maj_version:                count                                       &log    &default=0; 
        min_version:                count                                       &log    &default=0; 
        length:                     count                                       &log    &default=0;
        
        sa_doi:                     count                                       &log    &default=0;
        sa_situation:               string                                      &log    &default="";
        src_key_exchange_dh:        utils::KV                                   &optional;
        dst_key_exchange_dh:        utils::KV                                   &optional;

        src_vendors:                vector of utils::KV                         &default=vector();
        dst_vendors:                vector of utils::KV                         &default=vector();

        src_attributes:             vector of Attribute                         &default=vector();
        dst_attributes:             vector of Attribute                         &default=vector();

        src_sa:                     vector of IPSEC::SA                         &default=vector();
        dst_sa:                     vector of IPSEC::SA                         &default=vector();

        src_certs:                  vector of SSL::Certificate                  &default=vector();
        dst_certs:                  vector of SSL::Certificate                  &default=vector();

        notify_payload:             vector of utils::Payload                    &default=vector();
        key_exchange_payload:       vector of utils::Payload                    &default=vector();
        nonce_payload:              vector of utils::Payload                    &default=vector();
        id_payload:                 vector of utils::Payload                    &default=vector();
        sig_payload:                vector of utils::Payload                    &default=vector();
        private_payload:            vector of utils::Payload                    &default=vector();
        nat_d_payload:              vector of utils::Payload                    &default=vector();
        encrypted:                  vector of utils::Payload                    &default=vector();
        unknown_payload:            vector of utils::Payload                    &default=vector();

        flag_encryption:            bool                                        &log &default=F;
        flag_commit:                bool                                        &log &default=F;
        flag_authentication:        bool                                        &log &default=F;
        flag_i:                     bool                                        &log &default=F;
        flag_v:                     bool                                        &log &default=F;
        flag_r:                     bool                                        &log &default=F;
    };

    type Meta: record {
        isakmp:   table[count] of ISAKMP   &optional;
        esp:      ESP                      &optional;

        # ISAKMP 和 EH 协议（基于 TCP/UDP）的内容
        payloads: vector of utils::Payload &default=vector();

        # 证书合规性检测相关
        guomi_verify_result:  vector of SSL::GuoMiValidityResult  &default=vector();
    };
}