package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.xt.domain.template.LabelConfidence;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/19/21 04:02
 * @Description:
 */


public class XtThreat extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * threat_id
     */
    @Excel(name = "威胁id")
    private Long threatId;

    /**
     * 攻击名称
     */
    @Excel(name = "攻击名称")
    private String name;

    /**
     * 威胁来源
     */
    @Excel(name = "威胁来源")
    private String source;

    /**
     * 威胁主机ID
     */
    @Excel(name = "威胁主机Id")
    private String hostid;

    /**
     * 源Ip
     */
    @Excel(name = "源Ip")
    private String srcIp;

    /**
     * 目的Ip
     */
    @Excel(name = "目的IP")
    private String dstIp;

    /**
     * 源端口
     */
    @Excel(name = "源端口")
    private int srcPort;

    /**
     * 目的地端口
     */
    @Excel(name = "目的地端口")
    private int dstPort;

    /**
     * 时间戳
     */
    @Excel(name = "timestamp")
    private String timestamp;

    /**
     * 攻击名称 -1:no /1:yes
     */
    @Excel(name = "是否已经处理")
    private int handled;


    /**
     * 流量ID
     */
    @Excel(name = "traffic id")
    private String uid;

    private int isThreat;

    private String modelName;

    private String modelId;

    private List<LabelConfidence> labelConfidences;

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public int getIsThreat() {
        return isThreat;
    }

    public void setIsThreat(int isThreat) {
        this.isThreat = isThreat;
    }

    public Long getThreatId() {
        return threatId;
    }

    public void setThreatId(Long threatId) {
        this.threatId = threatId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getHostid() {
        return hostid;
    }

    public void setHostid(String hostid) {
        this.hostid = hostid;
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

    public int getSrcPort() {
        return srcPort;
    }

    public void setSrcPort(int srcPort) {
        this.srcPort = srcPort;
    }

    public int getDstPort() {
        return dstPort;
    }

    public void setDstPort(int dstPort) {
        this.dstPort = dstPort;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public int getHandled() {
        return handled;
    }

    public void setHandled(int handled) {
        this.handled = handled;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public List<LabelConfidence> getLabelConfidences() {
        return labelConfidences;
    }

    public void setLabelConfidences(List<LabelConfidence> labelConfidences) {
        this.labelConfidences = labelConfidences;
    }

    @Override
    public String toString() {
        return "XtThreat{" +
            "threatId=" + threatId +
            ", name='" + name + '\'' +
            ", source='" + source + '\'' +
            ", hostid='" + hostid + '\'' +
            ", srcIp='" + srcIp + '\'' +
            ", dstIp='" + dstIp + '\'' +
            ", srcPort=" + srcPort +
            ", dstPort=" + dstPort +
            ", timestamp='" + timestamp + '\'' +
            ", handled=" + handled +
            ", uid='" + uid + '\'' +
            ", isThreat=" + isThreat +
            ", modelName='" + modelName + '\'' +
            '}';
    }
}
