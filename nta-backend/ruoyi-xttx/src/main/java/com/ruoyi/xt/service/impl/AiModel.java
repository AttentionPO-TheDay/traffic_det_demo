package com.ruoyi.xt.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.xt.domain.*;
import com.ruoyi.xt.service.XtThreatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/20/21 05:47
 * @Description:
 */
@Component
public class AiModel {
    @Autowired
    XtThreatService xtThreatService;
    public static final String BASE_URL = "http://64.112.41.70:8000";

    public List<XtThreat> sendVector(Map<String, Object> message, String srcIp, String dstIp, Integer srcPort, Integer dstPort, String timestamp, String hostId) {
        //        System.out.println("message is :");
        //        System.out.println(message);
        //        模型端进行

        List<XtThreat> resList = new ArrayList<>();
        String url = BASE_URL;
        RestTemplate restTemplate = new RestTemplate();
        String str = JSONObject.toJSONString(message);
        ResponseEntity<String> response = restTemplate.postForEntity(url, str, String.class);
        if (response != null) {
            Integer statusCode = response.getStatusCodeValue();
            if (statusCode != null && statusCode == 200) {
                String resBody = response.getBody();
                if (resBody != null && resBody.length() != 0) {
                    ModelThreatResponse modelThreatResponse = JSON.parseObject(resBody, ModelThreatResponse.class);
                    System.out.println(modelThreatResponse.getThreat());//[ThreatResponse{modelName='CNNBiLSTM', isThreat=true, threatName='DGA'}, ThreatResponse{modelName='DoubleBiLSTM', isThreat=true, threatName='DGA'}]

                    // 每条流量都会经过所有的模型，每个模型都会输出结果，所以获取的是list
                    for (ThreatResponse threatResponse : modelThreatResponse.getThreat()) {
                        XtThreat xtThreat = new XtThreat();
                        xtThreat.setUid(modelThreatResponse.getUid());
                        if (srcIp != null) {
                            xtThreat.setSrcIp(srcIp);
                        }
                        if (dstIp != null) {
                            xtThreat.setDstIp(dstIp);
                        }
                        if (dstPort != null) {
                            xtThreat.setDstPort(dstPort);
                        }
                        if (srcPort != null) {
                            xtThreat.setSrcPort(srcPort);
                        }
                        if (threatResponse.getThreatName() != null) {
                            xtThreat.setName(threatResponse.getThreatName());
                        }
                        if (threatResponse.getModelName() != null) {
                            xtThreat.setModelName(threatResponse.getModelName());
                        }
                        if (timestamp != null) {
                            xtThreat.setTimestamp(timestamp);
                        }

                        xtThreat.setHostid(hostId);

                        int isThreat = 0;
                        if (threatResponse.isThreat()) {
                            isThreat = 1;
                        }
                        xtThreat.setIsThreat(isThreat);
                        resList.add(xtThreat);
                    }
                }
            }
        }
        return resList;
    }

    public AiModelSingleStatusResponse getSingleStatus(String name) {
        String url = BASE_URL + "/get_state/" + name;
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> aiModelSingleStatusResponse = restTemplate.getForEntity(url, String.class);

        if (aiModelSingleStatusResponse != null && aiModelSingleStatusResponse.getStatusCodeValue() == 200) {
            String resStr = aiModelSingleStatusResponse.getBody();
            //            System.out.println(resStr);
            if (resStr != null && resStr.length() != 0) {
                AiModelSingleStatusResponse modelRes = JSON.parseObject(resStr, AiModelSingleStatusResponse.class);
                return modelRes;
            } else {
                return null;
            }

        } else {
            return null;
        }

    }

    public List<Map<String, Object>> getStatus() {
        String url = BASE_URL + "/get_all_state/";
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> responseEntity = restTemplate.getForEntity(url, String.class);
        //        System.out.println(responseEntity);
        List<Map<String, Object>> res = new ArrayList<>();
        Map<String, Object> resElem;
        if (responseEntity != null && responseEntity.getStatusCodeValue() == 200) {
            String aiModelAllStatusResponseStr = responseEntity.getBody();
            if (aiModelAllStatusResponseStr != null && aiModelAllStatusResponseStr.length() != 0) {
                AiModelAllStatusResponse aiModelAllStatusResponse = JSON.parseObject(aiModelAllStatusResponseStr, AiModelAllStatusResponse.class);
                if (aiModelAllStatusResponse.isSuccess()) {
                    for (int i = 0; i < aiModelAllStatusResponse.getStates().size(); i++) {
                        AiModelStatus status = aiModelAllStatusResponse.getStates().get(i);
                        resElem = new HashMap<>();
                        resElem.put("name", status.getName());
                        resElem.put("type", "aimodel");
                        if (status.getState().equals("on")) {
                            resElem.put("status", true);
                        } else {
                            resElem.put("status", false);
                        }

                        res.add(resElem);
                    }
                    return res;
                } else {
                    return null;
                }
            } else {
                return null;
            }

        } else {
            return null;
        }
    }

    public Map<String, Object> setStatus(String name) {
        String url = BASE_URL + "/change_state/" + name;
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> testEntity = restTemplate.postForEntity(url, "", String.class);
        //        System.out.println(testEntity.getBody());
        Map<String, Object> res = new HashMap<>();
        if (testEntity != null && testEntity.getStatusCodeValue() == 200) {
            String aiModelSingleStatusResponseStr = testEntity.getBody();
            if (aiModelSingleStatusResponseStr != null && aiModelSingleStatusResponseStr.length() != 0) {
                AiModelSingleStatusResponse aiModelSingleStatusResponse = JSON.parseObject(aiModelSingleStatusResponseStr, AiModelSingleStatusResponse.class);
                if (aiModelSingleStatusResponse.isSuccess()) {
                    res.put("name", aiModelSingleStatusResponse.getName());
                    if (aiModelSingleStatusResponse.getState().equals("on")) {
                        res.put("status", true);
                    } else {
                        res.put("status", false);
                    }
                    res.put("type", "aimodel");
                    return res;
                } else {
                    return null;
                }
            } else {
                return null;
            }

        } else {
            return null;
        }

    }

    public Map<String, Object> addModel(String fileName) {
        String url = BASE_URL + "/add_model/" + fileName;
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> testEntity = restTemplate.postForEntity(url, "", String.class);
        Map<String, Object> res = new HashMap<>();
        if (testEntity != null && testEntity.getStatusCodeValue() == 200) {
            res.put("res", true);
        } else {
            res.put("res", false);
        }
        return res;
    }
}
