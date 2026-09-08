package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.domain.XtMetaData;
import com.ruoyi.xt.mapper.XtMetaDataMapper;
import com.ruoyi.xt.service.XtMetaDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/18/21 06:18
 * @Description:
 */

@Service
public class XtMetaDataImpl implements XtMetaDataService {

    @Autowired
    private XtMetaDataMapper xtMetaDataMapper;

    /**
     * 根据uid查询元数据表
     *
     * @param uid
     * @return
     */
    @Override
    public XtMetaData selectXtMetaDataByUid(String uid) {
        return xtMetaDataMapper.selectXtMetaDataByUid(uid);
    }

    /**
     * 查询udp表列表
     *
     * @param xtMetaData 源数据类
     * @return metadata表集合
     */
    @Override
    public List<XtMetaData> selectXtMetaDataList(XtMetaData xtMetaData) {
        return xtMetaDataMapper.selectXtMetaDataList(xtMetaData);
    }

    /**
     * 新增udp表
     *
     * @param xtMetaData 源数据类
     * @return 结果
     */
    @Override
    public int insertXtMetaData(XtMetaData xtMetaData) {
        return xtMetaDataMapper.insertXtMetaData(xtMetaData);
    }

    /**
     * 修改udp表
     *
     * @param xtMetaData 源数据类
     * @return 结果
     */
    @Override
    public int updateXtMetaData(XtMetaData xtMetaData) {
        return xtMetaDataMapper.updateXtMetaData(xtMetaData);
    }

    /**
     * 批量删除udp表
     *
     * @param uids 需要删除的metadata表主键集合
     * @return 结果
     */
    @Override
    public int deleteXtMetaDataByUids(String[] uids) {
        return xtMetaDataMapper.deleteXtMetaDataByUids(uids);
    }

    /**
     * 删除udp表信息
     *
     * @param uid metadata表主键
     * @return 结果
     */
    @Override
    public int deleteXtMetaDataByUid(String uid) {
        return xtMetaDataMapper.deleteXtMetaDataByUid(uid);
    }


    /**
     * 返回所有加密的流量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsEncryptedXtMetaDataList(int isEncrypted) {
        return xtMetaDataMapper.selectIsEncryptedXtMetaDataList(isEncrypted);
    }

    /**
     * 返回所有加密的流量,不包含Metadata
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsEncryptedXtMetaDataListWithoutMetadata(Integer isEncrypted, Integer srcPort, Integer dstPort) {
        return xtMetaDataMapper.selectIsEncryptedXtMetaDataListWithoutMetadata(isEncrypted, srcPort, dstPort);
    }

    /**
     * 返回所有不加密的流量,不包含Metadata
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsNotEncryptedXtMetaDataListWithoutMetadata(Integer isEncrypted, Integer srcPort, Integer dstPort) {
        return xtMetaDataMapper.selectIsNotEncryptedXtMetaDataListWithoutMetadata(isEncrypted, srcPort, dstPort);
    }

    /**
     * 根据是否加密加密的流量,返回符合条件的元数据的数量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public int selectXtMetadataNumWithEncrypted(Integer isEncrypted, Integer srcPort, Integer dstPort) {
        return xtMetaDataMapper.selectXtMetadataNumWithEncrypted(isEncrypted, srcPort, dstPort);
    }


    /**
     * 返回符合条件的元数据的数量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public int selectXtMetadataNum(Integer srcPort, Integer dstPort) {
        return xtMetaDataMapper.selectXtMetadataNum(srcPort, dstPort);
    }
}
