package com.ruoyi.xt.domain;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * @Auther: eniac
 * @Date: 11/22/21 05:57
 * @Description:
 */
public class ThreatResponse {
    private String modelName;
    private boolean isThreat;
    private String threatName;

    @JSONField(name = "model_name")
    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    @JSONField(name = "is_threat")
    public boolean isThreat() {
        return isThreat;
    }

    public void setThreat(boolean threat) {
        isThreat = threat;
    }

    @JSONField(name = "threat_name")
    public String getThreatName() {
        return threatName;
    }

    public void setThreatName(String threatName) {
        this.threatName = threatName;
    }

    @Override
    public String toString() {
        return "ThreatResponse{" +
            "modelName='" + modelName + '\'' +
            ", isThreat=" + isThreat +
            ", threatName='" + threatName + '\'' +
            '}';
    }
}
