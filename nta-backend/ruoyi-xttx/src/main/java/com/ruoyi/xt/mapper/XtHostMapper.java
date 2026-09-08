package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtHost;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 主机Mapper接口
 *
 * @author ruoyi
 * @date 2021-09-06
 */
@Mapper
public interface XtHostMapper {
    /**
     * 查询主机
     *
     * @param hostid 主机主键
     * @return 主机
     */
    public XtHost selectXtHostByHostid(String hostid);

    /**
     * 查询主机列表
     *
     * @param xtHost 主机
     * @return 主机集合
     */
    public List<XtHost> selectXtHostList(XtHost xtHost);

    /**
     * 新增主机
     *
     * @param xtHost 主机
     * @return 结果
     */
    public int insertXtHost(XtHost xtHost);

    /**
     * 批量新增主机
     *
     * @param xtHosts 主机
     * @return 结果
     */
    public int insertXtHosts(List<XtHost> xtHosts);

    /**
     * 修改主机
     *
     * @param xtHost 主机
     * @return 结果
     */
    public int updateXtHost(XtHost xtHost);

    /**
     * 删除主机
     *
     * @param hostid 主机主键
     * @return 结果
     */
    public int deleteXtHostByHostid(String hostid);

    /**
     * 批量删除主机
     *
     * @param hostids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteXtHostByHostids(String[] hostids);
}
