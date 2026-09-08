@load-plugin Seiso::Kafka

module Trace;

export {
    redef enum Log::ID += { Trace::LOG };

    # to prevent extremely large traces
    const threshold: count = 1000 &redef;

    type Packet: record {
        rel_time: double;
        size: int;
    };

    type Traffic: record {
        trace: vector of Packet; 
       
        sttl: count;
        dttl: count;
        proto: count;

        tcp_stat: record {
            sloss: count;
            dloss: count;
            synack: double;
            ackdat: double;
        } &optional;
    };

    type Info: record {
        uid: string &log;
        traffic: string &log;
    };
}


redef record connection += {
    trace: vector of Packet &optional; 
    sttl: count &optional;
    dttl: count &optional;
    proto: count &optional;

    init_time: time &optional;

    tcp_stat: record {
        sloss: count &default=0;
        dloss: count &default=0;
        syn_time: time &optional;
        sa_time: time &optional;
        ack_time: time &optional;
    } &optional;
};

event zeek_init() {
    Log::create_stream(Trace::LOG, [
        $columns = Info,
        $path = "traffic"
    ]);

    local filter: Log::Filter = [
        $name = "kafka",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "localhost:9092"
        ),
        $path = "traffic"
    ];
    Log::add_filter(Trace::LOG, filter);
    Log::remove_filter(Trace::LOG, "default");
}

event new_connection(c: connection) {
    c$trace = vector();
    c$init_time = network_time();
}

function isOrig(c: connection, a: addr): bool {
    return c$id$orig_h == a;
}

event new_packet(c: connection, p: pkt_hdr) {
   if (! c?$trace || ! c?$init_time) return;

    local rel_time = network_time() - c$init_time;
    local size = 0;
   if (p?$ip) {
        c$proto = p$ip$p;
        size = p$ip$len;

        if (isOrig(c, p$ip$src) && !c?$sttl) {
            c$sttl = p$ip$ttl;
        } else if (!isOrig(c, p$ip$src) && !c?$dttl) {
            c$dttl = p$ip$ttl;
        }
   } else if (p?$ip6) {
        c$proto = p$ip6$nxt;
        size = p$ip6$len;

        if (isOrig(c, p$ip6$src) && !c?$sttl) {
            c$sttl = p$ip6$hlim;
        } else if (!isOrig(c, p$ip6$src) && !c?$dttl) {
            c$dttl = p$ip6$hlim;
        }
   } else return; 
   
    if (|c$trace| >= Trace::threshold) return; 
    local pkt: Packet = [
        $rel_time = interval_to_double(rel_time),
        $size = size
    ];
    c$trace += pkt;
}

event connection_SYN_packet(c: connection, pkt: SYN_packet) {
    if (pkt$is_orig && !c?$tcp_stat) {
        c$tcp_stat = [
            $syn_time=network_time()
        ];
    }
}

event connection_established(c: connection) {
    if (c?$tcp_stat) {
        c$tcp_stat$sa_time = network_time();
    }
}

event connection_first_ACK(c: connection) {
    if (c?$tcp_stat) {
        c$tcp_stat$ack_time = network_time();
    }
}

event tcp_rexmit(c: connection, is_orig: bool, seq: count, len: count, data_in_flight: count, window: count) {
    if (c?$tcp_stat) {
        if (is_orig) c$tcp_stat$sloss += 1;
        else c$tcp_stat$dloss += 1;
    }
}

event connection_state_remove(c: connection) {
    if (! c?$sttl && ! c?$dttl ) return;
    
    if (! c?$sttl ) c$sttl = 0;
    if (! c?$dttl ) c$dttl = 0;

    local traffic: Traffic = [
        $trace = c$trace,
        $sttl = c$sttl,
        $dttl = c$dttl,
        $proto = c$proto
    ];

    # shattered tcp trace, abort
    if (c?$tcp_stat && c$tcp_stat?$syn_time && c$tcp_stat?$sa_time && c$tcp_stat?$ack_time) {
        local synack = c$tcp_stat$sa_time - c$tcp_stat$syn_time;
        local ackdat = c$tcp_stat$ack_time - c$tcp_stat$sa_time;
        
        traffic$tcp_stat = [
            $sloss = c$tcp_stat$sloss,
            $dloss = c$tcp_stat$dloss,
            $synack = interval_to_double(synack),
            $ackdat = interval_to_double(ackdat)
        ];
    }

    local traffic_json: Info = [
      $uid = c$uid,
      $traffic = to_json(traffic) 
    ];
    Log::write(Trace::LOG, traffic_json);
}