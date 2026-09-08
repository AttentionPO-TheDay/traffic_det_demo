package com.ruoyi.xt.domain.template;

import com.ruoyi.xt.domain.XtAnswers;
import com.ruoyi.xt.domain.XtQueries;

import java.util.Arrays;

/**
 * @Auther: eniac
 * @Date: 9/14/21 01:23
 * @Description:
 */
public class XtQueryTemplate {
    //    @JSONField(name = "queries")
    public XtQueries xtQueries;

    public XtAnswers[] xtAnswers;

    @Override
    public String toString() {
        return "XtQueryTemplate{" +
            "xtQueries=" + xtQueries +
            ", xtAnswers=" + Arrays.toString(xtAnswers) +
            '}';
    }
}
