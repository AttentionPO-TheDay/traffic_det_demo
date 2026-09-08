module IMAP;

export {
    type Meta: record {
        capabilities: vector of string &log &optional;
        used_starttls: bool &log &optional;
    };
}