package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * ip协议payload对象 xt_ip_payload
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtIpPayload extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * payloadID
     */
    @Excel(name = "payloadID")
    private Long payloadid;

    /**
     * 时间戳
     */
    //    @JsonFormat(pattern = "yyyy-MM-dd")
    //    @Excel(name = "时间戳", width = 30, dateFormat = "yyyy-MM-dd")
    @Excel(name = "时间戳")
    private String timestmp;

    /**
     * 长度
     */
    @Excel(name = "长度")
    private Long length;

    /**
     * id_orig
     */
    @Excel(name = "id_orig")
    private Integer isOrig;

    /**
     * optional
     */
    @Excel(name = "optional")
    private Long optional;

    /**
     * 属于的udpid
     */
    @Excel(name = "属于的udpid")
    private String ipid;

    public void setPayloadid(Long payloadid) {
        this.payloadid = payloadid;
    }

    public Long getPayloadid() {
        return payloadid;
    }

    public void setTimestmp(String timestmp) {
        this.timestmp = timestmp;
    }

    public String getTimestmp() {
        return timestmp;
    }

    public void setLength(Long length) {
        this.length = length;
    }

    public Long getLength() {
        return length;
    }

    public void setIsOrig(Integer isOrig) {
        this.isOrig = isOrig;
    }

    public Integer getIsOrig() {
        return isOrig;
    }

    public void setOptional(Long optional) {
        this.optional = optional;
    }

    public Long getOptional() {
        return optional;
    }

    public void setIpid(String ipid) {
        this.ipid = ipid;
    }

    public String getIpid() {
        return ipid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("payloadid", getPayloadid())
            .append("timestmp", getTimestmp())
            .append("length", getLength())
            .append("isOrig", getIsOrig())
            .append("optional", getOptional())
            .append("udpid", getIpid())
            .toString();
    }
}
