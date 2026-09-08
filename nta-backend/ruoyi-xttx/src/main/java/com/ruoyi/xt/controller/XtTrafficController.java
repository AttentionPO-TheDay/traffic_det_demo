package com.ruoyi.xt.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.xt.domain.XtHost;
import com.ruoyi.xt.domain.XtMetaData;
import com.ruoyi.xt.domain.XtTraffic;
import com.ruoyi.xt.service.IXtHostService;
import com.ruoyi.xt.service.IXtTrafficService;
import com.ruoyi.xt.service.XtMetaDataService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 流量总Controller
 *
 * @author ruoyi
 * @date 2021-09-26
 */
@Api("Traffic CRUD")
@RestController
@RequestMapping("/xt/traffic")
public class XtTrafficController extends BaseController {
    @Autowired
    private IXtTrafficService xtTrafficService;

    @Autowired
    private IXtHostService xtHostService;

    @Autowired
    private XtMetaDataService xtMetaDataService;

    /**
     * 查询流量总列表
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:list')")
    @GetMapping("/list")
    public TableDataInfo list(XtTraffic xtTraffic) {
        startPage();
        List<XtTraffic> list = xtTrafficService.selectXtTrafficList(xtTraffic);
        return getDataTable(list);
    }

    /**
     * 导出流量总列表
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:export')")
    @Log(title = "流量总", businessType = BusinessType.EXPORT)
    @GetMapping("/export")
    public AjaxResult export(XtTraffic xtTraffic) {
        List<XtTraffic> list = xtTrafficService.selectXtTrafficList(xtTraffic);
        ExcelUtil<XtTraffic> util = new ExcelUtil<XtTraffic>(XtTraffic.class);
        return util.exportExcel(list, "流量总数据");
    }

    /**
     * 获取流量总详细信息
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:query')")
    @GetMapping(value = "/{uid}")
    public AjaxResult getInfo(@PathVariable("uid") String uid) {
        return AjaxResult.success(xtTrafficService.selectXtTrafficByUid(uid));
    }

    /**
     * 根据参数获取威胁信息
     */
    @ApiOperation("威胁信息查看")
    @GetMapping(value = "/threaten")
    public AjaxResult getThreaten() {
        return AjaxResult.success(xtTrafficService.selectXtTrafficByThreatenBiggerThanZero(0));
    }

    /**
     * 查询收到威胁的主机的信息
     */
    @ApiOperation("查询收到威胁的主机的信息")
    @GetMapping(value = "/threaten/asset/{minThreatNum}/{maxThreatNum}")
    public AjaxResult getThreatenAsset(@PathVariable("minThreatNum") int minThreatNum, @PathVariable("maxThreatNum") int maxThreatNum) {
        //        System.out.println("this is GetThreatenAsset!!=========》");
        List<Map<String, Object>> hostList = xtTrafficService.selectThreatenHostInScope(minThreatNum, maxThreatNum);
        //        System.out.println("this is GetThreatenAsset!!");
        //        System.out.println(hostList);

        List<Map<String, Object>> data = new ArrayList<>();

        //        System.out.println(hostList);
        for (int i = 0; i < hostList.size(); i++) {
            Map<String, Object> hostMap = hostList.get(i);
            XtHost xtHost = xtHostService.selectXtHostByHostid((String) hostMap.get("ANY_VALUE(hostid)"));
            Map<String, Object> dataElem = new HashMap<>();
            dataElem.put("host", xtHost);
            dataElem.put("threatenNum", hostMap.get("count"));
            data.add(dataElem);
        }

        return AjaxResult.success(data);
    }

