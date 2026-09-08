package com.ruoyi.xt.util;

import com.alibaba.fastjson.JSON;

import java.util.Map;

public class CommandServiceUtil {
    /**
     * 检查CommandService执行命令是否成功
     * @param cmdRes 返回结果
     * @return 执行成功返回message，否则返回null
     */
    public static String checkExecutionResult(Map<String, String> cmdRes) {
        if (cmdRes == null || !cmdRes.get("command_result").equals("success")) return null;

        String cmdResMsg = cmdRes.get("msg");
        Map<String, Object> cmdResMsgMap = JSON.parseObject(cmdResMsg);
        String message = (String) cmdResMsgMap.get("message");
        Integer code = (Integer) cmdResMsgMap.get("code");

        if (code == null || code != 0 || message.isEmpty()) return null;
        return message;
    }
}
