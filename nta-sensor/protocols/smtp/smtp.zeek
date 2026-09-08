@load ../utils
@load ../type

module SMTP;

function init_smtp_meta(c: connection):SMTP::Meta {
    Protocols::init_protocol_meta(c);
    if (!c$meta?$smtp) {
        c$meta$smtp = SMTP::Meta();
    }
    return c$meta$smtp;
} 

event smtp_data(c: connection, is_orig: bool, data: string) {
#    if (!c$meta?$smtp) {
#        c$meta$smtp = SMTP::Meta();
#    }
#    c$meta$smtp$data += data;
#    print data;
}

event mime_end_entity(c: connection) {
    local meta = init_smtp_meta(c);
    if (c?$smtp) {
        local smtp = c$smtp;

        meta$helo = smtp$helo;
        meta$mailfrom = smtp$mailfrom;
        meta$rcptto = smtp$rcptto;

        local subject = c$smtp$subject;
        local flag: string = "?B?";
        local pos = find_str(subject, flag);
        if (pos == -1) {
            flag = "?b?";
            pos = find_str(subject, flag);
        }
        if (pos != -1){
            local end = |subject|;
            meta$charset = subject[2 : pos];
            subject = subject[pos+3:end];
            flag = "?";
            pos = find_str(subject, flag);
            meta$subject_base64 = subject[0 : pos];
        } else {
            subject = smtp$subject;
            if (|subject| % 4 == 0) {
                meta$subject = decode_base64(subject);
            } else {
                meta$subject = subject;
            }
        }

        meta$date = smtp$date;
        meta$user_agent = smtp$user_agent;
    }
}

#event mime_one_header(c: connection, h: mime_header_rec) {
#    print h;
#}

#global medata_cnt = 0;
#event mime_entity_data(c: connection, length: count, data: string) {
#    if(medata_cnt == 0){
#        print length, (encode_base64(data)),data;
#        ++medata_cnt;
#    }
#}

#event mime_segment_data(c: connection, length: count, data: string) {
#    print length, data;
#}

event mime_all_data(c: connection, length: count, data: string) {
    local meta = init_smtp_meta(c);
    meta$data = data;
}

event smtp_request(c: connection, is_orig: bool, command: string, arg: string) {
    local smtp = init_smtp_meta(c);
    switch command {
        case "AUTH":
            local s = split_string(arg, / /);
            smtp$auth_type = s[0];
            smtp$auth_content = s[1];
            break;
    }
}

#event smtp_reply(c: connection, is_orig: bool, code: count, cmd: string, msg: string, cont_resp: bool) {
#    print is_orig, code, cmd, msg, cont_resp;
#}

#event smtp_starttls(c: connection) {
#    print c;
#}