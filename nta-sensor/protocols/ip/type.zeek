@load ../utils

module IP;

export {
    type Meta: record {
        src:        addr    &log &default=0.0.0.0;
        dst:        addr    &log &default=0.0.0.0;
        protocol:   count   &log &default=0;
        version:    count   &log &default=0;
        length:     count   &log &default=0;
        payload:    vector of utils::Payload &default=vector();
    };
}