package com.ruoyi.xt.service;

import java.util.List;

/**
 * @Auther: sinrotic
 * @Date: 05/21/25 08:11
 * @Description:
 */
public interface RocketMQConsumer {

    public void consumeZeek(List<String> records);

    public void consumeZeek(String record);

    public void consumeRes(List<String> records);

    public void consumeRes(String record);
}
