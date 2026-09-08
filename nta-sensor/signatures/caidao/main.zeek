@load base/protocols/http

event signature_match(state: signature_state, msg: string, data: string) {
    if (state$sig_id == "caidao_response") {
        print fmt("%s: %s -> %s %s", state$sig_id, state$conn$id$orig_h, state$conn$id$resp_h, msg);
    }
}