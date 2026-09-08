package com.ruoyi.xt.domain;

import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/22/21 04:06
 * @Description:
 */
public class ModelThreatRequest {
    private String uid;
    private List<Map<String, Object>> vector;

    public String getUid() {
        return this.uid;
    }

    public List<Map<String, Object>> getVector() {
        return this.vector;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public void setVector(List<Map<String, Object>> vector) {
        this.vector = vector;
    }
}
