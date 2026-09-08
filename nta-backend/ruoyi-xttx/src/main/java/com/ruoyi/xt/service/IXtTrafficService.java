package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.XtTraffic;

import java.util.List;
import java.util.Map;

/**
 * 流量总Service接口
 *
 * @author ruoyi
 * @date 2021-09-26
 */
public interface IXtTrafficService {
    /**
     * 查询流量总
     *
     * @param uid 流量总主键
     * @return 流量总
     */
    public XtTraffic selectXtTrafficByUid(String uid);

    /**
     * 查询流量大于或者小于威胁数量的机器列表
     *
     * @param
     * @return 流量总集合
     */
    public List<Map<String, Object>> selectThreatenHostInScope(int num1, int num2);

    /**
     * 查询流量总列表
     *
     * @param xtTraffic 流量总
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficList(XtTraffic xtTraffic);

    /**
     * 查询收到攻击的host，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByHost();

    /**
     * 根据负责人id查询负责的机器，根据数量进行排序
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByHostAndOwner(String ownerId);

    /**
     * 查询收到攻击的Type，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByType(String hostName);

    /**
     * 查询流量总列表
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByThreatenBiggerThanZero(Integer handle);

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficByHost(String hostId, Integer trendTop);


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Host查询
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByHostAndType(String hostId, String type, String timestamp);

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Host查询时间戳
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficTimestampByType(String hostId, String type);

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Hostname查询时间戳
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficTimestampByTypeAndHostName(String hostName, String type);

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Hostname查询所有数量
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByHostNameAndType(String hostName, String type, String timestamp);

    /**
     * 根据Owner查询流量情况
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByOwner(String ownerId, String name, String type, String minTimestamp, String maxTimestamp, Integer handle);

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
     * 批量删除流量总
     *
     * @param uids 需要删除的流量总主键集合
     * @return 结果
     */
    public int deleteXtTrafficByUids(String[] uids);

    /**
     * 删除流量总信息
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public int deleteXtTrafficByUid(String uid);

    /**
     * 查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenHandled(String name, String type, String minTimestamp, String maxTimestamp, Integer handled);

    /**
     * 查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenNotHandled(String name, String type, String minTimestamp, String maxTimestamp, Integer handled);

    /**
     * 查询所有流量详情，不管解决的还是没有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreaten(String name, String type, String minTimestamp, String maxTimestamp);


    /**
     * 根据HostId查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdHandled(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer handled, Integer num);

    /**
     * 根据HostId查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdNotHandled(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer handled, Integer num);

    /**
     * 根据HostId查询所有流量详情，不管解决的还是没有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostId(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer num);
}
