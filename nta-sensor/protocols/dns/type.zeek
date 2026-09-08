module DNS;

export {
    type Query: record {
        query:      string              &log &optional;
        qtype:      string              &log &optional;
        qclass:     string              &log &optional;
        answers:    vector of string    &log &optional;
    };
    type Meta: record {
        queries:    vector of Query      &default=vector();
    };
}