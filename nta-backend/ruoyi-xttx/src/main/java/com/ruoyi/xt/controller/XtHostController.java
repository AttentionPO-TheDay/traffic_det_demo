package com.ruoyi.xt.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.xt.domain.XtHost;
import com.ruoyi.xt.domain.XtHostuser;
import com.ruoyi.xt.service.IXtHostService;
import com.ruoyi.xt.service.IXtHostuserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 主机Controller
 *
 * @author ruoyi
 * @date 2021-09-06
 */
@Api("Host CRUD")
@RestController
@RequestMapping("/system/host")
public class XtHostController extends BaseController {
    @Autowired
    private IXtHostService xtHostService;

    @Autowired
    private IXtHostuserService xtHostuserService;

    /**
     * 查询主机列表
     */
    @ApiOperation("host查询")
    //    @PreAuthorize("@ss.hasPermi('xt:host:list')")
    @GetMapping("/list")
    public TableDataInfo list(XtHost xtHost) {
        startPage();
        List<XtHost> list = xtHostService.selectXtHostList(xtHost);
        return getDataTable(list);
    }

    /**
     * 导出主机列表
     */
    @ApiOperation("host导出")
    //    @PreAuthorize("@ss.hasPermi('xt:host:export')")
    @Log(title = "主机", businessType = BusinessType.EXPORT)
    @GetMapping("/export")
    public AjaxResult export(XtHost xtHost) {
        List<XtHost> list = xtHostService.selectXtHostList(xtHost);
        ExcelUtil<XtHost> util = new ExcelUtil<XtHost>(XtHost.class);
        return util.exportExcel(list, "主机数据");
    }

    /**
     * 获取主机详细信息
     */
    @ApiOperation("host详细信息查询")
    //    @PreAuthorize("@ss.hasPermi('xt:host:query')")
    @GetMapping(value = "/{hostid}")
    public AjaxResult getInfo(@PathVariable("hostid") String hostid) {
        XtHost xtHost = xtHostService.selectXtHostByHostid(hostid);
        if (xtHost == null) {
            return AjaxResult.error("cannot get host message");
        }
        String userId = xtHost.getUserid();
        XtHostuser xtHostuser = null;
        if (userId != null) {
            xtHostuser = xtHostuserService.selectXtHostuserByUserId(userId);
        }
        Map<String, Object> res = new HashMap<>();
        res.put("hostid", xtHost.getHostid());
        res.put("hostname", xtHost.getHostname());
        res.put("address", xtHost.getAddress());
        res.put("userid", userId);
        Map<String, Object> resUser = null;
        if (xtHostuser != null) {
            resUser = new HashMap<>();
            resUser.put("userId", xtHostuser.getUserId());
            resUser.put("name", xtHostuser.getName());
            resUser.put("phone", xtHostuser.getPhone());
            resUser.put("depature", xtHostuser.getDeparture());
            resUser.put("job", xtHostuser.getJob());
            resUser.put("description", xtHostuser.getDescription());
        }

        res.put("owner", resUser);
        return AjaxResult.success(res);
    }

    /**
     * 新增主机
     */
    @ApiOperation("host新增")
    //    @PreAuthorize("@ss.hasPermi('xt:host:add')")
    @Log(title = "主机", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody XtHost xtHost) {
        return toAjax(xtHostService.insertXtHost(xtHost));
    }

    /**
     * 批量新增主机
     */
    @ApiOperation("host批量新增")
    //    @PreAuthorize("@ss.hasPermi('xt:host:add')")
    @Log(title = "主机", businessType = BusinessType.INSERT)
    @PostMapping("/InsertHostsFromExcel")
    public AjaxResult add(@RequestParam MultipartFile file) throws Exception
    {
        if (file.isEmpty()) {
                return AjaxResult.error("上传的文件为空");
        }
        ExcelUtil<XtHost> util = new ExcelUtil<>(XtHost.class);
        List<XtHost> XtHostList = util.importExcel(file.getInputStream());
        return toAjax(xtHostService.insertXtHosts(XtHostList));
    }

    /**
     * 修改主机
     */
    @ApiOperation("host修改")
    //    @PreAuthorize("@ss.hasPermi('xt:host:edit')")
    @Log(title = "主机", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody XtHost xtHost) {
        return toAjax(xtHostService.updateXtHost(xtHost));
    }

    /**
     * 删除主机
     */
    @ApiOperation("host删除")
    //    @PreAuthorize("@ss.hasPermi('xt:host:remove')")
    @Log(title = "主机", businessType = BusinessType.DELETE)
    @DeleteMapping("/{hostids}")
    public AjaxResult remove(@PathVariable String[] hostids) {
        return toAjax(xtHostService.deleteXtHostByHostids(hostids));
    }
}
