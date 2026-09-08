package com.ruoyi.xt.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.*;
import com.ruoyi.xt.service.IXtHostService;
import com.ruoyi.xt.service.IXtHostuserService;
import com.ruoyi.xt.service.XtMetaDataService;
import com.ruoyi.xt.service.XtThreatService;
import com.ruoyi.xt.util.EsUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;


/**
 * @Auther: eniac
 * @Date: 11/19/21 04:27
 * @Description: 威胁、告警相关接口
 */

@Api("Threat:告警相关接口")
@RestController
@RequestMapping("/threat/info")
public class XtThreatController extends BaseController {

    @Autowired
    private IXtHostService xtHostService;

    @Autowired
    private XtMetaDataService xtMetaDataService;

    @Autowired
    private XtThreatService xtThreatService;

    @Autowired
    private IXtHostuserService xtHostuserService;

    @Autowired
    EsUtil esUtil;


    /**
     * 从Mysql中获取全局告警信息，筛选出前N台主机中前M中威胁的种类。
     *
     * @param trendTop       前 M 个最多的威胁种类
     * @param thretenHostNum 受威胁最多的 N 台主机
     * @return
     */
    @GetMapping("/")
    @ApiOperation("查询全局所收到的威胁数量、告警数量，以及相关的折线图数据")
    public AjaxResult getGlobalThreatInfo(@RequestParam(name = "trendTop", required = false) Integer trendTop, @RequestParam(name = "thretenHostNum", required = false) Integer thretenHostNum) {
        List<String> hostList = xtThreatService.selectThreatGroupByHost(); // 获得按照受威胁数量排序的主机名称
        int hostNum = 0; // 查询出来的主机数量
        if (thretenHostNum != null) {
            if (hostList.size() < thretenHostNum) {
                hostNum = hostList.size();
            } else {
                hostNum = thretenHostNum;
            }
        } else {
            hostNum = hostList.size();
        }

        List<String> threatNameList = xtThreatService.selectThreatGroupByName();  // 获得按照威胁数量排序的威胁名称
        int trendNum = 0;  // 查询出来的威胁的数量
        if (trendTop != null) {
            if (threatNameList.size() < trendTop) {
                trendNum = threatNameList.size();
            } else {
                trendNum = trendTop;
            }
        } else {
            trendNum = threatNameList.size();
        }
        String hostid;
        String threatName;
        Map<String, Object> res = new HashMap<>();
        Map<String, Object> resHostMap;
        List<Map<String, Object>> resHostMapList = new ArrayList<>();
        // 把每个主机信息存成一个哈希表，再把所有哈希表按照原始数量存入list中
        for (int i = 0; i < hostNum; i++) {
            hostid = hostList.get(i);
            XtHost xtHost = xtHostService.selectXtHostByHostid(hostid); // 根据主机id查询主机信息
            int threatNum = xtThreatService.selectThreatNumByHostId(hostid); // 根据主机id查询对应主机上威胁的个数
            resHostMap = new HashMap<>();
            resHostMap.put("host", xtHost);
            resHostMap.put("threatnum", threatNum);
            String ownerId = xtHost.getUserid();
            XtHostuser xtHostuser = xtHostuserService.selectXtHostuserByUserId(ownerId);
            resHostMap.put("owner", xtHostuser);

            resHostMapList.add(resHostMap);
        }
        // 把所有前trendNum个威胁的日期取出来存成一个哈希集合
        Set<String> resTimeSet = new HashSet<>();
        for (int i = 0; i < trendNum; i++) {
            threatName = threatNameList.get(i);
            List<String> timeElem = xtThreatService.selectThreatDateByName(threatName);
            resTimeSet.addAll(timeElem);
        }
        List<String> resTimeList = new ArrayList<>(resTimeSet);
        Collections.sort(resTimeList);  // 按照时间顺序排序


        Map<String, Object> resTrendTopElem = new HashMap<>();
        List<Integer> timeNumList;
        for (int i = 0; i < trendNum; i++) {
            timeNumList = new ArrayList<>();
            threatName = threatNameList.get(i);
            for (int j = 0; j < resTimeList.size(); j++) {
                String timeTemp = resTimeList.get(j);
                int threatNum = xtThreatService.selectThreatNumByNameAndDate(threatName, timeTemp);
                timeNumList.add(threatNum);
            }
            // 得到每个威胁，在每个时间有多少个，并存到map里
            resTrendTopElem.put(threatName, timeNumList);
        }
        // 构造返回结果，

        res.put("time", resTimeList);
        res.put("alertTrendTop", resTrendTopElem);
        res.put("threatenHosts", resHostMapList);
        return AjaxResult.success(res);
    }


