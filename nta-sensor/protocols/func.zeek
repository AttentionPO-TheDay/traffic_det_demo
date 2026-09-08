@load ../output/extract

module Protocols;

export {
    function init_protocol_meta(c: connection) {
        if (!c?$meta) {
            c$meta = Protocols::Meta(
                $uid=c$uid,
                $hash=Sensor::get_connection_hash(c)
            );
        }
    }

}