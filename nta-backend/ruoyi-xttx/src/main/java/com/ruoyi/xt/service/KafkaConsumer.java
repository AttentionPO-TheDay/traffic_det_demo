package com.ruoyi.xt.service;

import java.util.List;

/**
 * @Auther: eniac
 * @Date: 11/28/21 02:08
 * @Description:
 */
public interface KafkaConsumer {

    //    public void consume(List<ConsumerRecord<String, String>> records);
    //
    //    public void consume(ConsumerRecord<String, String> record);
    public void consumeZeek(List<String> records);

    public void consumeZeek(String record);

    public void consumeRes(List<String> records);

    public void consumeRes(String record);
}