    @GetMapping("/name")
    public AjaxResult getThreatName() {
        List<String> resTemp = xtThreatService.selectThreatName();
        List<String> res = new ArrayList<>();
        for (String threatName : resTemp) {
            if (threatName.equals("suricata")) {
                continue;
            } else {
                res.add(threatName);
            }
        }
        return AjaxResult.success(res);
    }

    /**
     * 新增流量总
     * TODO:测试接口 COMMIT之前删除
     */

    @PostMapping("/")
    @ApiOperation("新增threat")
    public AjaxResult add(@RequestBody XtThreat xtThreat) {
        return AjaxResult.success(xtThreatService.insertXtThreat(xtThreat));
    }

    /**
     * 从Mysql中获取全局告警信息，查询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据。
     *
     * @param trendTop 前xx个最多的威胁种类
     * @param hostId   受威胁主机ID
     * @return
     */
    @GetMapping("/host/{hostId}")
    @ApiOperation("查询某一台主机所收到的威胁数量、告警数量，以及相关的折线图数据")
    public AjaxResult getThreatInfoByHostId(@PathVariable("hostId") String hostId, @RequestParam(name = "trendTop", required = false) Integer trendTop) {
        long startTime = System.currentTimeMillis(); // 获取开始时间
        List<String> threatNameList = xtThreatService.selectThreatGroupByNameAndHost(hostId);
        long endTime = System.currentTimeMillis(); //获取结束时间
        System.out.println("程序运行时间： " + (endTime - startTime) + "ms");
        int trendNum = 0;
        if (trendTop != null) {
            if (threatNameList.size() < trendTop) {
                trendNum = threatNameList.size();
            } else {
                trendNum = trendTop;
            }
        } else {
            trendNum = threatNameList.size();
        }

        Set<String> resTimeSet = new HashSet<>();
        String threatName;
        startTime = System.currentTimeMillis();
        for (int i = 0; i < trendNum; i++) {
            threatName = threatNameList.get(i);
            List<String> timeElem = xtThreatService.selectThreatDateByNameAndHostId(threatName, hostId);
            resTimeSet.addAll(timeElem);
        }
        endTime = System.currentTimeMillis();
        System.out.println("程序运行时间： " + (endTime - startTime) + "ms");
        List<String> resTimeList = new ArrayList<>(resTimeSet);
        Collections.sort(resTimeList);
        Map<String, Integer> reverseMap = new HashMap<>();
        for (int i = 0; i < resTimeList.size(); i++) {
            reverseMap.put(resTimeList.get(i), i);
        }

        List<Integer> timeNumList;
        Map<String, Object> trendTopMap = new HashMap<>();
        // 威胁总数
        int threatNum = 0;
        startTime = System.currentTimeMillis();
        for (int i = 0; i < trendNum; i++) {
            threatName = threatNameList.get(i);
            timeNumList = new ArrayList<>(Collections.nCopies(resTimeList.size(), 0));
            List<XtThreatNum> xtThreatNumList = xtThreatService.selectThreatNumByNameAndDateAndHostId(threatName, hostId);
            for (XtThreatNum xtThreatNum : xtThreatNumList) {
                threatNum += xtThreatNum.getNum();
                // 获取日期对应的下标
                int index = reverseMap.get(xtThreatNum.getDate());
                System.out.println("大小 " + resTimeList.size() + "size " + index + "timeNumList size " + timeNumList.size());
                // 将对应的下标改成威胁数量
                timeNumList.set(index, xtThreatNum.getNum());
            }
            trendTopMap.put(threatName, timeNumList);
        }
        endTime = System.currentTimeMillis();
        System.out.println("程序运行时间： " + (endTime - startTime) + "ms");
        Map<String, Object> res = new HashMap<>();
        res.put("threatNum", threatNum);
        res.put("alertTrendTop", trendTopMap);
        res.put("time", resTimeList);
        return AjaxResult.success(res);
    }


