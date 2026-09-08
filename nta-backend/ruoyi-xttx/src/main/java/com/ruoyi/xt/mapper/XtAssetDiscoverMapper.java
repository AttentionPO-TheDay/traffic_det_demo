package com.ruoyi.xt.mapper;

import com.ruoyi.xt.domain.AssetDiscoverRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface XtAssetDiscoverMapper {
    public int insertXtAssetHistory(AssetDiscoverRecord assetDiscoverRecord);

    public int updateXtAssetHistory(AssetDiscoverRecord assetDiscoverRecord);

    public List<AssetDiscoverRecord> getAssetDiscoverHistory(@Param("minTimestamp") Long minTimestamp, @Param("maxTimestamp") Long maxTimestamp);

    public List<String> getAssetDiscoverHistoryById(@Param("id") int id);
}
