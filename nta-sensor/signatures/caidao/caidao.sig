# alert http any any -> any any (msg:"webshell_caidao_php"; flow:established; content:"POST";http_method; content:".php"; http_uri; content:"base64_decode"; http_client_body; classtype:shellcode-detect; sid:3016009; rev:1; metadata:by al0ne;)
# alert http $EXTERNAL_NET any -> $HOME_NET any (msg: "China hacker tools caidao response - column directory"; flow: established,to_client; content:"200"; http_stat_code; content:!"<html>"; http_server_body; content:"|2d 3e|"; http_server_body; depth:2; pcre:"/[\w\d]+\.\w{2,3}\s+\d{4}-\d{2}-\d{2}\s[\d:]{8}/RQ"; classtype:shellcode-detect; sid: 3016010; rev: 1; metadata:created_at 2018_09_13,by al0ne; )

signature caidao_request {
    ip-proto == tcp
    enable "http"
    http-request /.*php/
    http-request-body /.*base64_decode/

    event "webshell_caidao_request"
}

signature caidao_response {
    requires-reverse-signature caidao_request
    ip-proto == tcp
    enable "http"

    http-reply-body /\x2d\x3e\x7c.*[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]][0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}/

    tcp-state established,responder
    event "webshell_caidao_response"
}

