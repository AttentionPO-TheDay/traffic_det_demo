package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.XtSensor;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/21/21 05:06
 * @Description:
 */
public interface XtSensorService {

    /**
     * 返回所有sensor
     *
     * @param
     * @return 结果
     */
    public List<XtSensor> selectXtSensorList();

    /**
     * 获取ID指向的XtSensor
     *
     * @param
     * @return 结果
     */
    public XtSensor selectXtSensorById(Integer id);


    public XtSensor selectXtSensorBySensorName(String name);
}
