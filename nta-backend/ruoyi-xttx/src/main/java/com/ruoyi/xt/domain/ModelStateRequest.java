package com.ruoyi.xt.domain;

/**
 * @Auther: eniac
 * @Date: 11/22/21 04:08
 * @Description:
 */
public class ModelStateRequest {
    private String name;

    public ModelStateRequest(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
