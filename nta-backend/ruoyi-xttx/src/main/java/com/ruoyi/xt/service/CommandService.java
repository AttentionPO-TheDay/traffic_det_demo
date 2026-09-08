package com.ruoyi.xt.service;

import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/17/21 22:16
 * @Description:
 */
// 定义Command Srevice接口
public interface CommandService {
    Map<String, String> executeCmd(String cmd);
}

