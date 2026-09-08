package com.ruoyi.xt.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.xt.domain.XtThreat;
import com.ruoyi.xt.service.KafkaConsumer;
import com.ruoyi.xt.service.XtThreatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.Executor;

/**
 * @Auther: eniac
 * @Date: 9/13/21 02:05
 * @Description:
 */
@Component
public class KafkaListenerSensor {


    @Autowired
    XtThreatService xtThreatServicel;

    @Resource
    KafkaConsumer kafkaConsumer;

    @Autowired
    @Qualifier("aexecutor")
    Executor executor;


    @org.springframework.kafka.annotation.KafkaListener(topics = {"zeek"}, groupId = "defaultConsumerGroup")
    @Async("aexecutor")
    public void listenZeek(String records) {
        // 解析data
        //TODO:开新的线程
        System.out.println("等待队列大小为：" + ((ThreadPoolTaskExecutor) executor).getThreadPoolExecutor().getQueue().size());
        kafkaConsumer.consumeZeek(records);
    }

    @org.springframework.kafka.annotation.KafkaListener(topics = {"traffic_results"}, groupId = "defaultConsumerGroup")
    @Async("aexecutor")
    public void listenRes(String records) {
        // 解析识别结果data
        //TODO:开新的线程
        System.out.println("等待队列大小为：" + ((ThreadPoolTaskExecutor) executor).getThreadPoolExecutor().getQueue().size());
        kafkaConsumer.consumeRes(records);
    }

    @org.springframework.kafka.annotation.KafkaListener(topics = {"suricata"}, groupId = "defaultConsumerGroup")
    public void listenSuricata(String data) {

        System.out.println(data);
        Map<String, Object> suricataMap = JSON.parseObject(data);
        String ts = (String) suricataMap.get("timestamp");
        String timestamp = null;
        // 时间戳处理
        if (ts != null) {
            try {
                //                System.out.println(ts);
                String[] tsArray = ts.split("T");
                String tsStr = "";
                tsStr += tsArray[0] + " ";
                tsArray = tsArray[1].split("\\+");
                tsStr += tsArray[0];
                Timestamp tsT = Timestamp.valueOf(tsStr);
                //                System.out.println(tsT);

                Date p = tsT;
                //                System.out.println(p);
                timestamp = "" + (p.getTime());
                //                System.out.println(timestamp);
                timestamp = timestamp.substring(0, timestamp.length() - 3) + "." + timestamp.substring(timestamp.length() - 3, timestamp.length()) + "000";
                //                System.out.println(timestamp);
            } catch (Exception e) {
                System.out.println("Error at parse date");
            }
        }

        //        String flowId = (String) suricataMap.get("flow_id");
        String srcIp = (String) suricataMap.get("src_ip");
        String destIp = (String) suricataMap.get("dest_ip");
        Integer srcPort = (Integer) suricataMap.get("src_port");
        Integer destPort = (Integer) suricataMap.get("dest_port");
        String name = "suricata";
        try {
            JSONObject alert = (JSONObject) suricataMap.get("alert");
            JSONObject metaData = alert.getJSONObject("metadata");
            JSONArray threatName = metaData.getJSONArray("threatName");
            name = threatName.getString(0);
        } catch (Exception e) {
            System.out.println("parse suricata for get threatName error");
        }
        String modelName = "suricata";

        int is_threat = 1;

        int handle = 0;

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
        xtThreat.setHostid("7777");

        xtThreatServicel.insertXtThreat(xtThreat);
    }
//    public static void main(String[] args) {
//        String record = "{\"ts\":1682497759.28326,\"data\":\"{\\\"uid\\\":\\\"CE7mOV11Cz97Qce0A5\\\",\\\"hash\\\":\\\"00857f007cbcfb55330e0df116fdddd4\\\",\\\"source\\\":\\\"zeek-1\\\",\\\"ip\\\":{\\\"src\\\":\\\"108.136.161.228\\\",\\\"dst\\\":\\\"38.242.210.211\\\",\\\"protocol\\\":1,\\\"version\\\":4,\\\"length\\\":72,\\\"payload\\\":[{\\\"timestamp\\\":1682497746.272332,\\\"length\\\":36,\\\"is_orig\\\":true,\\\"optional\\\":1},{\\\"timestamp\\\":1682497746.27245,\\\"length\\\":36,\\\"is_orig\\\":false,\\\"optional\\\":1}]}}\"}\n";
//        System.out.println(record);
//        KafkaConsumer kafkaConsumer = new KafkaConsumerImpl();
//        kafkaConsumer.consumeZeek(record);
//
//        ModelAnalyseResult modelAnalyseResult = new ModelAnalyseResult();
//        modelAnalyseResult.setUid("CE7mOV11Cz97Qce0A5");
//
//        AnalyseResult analyseResult1 = new AnalyseResult();
//        analyseResult1.setModelName("VGG");
//        analyseResult1.setModelId("model_001");
//        LabelConfidence labelConfidence11 = new LabelConfidence();
//        labelConfidence11.setConfidence(0.9);
//        labelConfidence11.setLabel("cat");
//        LabelConfidence labelConfidence12 = new LabelConfidence();
//        labelConfidence12.setConfidence(0.8);
//        labelConfidence12.setLabel("dog");
//        List<LabelConfidence> labelConfidenceList1 = Arrays.asList(labelConfidence11, labelConfidence12);
//        analyseResult1.setLabelConfidences(labelConfidenceList1);
//
//        AnalyseResult analyseResult2 = new AnalyseResult();
//        analyseResult2.setModelName("LSTM");
//        analyseResult2.setModelId("model_002");
//        LabelConfidence labelConfidence21 = new LabelConfidence();
//        labelConfidence21.setConfidence(0.78);
//        labelConfidence21.setLabel("cat");
//        LabelConfidence labelConfidence22 = new LabelConfidence();
//        labelConfidence22.setConfidence(0.65);
//        labelConfidence22.setLabel("dog");
//        List<LabelConfidence> labelConfidenceList2 = Arrays.asList(labelConfidence21, labelConfidence22);
//        analyseResult2.setLabelConfidences(labelConfidenceList2);
//
//        AnalyseResult analyseResult3 = new AnalyseResult();
//        analyseResult3.setModelName("Transformer");
//        analyseResult3.setModelId("model_003");
//        LabelConfidence labelConfidence31 = new LabelConfidence();
//        labelConfidence31.setConfidence(0.91);
//        labelConfidence31.setLabel("cat");
//        LabelConfidence labelConfidence32 = new LabelConfidence();
//        labelConfidence32.setConfidence(0.93);
//        labelConfidence32.setLabel("dog");
//        List<LabelConfidence> labelConfidenceList3 = Arrays.asList(labelConfidence31, labelConfidence32);
//        analyseResult3.setLabelConfidences(labelConfidenceList3);
//
//        List<AnalyseResult> analyseResultList1 = Arrays.asList(analyseResult1, analyseResult2,analyseResult3);
//        modelAnalyseResult.setAnalyseResultList(analyseResultList1);
//
//        String record2 = JSON.toJSONString(modelAnalyseResult);
//        System.out.println(record2);
//    }
}

