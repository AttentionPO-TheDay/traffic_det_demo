package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.XtHostuser;

import java.util.List;

/**
 * 用户信息Service接口
 *
 * @author zz
 * @date 2021-09-05
 */
public interface IXtHostuserService {
    /**
     * 查询用户信息
     *
     * @param userId 用户信息主键
     * @return 用户信息
     */
    public XtHostuser selectXtHostuserByUserId(String userId);

    /**
     * 查询用户信息列表
     *
     * @param xtHostuser 用户信息
     * @return 用户信息集合
     */
    public List<XtHostuser> selectXtHostuserList(XtHostuser xtHostuser);

    /**
     * 新增用户信息
     *
     * @param xtHostuser 用户信息
     * @return 结果
     */
    public int insertXtHostuser(XtHostuser xtHostuser);

    /**
     * 修改用户信息
     *
     * @param xtHostuser 用户信息
     * @return 结果
     */
    public int updateXtHostuser(XtHostuser xtHostuser);

    /**
     * 批量删除用户信息
     *
     * @param userIds 需要删除的用户信息主键集合
     * @return 结果
     */
    public int deleteXtHostuserByUserIds(String[] userIds);

    /**
     * 删除用户信息信息
     *
     * @param userId 用户信息主键
     * @return 结果
     */
    public int deleteXtHostuserByUserId(String userId);
}
