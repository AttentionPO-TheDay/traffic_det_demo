package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.XtMetaData;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/18/21 06:03
 * @Description:
 */
public interface XtMetaDataService {
    /**
     * 根据uid查询元数据表
     *
     * @param uid
     * @return
     */
    public XtMetaData selectXtMetaDataByUid(String uid);

    /**
     * 查询udp表列表
     *
     * @param xtMetaData 源数据类
     * @return metadata表集合
     */
    public List<XtMetaData> selectXtMetaDataList(XtMetaData xtMetaData);

    /**
     * 新增udp表
     *
     * @param xtMetaData 源数据类
     * @return 结果
     */
    public int insertXtMetaData(XtMetaData xtMetaData);

    /**
     * 修改udp表
     *
     * @param xtMetaData 源数据类
     * @return 结果
     */
    public int updateXtMetaData(XtMetaData xtMetaData);

    /**
     * 批量删除udp表
     *
     * @param uids 需要删除的metadata表主键集合
     * @return 结果
     */
    public int deleteXtMetaDataByUids(String[] uids);

    /**
     * 删除udp表信息
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public int deleteXtMetaDataByUid(String uid);

    /**
     * 返回所有加密的流量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsEncryptedXtMetaDataList(int isEncrypted);

    /**
     * 返回所有加密的流量,不包含Metadata
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsEncryptedXtMetaDataListWithoutMetadata(Integer isEncrypted, Integer srcPort, Integer dstPort);

    /**
     * 返回所有不加密的流量,不包含Metadata
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public List<XtMetaData> selectIsNotEncryptedXtMetaDataListWithoutMetadata(Integer isEncrypted, Integer srcPort, Integer dstPort);

    /**
     * 根据是否加密加密的流量,返回符合条件的元数据的数量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public int selectXtMetadataNumWithEncrypted(Integer isEncrypted, Integer srcPort, Integer dstPort);


    /**
     * 返回符合条件的元数据的数量
     *
     * @param uid metadata表主键
     * @return 结果
     */
    public int selectXtMetadataNum(Integer srcPort, Integer dstPort);
}
