package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 流量总对象 xt_traffic
 *
 * @author ruoyi
 * @date 2021-09-26
 */
public class XtTraffic extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 流量id
     */
    @Excel(name = "流量id")
    private String uid;

    /**
     * 攻击名称
     */
    @Excel(name = "攻击名称")
    private String name;

    /**
     * 攻击类型
     */
    @Excel(name = "攻击类型")
    private String type;

    /**
     * 被威胁主机
     */
    @Excel(name = "被威胁主机")
    private String threatenhost;

    /**
     * 时间戳
     */
    @Excel(name = "时间戳")
    private String timestamp;

    /**
     * 是否处理过
     */
    @Excel(name = "是否处理过")
    private Integer handle;

    /**
     * 关联的流量表
     */
    @Excel(name = "关联的流量表")
    private String tablename;

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getUid() {
        return uid;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }

    public void setThreatenhost(String threatenhost) {
        this.threatenhost = threatenhost;
    }

    public String getThreatenhost() {
        return threatenhost;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setHandle(Integer handle) {
        this.handle = handle;
    }

    public Integer getHandle() {
        return handle;
    }

    public void setTablename(String tablename) {
        this.tablename = tablename;
    }

    public String getTablename() {
        return tablename;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("uid", getUid())
            .append("name", getName())
            .append("type", getType())
            .append("threatenhost", getThreatenhost())
            .append("timestamp", getTimestamp())
            .append("handle", getHandle())
            .append("tablename", getTablename())
            .toString();
    }
}