    /**
     * 查询某负责人旗下一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     * 查询所有主机所收到的威胁数量、告警数量，以及相关的折线图数据,即前n台机器的前n个攻击手段,根据某一个负责人
     */
    @ApiOperation("查询某负责人旗下一台主机所收到的威胁数量、告警数量，以及相关的折线图数据")
    @GetMapping(value = "/threaten/info/{ownerId}/{trendTop}/{thretenHostNum}")
    public AjaxResult getThreatenInfoByOwner(@PathVariable("ownerId") String ownerId, @PathVariable("thretenHostNum") int thretenHostNum, @PathVariable("trendTop") int trendTop) {
        // 先选前n个host,其实没必要，直接限制for循环的个数就好
        // 筛选出前N个Host
        List<String> hostList = xtTrafficService.selectXtTrafficGroupByHostAndOwner(ownerId);
        System.out.println(hostList);
        Map<String, Object> data = new HashMap<>();
        Set<String> timestampSet = new HashSet<>();
        int hostLength = 0;
        if (hostList.size() >= thretenHostNum) {
            hostLength = thretenHostNum;
        } else {
            hostLength = hostList.size();
        }

        Map<String, Map<String, Map<String, Integer>>> mapElemHost = new HashMap<>();
        int resLength = 0;
        String hostName;

        for (int i = 0; i < hostLength; i++) {
            // 选出某一台机器等的前N个攻击手段
            hostName = hostList.get(i);
            // 在hostName总去筛选，根据Typegroupby
            List<String> typeList = xtTrafficService.selectXtTrafficGroupByType(hostName);
            System.out.println(typeList);
            int typeLength = 0;
            // 筛选出前N个攻击手段
            if (typeList.size() < trendTop) {
                typeLength = typeList.size();
            } else {
                typeLength = trendTop;
            }
            Map<String, Map<String, Integer>> mapElemType = new HashMap<>();
            for (int j = 0; j < typeLength; j++) {

                // 根据Host和Type，选出时间戳成Set，用来在Map中显示
                List<String> trafficTimestampList = xtTrafficService.selectXtTrafficTimestampByTypeAndHostName(hostName, typeList.get(j));
                timestampSet.addAll(trafficTimestampList);
                Map<String, Integer> mapElem = new HashMap<>();
                for (int k = 0; k < trafficTimestampList.size(); k++) {
                    //针对type，host和timestamp去查询，形成 timestamp-num的key-value对，
                    List<XtTraffic> xtTrafficList = xtTrafficService.selectXtTrafficByHostNameAndType(hostName, typeList.get(j), trafficTimestampList.get(k));

                    System.out.println("==========>");
                    System.out.println(xtTrafficList);
                    System.out.println("==========>");
                    int length = xtTrafficList.size();
                    resLength += length;
                    mapElem.put(trafficTimestampList.get(k), length);
                }
                mapElemType.put(typeList.get(j), mapElem);

            }
            mapElemHost.put(hostName, mapElemType);
        }
        List<String> timestampList = new ArrayList<>();
        timestampList.addAll(timestampSet);
        Collections.sort(timestampList);
        data.put("alertTrendTop", mapElemHost);
        data.put("timestamp", timestampList);
        data.put("alertNum", resLength);

        return AjaxResult.success(data);
    }

    /**
     * 查询所有主机所收到的威胁数量、告警数量，以及相关的折线图数据,即前n台机器的前n个攻击手段
     */
    @ApiOperation("查询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据")
    @GetMapping(value = "/threaten/info/{trendTop}/{thretenHostNum}")
    public AjaxResult getThreatenInfoByHost(@PathVariable("thretenHostNum") int thretenHostNum, @PathVariable("trendTop") int trendTop) {
        // 先选前n个host,其实没必要，直接限制for循环的个数就好
        List<String> hostList = xtTrafficService.selectXtTrafficGroupByHost();
        System.out.println(hostList);
        Map<String, Object> data = new HashMap<>();
        Set<String> timestampSet = new HashSet<>();
        int hostLength = 0;
        if (hostList.size() >= thretenHostNum) {
            hostLength = thretenHostNum;
        } else {
            hostLength = hostList.size();
        }

        Map<String, Map<String, Map<String, Integer>>> mapElemHost = new HashMap<>();
        int resLength = 0;
        for (int i = 0; i < hostLength; i++) {
            String hostName = hostList.get(i);
            // 在hostName总去筛选，根据Typegroupby
            List<String> typeList = xtTrafficService.selectXtTrafficGroupByType(hostName);
            System.out.println(typeList);
            int typeLength = 0;
            if (typeList.size() < trendTop) {
                typeLength = typeList.size();
            } else {
                typeLength = trendTop;
            }
            Map<String, Map<String, Integer>> mapElemType = new HashMap<>();
            for (int j = 0; j < typeLength; j++) {
                List<String> trafficTimestampList = xtTrafficService.selectXtTrafficTimestampByTypeAndHostName(hostName, typeList.get(j));
                timestampSet.addAll(trafficTimestampList);
                Map<String, Integer> mapElem = new HashMap<>();
                for (int k = 0; k < trafficTimestampList.size(); k++) {
                    //针对type去进行查询
                    List<XtTraffic> xtTrafficList = xtTrafficService.selectXtTrafficByHostNameAndType(hostName, typeList.get(j), trafficTimestampList.get(k));

                    System.out.println("==========>");
                    System.out.println(xtTrafficList);
                    System.out.println("==========>");
                    int length = xtTrafficList.size();
                    resLength += length;
                    mapElem.put(trafficTimestampList.get(k), length);
                }
                mapElemType.put(typeList.get(j), mapElem);

            }
            mapElemHost.put(hostName, mapElemType);
        }

        List<String> timestampList = new ArrayList<>();
        timestampList.addAll(timestampSet);
        Collections.sort(timestampList);
        data.put("alertTrendTop", mapElemHost);
        data.put("timestamp", timestampList);
        data.put("alertNum", resLength);

        return AjaxResult.success(data);
    }

