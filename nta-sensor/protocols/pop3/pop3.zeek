@load base/protocols/conn
@load base/protocols/pop3

module POP3;

function init_pop3_meta(c: connection) {
    Protocols::init_protocol_meta(c);
    if ( !c$meta?$pop3 )
        c$meta$pop3 = POP3::Meta();
}

event pop3_request(c: connection, is_orig: bool, command: string, arg: string) {
    init_pop3_meta(c);
    c$meta$pop3$last_command = command;
    c$meta$pop3$last_arg = arg;
}

event pop3_reply(c: connection, is_orig: bool, cmd: string, msg: string) {
    init_pop3_meta(c);
    c$meta$pop3$last_reply = fmt("%s %s", cmd, msg);
}

event pop3_data(c: connection, is_orig: bool, data: string) {
    init_pop3_meta(c);
    c$meta$pop3$last_data = data;
}

event pop3_unexpected(c: connection, is_orig: bool, msg: string, detail: string) {
    init_pop3_meta(c);
    c$meta$pop3$unexpected_msg = msg;
    c$meta$pop3$unexpected_detail = detail;
}

event pop3_login_success(c: connection, is_orig: bool, user: string, password: string) {
    init_pop3_meta(c);
    c$meta$pop3$user = user;
    c$meta$pop3$password = password;
    c$meta$pop3$auth_success = T;
}

event pop3_login_failure(c: connection, is_orig: bool, user: string, password: string) {
    init_pop3_meta(c);
    c$meta$pop3$user = user;
    c$meta$pop3$password = password;
    c$meta$pop3$auth_success = F;
}