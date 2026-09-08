package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * payload_udp表对象 xt_udp_payload
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtUdpPayload extends BaseEntity {
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
     * 属于的udpid
     */
    @Excel(name = "属于的udpid")
    private String udpid;

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

    public void setUdpid(String udpid) {
        this.udpid = udpid;
    }

    public String getUdpid() {
        return udpid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("payloadid", getPayloadid())
            .append("timestmp", getTimestmp())
            .append("length", getLength())
            .append("isOrig", getIsOrig())
            .append("udpid", getUdpid())
            .toString();
    }
}