    /**
     * 查询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据
     */
    @ApiOperation("查询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据")
    @GetMapping(value = "/threaten/info/host/{hostid}/{trendTop}")
    public AjaxResult getThreatenInfoByHost(@PathVariable("hostid") String hostid, @PathVariable("trendTop") int trendTop) {
        List<String> typeList = xtTrafficService.selectXtTrafficByHost(hostid, trendTop);
        System.out.println(typeList);
        //        List<List<XtTraffic>> resList = new ArrayList<List<XtTraffic>>();
        Set<String> timestampSet = new HashSet<>();
        Map<String, Object> data = new HashMap<>();
        Map<String, Map<String, Integer>> resData = new HashMap<>();
        int resLength = 0;
        for (int i = 0; i < typeList.size(); i++) {
            //先筛选出时间戳出来
            List<String> trafficTimestampList = xtTrafficService.selectXtTrafficTimestampByType(hostid, typeList.get(i));
            Map<String, Integer> mapElem = new HashMap<>();
            timestampSet.addAll(trafficTimestampList);
            for (int j = 0; j < trafficTimestampList.size(); j++) {
                //针对type去进行查询
                List<XtTraffic> xtTrafficList = xtTrafficService.selectXtTrafficByHostAndType(hostid, typeList.get(i), trafficTimestampList.get(j));

                System.out.println("==========>");
                System.out.println(xtTrafficList);
                System.out.println("==========>");
                int length = xtTrafficList.size();
                resLength += length;
                mapElem.put(trafficTimestampList.get(j), length);
            }
            resData.put(typeList.get(i), mapElem);
        }


        List<String> timestampList = new ArrayList<>();
        timestampList.addAll(timestampSet);
        Collections.sort(timestampList);
        System.out.println(timestampList);
        data.put("alertTrendTop", resData);
        data.put("timestamp", timestampList);
        data.put("alertNum", resLength);
        return AjaxResult.success(data);
    }

    /**
     * 查询某一位负责人名下的主机收到的威胁告警Detail
     */
    @ApiOperation("查询某一位负责人名下的主机收到的威胁告警")
    @GetMapping(value = "/threaten/info/owner/{ownerid}/{name}/{type}/{minTimestamp}/{maxTimestamp}/{handle}")
    public AjaxResult getThreatenDetailByOwner(@PathVariable("ownerid") String ownerId, @PathVariable("name") String name, @PathVariable("type") String type, @PathVariable("minTimestamp") Integer minTimestamp, @PathVariable("maxTimestamp") Integer maxTimestamp, @PathVariable("handle") Boolean handle) {
        String minTimestampStr = "" + minTimestamp;
        String maxTimestampStr = "" + maxTimestamp;
        if (!minTimestampStr.contains("\\.")) {
            minTimestampStr += ".";
        }
        while (minTimestampStr.length() < 17) {
            minTimestampStr += "0";
        }

        if (!maxTimestampStr.contains("\\.")) {
            maxTimestampStr += ".";
        }
        while (maxTimestampStr.length() < 17) {
            maxTimestampStr += "0";
        }


        if (handle) {
            return AjaxResult.success(xtTrafficService.selectXtTrafficByOwner(ownerId, name, type, minTimestampStr, maxTimestampStr, 1));
        } else {
            return AjaxResult.success(xtTrafficService.selectXtTrafficByOwner(ownerId, name, type, minTimestampStr, maxTimestampStr, 0));
        }

    }

    /**
     * 新增流量总
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:add')")
    @Log(title = "流量总", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody XtTraffic xtTraffic) {
        return toAjax(xtTrafficService.insertXtTraffic(xtTraffic));
    }

    /**
     * 修改流量总
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:edit')")
    @Log(title = "流量总", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody XtTraffic xtTraffic) {
        return toAjax(xtTrafficService.updateXtTraffic(xtTraffic));
    }

    /**
     * 删除流量总
     */
    @PreAuthorize("@ss.hasPermi('xt:traffic:remove')")
    @Log(title = "流量总", businessType = BusinessType.DELETE)
    @DeleteMapping("/{uids}")
    public AjaxResult remove(@PathVariable String[] uids) {
        return toAjax(xtTrafficService.deleteXtTrafficByUids(uids));
    }


