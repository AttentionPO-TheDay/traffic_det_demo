package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * answer表对象 xt_answers
 *
 * @author ruoyi
 * @date 2021-09-13
 */
public class XtAnswers extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * ansid
     */
    @Excel(name = "ansid")
    private String ansid;

    /**
     * value
     */
    @Excel(name = "value")
    private String value;

    /**
     * queryid
     */
    @Excel(name = "queryid")
    private String queryid;

    public void setAnsid(String ansid) {
        this.ansid = ansid;
    }

    public String getAnsid() {
        return ansid;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public void setQueryid(String queryid) {
        this.queryid = queryid;
    }

    public String getQueryid() {
        return queryid;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("ansid", getAnsid())
            .append("value", getValue())
            .append("queryid", getQueryid())
            .toString();
    }
}
