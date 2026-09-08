package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.AssetDiscoverRecord;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface AssetDiscoverService {

    public int insertAssetDiscoverRecord(AssetDiscoverRecord assetDiscoverRecord);

    public int updateAssetDiscoverRecord(AssetDiscoverRecord assetDiscoverRecord);

    public List<AssetDiscoverRecord> getAssetDiscoverRecord(Long minTimestamp, Long maxTimestamp);

    public List<String> getAssetDiscoverRecordById(int id);
}
