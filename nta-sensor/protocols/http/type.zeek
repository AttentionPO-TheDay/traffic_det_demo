@load ../utils

module HTTP;

export {
    type Meta: record {
        method:                 string  &log            &optional;
        host:                   string  &log            &optional;
        uri:                    string  &log            &optional;
        version:                string  &log            &optional;
        content_type:           string  &log            &optional;
        upgrade:                string  &log            &optional;
        status:                 utils::KV               &default=utils::KV();
        src_headers:            table[string] of string &default=table();
        dst_headers:            table[string] of string &default=table();
        payload:                vector of utils::Payload &default=vector();
    };

}