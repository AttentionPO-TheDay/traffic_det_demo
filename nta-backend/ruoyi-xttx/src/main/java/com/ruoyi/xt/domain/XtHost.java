package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 主机对象 xt_host
 *
 * @author ruoyi
 * @date 2021-09-06
 */
public class XtHost extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 主机ID
     */
    private String hostid;

    /**
     * 主机名
     */
    @Excel(name = "主机名")
    private String hostname;

    /**
     * 主机IP地址
     */
    @Excel(name = "主机IP地址")
    private String address;

    /**
     * 主机负责人Id
     */
    @Excel(name = "主机负责人Id")
    private String userid;

    public void setHostid(String hostid) {
        this.hostid = hostid;
    }

    public String getHostid() {
        return hostid;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public String getHostname() {
        return hostname;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress() {
        return address;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getUserid() {
        return userid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("hostid", getHostid())
            .append("hostname", getHostname())
            .append("address", getAddress())
            .append("userid", getUserid())
            .toString();
    }
}
