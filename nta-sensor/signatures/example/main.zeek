event signature_match(state: signature_state, msg: string, data: string) {
    if (state$sig_id == "check_http_baidu") {
        print fmt("%s: %s -> %s", state$sig_id, state$conn$id$orig_h, state$conn$id$resp_h);
    }
}