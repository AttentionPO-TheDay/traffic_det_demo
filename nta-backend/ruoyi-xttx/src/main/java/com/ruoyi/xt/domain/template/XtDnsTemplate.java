package com.ruoyi.xt.domain.template;

import com.ruoyi.xt.domain.XtDns;
import com.ruoyi.xt.domain.XtQueries;

import java.util.Arrays;

/**
 * @Auther: eniac
 * @Date: 9/14/21 01:11
 * @Description:
 */
public class XtDnsTemplate {
    public XtDns xtDns;

    public XtQueries[] xtQueries;

    @Override
    public String toString() {
        return "XtDnsTemplate{" +
            "xtDns=" + xtDns +
            ", xtQueries=" + Arrays.toString(xtQueries) +
            '}';
    }
}
