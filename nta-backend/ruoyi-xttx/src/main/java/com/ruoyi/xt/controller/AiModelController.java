package com.ruoyi.xt.controller;

import com.alibaba.fastjson.JSON;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.AiModelEnableReq;
import com.ruoyi.xt.domain.AiModelSingleStatusResponse;
import com.ruoyi.xt.service.AsyncService;
import com.ruoyi.xt.service.CommandService;
import com.ruoyi.xt.service.impl.AiModel;
import com.ruoyi.xt.service.impl.KafkaListenerSensor;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 11/20/21 08:02
 * @Description:
 */
@RestController
@RequestMapping("/xt/aimodel")
@Api("规则和模型的相关接口")
public class AiModelController {
    @Autowired
    KafkaListenerSensor kafkaListener;

    @Autowired
    SensenControlController sensenControlController;

    @Autowired
    AsyncService asyncService;

    @Autowired
    CommandService commandService;

    private static final String ROOT_PATH = "/root/sensor/";
    private static final String LIST_RULE_COMMAND = "script -s rules list";
    private static final String ENABLE_RULE_COMMAND = "script -s rules enable ";
    private static final String DISABLE_RULE_COMMAND = "script -s rules disable ";
    private static final String RELOAD_RULE_COMMAND = "script -s rules reload";
    private static final String UNZIP_COMMAND = "unzip -nq -d /root/Model/models/ ";

