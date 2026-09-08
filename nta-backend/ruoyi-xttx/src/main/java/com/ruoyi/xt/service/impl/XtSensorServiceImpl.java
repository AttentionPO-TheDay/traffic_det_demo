package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtSensor;
import com.ruoyi.xt.mapper.XtSensorMapper;
import com.ruoyi.xt.service.XtSensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/21/21 05:05
 * @Description:
 */
@Service
public class XtSensorServiceImpl implements XtSensorService {
    @Autowired
    private XtSensorMapper xtSensorMapper;


    /**
     * 返回所有sensor
     *
     * @param
     * @return 结果
     */
    public List<XtSensor> selectXtSensorList() {
        return xtSensorMapper.selectXtSensorList();
    }


    /**
     * 获取ID指向的XtSensor
     *
     * @param
     * @return 结果
     */
    public XtSensor selectXtSensorById(Integer id) {
        return xtSensorMapper.selectXtSensorById(id);
    }


    public XtSensor selectXtSensorBySensorName(String name) {
        return xtSensorMapper.selectXtSensorBySensorName(name);
    }

}
