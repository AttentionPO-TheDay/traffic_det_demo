package com.ruoyi.xt.domain.template;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * @Auther: eniac
 * @Date: 9/14/21 01:02
 * @Description:
 */
public class XtSshTemplate {
    /**
     * ssh攻击id
     */
    @JSONField(name = "uid")
    private String uid;

    /**
     * ipid
     */
    private String ipid;

    /**
     * udpid
     */
    private String udpid;

    /**
     * dnsid
     */
    private String dnsid;

    /**
     * tcpid
     */
    private String tcpid;

    /**
     * sslid
     */
    private String sslid;

    @JSONField(name = "ip")
    public XtIpTemplate xtIpTemplate;

    @JSONField(name = "udp")
    public XtUdpTemplate xtUdpTemplate;

    @JSONField(name = "dns")
    public XtDnsTemplate xtDnsTemplate;

    @Override
    public String toString() {
        return "XtSshTemplate{" +
            "uid='" + uid + '\'' +
            ", ipid='" + ipid + '\'' +
            ", udpid='" + udpid + '\'' +
            ", dnsid='" + dnsid + '\'' +
            ", tcpid='" + tcpid + '\'' +
            ", sslid='" + sslid + '\'' +
            ", xtIpTemplate=" + xtIpTemplate +
            ", xtUdpTemplate=" + xtUdpTemplate +
            ", xtDnsTemplate=" + xtDnsTemplate +
            '}';
    }
}

