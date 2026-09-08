@load ../type

module IMAP;

function init_imap_meta(c: connection) {
    Protocols::init_protocol_meta(c);
    if ( ! c$meta?$imap )
        c$meta$imap = IMAP::Meta();
}

event imap_capabilities(c: connection, capabilities: string_vec) {
    init_imap_meta(c);
    c$meta$imap$capabilities = capabilities;
}

event imap_starttls(c: connection) {
    init_imap_meta(c);
    c$meta$imap$used_starttls = T;
}