package com.ruoyi.xt.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.AssetDiscoverRecord;
import com.ruoyi.xt.domain.AssetsDiscoveryReq;
import com.ruoyi.xt.domain.AssetsDiscoveryRes;
import com.ruoyi.xt.domain.AssetsDiscoveryStopRes;
import com.ruoyi.xt.domain.template.DataFrameReq;
import com.ruoyi.xt.domain.template.RandomTestRes;
import com.ruoyi.xt.service.AssetDiscoverService;
import com.ruoyi.xt.service.AssetObjkService;
import com.ruoyi.xt.service.AsyncService;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 5/11/22 17:55
 * @Description:
 */

@RestController
@RequestMapping("/xt/assets")
@Api("资产发现相关接口")
public class AssetController extends BaseController {

    /**
     * 边缘辅助服务地址，通过环境变量 EDGE_BASE_URL 注入（application.yml 已映射 edge.base-url）
     */
    @Value("${edge.base-url:http://127.0.0.1:8888/}")
    String BASE_URL;
    String STOP_SUB_URL = "stop";
    String STATUS_SUB_URL = "status";
    String DATA_FRAME_URL = "dataFrame";
    String RANDOM_TEST_URL = "randomTest";
    String CERT_VERIFY_URL = "verify-cert";

    public AssetsDiscoveryRes assetsDiscoveryRes;

    private Boolean status = false;

    @Autowired
    private AsyncService asyncService;

    @Autowired
    private AssetObjkService assetObjkService;

    @Autowired
    private AssetDiscoverService assetDiscoverService;

    /**
     * 资产发现接口，传递IP段的起始
     *
     * @param assetsDiscoveryReq
     * @return
     */
    @PostMapping("/discovery")
    public AjaxResult discoveryStart(@RequestBody AssetsDiscoveryReq assetsDiscoveryReq) {
        if (!isCorrectIp(assetsDiscoveryReq.getStart()) || !isCorrectIp(assetsDiscoveryReq.getEnd())) {
            return AjaxResult.error("Illegal Ip Address!");
        }

        if (status) {
            return AjaxResult.success();
        }
        String url = BASE_URL;

        AssetDiscoverRecord assetDiscoverRecord = new AssetDiscoverRecord();
        assetDiscoverRecord.setTimestamp(System.currentTimeMillis());
        JSONObject req = new JSONObject();
        req.put("start", assetsDiscoveryReq.getStart());
        req.put("end", assetsDiscoveryReq.getEnd());
        assetDiscoverRecord.setRequest(JSONObject.toJSONString(req));
        assetDiscoverService.insertAssetDiscoverRecord(assetDiscoverRecord);

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("application/json;UTF-8"));
        String jsonString = JSON.toJSONString(assetsDiscoveryReq);
        HttpEntity<String> strEntity = new HttpEntity<String>(jsonString, headers);
        //        AssetsDiscoveryRes tempAssetsDiscoveryRes =restTemplate.postForObject(url,strEntity,AssetsDiscoveryRes.class);
        //        restTemplate.postForObject(url,strEntity,AssetsDiscoveryRes.class);
        //        Callable<AssetsDiscoveryRes> tempAssetsDiscoveryRes = (() -> {
        //            return restTemplate.postForObject(url,strEntity,AssetsDiscoveryRes.class);
        //        });
        asyncService.sendAssetsDiscoveryQuestToModel(restTemplate, url, strEntity, assetsDiscoveryRes, assetDiscoverRecord);

