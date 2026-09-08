@load ../type
@load ../utils
@load base/protocols/http/main

module HTTP;

export {
    const with_payload = T &redef;
}

function init_http_meta(c: connection): HTTP::Meta {
    Protocols::init_protocol_meta(c);
    if (!c$meta?$http) {
        c$meta$http = HTTP::Meta();
    }
    return c$meta$http;
}

event http_content_type(c: connection, is_orig: bool, ty: string, subty: string) {
    local meta = init_http_meta(c);
    if (is_orig) {
        local content_type: string = to_lower(ty);
        meta$content_type = content_type + "/" + to_lower(subty);    #告诉浏览器，回送的数据类型
    }
}

event http_connection_upgrade(c: connection, protocol: string) {
   local meta = init_http_meta(c);
   meta$upgrade = protocol;
}

event http_header(c: connection, is_orig: bool, name: string, value: string) &priority=3 {
    local meta = init_http_meta(c);

    if (is_orig) {
        meta$src_headers[name] = value;
    } else {
        meta$dst_headers[name] = value;
    }
}

event http_reply(c: connection, version: string, code: count, reason: string) {
    local meta = init_http_meta(c);
    meta$status = utils::KV(
        $id=code,
        $name=reason
    );
}

event http_request(c: connection, method: string, original_URI: string, unescaped_URI: string, version: string) {
    local meta = init_http_meta(c);
    meta$method = method;
    meta$uri = unescaped_URI;
    meta$version = version;
}

event http_entity_data (c: connection, is_orig: bool, length: count, data: string) {
    local meta = init_http_meta(c);

    local new_http_payload = utils::Payload(
        $timestamp=network_time(),
        $length=length,
        $is_orig=is_orig
    );

    if (with_payload) {
        new_http_payload$optional = encode_base64(data);
    }

    meta$payload += new_http_payload;
}