package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtHostuser;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 用户信息Mapper接口
 *
 * @author zz
 * @date 2021-09-05
 */
@Mapper
public interface XtHostuserMapper {
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
     * 删除用户信息
     *
     * @param userId 用户信息主键
     * @return 结果
     */
    public int deleteXtHostuserByUserId(String userId);

    /**
     * 批量删除用户信息
     *
     * @param userIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteXtHostuserByUserIds(String[] userIds);
}
