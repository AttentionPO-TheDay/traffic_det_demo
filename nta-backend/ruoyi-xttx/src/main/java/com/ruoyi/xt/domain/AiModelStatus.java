package com.ruoyi.xt.domain;

/**
 * @Auther: eniac
 * @Date: 11/23/21 04:54
 * @Description:
 */
public class AiModelStatus {
    private String name;
    private String state;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    @Override
    public String toString() {
        return "AiModelStatus{" +
            "name='" + name + '\'' +
            ", state='" + state + '\'' +
            '}';
    }
}
