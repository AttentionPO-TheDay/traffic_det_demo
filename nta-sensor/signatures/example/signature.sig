signature check_http_baidu {
    ip-proto == tcp
    dst-port == 80
    payload /.*baidu/
    event "baidu"
}