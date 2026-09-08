@load ../type

module DNS;

event dns_end(c: connection, msg: dns_msg) {
    if (!c$meta?$dns) {
        c$meta$dns = DNS::Meta();
    }
    if (c$dns?$answers) {
        c$meta$dns$queries += DNS::Query(
            $query=c$dns$query,
            $qtype=c$dns$qtype_name,
            $qclass=c$dns$qclass_name,
            $answers=c$dns$answers
        );
    }
}