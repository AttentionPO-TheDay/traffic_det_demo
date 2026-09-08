package com.ruoyi.xt.domain;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/22/21 04:07
 * @Description:
 */
public class ModelThreatResponse {
    private String uid;
    private List<ThreatResponse> threat;

    @JSONField(name = "uid")
    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    @JSONField(name = "threat")
    public List<ThreatResponse> getThreat() {
        return threat;
    }

    public void setThreat(List<ThreatResponse> threat) {
        this.threat = threat;
    }
}


