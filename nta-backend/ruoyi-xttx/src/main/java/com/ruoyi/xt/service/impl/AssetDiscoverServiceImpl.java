package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.AssetDiscoverRecord;
import com.ruoyi.xt.mapper.XtAssetDiscoverMapper;
import com.ruoyi.xt.service.AssetDiscoverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AssetDiscoverServiceImpl implements AssetDiscoverService {

    @Autowired
    private XtAssetDiscoverMapper xtAssetDiscoverMapper;

    @Override
    public int insertAssetDiscoverRecord(AssetDiscoverRecord assetDiscoverRecord) {
        int i = xtAssetDiscoverMapper.insertXtAssetHistory(assetDiscoverRecord);
        return i;
    }

    @Override
    public int updateAssetDiscoverRecord(AssetDiscoverRecord assetDiscoverRecord) {
        return xtAssetDiscoverMapper.updateXtAssetHistory(assetDiscoverRecord);
    }

    @Override
    public List<AssetDiscoverRecord> getAssetDiscoverRecord(Long minTimestamp, Long maxTimestamp) {
        return xtAssetDiscoverMapper.getAssetDiscoverHistory(minTimestamp, maxTimestamp);
    }

    @Override
    public List<String> getAssetDiscoverRecordById(int id) {
        return xtAssetDiscoverMapper.getAssetDiscoverHistoryById(id);
    }
}
