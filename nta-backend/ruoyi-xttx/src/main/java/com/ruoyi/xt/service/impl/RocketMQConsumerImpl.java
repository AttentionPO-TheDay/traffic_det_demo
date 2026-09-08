package com.ruoyi.xt.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.xt.domain.AnalyseResult;
import com.ruoyi.xt.domain.EsEntity;
import com.ruoyi.xt.service.RocketMQConsumer;
import com.ruoyi.xt.util.EsUtil;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: sinrotic
 * @Date: 05/21/25 08:05
 * @Description:
 */
@Service
public class RocketMQConsumerImpl implements RocketMQConsumer {
    @Autowired
    ConsumeSingle consumeSingle;

    @Autowired
    private EsUtil esUtil;

    @Autowired
    XtSensorServiceImpl xtSensorService;

    private Map<String, String> threatMap = new HashMap<>();

    private static final Logger log = LoggerFactory.getLogger(KafkaConsumerImpl.class);

    @Override
    public void consumeZeek(List<String> records) {
        records.forEach(this::consumeZeek);
    }

    @Override
    public void consumeRes(List<String> records) {
        records.forEach(this::consumeRes);
    }

    @Override
    public void consumeZeek(String record) {

        System.out.println("当前处理线程的名字是：" + Thread.currentThread().getName());


        System.out.println("消息是：" + record);
        //{"ts":1682497759.28326,"data":"{\"uid\":\"CE7mOV11Cz97Qce0A5\",\"hash\":\"00857f007cbcfb55330e0df116fdddd4\",\"source\":\"zeek-1\",\"ip\":{\"src\":\"108.136.161.228\",\"dst\":\"38.242.210.211\",\"protocol\":1,\"version\":4,\"length\":72,\"payload\":[{\"timestamp\":1682497746.272332,\"length\":36,\"is_orig\":true,\"optional\":1},{\"timestamp\":1682497746.27245,\"length\":36,\"is_orig\":false,\"optional\":1}]}}"}

        //        System.out.println(record);
        Map<String, Object> tempMap = JSON.parseObject(record);
        String timestamp = tempMap.get("ts").toString();

        record = (String) tempMap.get("data");
        tempMap = JSON.parseObject(record);

        String uid = (String) tempMap.get("uid");

        String zeekName = (String) tempMap.get("source");
        //System.out.println(zeekName);


        try {
            // 存储到ES当中
            EsEntity<JSONObject> esEntity = new EsEntity<>();
            esEntity.setId(uid);
            JSONObject recordObject = JSON.parseObject(record);
            recordObject.put("timestamp", System.currentTimeMillis());
            esEntity.setData(recordObject);
            //System.out.println(esEntity.getId());
            //System.out.println(JSON.toJSONString(esEntity.getData()));
            IndexResponse indexResponse = esUtil.insertOrUpdateOne("test-traffic", esEntity);

            System.out.printf("before consumeMessage uid:%s\n", uid);
            consumeSingle.consumeMessage(record, tempMap, uid, timestamp, zeekName);
            if (threatMap.containsKey(uid)) {
                consumeRes(threatMap.get(uid));
                threatMap.remove(uid);
            }
            System.out.printf("after consumeMessage uid:%s\n", uid);
            System.out.println(indexResponse);
        } catch (Exception ex) {
            //            log.error("ConsumeServiceImpl.consume error, ", ex);
            System.err.println(ex);
            return;
        }
    }

    public void consumeRes(String record) {
        System.out.println("Result消息是：" + record);
        ObjectMapper mapper = new ObjectMapper();

        try {
            List<AnalyseResult> analyseResults = mapper.readValue(
                record,
                new TypeReference<List<AnalyseResult>>() {}
            );

            for (AnalyseResult ar : analyseResults) {
                String uid = ar.getUid();

                GetRequest getRequest = new GetRequest("test-traffic", "doc", uid);
                Map<String, Object> zeek = esUtil.getRecord(getRequest);
                if (zeek == null) {
                    //将该结果数据存入缓存
                    threatMap.put(uid, record);
                    return;
                }

                String zeekname = zeek.get("zeekname").toString();
                System.out.printf("before consumeMessage uid:%s\n", uid);
                consumeSingle.consumeMessage(ar, uid, zeekname);
                System.out.printf("after consumeMessage uid:%s\n", uid);

            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