    /**
     * 返回某一个负责人名下的所有主机的总威胁数量、总告警数量，以及相关的折线图数据。
     *
     * @param trendTop        前xx个最多的威胁种类
     * @param threatenHostNum 收威胁最严重的前n个
     * @return
     * @Param ownerId 主机负责人Id
     */
    @GetMapping("/owner/{ownerId}")
    @ApiOperation("返回某一个负责人名下的所有主机的总威胁数量、总告警数量，以及相关的折线图数据。")
    public AjaxResult getThreatInfoByHostId(@PathVariable("ownerId") String ownerId, @RequestParam(name = "trendTop", required = false) Integer trendTop, @RequestParam(name = "threatenHostNum", required = false) Integer threatenHostNum) {
        XtHost xtHost = new XtHost();
        xtHost.setUserid(ownerId);
        List<XtHost> hostList = xtHostService.selectXtHostList(xtHost);
        List<String> hostIdList = new ArrayList<>();
        // 把ownerId负责人负责的所有主机id存到hostIdList中
        // 感觉把hostList改成哈希集合，效率更高，下面的复杂度变成o（N）
        for (int i = 0; i < hostList.size(); i++) {
            String hostId = hostList.get(i).getHostid();
            hostIdList.add(hostId);
        }
        List<String> hostIdInOwnerList = new ArrayList<>();
        List<String> hostIdNotInOwnerList = xtThreatService.selectThreatGroupByHost();

        for (int i = 0; i < hostIdNotInOwnerList.size(); i++) {
            for (String h : hostIdList) {
                if (hostIdNotInOwnerList.get(i).equals(h)) {
                    hostIdInOwnerList.add(h);
                }
            }
        }
        // 显示主机数量
        int hostNum = 0;
        if (threatenHostNum != null) {
            if (hostIdInOwnerList.size() < threatenHostNum) {
                hostNum = hostIdInOwnerList.size();
            } else {
                hostNum = threatenHostNum;
            }
        } else {
            hostNum = hostIdInOwnerList.size();
        }
        hostIdInOwnerList = hostIdInOwnerList.subList(0, hostNum);

        List<String> threatNameList = xtThreatService.selectThreatGroupByNameAndHostList(hostIdInOwnerList);

        int threatNameNum = 0;
        if (trendTop != null) {
            if (trendTop < threatNameList.size()) {
                threatNameNum = trendTop;
            } else {
                threatNameNum = threatNameList.size();
            }
        } else {
            threatNameNum = threatNameList.size();
        }
        // 得到威胁名字列表  然后应该是判断判断时间 name=#{name} hostid in hostidlist
        Set<String> resTimeSet = new HashSet<>();
        for (int i = 0; i < threatNameNum; i++) {
            String threatname = threatNameList.get(i);
            List<String> timeListTemp = xtThreatService.selectThreatDateByNameAndHostIdList(threatname, hostIdInOwnerList);
            resTimeSet.addAll(timeListTemp);
        }

        List<String> resTimeList = new ArrayList<>(resTimeSet);
        Collections.sort(resTimeList);
        Map<String, Integer> reverseMap = new HashMap<>();
        for (int i = 0; i < resTimeList.size(); i++) {
            reverseMap.put(resTimeList.get(i), i);
        }

        // 得到威胁名字列表  然后应该是判断威胁 name=#{name} hostid in hostidlist
        List<Integer> timeList;
        Map<String, Object> res = new HashMap<>();
        Map<String, Object> resTrendTopMap = new HashMap<>();
        int threatNum = 0;
        for (int i = 0; i < threatNameNum; i++) {
            String threatname = threatNameList.get(i);
            timeList = new ArrayList<>(Collections.nCopies(resTimeList.size(), 0));
            List<XtThreatNum> xtThreatNumList = xtThreatService.selectThreatNumByNameAndDateAndHostIdList(threatname, hostIdInOwnerList);
            for (XtThreatNum xtThreatNum : xtThreatNumList) {
                threatNum += xtThreatNum.getNum();
                int index = reverseMap.get(xtThreatNum.getDate());
                System.out.println("大小 " + resTimeList.size() + "size " + index + "timeNumList size " + timeList.size());
                timeList.set(index, xtThreatNum.getNum());
            }
            resTrendTopMap.put(threatname, timeList);
        }
        //threatNum 所有威胁的总数
        res.put("threatNum", threatNum);
        res.put("alertTrendTop", resTrendTopMap);
        res.put("time", resTimeList);

        return AjaxResult.success(res);
    }