    /**
     * 查询所有威胁告警
     */
    @ApiOperation("获取制定威胁ID的详细信息")
    @GetMapping(value = "/threaten/detail")
    public AjaxResult getAllThreaten(@RequestParam(name = "name", required = false) String name, @RequestParam(name = "type", required = false) String type, @RequestParam(name = "minTimestamp", required = false) Integer minTimestamp, @RequestParam(name = "maxTimestamp", required = false) Integer maxTimestamp, @RequestParam(name = "handled", required = false) Boolean handled) {
        String minTimestampStr = "";
        String maxTimestampStr = "";

        if (minTimestamp != null) {
            minTimestampStr = getTimeStamp(minTimestamp);
        }
        if (maxTimestamp != null) {
            maxTimestampStr = getTimeStamp(maxTimestamp);
        }
        List<XtTraffic> trafficRes = new ArrayList<>();
        if (handled != null && handled) {
            trafficRes = xtTrafficService.selectXtTrafficGetAllThreatenHandled(name, type, minTimestampStr, maxTimestampStr, 1);
        } else if (handled != null && !handled) {
            trafficRes = xtTrafficService.selectXtTrafficGetAllThreatenNotHandled(name, type, minTimestampStr, maxTimestampStr, -1);
        } else {
            trafficRes = xtTrafficService.selectXtTrafficGetAllThreaten(name, type, minTimestampStr, maxTimestampStr);
        }

        //TODO:等待删除
        System.out.println(trafficRes);
        List<XtMetaData> resMetaData = new ArrayList<>();
        for (XtTraffic xtt : trafficRes) {
            String uid = xtt.getUid();
            String tableName = xtt.getTablename();
            XtMetaData metaData = xtMetaDataService.selectXtMetaDataByUid(uid);
            if (metaData != null) {
                resMetaData.add(metaData);
            }

        }

        System.out.println(resMetaData);


        return AjaxResult.success(resMetaData);
    }

    /**
     * 获取制定威胁ID的详细信息
     */
    @ApiOperation("获取制定威胁ID的详细信息")
    @GetMapping(value = "/threaten/detail/id/{threatId}")
    public AjaxResult getThreatenDetailById(@PathVariable("threatId") String uid) {
        return AjaxResult.success(xtMetaDataService.selectXtMetaDataByUid(uid));
    }

    /**
     * 获取指定主机所收到的威胁警告
     */
    @ApiOperation("获取指定主机所收到的威胁警告")
    @GetMapping(value = "/threaten/detail/host/{hostId}")
    public AjaxResult getThreatenDetailByHostId(@PathVariable("hostId") String hostId, @RequestParam(name = "name", required = false) String name, @RequestParam(name = "type", required = false) String type, @RequestParam(name = "minTimestamp", required = false) Integer minTimestamp, @RequestParam(name = "maxTimestamp", required = false) Integer maxTimestamp, @RequestParam(name = "handled", required = false) Boolean handled, @RequestParam(name = "minThreatNum", required = false) Integer minThreatNum) {
        XtHost threatenHost = xtHostService.selectXtHostByHostid(hostId);
        String hostname = threatenHost.getHostname();
        String minTimestampStr = "";
        String maxTimestampStr = "";

        if (minTimestamp != null) {
            minTimestampStr = getTimeStamp(minTimestamp);
        }
        if (maxTimestamp != null) {
            maxTimestampStr = getTimeStamp(maxTimestamp);
        }

        List<XtTraffic> trafficRes;
        if (handled != null && handled) {
            trafficRes = xtTrafficService.selectXtTrafficByHostIdHandled(hostname, name, type, minTimestampStr, maxTimestampStr, 1, minThreatNum);
        } else if (handled != null && !handled) {
            trafficRes = xtTrafficService.selectXtTrafficByHostIdNotHandled(hostname, name, type, minTimestampStr, maxTimestampStr, -1, minThreatNum);
        } else {
            trafficRes = xtTrafficService.selectXtTrafficByHostId(hostname, name, type, minTimestampStr, maxTimestampStr, minThreatNum);
        }

        return null;

    }


    public String getTimeStamp(int timestamp) {
        String TimestampStr = "" + timestamp;

        if (!TimestampStr.contains("\\.")) {
            TimestampStr += ".";
        }
        while (TimestampStr.length() < 17) {
            TimestampStr += "0";
        }
        return TimestampStr;

    }
}
