module SSH;

export {
    type Meta: record {
        version:                                count               &log &default=0;
        success:                                bool                &log &default=F;
        attempts:                               count               &log &default=0;
        client_packet:                          count               &log &default=0;
        client_byte:                            count               &log &default=0;
        server_packet:                          count               &log &default=0;
        server_byte:                            count               &log &default=0;
        client:                                 string              &log &default="";
        server:                                 string              &log &default="";
        cipher_algorithm:                       string              &log &default="";
        mac_algorithm:                          string              &log &default="";
        compression_algorithm:                  string              &log &default="";
        key_exchange_algorithm:                 string              &log &default="";
        host_key_algorithm:                     string              &log &default="";
        host_key:                               string              &log &default="";
        support_key_exchange_algorithms:        vector of string    &log &default=vector();
        support_host_key_algorithms:            vector of string    &log &default=vector();
        support_client_encryption_algorithms:   vector of string    &log &default=vector();
        support_server_encryption_algorithms:   vector of string    &log &default=vector();
        support_client_mac_algorithms:          vector of string    &log &default=vector();
        support_server_mac_algorithms:          vector of string    &log &default=vector();
        support_client_mac_algorithms:          vector of string    &log &default=vector();
        support_server_mac_algorithms:          vector of string    &log &default=vector();
        client_ecc_key:                         string              &log &default="";
        server_ecc_key:                         string              &log &default="";

    };
}                           