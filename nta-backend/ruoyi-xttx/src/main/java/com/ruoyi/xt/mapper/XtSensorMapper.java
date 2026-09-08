package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtSensor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/21/21 05:05
 * @Description:
 */

@Mapper
public interface XtSensorMapper {

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
    public XtSensor selectXtSensorById(@Param("id") Integer id);


    public XtSensor selectXtSensorBySensorName(@Param("name") String name);
}
