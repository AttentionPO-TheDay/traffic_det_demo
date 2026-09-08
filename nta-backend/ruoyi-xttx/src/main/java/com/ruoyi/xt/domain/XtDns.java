package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * dns表对象 xt_dns
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtDns extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * dnsID
     */
    @Excel(name = "dnsID")
    private String dnsid;

    public void setDnsid(String dnsid) {
        this.dnsid = dnsid;
    }

    public String getDnsid() {
        return dnsid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("dnsid", getDnsid())
            .toString();
    }
}