        //        String resMsg = tempAssetsDiscoveryRes.;
        //        if(resMsg.equals("success")){
        //            return AjaxResult.success(assetsDiscoveryRes);
        //        }else{
        //            return AjaxResult.error();
        //        }
        return AjaxResult.success();

    }

    //判断字符是否是IP
    public boolean isCorrectIp(String ipString) {
        //1、判断是否是7-15位之间（0.0.0.0-255.255.255.255.255）
        if (ipString.length() < 7 || ipString.length() > 15) {
            return false;
        }
        //2、判断是否能以小数点分成四段
        String[] ipArray = ipString.split("\\.");
        if (ipArray.length != 4) {
            return false;
        }
        for (int i = 0; i < ipArray.length; i++) {
            //3、判断每段是否都是数字
            try {
                int number = Integer.parseInt(ipArray[i]);
                //4.判断每段数字是否都在0-255之间
                if (number < 0 || number > 255) {
                    return false;
                }
            } catch (Exception e) {
                return false;
            }
        }
        return true;
    }


    @PostMapping("/stop")
    public AjaxResult discoveryStop() {
        String url = BASE_URL + STOP_SUB_URL;

        RestTemplate restTemplate = new RestTemplate();
        AssetsDiscoveryStopRes assetsDiscoveryStopRes = restTemplate.postForObject(url, "", AssetsDiscoveryStopRes.class);
        if (assetsDiscoveryStopRes.getSuccess()) {
            return AjaxResult.success(assetsDiscoveryStopRes);
        } else {
            return AjaxResult.error(assetsDiscoveryStopRes.getMsg());
        }
    }

    @GetMapping("/status")
    public AjaxResult getStatus() {
        String url = BASE_URL + STATUS_SUB_URL;

        RestTemplate restTemplate = new RestTemplate();
        AssetsDiscoveryStopRes assetsDiscoveryStopRes = restTemplate.getForObject(url, AssetsDiscoveryStopRes.class);
        if (assetsDiscoveryStopRes.getSuccess()) {
            this.status = assetsDiscoveryStopRes.getStatus().equals("Running");
            return AjaxResult.success(assetsDiscoveryStopRes);
        } else {
            return AjaxResult.error(assetsDiscoveryStopRes.getMsg());
        }
    }

    @GetMapping("/result")
    public AjaxResult getResult() {
        System.out.println();
        return AjaxResult.success(assetObjkService.getAssetsDiscoveryRes());
    }

    @PostMapping("/dataFrame")
    public AjaxResult generateDataFrame(@RequestBody DataFrameReq dataFrameReq) {
        String url = BASE_URL + DATA_FRAME_URL;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("application/json;UTF-8"));
        String jsonString = JSON.toJSONString(dataFrameReq);
        HttpEntity<String> strEntity = new HttpEntity<String>(jsonString, headers);
        asyncService.requestDataframe(url, strEntity);
        return AjaxResult.success();
    }


    @GetMapping("/history")
    public AjaxResult getHistory(@RequestParam(name = "minTimestamp", required = false) Long minTimestamp,
                                 @RequestParam(name = "maxTimestamp", required = false) Long maxTimestamp) {
        startPage();
        List<AssetDiscoverRecord> assetDiscoverRecordList = assetDiscoverService.getAssetDiscoverRecord(minTimestamp, maxTimestamp);
        Map<String, Object> res = new HashMap<>();
        res.put("result", assetDiscoverRecordList);
        return AjaxResult.success(res);
    }

    @GetMapping("/history/info")
    public AjaxResult getHistoryById(@RequestParam(name = "id") int id) {
        List<String> res = assetDiscoverService.getAssetDiscoverRecordById(id);
        System.out.println(id);
        return AjaxResult.success(res);
    }

    @PostMapping("/randomTest")
    public AjaxResult getrandomTestResult(@RequestBody List<Integer> randomTestList) {
        String url = BASE_URL + RANDOM_TEST_URL;
        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> sendMsg = new HashMap<>();
        RandomTestRes randomTestRes = new RandomTestRes();
        sendMsg.put("data", randomTestList);
        String str = JSONObject.toJSONString(sendMsg);
        try {
            ResponseEntity<RandomTestRes> randomTestResResponseEntity = restTemplate.postForEntity(url, str, RandomTestRes.class);
            if (randomTestResResponseEntity != null && randomTestResResponseEntity.getStatusCodeValue() == 200) {
                randomTestRes = randomTestResResponseEntity.getBody();
            }
        } catch (Exception e) {
            return AjaxResult.error("请求随机数检测失败：" + ExceptionUtils.getStackTrace(e));
        }
        return AjaxResult.success(randomTestRes);
    }

    @PostMapping("/verifyCert")
    public AjaxResult getCertVerifyRes(@RequestBody String certMessage) {
        String url = BASE_URL + CERT_VERIFY_URL;
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Object> certVerifyEntity;
        try {
            certVerifyEntity = restTemplate.postForEntity(url, certMessage, Object.class);
            if (certVerifyEntity != null && certVerifyEntity.getStatusCodeValue() == 200) {
                return AjaxResult.success(certVerifyEntity.getBody());
            }
        } catch (Exception e) {
            return AjaxResult.error("验证证书请求失败：" + ExceptionUtils.getStackTrace(e));
        }
        return AjaxResult.error("莫名错误！！！");
    }
}
