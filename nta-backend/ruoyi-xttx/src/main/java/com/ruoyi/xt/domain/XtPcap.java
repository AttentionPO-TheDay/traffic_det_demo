package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * @Auther: sinrotic
 * @Date: 05/15/25 14:30
 * @Description:
 */
public class XtPcap {

    @Excel(name = "文件名称")
    private String name;

    @Excel(name = "文件大小")
    private Long size;

    @Excel(name = "上传时间")
    private String timestamp;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getSize() {
        return size;
    }

    public void setSize(Long size) {
        this.size = size;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "XtPcap{" +
                "name='" + name + '\'' +
                ", size=" + size +
                ", timestamp=" + timestamp +
                '}';
    }
}
