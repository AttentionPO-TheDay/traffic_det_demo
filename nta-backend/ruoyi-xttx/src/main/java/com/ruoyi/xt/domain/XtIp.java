package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * ip表对象 xt_ip
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtIp extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * ipid
     */
    @Excel(name = "ipid")
    private String ipid;

    /**
     * 源端口
     */
    @Excel(name = "源端口")
    private String src;

    /**
     * 目的端口
     */
    @Excel(name = "目的端口")
    private String dst;

    /**
     * 版本
     */
    @Excel(name = "版本")
    private Long version;

    /**
     * 协议号
     */
    @Excel(name = "协议号")
    private Long protocol;

    /**
     * 长度
     */
    @Excel(name = "长度")
    private Long Length;

    public void setLength(Long length) {
        this.Length = length;
    }

    public Long getLength() {
        return this.Length;
    }

    public void setIpid(String ipid) {
        this.ipid = ipid;
    }

    public String getIpid() {
        return ipid;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getSrc() {
        return src;
    }

    public void setDst(String dst) {
        this.dst = dst;
    }

    public String getDst() {
        return dst;
    }

    public void setVersion(Long version) {
        this.version = version;
    }

    public Long getVersion() {
        return version;
    }

    public void setProtocol(Long protocol) {
        this.protocol = protocol;
    }

    public Long getProtocol() {
        return protocol;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("ipid", getIpid())
            .append("src", getSrc())
            .append("dst", getDst())
            .append("version", getVersion())
            .append("protocol", getProtocol())
            .toString();
    }
}
