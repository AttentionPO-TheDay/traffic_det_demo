package com.ruoyi.xt.domain;

//import org.apache.commons.lang.builder.ToStringBuilder;
//import org.apache.commons.lang3.builder.ToStringBuilder;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 用户信息对象 xt_hostuser
 *
 * @author zz
 * @date 2021-09-05
 */
public class XtHostuser extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 用户编号
     */
    private String userId;

    /**
     * 用户名
     */
    @Excel(name = "用户名")
    private String name;

    /**
     * 联系方式
     */
    @Excel(name = "联系方式")
    private String phone;

    /**
     * 部门
     */
    @Excel(name = "部门")
    private String departure;

    /**
     * 职位
     */
    @Excel(name = "职位")
    private String job;

    /**
     * 备注
     */
    @Excel(name = "备注")
    private String description;

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhone() {
        return phone;
    }

    public void setDeparture(String departure) {
        this.departure = departure;
    }

    public String getDeparture() {
        return departure;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getJob() {
        return job;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("userId", getUserId())
            .append("name", getName())
            .append("phone", getPhone())
            .append("departure", getDeparture())
            .append("job", getJob())
            .append("description", getDescription())
            .toString();
    }
}
