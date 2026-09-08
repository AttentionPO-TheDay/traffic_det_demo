module POP3;

export {
    type Meta: record {
        user: string &log &optional;
        password: string &log &optional;
        auth_success: bool &log &optional;
        last_command: string &log &optional;
        last_arg: string &log &optional;
        last_reply: string &log &optional;
        last_data: string &log &optional;
        unexpected_msg: string &log &optional;
        unexpected_detail: string &log &optional;
    };
}