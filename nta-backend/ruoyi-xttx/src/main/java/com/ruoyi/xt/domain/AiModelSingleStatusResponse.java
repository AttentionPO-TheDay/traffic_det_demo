package com.ruoyi.xt.domain;

/**
 * @Auther: eniac
 * @Date: 11/23/21 04:28
 * @Description:
 */
public class AiModelSingleStatusResponse {
    private boolean success;
    private String name;
    private String state;
    private String msg;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

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

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }


    @Override
    public String toString() {
        return "AiModelSingleStatusResponse{" +
            "success=" + success +
            ", name='" + name + '\'' +
            ", state='" + state + '\'' +
            ", msg='" + msg + '\'' +
            '}';
    }
}
