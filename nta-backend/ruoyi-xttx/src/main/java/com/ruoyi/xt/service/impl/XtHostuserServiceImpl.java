package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtHostuser;
import com.ruoyi.xt.mapper.XtHostuserMapper;
import com.ruoyi.xt.service.IXtHostuserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 用户信息Service业务层处理
 *
 * @author zz
 * @date 2021-09-05
 */
@Service
public class XtHostuserServiceImpl implements IXtHostuserService {
    @Autowired
    private XtHostuserMapper xtHostuserMapper;

    /**
     * 查询用户信息
     *
     * @param userId 用户信息主键
     * @return 用户信息
     */
    @Override
    public XtHostuser selectXtHostuserByUserId(String userId) {
        return xtHostuserMapper.selectXtHostuserByUserId(userId);
    }

    /**
     * 查询用户信息列表
     *
     * @param xtHostuser 用户信息
     * @return 用户信息
     */
    @Override
    public List<XtHostuser> selectXtHostuserList(XtHostuser xtHostuser) {
        return xtHostuserMapper.selectXtHostuserList(xtHostuser);
    }

    /**
     * 新增用户信息
     *
     * @param xtHostuser 用户信息
     * @return 结果
     */
    @Override
    public int insertXtHostuser(XtHostuser xtHostuser) {
        return xtHostuserMapper.insertXtHostuser(xtHostuser);
    }

    /**
     * 修改用户信息
     *
     * @param xtHostuser 用户信息
     * @return 结果
     */
    @Override
    public int updateXtHostuser(XtHostuser xtHostuser) {
        return xtHostuserMapper.updateXtHostuser(xtHostuser);
    }

    /**
     * 批量删除用户信息
     *
     * @param userIds 需要删除的用户信息主键
     * @return 结果
     */
    @Override
    public int deleteXtHostuserByUserIds(String[] userIds) {
        return xtHostuserMapper.deleteXtHostuserByUserIds(userIds);
    }

    /**
     * 删除用户信息信息
     *
     * @param userId 用户信息主键
     * @return 结果
     */
    @Override
    public int deleteXtHostuserByUserId(String userId) {
        return xtHostuserMapper.deleteXtHostuserByUserId(userId);
    }
}
