package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * @Auther: eniac
 * @Date: 11/18/21 06:06
 * @Description:
 */
public class XtMetaData extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * udpID
     */
    @Excel(name = "uid")
    private String uid;

    /**
     * 源端口
     */
    @Excel(name = "metadata")
    private String metadata;

    private String srcIp;
    private String dstIp;
    private Integer srcPort;
    private Integer dstPort;
    private int isEncrypted;
    private String timestamp;

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getSrcIp() {
        return srcIp;
    }

    public void setSrcIp(String srcIp) {
        this.srcIp = srcIp;
    }

    public String getDstIp() {
        return dstIp;
    }

    public void setDstIp(String dstIp) {
        this.dstIp = dstIp;
    }

    public Integer getDstPort() {
        return dstPort;
    }

    public void setDstPort(Integer dstPort) {
        this.dstPort = dstPort;
    }

    public Integer getSrcPort() {
        return srcPort;
    }

    public void setSrcPort(Integer srcPort) {
        this.srcPort = srcPort;
    }

    public int getIsEncrypted() {
        return isEncrypted;
    }

    public void setIsEncrypted(int isEncrypted) {
        this.isEncrypted = isEncrypted;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    @Override
    public String toString() {
        return "XtMetaData{" +
            "uid='" + uid + '\'' +
            ", metadata='" + metadata + '\'' +
            ", srcIp='" + srcIp + '\'' +
            ", dstIp='" + dstIp + '\'' +
            ", srcPort=" + srcPort +
            ", dstPort=" + dstPort +
            ", isEncrypted=" + isEncrypted +
            ", timestamp='" + timestamp + '\'' +
            '}';
    }
}
