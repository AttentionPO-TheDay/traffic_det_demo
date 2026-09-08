package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtTraffic;
import com.ruoyi.xt.mapper.XtTrafficMapper;
import com.ruoyi.xt.service.IXtTrafficService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 流量总Service业务层处理
 *
 * @author ruoyi
 * @date 2021-09-26
 */
@Service
public class XtTrafficServiceImpl implements IXtTrafficService {
    @Autowired
    private XtTrafficMapper xtTrafficMapper;

    /**
     * 查询流量总
     *
     * @param uid 流量总主键
     * @return 流量总
     */
    @Override
    public XtTraffic selectXtTrafficByUid(String uid) {
        return xtTrafficMapper.selectXtTrafficByUid(uid);
    }

    /**
     * 查询威胁流量
     *
     * @param handle 解决状况
     * @return 流量总
     */
    @Override
    public List<XtTraffic> selectXtTrafficByThreatenBiggerThanZero(Integer handle) {
        return xtTrafficMapper.selectXtTrafficByThreatenBiggerThanZero(handle);
    }

    /**
     * 查询流量大于或者小于威胁数量的机器列表
     *
     * @param
     * @return 流量总集合
     */
    public List<Map<String, Object>> selectThreatenHostInScope(int num1, int num2) {
        return xtTrafficMapper.selectThreatenHostInScope(num1, num2);

    }

    /**
     * 根据负责人id查询负责的机器，根据数量进行排序
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficGroupByHostAndOwner(String ownerId) {
        return xtTrafficMapper.selectXtTrafficGroupByHostAndOwner(ownerId);
    }

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Hostname查询时间戳
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficTimestampByTypeAndHostName(String hostName, String type) {
        return xtTrafficMapper.selectXtTrafficByTypeAndHostName(hostName, type);
    }

    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Hostname查询所有数量
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<XtTraffic> selectXtTrafficByHostNameAndType(String hostName, String type, String timestamp) {
        return xtTrafficMapper.selectXtTrafficByHostNameAndType(hostName, type, timestamp);
    }

    /**
     * 查询收到攻击的host，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    @Override
    public List<String> selectXtTrafficGroupByHost() {
        return xtTrafficMapper.selectXtTrafficGroupByHost();
    }


    /**
     * 查询收到攻击的type，按照数量排列
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    @Override
    public List<String> selectXtTrafficGroupByType(String hostName) {
        return xtTrafficMapper.selectXtTrafficGroupByType(hostName);
    }


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    @Override
    public List<String> selectXtTrafficByHost(String hostId, Integer trendTop) {
        return xtTrafficMapper.selectXtTrafficByHost(hostId, trendTop);
    }


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据：根据Type和Host查询时间戳
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    public List<String> selectXtTrafficTimestampByType(String hostId, String type) {
        return xtTrafficMapper.selectXtTrafficTimestampByType(hostId, type);
    }


    /**
     * 询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     *
     * @param handle 流量威胁情况
     * @return 流量总集合
     */
    @Override
    public List<XtTraffic> selectXtTrafficByHostAndType(String hostId, String type, String timestamp) {
        return xtTrafficMapper.selectXtTrafficByHostAndType(hostId, type, timestamp);
    }


    /**
     * 根据Owner查询威胁情况
     *
     * @param handle 解决状况
     * @return 流量总
     */
    @Override
    public List<XtTraffic> selectXtTrafficByOwner(String ownerId, String name, String type, String minTimestamp, String maxTimestamp, Integer handle) {
        return xtTrafficMapper.selectXtTrafficByOwner(ownerId, name, type, minTimestamp, maxTimestamp, handle);
    }

    /**
     * 查询流量总列表
     *
     * @param xtTraffic 流量总
     * @return 流量总
     */
    @Override
    public List<XtTraffic> selectXtTrafficList(XtTraffic xtTraffic) {
        return xtTrafficMapper.selectXtTrafficList(xtTraffic);
    }

    /**
     * 新增流量总
     *
     * @param xtTraffic 流量总
     * @return 结果
     */
    @Override
    public int insertXtTraffic(XtTraffic xtTraffic) {
        return xtTrafficMapper.insertXtTraffic(xtTraffic);
    }

    /**
     * 修改流量总
     *
     * @param xtTraffic 流量总
     * @return 结果
     */
    @Override
    public int updateXtTraffic(XtTraffic xtTraffic) {
        return xtTrafficMapper.updateXtTraffic(xtTraffic);
    }

    /**
     * 批量删除流量总
     *
     * @param uids 需要删除的流量总主键
     * @return 结果
     */
    @Override
    public int deleteXtTrafficByUids(String[] uids) {
        return xtTrafficMapper.deleteXtTrafficByUids(uids);
    }

    /**
     * 删除流量总信息
     *
     * @param uid 流量总主键
     * @return 结果
     */
    @Override
    public int deleteXtTrafficByUid(String uid) {
        return xtTrafficMapper.deleteXtTrafficByUid(uid);
    }


    //

    /**
     * 查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenHandled(String name, String type, String minTimestamp, String maxTimestamp, Integer handled) {
        return xtTrafficMapper.selectXtTrafficGetAllThreatenHandled(name, type, minTimestamp, maxTimestamp, handled);
    }

    /**
     * 查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreatenNotHandled(String name, String type, String minTimestamp, String maxTimestamp, Integer handled) {
        return xtTrafficMapper.selectXtTrafficGetAllThreatenNotHandled(name, type, minTimestamp, maxTimestamp, handled);
    }

    /**
     * 查询所有流量详情，所有未解决的解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficGetAllThreaten(String name, String type, String minTimestamp, String maxTimestamp) {
        return xtTrafficMapper.selectXtTrafficGetAllThreaten(name, type, minTimestamp, maxTimestamp);
    }

    /**
     * 根据HostId查询所有流量详情，所有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdHandled(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer handled, Integer num) {
        return xtTrafficMapper.selectXtTrafficByHostIdHandled(hostname, name, type, minTimestamp, maxTimestamp, handled, num);
    }

    /**
     * 根据HostId查询所有流量详情，所有未解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostIdNotHandled(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer handled, Integer num) {
        return xtTrafficMapper.selectXtTrafficByHostIdNotHandled(hostname, name, type, minTimestamp, maxTimestamp, handled, num);
    }

    /**
     * 根据HostId查询所有流量详情，不管解决的还是没有解决的
     *
     * @param uid 流量总主键
     * @return 结果
     */
    public List<XtTraffic> selectXtTrafficByHostId(String hostname, String name, String type, String minTimestamp, String maxTimestamp, Integer num) {
        return xtTrafficMapper.selectXtTrafficByHostId(hostname, name, type, minTimestamp, maxTimestamp, num);
    }
}
