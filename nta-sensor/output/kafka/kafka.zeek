@load-plugin SEISO_KAFKA
@load ../log

# @load packages/metron-bro-plugin-kafka/Apache/Kafka
# redef Kafka::send_all_active_logs = T;
# redef Kafka::kafka_conf = table(
#     ["metadata.broker.list"] = "localhost:9092"
# );

module Kafka;

redef Kafka::logs_to_send = set(Sensor::LOG);
redef Kafka::topic_name = "";
redef Kafka::tag_json = F;


function send_to_kafka(id: Log::ID): bool {
    if (|logs_to_send| == 0 && send_all_active_logs == F)
        return F;
    else if (id in logs_to_exclude ||
            (id !in logs_to_send && send_all_active_logs == F))
        return F;
    else
        return T;
}

event zeek_init() &priority=-10 {
    for (stream_id in Log::active_streams) {
        if (send_to_kafka(stream_id)) {
            local filter: Log::Filter = [
                    $name = fmt("kafka-%s", stream_id),
                    $writer = Log::WRITER_KAFKAWRITER,
                    $config = table(
                        ["stream_id"] = fmt("%s", stream_id),
                        ["metadata.broker.list"] = "localhost:9092"
                    ),
                    $path = "zeek"
            ];
            Log::add_filter(stream_id, filter);
        }
    }
}

event kafka_topic_resolved_event(topic: string) {
    print(fmt("Kafka topic set to %s",topic));
}
