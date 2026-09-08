package com.ruoyi.xt.service.impl;

import com.ruoyi.xt.service.KafkaConsumer;
import com.ruoyi.xt.service.RocketMQConsumer;
import com.ruoyi.xt.service.XtThreatService;
import org.apache.rocketmq.spring.annotation.ConsumeMode;
import org.apache.rocketmq.spring.annotation.MessageModel;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.concurrent.Executor;

/**
 * @Auther: sinrotic
 * @Date: 05/21/25 08:22
 * @Description:
 */
@Component
public class RocketMQListenerSensor {
    @Autowired
    XtThreatService xtThreatServicel;

    @Resource
    RocketMQConsumer rocketMQConsumer;

    @Service
    @RocketMQMessageListener(
        topic = "zeek",
        consumerGroup = "defaultConsumerGroup"
    )
    public static class ZeekMessageListener implements RocketMQListener<String> {

        @Autowired
        @Qualifier("aexecutor")
        Executor executor;

        @Resource
        private RocketMQConsumer rocketMQConsumer;

        @Override
        @Async("aexecutor")
        public void onMessage(String message) {
            //TODO:开新的线程
            System.out.println("等待队列大小为：" +
                ((ThreadPoolTaskExecutor) executor).getThreadPoolExecutor().getQueue().size());
            rocketMQConsumer.consumeZeek(message);
        }
    }

    @Service
    @RocketMQMessageListener(
        topic = "traffic_results",
        consumerGroup = "defaultConsumerGroup"
    )
    public static class ResListener implements RocketMQListener<String> {

        @Autowired
        @Qualifier("aexecutor")
        Executor executor;

        @Resource
        private RocketMQConsumer rocketMQConsumer;

        @Override
        @Async("aexecutor")
        public void onMessage(String message) {
            //TODO:开新的线程
            System.out.println("等待队列大小为：" +
                ((java.util.concurrent.ThreadPoolExecutor) executor).getQueue().size());
            rocketMQConsumer.consumeRes(message);
        }
    }
}
