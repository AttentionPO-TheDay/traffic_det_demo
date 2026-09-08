package com.ruoyi.xt.domain;

import com.alibaba.fastjson.annotation.JSONField;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * query查询对象 xt_queries
 *
 * @author ruoyi
 * @date 2021-09-12
 */
public class XtQueries extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * queryID
     */
    @Excel(name = "queryID")
    private String queryid;

    /**
     * query
     */
    @Excel(name = "query")
    @JSONField(name = "query")
    private String query;

    /**
     * qtype
     */
    @Excel(name = "qtype")
    @JSONField(name = "qtype")
    private String qtype;

    /**
     * qclass
     */
    @Excel(name = "qclass")
    @JSONField(name = "qclass")
    private String qclass;

    /**
     * dnsid
     */
    @Excel(name = "dnsid")
    private String dnsid;

    public void setQueryid(String queryid) {
        this.queryid = queryid;
    }

    public String getQueryid() {
        return queryid;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public String getQuery() {
        return query;
    }

    public void setQtype(String qtype) {
        this.qtype = qtype;
    }

    public String getQtype() {
        return qtype;
    }

    public void setQclass(String qclass) {
        this.qclass = qclass;
    }

    public String getQclass() {
        return qclass;
    }

    public void setDnsid(String dnsid) {
        this.dnsid = dnsid;
    }

    public String getDnsid() {
        return dnsid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("queryid", getQueryid())
            .append("query", getQuery())
            .append("qtype", getQtype())
            .append("qclass", getQclass())
            .append("dnsid", getDnsid())
            .toString();
    }
}