    /**
     * 查询受威胁的主机信息，主机收到的威胁数量应该大于等于a小于等于b。
     *
     * @param minThreatNum 上文中的a
     * @param maxThreatNum 上文中的b
     * @return
     */
    @GetMapping("/threat/asset")
    @ApiOperation("查询受威胁的主机信息")
    //TODO: 看一下这个函数  需要分页的到底是什么
    public AjaxResult getThreatAsset(@RequestParam(name = "minThreatNum", required = false) Integer minThreatNum, @RequestParam(name = "maxThreatNum", required = false) Integer maxThreatNum) {
        // 先获取满足条件的每个hostId的威胁数量
        List<Integer> totalList = xtThreatService.selectHostInScopeGroupByHostId(minThreatNum, maxThreatNum);
        int total = totalList.size();
        startPage();
        //  获取满足条件的hostId的列表
        List<String> hostIdList = xtThreatService.selectThreatHostIdGroupByHostInScope(minThreatNum, maxThreatNum);
        List<XtHost> resHost = new ArrayList<>();
        // 根据主机id查询主机信息并依次保存在resHost中
        for (String hostId : hostIdList) {
            XtHost xtHost = xtHostService.selectXtHostByHostid(hostId);
            resHost.add(xtHost);
        }

        List<Integer> resThreatNumList = new ArrayList<>();
        // 根据主机id查询每个主机受到的威胁的数量，并依次存到resThreatNumList中
        for (String hostId : hostIdList) {

            int num = xtThreatService.selectThreatNumByHostId(hostId);
            resThreatNumList.add(num);
        }
        // 把每个主机和对应的威胁数量存到一个map中，再依次存到resRows中
        List<Map<String, Object>> resRows = new ArrayList<>();
        Map<String, Object> res = new HashMap<>();
        for (int i = 0; i < resHost.size(); i++) {
            Map<String, Object> resElem = new HashMap<>();
            resElem.put("threatNum", resThreatNumList.get(i));
            resElem.put("host", resHost.get(i));
            resRows.add(resElem);
        }
        res.put("total", total);
        res.put("rows", resRows);
        return AjaxResult.success(res);

    }

