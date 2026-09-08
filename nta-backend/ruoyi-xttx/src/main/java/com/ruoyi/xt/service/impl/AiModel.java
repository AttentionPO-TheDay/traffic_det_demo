package com.ruoyi.xt.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.xt.domain.*;
import com.ruoyi.xt.service.XtThreatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
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

    /**
     * 推理服务地址，通过环境变量 INFER_BASE_URL 注入（application.yml 中已映射 infer.base-url）
     */
    @Value("${infer.base-url:http://127.0.0.1:8000}")
    public String baseUrl;

    public List<XtThreat> sendVector(Map<String, Object> message, String srcIp, String dstIp, Integer srcPort, Integer dstPort, String timestamp, String hostId) {
        //        System.out.println("message is :");
        //        System.out.println(message);
        //        模型端进行

        List<XtThreat> resList = new ArrayList<>();
        String url = baseUrl;
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

    /**
     * 查询单个模型状态。新版 infer-service 没有单模型查询接口，
     * 这里通过 GET /models 列表按 modelId 匹配得到状态。
     */
    public AiModelSingleStatusResponse getSingleStatus(String id) {
        String url = baseUrl + "/models";
        RestTemplate restTemplate = new RestTemplate();
        AiModelSingleStatusResponse res = new AiModelSingleStatusResponse();
        res.setSuccess(false);
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            if (response != null && response.getStatusCodeValue() == 200 && response.getBody() != null) {
                List<Map<String, Object>> models = JSON.parseObject(response.getBody(), List.class);
                for (Map<String, Object> model : models) {
                    if (id != null && id.equals(String.valueOf(model.get("modelId")))) {
                        res.setSuccess(true);
                        res.setName((String) model.get("name"));
                        res.setState(Boolean.TRUE.equals(model.get("enabled")) ? "on" : "off");
                        res.setMsg("");
                        return res;
                    }
                }
            }
        } catch (Exception e) {
            res.setMsg(e.getMessage());
        }
        return res;
    }

    /**
     * 查询所有模型状态，映射为前端所需的结构：{name, id, type, status}
     */
    public List<Map<String, Object>> getStatus() {
        String url = baseUrl + "/models";
        RestTemplate restTemplate = new RestTemplate();
        List<Map<String, Object>> res = new ArrayList<>();
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            if (response != null && response.getStatusCodeValue() == 200 && response.getBody() != null) {
                List<Map<String, Object>> models = JSON.parseObject(response.getBody(), List.class);
                for (Map<String, Object> model : models) {
                    Map<String, Object> resElem = new HashMap<>();
                    resElem.put("name", model.get("name"));
                    resElem.put("id", model.get("modelId"));
                    resElem.put("type", "aimodel");
                    resElem.put("status", Boolean.TRUE.equals(model.get("enabled")));
                    res.add(resElem);
                }
            }
        } catch (Exception e) {
            // 推理服务不可用时返回空列表，由上层判断
        }
        return res;
    }

    /**
     * 启用/停用模型。新版 infer-service 使用 PUT /models/{id}/status?enabled=true|false
     */
    public Map<String, Object> setStatus(String id, boolean enabled) {
        String url = baseUrl + "/models/" + id + "/status?enabled=" + enabled;
        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> res = new HashMap<>();
        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.PUT, null, String.class);
            if (response != null && response.getStatusCodeValue() == 200) {
                res.put("name", id);
                res.put("type", "aimodel");
                res.put("status", enabled);
            } else {
                res.put("error", "cannot set status, HTTP " + (response == null ? "null" : response.getStatusCodeValue()));
            }
        } catch (Exception e) {
            res.put("error", e.getMessage());
        }
        return res;
    }

    public Map<String, Object> addModel(String fileName) {
        String url = baseUrl + "/add_model/" + fileName;
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
