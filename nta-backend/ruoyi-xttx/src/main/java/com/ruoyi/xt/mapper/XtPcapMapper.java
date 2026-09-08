package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.XtPcap;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface XtPcapMapper {
    /**
     * 返回所有pcap
     *
     * @param
     * @return 结果
     */
    public List<XtPcap> selectXtPcapList();

    /**
     * 新增
     *
     * @param xtPcap pcap类
     * @return 结果
     */
    public int insertXtPcap(XtPcap xtPcap);
}