    /**
     * 从Mysql中，根据名称、来源、时间范围查询所有告警威胁。
     *
     * @param name   威胁类型
     * @param source 威胁来源
     * @return
     * @Param timestamp 时间范围
     */
    @GetMapping("/threat/detail")
    @ApiOperation("查询所有告警威胁")
    public AjaxResult getThratDetail(@RequestParam(name = "name", required = false) String name,
                                     @RequestParam(name = "source", required = false) String source,
                                     @RequestParam(name = "minTimestamp", required = false) Integer minTimestamp,
                                     @RequestParam(name = "maxTimestamp", required = false) Integer maxTimestamp,
                                     @RequestParam(name = "handled", required = false) Boolean handled) {
        int handle = 0;
        int total = 0;
        List<XtThreat> threatList;
        String minTimestampStr = null;
        String maxTimestampStr = null;
        if (minTimestamp != null) {
            minTimestampStr = getTimeStamp(minTimestamp);
        }
        if (maxTimestamp != null) {
            maxTimestampStr = getTimeStamp(maxTimestamp);
        }
        if (handled != null) {
            if (handled) {
                handle = 1;
            } else {
                handle = 0;
            }
            total = xtThreatService.selectThreatDetailNumByHandle(name, source, minTimestampStr, maxTimestampStr, handle);

            startPage();
            threatList = xtThreatService.selectThreatDetailByHandle(name, source, minTimestampStr, maxTimestampStr, handle);
        } else {
            total = xtThreatService.selectThreatDetailNumNotHandle(name, source, minTimestampStr, maxTimestampStr);

            startPage();
            threatList = xtThreatService.selectThreatDetailNotHandle(name, source, minTimestampStr, maxTimestampStr);
        }

        String hostId;
        Map<String, Object> resElemMap;

        List<Map<String, Object>> resRows = new ArrayList<>();

        Map<String, Object> res = new HashMap<>();

        for (XtThreat xtThreat : threatList) {

            resElemMap = new HashMap<>();
            hostId = xtThreat.getHostid();
            resElemMap.put("name", xtThreat.getName());
            resElemMap.put("source", xtThreat.getSource());
            resElemMap.put("srcIp", xtThreat.getSrcIp());
            resElemMap.put("dstIp", xtThreat.getDstIp());
            resElemMap.put("srcPort", xtThreat.getSrcPort());
            resElemMap.put("dstPort", xtThreat.getDstPort());
            resElemMap.put("timestamp", xtThreat.getTimestamp());
            resElemMap.put("flowid", xtThreat.getUid());
            resElemMap.put("handle", xtThreat.getHandled());
            resElemMap.put("threatenHost", xtHostService.selectXtHostByHostid(hostId));
            resElemMap.put("threat_id", xtThreat.getThreatId());
            resElemMap.put("is_threat", xtThreat.getIsThreat());
            resElemMap.put("modelName", xtThreat.getModelName());
            resRows.add(resElemMap);
        }

        res.put("rows", resRows);
        res.put("total", total);
        return AjaxResult.success(res);

    }


    /**
     * 根据威胁ID获取威胁详细信息。
     *
     * @param threatId 威胁ID
     * @return
     */
    @GetMapping("/threat/detail/id/{threatId}")
    @ApiOperation("获取指定威胁 ID 的详细信息。")
    public AjaxResult getThratDetail(@PathVariable("threatId") Integer threatId) {
        XtThreat xtThreat = xtThreatService.selectThreatByThreatId(threatId);
        String flowId = xtThreat.getUid();
        XtMetaData metaData = xtMetaDataService.selectXtMetaDataByUid(flowId);
        Map<String, Object> res = new HashMap<>();
        res.put("threat", xtThreat);
        res.put("sensortData", metaData);
        return AjaxResult.success(res);
    }

