module utils;

export {
    # 协议流量在事件和空间上的特征对象
    type Payload: record {
        timestamp:      time    &log    &default=network_time();
        length:         count   &log    &default=0;
        is_orig:        bool    &log    &default=T;
        type_id:        count   &log    &optional;
        type_name:      string  &log    &optional;
        payload:        string  &log    &optional;
        optional:       any             &optional;
    };

    type KV: record {
        id:            any              &optional;
        name:          string   &log    &default="";
        value:         any              &optional;
    };
}
