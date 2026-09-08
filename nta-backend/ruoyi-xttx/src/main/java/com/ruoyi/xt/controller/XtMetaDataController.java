package com.ruoyi.xt.controller;

import com.alibaba.fastjson.JSON;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.XtMetaData;
import com.ruoyi.xt.service.XtMetaDataService;
import com.ruoyi.xt.service.impl.KafkaListenerSensor;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/20/21 04:51
 * @Description:
 */

@Api("Flow:元数据相关接口")
@RestController
@RequestMapping("/flow")
public class XtMetaDataController extends BaseController {
    @Autowired
    private XtMetaDataService xtMetaDataService;

    @Autowired
    private KafkaListenerSensor kafkaListenerSensor;


    @GetMapping("/encrypted")
    @ApiOperation("获取所有加密流量")
    public AjaxResult getEncryptedTraffic(@RequestParam(name = "isEncrypted", required = false) Boolean isEncrypted, @RequestParam(name = "srcPort", required = false) Integer srcPort, @RequestParam(name = "dstPort", required = false) Integer dstPort) {
        List<XtMetaData> resList;
        int total = 0;
        Map<String, Object> res = new HashMap<>();
        if (isEncrypted != null && isEncrypted) {
            total = xtMetaDataService.selectXtMetadataNumWithEncrypted(1, srcPort, dstPort);
            startPage();
            resList = xtMetaDataService.selectIsEncryptedXtMetaDataListWithoutMetadata(1, srcPort, dstPort);
        } else {
            if (isEncrypted != null) {
                total = xtMetaDataService.selectXtMetadataNum(srcPort, dstPort);
                startPage();
                resList = xtMetaDataService.selectIsNotEncryptedXtMetaDataListWithoutMetadata(0, srcPort, dstPort);
            } else {
                total = xtMetaDataService.selectXtMetadataNumWithEncrypted(0, srcPort, dstPort);
                startPage();
                resList = xtMetaDataService.selectIsNotEncryptedXtMetaDataListWithoutMetadata(null, srcPort, dstPort);
            }
        }

        //        total = resList.size();
        res.put("total", total);
        res.put("rows", resList);


        return AjaxResult.success(res);
    }

    @GetMapping("/metadata")
    @ApiOperation("获取单条流量元数据")
    public AjaxResult getMetadataByUid(@RequestParam("id") String id) {
        XtMetaData xtMetaData = xtMetaDataService.selectXtMetaDataByUid(id);
        return AjaxResult.success(xtMetaData);
    }

    @GetMapping("/test")
    @ApiOperation("test")
    public AjaxResult getMetadata() {
        String data = "{\"uid\":\"CS1zaS3lNKtWw0Ohg\",\"ip\":{\"src\":\"223.72.41.168\",\"dst\":\"140.82.10.193\",\"protocol\":6,\"version\":4,\"length\":132,\"payload\":[{\"timestamp\":1637456138.812561,\"length\":52,\"is_orig\":true,\"optional\":104},{\"timestamp\":1637456138.812622,\"length\":40,\"is_orig\":false,\"optional\":64},{\"timestamp\":1637456139.066612,\"length\":40,\"is_orig\":true,\"optional\":104}]},\"tcp\":{\"client_port\":24112,\"server_port\":9094,\"packet_up\":2,\"packet_dn\":0,\"byte_up\":0,\"byte_dn\":0,\"packet_retrans_up\":0,\"byte_retrans_up\":0,\"packet_retrans_dn\":0,\"byte_retrans_dn\":0,\"payload\":[{\"timestamp\":1637456138.812561,\"length\":0,\"is_orig\":true,\"type_name\":\"S\",\"optional\":[0,0]},{\"timestamp\":1637456139.066612,\"length\":0,\"is_orig\":true,\"type_name\":\"R\",\"optional\":[1672912604,0]}]}}";
        Map<String, Object> tempMap = JSON.parseObject(data);

        String uid = (String) tempMap.get("uid");


        //        kafkaListenerSensor.saveMetaData(data,tempMap,uid,"");

        return AjaxResult.success(null);
    }

