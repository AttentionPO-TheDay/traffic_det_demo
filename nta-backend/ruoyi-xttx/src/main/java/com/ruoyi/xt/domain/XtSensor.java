package com.ruoyi.xt.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * @Auther: eniac
 * @Date: 11/21/21 05:00
 * @Description:
 */
public class XtSensor {

    private static final long serialVersionUID = 1L;

    /**
     * sensor_id
     */
    @Excel(name = "SensorId")
    private Long sensorId;

    /**
     * zeek/suricata
     */
    @Excel(name = "type")
    private String type;

    /**
     * hostid
     */
    @Excel(name = "hostId")
    private String hostId;

    /**
     * sensor_name
     */
    @Excel(name = "sensorName")
    private String sensorName;


    public String getSensorName() {
        return sensorName;
    }

    public void setSensorName(String sensorName) {
        this.sensorName = sensorName;
    }

    public Long getSensorId() {
        return sensorId;
    }

    public void setSensorId(Long sensorId) {
        this.sensorId = sensorId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    @Override
    public String toString() {
        return "XtSensor{" +
            "sensorId=" + sensorId +
            ", type='" + type + '\'' +
            ", hostId='" + hostId + '\'' +
            '}';
    }
}
