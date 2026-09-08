package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtHost;
import com.ruoyi.xt.mapper.XtHostMapper;
import com.ruoyi.xt.service.IXtHostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 主机Service业务层处理
 *
 * @author ruoyi
 * @date 2021-09-06
 */
@Service
public class XtHostServiceImpl implements IXtHostService {
    @Autowired
    private XtHostMapper xtHostMapper;

    /**
     * 查询主机
     *
     * @param hostid 主机主键
     * @return 主机
     */
    @Override
    public XtHost selectXtHostByHostid(String hostid) {
        return xtHostMapper.selectXtHostByHostid(hostid);
    }

    /**
     * 查询主机列表
     *
     * @param xtHost 主机
     * @return 主机
     */
    @Override
    public List<XtHost> selectXtHostList(XtHost xtHost) {
        return xtHostMapper.selectXtHostList(xtHost);
    }

    /**
     * 新增主机
     *
     * @param xtHost 主机
     * @return 结果
     */
    @Override
    public int insertXtHost(XtHost xtHost) {
        return xtHostMapper.insertXtHost(xtHost);
    }

    /**
     * 新增主机
     *
     * @param xtHosts 主机
     * @return 结果
     */
    @Override
    public int insertXtHosts(List<XtHost> xtHosts) {
        return xtHostMapper.insertXtHosts(xtHosts);
    }

    /**
     * 修改主机
     *
     * @param xtHost 主机
     * @return 结果
     */
    @Override
    public int updateXtHost(XtHost xtHost) {
        return xtHostMapper.updateXtHost(xtHost);
    }

    /**
     * 批量删除主机
     *
     * @param hostids 需要删除的主机主键
     * @return 结果
     */
    @Override
    public int deleteXtHostByHostids(String[] hostids) {
        return xtHostMapper.deleteXtHostByHostids(hostids);
    }

    /**
     * 删除主机信息
     *
     * @param hostid 主机主键
     * @return 结果
     */
    @Override
    public int deleteXtHostByHostid(String hostid) {
        return xtHostMapper.deleteXtHostByHostid(hostid);
    }
}
