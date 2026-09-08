package com.ruoyi.xt.domain.template;

import com.ruoyi.xt.domain.XtIp;
import com.ruoyi.xt.domain.XtIpPayload;

import java.util.Arrays;

/**
 * @Auther: eniac
 * @Date: 9/14/21 01:07
 * @Description:
 */
public class XtIpTemplate {
    public XtIp xtIp;

    public XtIpPayload[] xtIpPayloads;

    @Override
    public String toString() {
        return "XtIpTemplate{" +
            "xtIp=" + xtIp +
            ", xtIpPayloads=" + Arrays.toString(xtIpPayloads) +
            '}';
    }
}
