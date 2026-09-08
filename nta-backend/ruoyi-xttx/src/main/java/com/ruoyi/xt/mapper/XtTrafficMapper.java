package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtTraffic;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 流量总Mapper接口
 *
 * @author ruoyi
 * @date 2021-09-26
 */
@Mapper
public interface XtTrafficMapper {
    /**
     * 查询流量总
     *
     * @param uid 流量总主键
     * @return 流量总
     */
    public XtTraffic selectXtTrafficByUid(String uid);

    /**
     * 查询流量总列表
     *
     * @param xtTraffic 流量总
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficList(XtTraffic xtTraffic);

    /**
     * 查询流量总列表
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByThreatenBiggerThanZero(Integer handle);

    public List<String> selectXtTrafficByTypeAndHostName(@Param("hostName") String hostName, @Param("type") String type);

    public List<XtTraffic> selectXtTrafficByHostNameAndType(@Param("hostName") String hostName, @Param("type") String type, @Param("timestamp") String timestamp);

    public List<Map<String, Object>> selectThreatenHostInScope(@Param("num1") int num1, @Param("num2") int num2);


    /**
     * 根据负责人id查询负责的机器，根据数量进行排序
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByHostAndOwner(@Param("ownerId") String ownerId);

    /**
     * 查询收到攻击的host，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByHost();

    /**
     * 查询收到攻击的type，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByType(@Param("hostName") String hostName);


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     *
     * @param
     * @return 流量总集合
     */
    public List<String> selectXtTrafficByHost(@Param("hostid") String hostId, @Param("trendTop") Integer trendTop);


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据 查询时间戳
     *
     * @param
     * @return 流量总集合
     */
    public List<String> selectXtTrafficTimestampByType(@Param("hostid") String hostId, @Param("type") String type);


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     *
     * @param
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByHostAndType(@Param("hostid") String hostId, @Param("type") String type, @Param("timestamp") String timestamp);

    /**
     * 查询流量总列表
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByOwner(@Param("ownerid") String ownerId, @Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handle") Integer handle);

    /**
     * 新增流量总
     *
     * @param xtTraffic 流量总
     * @return 结果
     */
    public int insertXtTraffic(XtTraffic xtTraffic);

    /**
     * 修改流量总
     *
     * @param xtTraffic 流量总
     * @return 结果
     */
    public int updateXtTraffic(XtTraffic xtTraffic);

    /**
     * 删除流量总
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public int deleteXtTrafficByUid(String uid);

    /**
     * 批量删除流量总
     *
     * @param uids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteXtTrafficByUids(String[] uids);

    /**
     * 查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenNotHandled(@Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handle") Integer handled);


    /**
     * 查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenHandled(@Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handle") Integer handled);

    /**
     * 查询所有流量详情，所有解决的未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreaten(@Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp);

    /**
     * 根据HostId查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdHandled(@Param("hostname") String hostname, @Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handled") Integer handled, @Param("num") Integer num);

    /**
     * 根据HostId查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdNotHandled(@Param("hostname") String hostname, @Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handled") Integer handled, @Param("num") Integer num);

    /**
     * 根据HostId查询所有流量详情，不管解决的还是没有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostId(@Param("hostname") String hostname, @Param("name") String name, @Param("type") String type, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("num") Integer num);
}