    @GetMapping("/test2")
    @ApiOperation("test2")
    public AjaxResult getMetadata2() {
        String data = "{\"ts\":1637459450.808917,\"data\":\"{\\\"uid\\\":\\\"CwOFAEvuVpa2GJvw8\\\",\\\"ip\\\":{\\\"src\\\":\\\"223.72.76.155\\\",\\\"dst\\\":\\\"140.82.10.193\\\",\\\"protocol\\\":6,\\\"version\\\":4,\\\"length\\\":92,\\\"payload\\\":[{\\\"timestamp\\\":1637459445.808762,\\\"length\\\":52,\\\"is_orig\\\":true,\\\"optional\\\":105},{\\\"timestamp\\\":1637459445.808826,\\\"length\\\":40,\\\"is_orig\\\":false,\\\"optional\\\":64}]},\\\"tcp\\\":{\\\"client_port\\\":5994,\\\"server_port\\\":9092,\\\"packet_up\\\":1,\\\"packet_dn\\\":1,\\\"byte_up\\\":0,\\\"byte_dn\\\":0,\\\"packet_retrans_up\\\":0,\\\"byte_retrans_up\\\":0,\\\"packet_retrans_dn\\\":0,\\\"byte_retrans_dn\\\":0,\\\"payload\\\":[{\\\"timestamp\\\":1637459445.808762,\\\"length\\\":0,\\\"is_orig\\\":true,\\\"type_name\\\":\\\"S\\\",\\\"optional\\\":[0,0]},{\\\"timestamp\\\":1637459445.808826,\\\"length\\\":0,\\\"is_orig\\\":false,\\\"type_name\\\":\\\"RA\\\",\\\"optional\\\":[1,1]}]}}\"}";
        Map<String, Object> tempMap = JSON.parseObject(data);

        tempMap = JSON.parseObject(data);

        data = (String) tempMap.get("data");
        tempMap = JSON.parseObject(data);

        String uid = (String) tempMap.get("uid");


        //        System.out.println("=======");
        //        System.out.println(uid);
        //        System.out.println("=======");

        //        kafkaListenerSensor.saveMetaData(data,tempMap,uid,"");

        return AjaxResult.success(null);
    }

    //    @GetMapping("/testRest")
    //    @ApiOperation("测试RestTemplate相关")
    //    public AjaxResult getRestTemplate(){
    //        RestTemplate restTemplate = new RestTemplate();
    //        String url = "http://140.82.10.193:8000";
    //
    //        ModelThreatRequest sendMsgC = new ModelThreatRequest();
    //        sendMsgC.uid = "CDPVKt4gh2nf1WgmG5";
    //        sendMsgC.vector = new ArrayList<>();
    //        Map<String,Object> vectorElem = new HashMap<>();
    //        vectorElem.put("length",31);
    //        vectorElem.put("timestamp",0.000000);
    //        sendMsgC.vector.add(vectorElem);
    //
    //        vectorElem = new HashMap<>();
    //        vectorElem.put("length",31);
    //        vectorElem.put("timestamp",0.000005);
    //        sendMsgC.vector.add(vectorElem);
    //
    //        vectorElem = new HashMap<>();
    //        vectorElem.put("length",122);
    //        vectorElem.put("timestamp", -0.056596);
    //        sendMsgC.vector.add(vectorElem);
    //
    //        vectorElem = new HashMap<>();
    //        vectorElem.put("length",74);
    //        vectorElem.put("timestamp",-0.082624);
    //        sendMsgC.vector.add(vectorElem);
    //
    //        while (sendMsgC.vector.size() < 50){
    //            vectorElem = new HashMap<>();
    //            vectorElem.put("length",-1);
    //            vectorElem.put("timestamp",0);
    //            sendMsgC.vector.add(vectorElem);
    //        }
    //        String jsonStr = JSONObject.toJSONString(sendMsgC);
    ////        System.out.println(jsonStr);
    //        ResponseEntity<String> response = restTemplate.postForEntity(url,jsonStr ,String.class);
    ////        System.out.println(response);
    ////        System.out.println(response.getBody());
    ////        System.out.println(response.getStatusCode()
    //        return AjaxResult.success(response);
    //    }
}

