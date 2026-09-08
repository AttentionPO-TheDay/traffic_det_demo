package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * ssh攻击对象 xt_ssh
 *
 * @author ruoyi
 * @date 2021-09-12
 */
public class XtSsh extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * ssh攻击id
     */
    @Excel(name = "ssh攻击id")
    private String uid;

    /**
     * ipid
     */
    @Excel(name = "ipid")
    private String ipid;

    /**
     * udpid
     */
    @Excel(name = "udpid")
    private String udpid;

    /**
     * dnsid
     */
    @Excel(name = "dnsid")
    private String dnsid;

    /**
     * tcpid
     */
    @Excel(name = "tcpid")
    private String tcpid;

    /**
     * sslid
     */
    @Excel(name = "sslid")
    private String sslid;

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getUid() {
        return uid;
    }

    public void setIpid(String ipid) {
        this.ipid = ipid;
    }

    public String getIpid() {
        return ipid;
    }

    public void setUdpid(String udpid) {
        this.udpid = udpid;
    }

    public String getUdpid() {
        return udpid;
    }

    public void setDnsid(String dnsid) {
        this.dnsid = dnsid;
    }

    public String getDnsid() {
        return dnsid;
    }

    public void setTcpid(String tcpid) {
        this.tcpid = tcpid;
    }

    public String getTcpid() {
        return tcpid;
    }

    public void setSslid(String sslid) {
        this.sslid = sslid;
    }

    public String getSslid() {
        return sslid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("uid", getUid())
            .append("ipid", getIpid())
            .append("udpid", getUdpid())
            .append("dnsid", getDnsid())
            .append("tcpid", getTcpid())
            .append("sslid", getSslid())
            .toString();
    }
}
