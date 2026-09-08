package com.ruoyi.xt.service.impl;

import com.alibaba.fastjson.JSON;
import com.ruoyi.xt.domain.*;
import com.ruoyi.xt.domain.template.LabelConfidence;
import com.ruoyi.xt.service.IXtHostService;
import com.ruoyi.xt.service.IXtHostuserService;
import com.ruoyi.xt.service.XtMetaDataService;
import com.ruoyi.xt.service.XtThreatService;
import com.ruoyi.xt.util.EsUtil;
import org.elasticsearch.action.get.GetRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/28/21 00:50
 * @Description:
 */

@Component
public class ConsumeSingle {
    @Autowired
    XtMetaDataService xtMetaDataService;

    @Autowired
    XtThreatService xtThreatService;

    @Autowired
    EsUtil esUtil;

    @Autowired
    IXtHostService xtHostService;

    @Autowired
    IXtHostuserService xtHostuserService;

    @Autowired
    XtSensorServiceImpl xtSensorService;

    @Autowired
    XtThreatService xtThreatServicel;

    //    @Async
    public void consumeMessage(String data, Map<String, Object> dataMap, String uid, String timestamp, String zeekName) {
        XtMetaData xtMetaData = new XtMetaData();
        Map<String, String> ipList = null;
        Map<String, Integer> portList = null;
        String src = "";
        String dst = "";
        if (dataMap.get("tcp") != null) {
            // getPortFromTcp
            portList = getPortFromTcp((Map<String, Object>) dataMap.get("tcp"));
            // getIPAddressFromIp
            ipList = getIpAddressFromIp((Map<String, Object>) dataMap.get("ip"));
        } else if (dataMap.get("udp") != null) {
            // getPortFromUdp
            portList = getPortFromUdp((Map<String, Object>) dataMap.get("udp"));
            // getIPAddressFromIp
            ipList = getIpAddressFromIp((Map<String, Object>) dataMap.get("ip"));
        } else if (dataMap.get("ip") != null) {
            ipList = getIpAddressFromIp((Map<String, Object>) dataMap.get("ip"));
        }
        if (portList != null) {
            xtMetaData.setDstPort(portList.get("dst"));
            xtMetaData.setSrcPort(portList.get("src"));
        }

        if (ipList != null) {
            xtMetaData.setSrcIp(ipList.get("src"));
            src = ipList.get("src");
            xtMetaData.setDstIp(ipList.get("dst"));
            dst = ipList.get("dst");
        }
        boolean isEncrypted = false;
        if (dataMap.get("ssl") != null || dataMap.get("ssh") != null || dataMap.get("ipsec") != null) {
            isEncrypted = true;
        }
        if (isEncrypted) {
            xtMetaData.setIsEncrypted(1);
        } else {
            xtMetaData.setIsEncrypted(0);
        }
        xtMetaData.setUid(uid);

        if (timestamp != null) {
            xtMetaData.setTimestamp(timestamp);
        }
        xtMetaData.setMetadata(data);

        xtMetaDataService.insertXtMetaData(xtMetaData);
        if (src.equals("74.48.83.221") || dst.equals("74.48.83.221")) {
            return;
        }

        //        return xtMetaData;

        Map<String, Object> zeekNameMap = new HashMap<>();
        zeekNameMap.put("zeekname", zeekName);
        esUtil.updateThreate("test-traffic", uid, zeekNameMap);
//        List<Object> sendMsgValue = getVectorData(dataMap);
//        Map<String, Object> sendMsg = new HashMap<>();
//        sendMsg.put("vector", sendMsgValue);
//        sendMsg.put("uid", uid);

//        AiModel aiModel = new AiModel();
//        List<XtThreat> modelResList = aiModel.sendVector(sendMsg, xtMetaData.getSrcIp(), xtMetaData.getDstIp(), xtMetaData.getSrcPort(), xtMetaData.getDstPort(), timestamp, hostId);
    }

//    @Async
    public void consumeMessage(AnalyseResult analyseResult, String uid, String zeekName) {
        // getHostId
        String hostId = getHostId(zeekName);

        /*
            {
                "uid": "123",
                "model_name": "CNN",
                "model_id": "model_001",
                "classification_result": [
                    {
                        "label": "cat",
                        "confidence": 0.95
                    },
                    {
                        "label": "dog",
                        "confidence": 0.87
                    }
                ]
            }
        */
        identify_threat(analyseResult, uid, hostId);
        esUtil.appendToArray("test-traffic", uid, "analyse_results", analyseResult);
        
        Map<String, Object> handledMap = new HashMap<>();
        handledMap.put("handled", false);
        esUtil.updateThreate("test-traffic", uid, handledMap);

        updateHostInfoInES(hostId, uid);
    }

