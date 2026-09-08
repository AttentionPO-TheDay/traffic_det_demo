package com.ruoyi.xt.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.SensorStatusReq;
import com.ruoyi.xt.domain.XtMetaData;
import com.ruoyi.xt.domain.XtSensor;
import com.ruoyi.xt.service.CommandService;
import com.ruoyi.xt.service.XtMetaDataService;
import com.ruoyi.xt.service.XtSensorService;
import com.ruoyi.xt.util.CommandServiceUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/17/21 21:33
 * @Description:
 */
@RestController
@RequestMapping("/xt/sensors")
@Api("探针相关接口")
public class SensenControlController extends BaseController {
    @Autowired
    CommandService commandService;

    @Autowired
    XtMetaDataService xtMetaDataService;

    @Autowired
    XtSensorService xtSensorService;


    private static final String RootPath = "/root/sensor";

    private static final String KEY_INTERFACE = "SENSOR_INTERFACE";

    // status final
    private static final String SURICATA_STATUS_COMMAND = "/script -s status";
    private static final String ZEEK_STATUS_COMMAND = "/script -z status";

    // start
    private static final String ZEEK_START_COMMAND = "/script -z start";
    private static final String SURICATA_START_COMMAND = "/script -s start";

    // stop
    private static final String ZEEK_STOP_COMMAND = "/script -z stop";
    private static final String SURICATA_STOP_COMMAND = "/script -s stop";

    // restart
    private static final String ZEEK_RESTART_COMMAND = "ls -l";
    private static final String SURICATA_RESTART_COMMAND = "ls -l";

    @ApiOperation("获取所有探针状态")
    @GetMapping("/status")
    public AjaxResult getSensorsStatus() {
        List<XtSensor> xtSensorList = xtSensorService.selectXtSensorList();
        List<Map<String, Object>> res = new ArrayList<>();

        for (XtSensor xtSensor : xtSensorList) {
            Map<String, Object> resMap = new HashMap<>();

            boolean currState = getSensorCurrentState(xtSensor);
            resMap.put("sensor", xtSensor);
            resMap.put("status", currState);

            res.add(resMap);
        }
        return AjaxResult.success(res);
    }

    public boolean getSensorCurrentState(XtSensor xtSensor) {
        Map<String, String> cmdRes;
        if (xtSensor.getType().equals("suricata")) {
            cmdRes = commandService.executeCmd(RootPath + SURICATA_STATUS_COMMAND);
        } else {
            cmdRes = commandService.executeCmd(RootPath + ZEEK_STATUS_COMMAND);
        }

        return CommandServiceUtil.checkExecutionResult(cmdRes) != null;
    }

    @ApiOperation("控制探针的启停")
    @PostMapping("/status")
    public AjaxResult setSensorsStatus(@RequestBody SensorStatusReq sensorStatusReq) {
        Integer id = sensorStatusReq.id;
        Boolean expectedState = sensorStatusReq.status;
        Map<String, Object> res = new HashMap<>();

        XtSensor xtSensor = xtSensorService.selectXtSensorById(id);
        boolean currState = getSensorCurrentState(xtSensor);

        res.put("sensor", xtSensor);
        if (currState == expectedState) {
            res.put("status", currState);
            res.put("msg", "Already " + (currState ? "Started" : "Stopped"));
        } else {
            String cmd;
            if (currState) { // 原本是启动的，现在关闭
                cmd = xtSensor.getType().equals("suricata") ? SURICATA_STOP_COMMAND : ZEEK_STOP_COMMAND;
            } else { // 原本是关闭的，现在启动
                cmd = xtSensor.getType().equals("suricata") ? SURICATA_START_COMMAND : ZEEK_START_COMMAND;
            }

            Map<String, String> cmdRes = commandService.executeCmd(RootPath + cmd);
            if (CommandServiceUtil.checkExecutionResult(cmdRes) != null) {
                res.put("status", expectedState);
                res.put("msg", "Sensor " + (expectedState ? "started" : "stopped"));
            } else {
                AjaxResult.error("Status change command execution failed.");
            }
        }

        return AjaxResult.success(res);
    }

    @ApiOperation("返回探针的所有的元数据")
    @GetMapping("/metadata")
    public AjaxResult getSensorMetaData(@RequestParam("id") String id) {
        XtMetaData xtMetaData = xtMetaDataService.selectXtMetaDataByUid(id);
        if (xtMetaData == null) {
            return AjaxResult.error("cannot get metadata");
        } else {
            return AjaxResult.success(xtMetaData);
        }
    }
}