    /**
     * 从Mysql中查询指定主机所受到的威胁告警。
     *
     * @param hostId 主机Id
     * @param name   威胁名称
     * @param source 威胁来源
     * @return
     * @Param timestamp 时间范围
     */
    @GetMapping("/threat/detail/host/{hostId}")
    @ApiOperation("查询指定主机所受到的威胁告警。")
    public AjaxResult getThreatByHostId(@PathVariable("hostId") String hostId, @RequestParam(name = "name", required = false) String name, @RequestParam(name = "source", required = false) String source, @RequestParam(name = "minTimestamp", required = false) Integer minTimestamp, @RequestParam(name = "maxTimestamp", required = false) Integer maxTimestamp, @RequestParam(name = "handled", required = false) Boolean handled) {
        int handle = 0;
        List<XtThreat> threatList;
        String minTimestampStr = null;
        String maxTimestampStr = null;
        //对时间戳字符串进行处理
        if (minTimestamp != null) {
            minTimestampStr = getTimeStamp(minTimestamp);
        }
        if (maxTimestamp != null) {
            maxTimestampStr = getTimeStamp(maxTimestamp);
        }
        int total = 0;
        if (handled != null) {
            if (handled) {
                handle = 1;
            } else {
                handle = 0;
            }
            total = xtThreatService.selectThreatDetailNumByHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, handle, hostId);

            startPage();
            threatList = xtThreatService.selectThreatDetailByHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, handle, hostId);
        } else {
            total = xtThreatService.selectThreatDetailNumNotHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, hostId);

            startPage();
            threatList = xtThreatService.selectThreatDetailNotHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, hostId);
        }
        Map<String, Object> res = new HashMap<>();
        res.put("total", total);
        res.put("rows", threatList);
        return AjaxResult.success(res);
    }

    /**
     * 从Mysql中，根据名称、来源、时间范围查询所有告警威胁。
     *
     * @param name   威胁类型
     * @param source 威胁来源
     * @return
     * @Param ownerId 负责人Id
     * @Param timestamp 时间范围
     */
    @GetMapping("/threat/detail/owner/{ownerId}")
    @ApiOperation("查询指定负责人旗下的主机所受到的威胁告警。")
    public AjaxResult getThreatByOwnerId(@PathVariable("ownerId") String ownerId, @RequestParam(name = "name", required = false) String name, @RequestParam(name = "source", required = false) String source, @RequestParam(name = "minTimestamp", required = false) Integer minTimestamp, @RequestParam(name = "maxTimestamp", required = false) Integer maxTimestamp, @RequestParam(name = "handled", required = false) Boolean handled) {
        // 1. get hostid list

        List<XtThreat> resList = new ArrayList<>();
        XtHost xtHost = new XtHost();
        xtHost.setUserid(ownerId);
        // 查询ownerId管理的所有主机
        List<XtHost> hostList = xtHostService.selectXtHostList(xtHost);

        int handle = 0;
        List<XtThreat> threatList;
        String minTimestampStr = null;
        String maxTimestampStr = null;
        if (minTimestamp != null) {
            minTimestampStr = getTimeStamp(minTimestamp);
        }
        if (maxTimestamp != null) {
            maxTimestampStr = getTimeStamp(maxTimestamp);
        }

        boolean usingHandle = false;
        if (handled != null) {
            if (handled) {
                handle = 1;
            } else {
                handle = 0;
            }
            usingHandle = true;
        } else {
            usingHandle = false;
        }

        int total = 0;
        for (XtHost host : hostList) {
            String hostId = host.getHostid();
            if (usingHandle) {
                total += xtThreatService.selectThreatDetailNumByHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, handle, hostId);

                startPage();
                threatList = xtThreatService.selectThreatDetailByHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, handle, hostId);
            } else {
                total += xtThreatService.selectThreatDetailNumNotHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, hostId);

                startPage();
                threatList = xtThreatService.selectThreatDetailNotHandleWithHostId(name, source, minTimestampStr, maxTimestampStr, hostId);
            }
            resList.addAll(threatList);
        }
        Map<String, Object> res = new HashMap<>();
        res.put("total", total);
        res.put("rows", resList);
        return AjaxResult.success(res);
    }

    /**
     * 更改某一个告警的状态，威胁是否处理进行修改
     *
     * @return
     * @Param timestamp 时间范围
     */
    @PostMapping("/threat/handled")
    @ApiOperation("更改某一个告警的状态")
    public AjaxResult changeThreatStatus(@RequestBody ThreatChangeStateReq threatChangeStateReq) {
        Integer threatId = threatChangeStateReq.threatId;
        Boolean handled = threatChangeStateReq.handled;
        int handleValue = 0;
        if (handled) {
            handleValue = 1;
        } else {
            handleValue = 0;
        }
        int resValue = xtThreatService.updateThreatStatus(threatId, handleValue);
        //        System.out.println(resValue);
        Map<String, Object> esUpdateMap = new HashMap<>();
        esUpdateMap.put("handled", threatChangeStateReq.handled);
        XtThreat xtThreat = xtThreatService.selectThreatByThreatId(threatId);
        String uid = xtThreat.getUid();
        esUtil.updateThreate("test-traffic", uid, esUpdateMap);

        return AjaxResult.success();
    }


    /**
     * 工具函数，用来拼接Timestamp
     * TODO：移到UTIL当中
     */
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
