package com.ruoyi.xt.domain;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/23/21 04:28
 * @Description:
 */
public class AiModelAllStatusResponse {
    private boolean success;
    private List<AiModelStatus> states;
    private String msg;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }


    public List<AiModelStatus> getStates() {
        return states;
    }

    public void setStates(List<AiModelStatus> states) {
        this.states = states;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    @Override
    public String toString() {
        return "AiModelAllStatusResponse{" +
            "success=" + success +
            ", states=" + states +
            ", msg='" + msg + '\'' +
            '}';
    }
}