    public String getHostId(String zeekName) {
        XtSensor xtSensor = xtSensorService.selectXtSensorBySensorName(zeekName);
        return xtSensor.getHostId();
    }

    public void updateHostInfoInES(String hostId, String uid) {
        Map<String, Object> hostInfoMap = new HashMap<>();
        XtHost xtHost = xtHostService.selectXtHostByHostid(hostId);
        hostInfoMap.put("host_id", xtHost.getHostid());
        hostInfoMap.put("host_name", xtHost.getHostname());
        hostInfoMap.put("user_id", xtHost.getUserid());
        hostInfoMap.put("ip_address", xtHost.getAddress());

        XtHostuser xtHostuser = xtHostuserService.selectXtHostuserByUserId(xtHost.getUserid());

        hostInfoMap.put("user_departure", xtHostuser.getDeparture());
        hostInfoMap.put("user_job", xtHostuser.getJob());
        hostInfoMap.put("user_name", xtHostuser.getName());
        hostInfoMap.put("user_phone", xtHostuser.getPhone());

        esUtil.updateThreate("test-traffic", uid, hostInfoMap);

    }

    public void identify_threat(AnalyseResult analyseResult, String uid, String hostId) {

        List<LabelConfidence> classificationResult = analyseResult.getClassificationResult();

        String bestLabel = null;
        double maxProb = Double.NEGATIVE_INFINITY;

        for (LabelConfidence result : classificationResult) {
                String label = result.getLabel();
                double prob = result.getProb();

                if (prob > maxProb) {
                    maxProb = prob;
                    bestLabel = label;
                }
            }
        boolean isAbnormal = bestLabel != null && bestLabel.startsWith("VPN-");

        if (isAbnormal) {
            int is_threat = 1;

            int handle = 0;
            String name  = bestLabel;

            String modelName = analyseResult.getModelName();

            GetRequest getRequest = new GetRequest("test-traffic", "doc", uid);
            Map<String, Object> zeek = esUtil.getRecord(getRequest);

            String timestamp = zeek.get("timestamp").toString();

            String srcIp = (String) zeek.get("src_ip");
            String destIp = (String) zeek.get("dest_ip");
            Integer srcPort = (Integer) zeek.get("src_port");
            Integer destPort = (Integer) zeek.get("dest_port");


            XtThreat xtThreat = new XtThreat();

            if (timestamp != null) {
                xtThreat.setTimestamp(timestamp);
            }


            if (srcIp != null) {
                xtThreat.setSrcIp(srcIp);
            }

            if (destIp != null) {
                xtThreat.setDstIp(destIp);
            }

            if (srcPort != null) {
                xtThreat.setSrcPort(srcPort);
            }

            if (destPort != null) {
                xtThreat.setDstPort(destPort);
            }

            xtThreat.setName(name);
            xtThreat.setModelName(modelName);

            xtThreat.setIsThreat(is_threat);

            xtThreat.setHandled(handle);
            xtThreat.setHostid(hostId);
            xtThreat.setLabelConfidences(classificationResult);

            xtThreatServicel.insertXtThreat(xtThreat);
        }

    }
    public List<Object> getVectorData(Map<String, Object> tempMap) {
        //get tcp or udp's payload
        List<Object> res = new ArrayList<>();
        //        Map<String ,Object> udpMap = (Map<String,Object>) tempMap.get("udp");
        Map<String, Object> ipMap = (Map<String, Object>) tempMap.get("ip");
        /**"timestamp": 1624007713.220484,
         * "length": 59,
         * "is_orig": true,
         */
        BigDecimal udpStartTimestamp = null;
        if (ipMap != null) {
            List<Object> udpPayloadList = (List<Object>) ipMap.get("payload");
            if (udpPayloadList != null) {
                for (int i = 0; i < udpPayloadList.size(); i++) {
                    Map<String, Object> pMap = new HashMap<>();
                    Map<String, Object> udppayloadMap = (Map<String, Object>) udpPayloadList.get(i);

                    //                    String timestampStr = ((BigDecimal)udppayloadMap.get("timestamp")).toString();
                    BigDecimal timestamp = (BigDecimal) udppayloadMap.get("timestamp");
                    if (i == 0) {
                        udpStartTimestamp = timestamp;
                    }

                    BigDecimal vectorTimestampTemp = timestamp.subtract(udpStartTimestamp);

                    long l = Integer.toUnsignedLong((Integer) udppayloadMap.get("length"));
                    l = l + 14;
                    Boolean is_orig = (Boolean) udppayloadMap.get("is_orig");

                    BigDecimal vectorTimestamp = vectorTimestampTemp;
                    //                    if(is_orig){
                    //                        l = -l;
                    //                    }
                    pMap.put("length", l);
                    pMap.put("timestamp", vectorTimestamp);

                    res.add(pMap);
                }
            }
        }
        //        if(udpMap != null){
        //            List<Object> udpPayloadList = (List<Object>) udpMap.get("payload");
        //            if(udpPayloadList != null){
        //                for(int i = 0;i<udpPayloadList.size();i++){
        //                    Map<String,Object> pMap = new HashMap<>();
        //                    Map<String,Object> udppayloadMap = (Map<String,Object>) udpPayloadList.get(i);
        //
        ////                    String timestampStr = ((BigDecimal)udppayloadMap.get("timestamp")).toString();
        //                    BigDecimal timestamp = (BigDecimal)udppayloadMap.get("timestamp");
        //                    if(i == 0){
        //                        udpStartTimestamp = timestamp;
        //                    }
        //
        //                    BigDecimal vectorTimestampTemp = timestamp.subtract(udpStartTimestamp);
        //
        //                    Long l = Integer.toUnsignedLong((Integer) udppayloadMap.get("length")) ;
        //                    Boolean is_orig = (Boolean) udppayloadMap.get("is_orig");
        //
        //                    BigDecimal vectorTimestamp = vectorTimestampTemp;
        //                    if(!is_orig){
        //                        l = -l;
        //                    }
        //                    pMap.put("length",l);
        //                    pMap.put("timestamp",vectorTimestamp);
        //
        //                    res.add(pMap);
        //                }
        //            }
        //        }
        //
        //
        //        Map<String,Object> tcpMap = (Map<String,Object>) tempMap.get("tcp");
        //
        //        BigDecimal tcpStartTimestamp = null;
        //        if(tcpMap != null){
        //            List<Object> tcpPayloadList = (List<Object>) tcpMap.get("payload");
        //            if(tcpPayloadList != null){
        //                for(int i = 0;i<tcpPayloadList.size();i++){
        //                    Map<String,Object> pMap = new HashMap<>();
        //                    Map<String,Object> tcppayloadMap = (Map<String,Object>) tcpPayloadList.get(i);
        //                    BigDecimal timestamp = (BigDecimal)tcppayloadMap.get("timestamp");
        //                    if(i == 0){
        //                        tcpStartTimestamp = timestamp;
        //                    }
        //
        //                    BigDecimal vectorTimestampTemp = timestamp.subtract(tcpStartTimestamp);
        //
        //                    Long l = Integer.toUnsignedLong((Integer) tcppayloadMap.get("length")) ;
        //                    Boolean is_orig = (Boolean) tcppayloadMap.get("is_orig");
        //
        //                    BigDecimal vectorTimestamp = vectorTimestampTemp;
        //                    if(!is_orig){
        //                        l = -l;
        //                    }
        //                    pMap.put("length",l);
        //                    pMap.put("timestamp",vectorTimestamp);
        //                    res.add(pMap);
        //                }
        //            }
        //        }

        if (res.size() < 50) {
            while (res.size() < 50) {
                Map<String, Object> addMap = new HashMap<>();
                addMap.put("length", 0);
                addMap.put("timestamp", -1);
                res.add(addMap);
            }
        }
        res = res.subList(0, 50);

        return res;
    }

    public Map<String, String> getIpAddressFromIp(Map<String, Object> ipMap) {
        String srcIp = (String) ipMap.get("src");
        String dstIp = (String) ipMap.get("dst");
        Map<String, String> res = new HashMap<>();
        if (srcIp != null) {
            res.put("src", srcIp);
        }
        if (dstIp != null) {
            res.put("dst", dstIp);
        }

        return res;
    }

    public Map<String, Integer> getPortFromUdp(Map<String, Object> udpMap) {
        Integer src = (Integer) udpMap.get("src");
        Integer dst = (Integer) udpMap.get("dst");
        Map<String, Integer> res = new HashMap<>();
        if (src != null) {
            res.put("src", src);
        }

        if (dst != null) {
            res.put("dst", dst);
        }

        return res;
    }


    public Map<String, Integer> getPortFromTcp(Map<String, Object> tcpMap) {
        //        System.out.println(tcpMap);
        Integer src = (Integer) tcpMap.get("client_port");
        Integer dst = (Integer) tcpMap.get("server_port");
        Map<String, Integer> res = new HashMap<>();
        if (src != null) {
            res.put("src", src);
        }

        if (dst != null) {
            res.put("dst", dst);
        }

        return res;
    }
}


