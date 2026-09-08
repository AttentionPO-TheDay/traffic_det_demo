@load ../../protocols

module Sensor;

redef LogAscii::enable_utf_8 = T;
redef LogAscii::use_json = T;

export {
    const source = "zeek-1" &redef;
    const isLive: bool = T &redef; 

    redef enum Log::ID += { LOG };
	type Log: record {
        ts:     time    &log;
		data:   string  &log;
	} &log;

    const to_kafka   = F    &redef;
    const to_console = F    &redef;

    const debug_print = F   &redef;

    function output(msg: Protocols::Meta) {
        msg$source = source;
        msg$live = isLive;

        if (to_kafka) {
            Log::write(
                LOG, 
                [
                    $ts=network_time(),
                    $data=to_json(msg)
                ]
            );
        }
        if (to_console) {
            print(to_json(msg));
        }
    }

    function debug_print_connection(c: connection) {
        if (debug_print) {
            print "";
            print "!!ZEEKCONN!!" + to_json(c);
            print "";
        }
    }
}

event zeek_init() &priority=5 {
    if (to_kafka) {
        Log::create_stream(Sensor::LOG, [$columns=Log, $path="sensor"]);
    }
}