    @PostMapping("/addRules")
    @ApiOperation("增加suricata规则")
    public AjaxResult addSuricataRules(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = file.getOriginalFilename();
            File dest = new File(ROOT_PATH + "suricata/" + fileName + ".disabled");
            if (dest.exists()) {
                return AjaxResult.error("文件已存在");
            }
            file.transferTo(dest);
            asyncService.reloadRules(ROOT_PATH, RELOAD_RULE_COMMAND);
        } catch (Exception e) {
            return AjaxResult.error("增加suricata规则失败");
        }
        return AjaxResult.success("增加suricata规则成功");
    }

    @GetMapping("/downloadRules")
    @ApiOperation("下载suricata规则")
    public ResponseEntity<Resource> downloadSuricataRules(@RequestParam String fileName) {
        try {
            Path filePath = Paths.get(ROOT_PATH + "suricata/").resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists()) {
                return ResponseEntity.notFound().build();
            }

            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"");
            headers.add(HttpHeaders.CONTENT_TYPE, "application/octet-stream");

            return ResponseEntity.ok()
                .headers(headers)
                .contentLength(resource.contentLength())
                .body(resource);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/deleteRules")
    @ApiOperation("删除suricata规则")
    public AjaxResult deleteSuricataRules(@RequestParam("file") String fileName) {
        try {
            File file = new File(ROOT_PATH + "suricata/" + fileName);
            if (!file.exists()) {
                return AjaxResult.error("文件不存在");
            }
            if (!file.delete()) {
                return AjaxResult.error("删除suricata规则失败");
            }
            asyncService.reloadRules(ROOT_PATH, RELOAD_RULE_COMMAND);
        } catch (Exception e) {
            return AjaxResult.error("删除suricata规则失败");
        }
        return AjaxResult.success("删除suricata规则成功");
    }

    @GetMapping("/status")
    @ApiOperation("获取所有模型、规则的状态")
    public AjaxResult getAiModelStatus(@RequestParam("type") String type) {
        List<Map<String, Object>> res = new ArrayList<>();
        Map<String, Object> resElem;
        if (type.equals("rule")) {
            Map<String, String> cmdRes = commandService.executeCmd(ROOT_PATH + LIST_RULE_COMMAND);

            if (cmdRes != null) {
                String cmdStr = cmdRes.get("command_result");
                if (cmdStr != null && cmdStr.equals("success")) {
                    Map<String, Object> cmdResMap = JSON.parseObject(cmdRes.get("msg"));
                    if (cmdResMap != null) {
                        boolean isSuccess = (Boolean) cmdResMap.get("success");
                        if (isSuccess) {
                            List<String> rules = (List<String>) cmdResMap.get("rules");
                            for (String rule : rules) {
                                resElem = new HashMap<>();
                                if (rule.contains("disabled")) {
                                    resElem.put("type", "rule");
                                    resElem.put("name", rule);
                                    resElem.put("status", false);
                                    //                                    resElem.put("msg","");
                                } else {
                                    resElem.put("type", "rule");
                                    resElem.put("name", rule);
                                    resElem.put("status", true);
                                }
                                res.add(resElem);
                            }
                        }
                    }
                }
            }
        } else {
            AiModel aiModel = new AiModel();
            res = aiModel.getStatus();
        }
        if (res == null) {
            return AjaxResult.error("cannot get state");
        } else {
            return AjaxResult.success(res);
        }

    }


    @PostMapping("/enable")
    @ApiOperation("修改所有模型、规则的状态")
    public AjaxResult enableAiModel(@RequestBody AiModelEnableReq req) {
        String type = req.type;
        String id = req.id;
        Boolean status = req.status;
        Map<String, Object> res = new HashMap<>();
        Map<String, String> cmdRes;
        String name;
        if (type != null && type.length() != 0) {
            if (type.equals("rule")) {
                if (status) {
                    cmdRes = commandService.executeCmd(ROOT_PATH + ENABLE_RULE_COMMAND + id);
                    //                    name = id.split("\\.")[0];
                    name = id.replace(".disabled", "");
                } else {
                    cmdRes = commandService.executeCmd(ROOT_PATH + DISABLE_RULE_COMMAND + id);
                    name = id + ".disabled";
                }
                if (cmdRes != null) {
                    String cmdStr = cmdRes.get("command_result");
                    if (cmdStr != null && cmdStr.equals("success")) {
                        Map<String, Object> cmdResMap = JSON.parseObject(cmdRes.get("msg"));
                        if (cmdResMap != null) {
                            boolean isSuccess = (Boolean) cmdResMap.get("success");
                            if (isSuccess) {
                                res.put("status", status);
                                res.put("type", "rule");
                                res.put("name", name);
                                return AjaxResult.success(res);
                            } else {
                                return AjaxResult.error("cannot set status");
                            }

                        } else {
                            return AjaxResult.error("cannot set status");
                        }
                    } else {
                        return AjaxResult.error("cannot set status");
                    }
                } else {
                    return AjaxResult.error("cannot set status");
                }

            } else if (type.equals("aimodel")) {
                AiModel aiModel = new AiModel();
                AiModelSingleStatusResponse aiModelSingleStatusResponse = aiModel.getSingleStatus(id);
                if (aiModel == null) {
                    return AjaxResult.error("cannot set status");
                } else {
                    boolean statusNow;
                    if (aiModelSingleStatusResponse.isSuccess()) {
                        if (aiModelSingleStatusResponse.getState().equals("on")) {
                            statusNow = true;
                        } else {
                            statusNow = false;
                        }
                        if (status == statusNow) {
                            res = new HashMap<>();
                            res.put("status", status);
                            res.put("type", "rule");
                            res.put("name", id);
                            return AjaxResult.success(res);
                        } else {
                            res = aiModel.setStatus(id);
                            return AjaxResult.success(res);
                        }

                    } else {
                        return AjaxResult.error("cannot set status");
                    }
                }

            } else {
                return AjaxResult.error("cannot set status");
            }
        } else {
            return AjaxResult.error("cannot set status");
        }


        //        return AjaxResult.success(res);
    }

    @PostMapping("/addModel")
    @ApiOperation("增加模型")
    public AjaxResult addAiModel(MultipartFile file) {
        String fileName = file.getOriginalFilename();
        String fileBaseName = fileName.substring(0, fileName.lastIndexOf("."));
        ;
        File dest = null;
        try {
            dest = new File("/root/" + fileName);
            file.transferTo(dest);
            System.out.println(UNZIP_COMMAND + "/root/" + fileName);
            commandService.executeCmd(UNZIP_COMMAND + "/root/" + fileName);
        } catch (Exception e) {
            System.out.println("解压缩失败");
            System.out.println(fileName);
            System.out.println(fileBaseName);
            return AjaxResult.error("error");
        } finally {
            dest.delete();
        }
        AiModel aiModel = new AiModel();
        Map<String, Object> m = aiModel.addModel(fileBaseName);
        if (m.get("res").equals(true)) {
            return AjaxResult.success("success");
        }
        System.out.println("解析模型文件失败");
        return AjaxResult.error("error");
    }


}
