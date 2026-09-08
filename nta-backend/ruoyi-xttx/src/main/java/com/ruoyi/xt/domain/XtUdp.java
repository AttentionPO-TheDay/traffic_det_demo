package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * udp表对象 xt_udp
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtUdp extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * udpID
     */
    @Excel(name = "udpID")
    private String udpid;

    /**
     * 源端口
     */
    @Excel(name = "源端口")
    private Long src;

    /**
     * 目的端口
     */
    @Excel(name = "目的端口")
    private Long dst;

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

    public void setUdpid(String udpid) {
        this.udpid = udpid;
    }

    public String getUdpid() {
        return udpid;
    }

    public void setSrc(Long src) {
        this.src = src;
    }

    public Long getSrc() {
        return src;
    }

    public void setDst(Long dst) {
        this.dst = dst;
    }

    public Long getDst() {
        return dst;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("udpid", getUdpid())
            .append("src", getSrc())
            .append("dst", getDst())
            .append("packetUp", getPacketUp())
            .append("packetDn", getPacketDn())
            .append("byteUp", getByteUp())
            .append("byteDn", getByteDn())
            .toString();
    }
}
