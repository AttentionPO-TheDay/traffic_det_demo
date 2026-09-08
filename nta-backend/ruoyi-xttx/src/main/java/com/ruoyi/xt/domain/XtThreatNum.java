package com.ruoyi.xt.domain;

import lombok.Data;

@Data
public class XtThreatNum {
    private int num;
    private String date;

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
