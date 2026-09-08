package com.ruoyi.xt.controller;

import com.alibaba.fastjson.JSONObject;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.xt.domain.XtPcap;
import com.ruoyi.xt.domain.XtSensor;
import com.ruoyi.xt.mapper.XtPcapMapper;
import com.ruoyi.xt.service.XtPcapService;
import com.ruoyi.xt.service.impl.CommandServiceImpl;
import com.ruoyi.xt.service.impl.XtSensorServiceImpl;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 4/14/22 02:09
 * @Description:
 */
@RestController
@RequestMapping("/xt/pcap")
@Api("Pcap上传接口")
public class PcapUpload {

    /**
     * 以下路径均通过环境变量注入（application.yml 已映射 sensor.root-path / pcap.dir）
     */
    @Value("${pcap.dir:/root/pcap}")
    private String uploadFilePath;

    @Autowired
    CommandServiceImpl commandService;

    @Autowired
    XtSensorServiceImpl xtSensorService;

    @Autowired
    XtPcapService xtpcapService;

    @Value("${sensor.root-path:/root/sensor}")
    private String RootPath;

    // status final
    private static final String PcapAnalyse = "/script zeek pcap ";

    @Value("${pcap.dir:/root/pcap}")
    private String PcapPath;

    @Value("${sensor.extract-dir:/root/sensor/extract_files}")
    private String PcapDownloadPath;

    @PostMapping("/upload")
    public AjaxResult httpUpload(@RequestParam("files") MultipartFile[] files) {
        JSONObject object = new JSONObject();
        List<Map<String, Object>> res = new ArrayList<>();
        for (MultipartFile file : files) {
            XtPcap xtPcap = new XtPcap();
            // 获取源文件名
            String fileName = file.getOriginalFilename();
            File dest = new File(uploadFilePath + '/' + fileName);
            // 获取父目录目录名，如果不存在就创建出来
            if (!dest.getParentFile().exists()) {
                dest.getParentFile().mkdirs();
            }

            try {
                file.transferTo(dest);
                xtPcap.setName(fileName);
                xtPcap.setSize(dest.length());
                xtPcap.setTimestamp(String.valueOf(System.currentTimeMillis()));
                System.out.printf("%s文件大小为%d", dest.getName(), dest.length());
            } catch (Exception e) {
                object.put("success", 2);
                object.put("result", "程序错误，请重新上传");
                System.out.println("result:程序错误，请重新上传");
                return AjaxResult.error("程序错误，请重新上传");
            }

            xtpcapService.insertXtPcap(xtPcap);
            pcapExecute(PcapPath + "/" + fileName);
            Map<String, Object> tmp = new HashMap<>();
            tmp.put("result", "成功");
            res.add(tmp);
        }

        System.out.println("result:文件上传成功");
        return AjaxResult.success(res);
    }

    @GetMapping("/upload/history")
    public AjaxResult UploadHistory() {
        List<XtPcap> xtPcapList = xtpcapService.selectXtPcapList();
        List<Map<String, Object>> res = new ArrayList<>();

        for (XtPcap xtPcap : xtPcapList) {
            Map<String, Object> resMap = new HashMap<>();

            resMap.put("name", xtPcap.getName());
            resMap.put("size", xtPcap.getSize());
            resMap.put("timestamp", xtPcap.getTimestamp());

            res.add(resMap);
        }
        return AjaxResult.success(res);
    }

    public Map<String, String> pcapExecute(String uploadFilePath) {
        Map<String, String> res = commandService.executeCmd(RootPath + PcapAnalyse + uploadFilePath);
        return res;
    }

    @RequestMapping("/download")
    public AjaxResult fileDownLoad(HttpServletResponse response, @RequestParam("file_name") String fileName, @RequestParam("file_type") String fileType) {
        File file = null;
        String resFileName = null;
        if (fileType.equals("pcap")) {
            file = new File(PcapDownloadPath + '/' + fileName + ".pcap");
            resFileName = fileName + ".pcap";
        } else if (fileType.equals("orig")) {
            file = new File(PcapDownloadPath + '/' + fileName + "_orig.bin");
            resFileName = fileName + "_orig.bin";
        } else if (fileType.equals("resp")) {
            file = new File(PcapDownloadPath + '/' + fileName + "_resp.bin");
            resFileName = fileName + "_resp.bin";
        } else {
            return AjaxResult.error("文件不存在！");
        }

        if (!file.exists()) {
            return AjaxResult.error("下载文件不存在");
        }
        response.reset();
        response.setContentType("application/octet-stream");
        response.setCharacterEncoding("utf-8");
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment;filename=" + resFileName);

        try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file))) {
            byte[] buff = new byte[1024];
            OutputStream os = response.getOutputStream();
            int i;
            while ((i = bis.read(buff)) != -1) {
                os.write(buff, 0, i);
                os.flush();
            }
        } catch (IOException e) {
            return AjaxResult.error("下载失败");
        }
        return AjaxResult.success("下载成功");
    }


}
