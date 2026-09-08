package com.ruoyi.xt.domain.template;

import com.ruoyi.xt.domain.XtUdp;
import com.ruoyi.xt.domain.XtUdpPayload;

import java.util.Arrays;

/**
 * @Auther: eniac
 * @Date: 9/14/21 01:08
 * @Description:
 */
public class XtUdpTemplate {
    public XtUdp xtUdp;

    public XtUdpPayload[] xtUdpPayloads;

    @Override
    public String toString() {
        return "XtUdpTemplate{" +
            "xtUdp=" + xtUdp +
            ", xtUdpPayloads=" + Arrays.toString(xtUdpPayloads) +
            '}';
    }
}
