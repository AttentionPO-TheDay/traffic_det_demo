package com.ruoyi.xt.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.xt.domain.AssetDiscoverRecord;
import com.ruoyi.xt.domain.AssetsDiscoveryRes;
import com.ruoyi.xt.domain.AssetsDiscoveryStopRes;
import com.ruoyi.xt.domain.AssetsStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

/**
 * @author eniac
 * @date 5/18/22 15:50e
 * @Description:
 */

@Component
public class AsyncService {

    @Autowired
    AssetObjkService assetObjkService;

    @Autowired
    private AssetDiscoverService assetDiscoverService;

    @Autowired
    CommandService commandService;

    @Async("aexecutor")
    public void sendAssetsDiscoveryQuestToModel(RestTemplate restTemplatem, String url, HttpEntity<String> strEntity, AssetsDiscoveryRes assetsDiscoveryRes, AssetDiscoverRecord assetDiscoverRecord) {
        AssetsDiscoveryRes tempAssetsDiscoveryRes = restTemplatem.postForObject(url, strEntity, AssetsDiscoveryRes.class);
        if (tempAssetsDiscoveryRes.getMsg().equals("success")) {
            System.out.println("get Result from model assets");

            System.out.println(tempAssetsDiscoveryRes);
            JSONObject res = new JSONObject();
            JSONArray array = new JSONArray();
            res.put("msg", tempAssetsDiscoveryRes.getMsg());
            for (AssetsStatus assetsStatus : tempAssetsDiscoveryRes.getAns()) {
                JSONObject tmp = new JSONObject();
                tmp.put("ip", assetsStatus.getIp());
                tmp.put("os", assetsStatus.getOs());
                tmp.put("status", assetsStatus.getStatus());
                array.add(tmp);
            }
            res.put("res", array);
            assetDiscoverRecord.setResponse(JSONObject.toJSONString(res));
            assetDiscoverService.updateAssetDiscoverRecord(assetDiscoverRecord);
            assetObjkService.setAssetsDiscoveryRes(tempAssetsDiscoveryRes);
        }
    }

    @Async("aexecutor")
    public void requestDataframe(String url, HttpEntity<String> strEntity) {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.postForObject(url, strEntity, AssetsDiscoveryStopRes.class);
    }

    @Async("aexecutor")
    public void reloadRules(String rootPath, String command) {
        commandService.executeCmd(rootPath + command);
    }
}
