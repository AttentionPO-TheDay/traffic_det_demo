package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtThreat;
import com.ruoyi.xt.domain.XtThreatNum;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/19/21 05:01
 * @Description:
 */
@Mapper
public interface XtThreatMapper {
    /**
     * 根据受威胁的host 来排序 返回 hostname
     *
     * @param
     * @return 流量总
     */

    public List<String> selectThreatGroupByHost();

    /**
     * 新增
     *
     * @param xtThreat 源数据类
     * @return 结果
     */
    public int insertXtThreat(XtThreat xtThreat);


    /**
     * 根据id查询威胁数量
     *
     * @param hostId hostid
     * @return 结果
     */
    public int selectThreatNumByHostId(@Param("hostId") String hostId);

    /**
     * 根据name排序，返回前n个
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatGroupByName();

    /**
     * 根据name排序，返回所有的时间表
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatDateByName(String name);

    /**
     * 根据name和date，返回threat的个数
     *
     * @param
     * @return 结果
     */

    public int selectThreatDateByNameAndDate(@Param("name") String name, @Param("date") String date);

    /**
     * 根据hostID，返回threat的name，按照个数从高到低排序
     *
     * @param
     * @return 结果
     */

    public List<String> selectThreatGroupByNameAndHost(@Param("hostId") String hostId);


    /**
     * 根据hostID和name，返回threat的time的List
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatDateByNameAndHostId(@Param("name") String name, @Param("hostId") String hostId);


    /**
     * 根据hostID和name以及Date，返回threat的个数
     *
     * @param
     * @return 结果
     */
    public List<XtThreatNum> selectThreatNumByNameAndDateAndHostId(@Param("name") String name, @Param("hostId") String hostId);

    /**
     * 根据hostIDList 返回属于这个的thratName的个数，按照大小排序从高到低
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatGroupByNameAndHostList(@Param("hostIdList") List<String> hostIdList);

    /**
     * 根据hostIDList and thratname 返回时间 ymd的格式
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatDateByNameAndHostIdList(@Param("name") String name, @Param("hostIdList") List<String> hostIdList);

    /**
     * 根据hostIDList and thratname date 返回符合条件的个数
     *
     * @param
     * @return 结果
     */
    public List<XtThreatNum> selectThreatNumByNameAndDateAndHostIdList(@Param("name") String name, @Param("hostIdList") List<String> hostIdList);

    /**
     * 范围查询威胁数量 【】
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatHostIdGroupByHostInScope(@Param("minThreatNum") Integer minThreatNum, @Param("maxThreatNum") Integer maxThreatNum);

    /**
     * 查询所有满足条件的威胁
     *
     * @param
     * @return 结果
     */
    public List<XtThreat> selectThreatDetailByHandle(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handled") int handled);

    /**
     * 查询所有满足条件的威胁
     *
     * @param
     * @return 结果
     */
    public List<XtThreat> selectThreatDetailNotHandle(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp);

    /**
     * 根据threatId返回threta
     *
     * @param
     * @return 结果
     */
    public XtThreat selectThreatByThreatId(@Param("threatId") Integer threatId);

    /**
     * 查询某台机器上所有满足条件的威胁
     *
     * @param
     * @return 结果
     */
    public List<XtThreat> selectThreatDetailByHandleWithHostId(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handled") int handled, @Param("hostId") String hostId);

    /**
     * 查询某台机器上所有满足条件的威胁
     *
     * @param
     * @return 结果
     */
    public List<XtThreat> selectThreatDetailNotHandleWithHostId(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("hostId") String hostId);

    /**
     * 更新Threat状态
     *
     * @param
     * @return 结果
     */
    public int updateThreatStatus(@Param("threatId") Integer threatId, @Param("handle") int handle);

    /**
     * 获取所有threat的类别
     *
     * @param
     * @return 结果
     */
    public List<String> selectThreatName();


    /**
     * 查寻所有满足条件已经解决的总数
     *
     * @param
     * @return 结果
     */
    public int selectThreatDetailNumByHandle(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handle") int handled);


    /**
     * 查寻所有满足条件没有解决的总数
     *
     * @param
     * @return 结果
     */
    public int selectThreatDetailNumNotHandle(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp);


    /**
     * 根据hostid查寻所有满足条件没有解决的总数
     *
     * @param
     * @return 结果
     */
    public int selectThreatDetailNumByHandleWithHostId(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("handle") int handled, @Param("hostId") String hostId);

    /**
     * 根据hostid查寻所有没有满足条件没有解决的总数
     *
     * @param
     * @return 结果
     */
    public int selectThreatDetailNumNotHandleWithHostId(@Param("name") String name, @Param("source") String source, @Param("minTimestamp") String minTimestamp, @Param("maxTimestamp") String maxTimestamp, @Param("hostId") String hostId);

    /**
     * 查询所有满足hostid的个数
     *
     * @param
     * @return 结果
     */
    public List<Integer> selectHostInScopeGroupByHostId(@Param("minThreatNum") Integer minThreatNum, @Param("maxThreatNum") Integer maxThreatNum);
}
