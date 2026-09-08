package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtPcap;
import com.ruoyi.xt.mapper.XtPcapMapper;
import com.ruoyi.xt.service.XtPcapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class XtPcapServiceImpl implements XtPcapService {
    @Autowired
    private XtPcapMapper xtPcapMapper;

    /**
     * 新增pcap记录
     *
     * @param xtPcap pcap类
     * @return 结果
     */
    @Override
    public int insertXtPcap(XtPcap xtPcap) {
        return xtPcapMapper.insertXtPcap(xtPcap);
    }

    /**
     * 返回所有pcap
     *
     * @param
     * @return 结果
     */
    @Override
    public List<XtPcap> selectXtPcapList() {
        return xtPcapMapper.selectXtPcapList();
    }
}
