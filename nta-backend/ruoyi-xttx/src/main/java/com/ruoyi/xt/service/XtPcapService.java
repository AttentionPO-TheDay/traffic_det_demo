package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.XtPcap;

import java.util.List;

/**
 * @Auther: sinrotic
 * @Date: 05/15/25 14:45
 * @Description:
 */

public interface XtPcapService {
    /**
     * 新增pcap记录
     *
     * @param xtPcap pcap类
     * @return 结果
     */
    public int insertXtPcap(XtPcap xtPcap);

    /**
     * 返回所有pcap
     *
     * @param
     * @return 结果
     */
    public List<XtPcap> selectXtPcapList();
}
