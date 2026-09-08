package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * tcp表对象 xt_tcp
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtTcp extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * tcpid
     */
    @Excel(name = "tcpid")
    private String tcpid;

    /**
     * 源端口
     */
    @Excel(name = "源端口")
    private Long clientPort;

    /**
     * 目的端口
     */
    @Excel(name = "目的端口")
    private Long serverPort;

    /**
     * packet_up
     */
    @Excel(name = "packet_up")
    private Long packetUp;

    /**
     * packet_dn
     */
    @Excel(name = "packet_dn")
    private Long packetDn;

    /**
     * byte_up
     */
    @Excel(name = "byte_up")
    private Long byteUp;

    /**
     * byte_dn
     */
    @Excel(name = "byte_dn")
    private Long byteDn;

    /**
     * byte_dn
     */
    @Excel(name = "byte_dn")
    private Long packetRetransUp;

    /**
     * byte_dn
     */
    @Excel(name = "byte_dn")
    private Long byteRetransUp;

    /**
     * byte_dn
     */
    @Excel(name = "byte_dn")
    private Long packetRetransDn;

    /**
     * byte_dn
     */
    @Excel(name = "byte_dn")
    private Long byteRetransDn;

    public void setTcpid(String tcpid) {
        this.tcpid = tcpid;
    }

    public String getTcpid() {
        return tcpid;
    }

    public void setClientPort(Long clientPort) {
        this.clientPort = clientPort;
    }

    public Long getClientPort() {
        return clientPort;
    }

    public void setServerPort(Long serverPort) {
        this.serverPort = serverPort;
    }

    public Long getServerPort() {
        return serverPort;
    }

    public void setPacketUp(Long packetUp) {
        this.packetUp = packetUp;
    }

    public Long getPacketUp() {
        return packetUp;
    }

    public void setPacketDn(Long packetDn) {
        this.packetDn = packetDn;
    }

    public Long getPacketDn() {
        return packetDn;
    }

    public void setByteUp(Long byteUp) {
        this.byteUp = byteUp;
    }

    public Long getByteUp() {
        return byteUp;
    }

    public void setByteDn(Long byteDn) {
        this.byteDn = byteDn;
    }

    public Long getByteDn() {
        return byteDn;
    }

    public void setPacketRetransUp(Long packetRetransUp) {
        this.packetRetransUp = packetRetransUp;
    }

    public Long getPacketRetransUp() {
        return packetRetransUp;
    }

    public void setByteRetransUp(Long byteRetransUp) {
        this.byteRetransUp = byteRetransUp;
    }

    public Long getByteRetransUp() {
        return byteRetransUp;
    }

    public void setPacketRetransDn(Long packetRetransDn) {
        this.packetRetransDn = packetRetransDn;
    }

    public Long getPacketRetransDn() {
        return packetRetransDn;
    }

    public void setByteRetransDn(Long byteRetransDn) {
        this.byteRetransDn = byteRetransDn;
    }

    public Long getByteRetransDn() {
        return byteRetransDn;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("tcpid", getTcpid())
            .append("clientPort", getClientPort())
            .append("serverPort", getServerPort())
            .append("packetUp", getPacketUp())
            .append("packetDn", getPacketDn())
            .append("byteUp", getByteUp())
            .append("byteDn", getByteDn())
            .append("packetRetransUp", getPacketRetransUp())
            .append("byteRetransUp", getByteRetransUp())
            .append("packetRetransDn", getPacketRetransDn())
            .append("byteRetransDn", getByteRetransDn())
            .toString();
    }
}
