package com.ruoyi.xt.domain;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 5/11/22 18:08
 * @Description:
 */
public class AssetsDiscoveryRes {
    private String msg;
    private List<AssetsStatus> ans;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public List<AssetsStatus> getAns() {
        return ans;
    }

    public void setAns(List<AssetsStatus> ans) {
        this.ans = ans;
    }
}
