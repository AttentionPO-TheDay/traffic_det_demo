module IPSEC;

const CERT_USAGE_SIG = 4;
const CERT_USAGE_ENC = 5;

const CERT_USAGE: table[count] of string = {
    [CERT_USAGE_SIG] = "sig",
    [CERT_USAGE_ENC] = "enc",
} &default="unknown";
