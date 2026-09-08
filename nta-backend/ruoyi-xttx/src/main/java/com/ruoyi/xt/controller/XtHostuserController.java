package com.ruoyi.xt.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.xt.domain.XtHostuser;
import com.ruoyi.xt.service.IXtHostuserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户信息Controller
 *
 * @author zz
 * @date 2021-09-05
 */
@Api("HostUser CRUD")
@RestController
@RequestMapping("/xt/hostuser")
public class XtHostuserController extends BaseController {
    @Autowired
    private IXtHostuserService xtHostuserService;

    /**
     * 查询用户信息列表
     */
    @ApiOperation("hostuser查询")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:list')")
    @GetMapping("/list")
    public TableDataInfo list(XtHostuser xtHostuser) {
        startPage();
        List<XtHostuser> list = xtHostuserService.selectXtHostuserList(xtHostuser);
        return getDataTable(list);
    }

    /**
     * 导出用户信息列表
     */
    @ApiOperation("导出用户信息列表")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:export')")
    @Log(title = "用户信息", businessType = BusinessType.EXPORT)
    @GetMapping("/export")
    public AjaxResult export(XtHostuser xtHostuser) {
        List<XtHostuser> list = xtHostuserService.selectXtHostuserList(xtHostuser);
        ExcelUtil<XtHostuser> util = new ExcelUtil<XtHostuser>(XtHostuser.class);
        return util.exportExcel(list, "用户信息数据");
    }

    /**
     * 获取用户信息详细信息
     */
    @ApiOperation("获取用户信息详细信息")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:query')")
    @GetMapping(value = "/{userId}")
    public AjaxResult getInfo(@PathVariable("userId") String userId) {
        return AjaxResult.success(xtHostuserService.selectXtHostuserByUserId(userId));
    }

    /**
     * 新增用户信息
     */
    @ApiOperation("新增用户信息")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:add')")
    @Log(title = "用户信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody XtHostuser xtHostuser) {
        return toAjax(xtHostuserService.insertXtHostuser(xtHostuser));
    }

    /**
     * 修改用户信息
     */
    @ApiOperation("修改用户信息")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:edit')")
    @Log(title = "用户信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody XtHostuser xtHostuser) {
        return toAjax(xtHostuserService.updateXtHostuser(xtHostuser));
    }

    /**
     * 删除用户信息
     */
    @ApiOperation("删除用户信息")
    //    @PreAuthorize("@ss.hasPermi('xt:hostuser:remove')")
    @Log(title = "用户信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable String[] userIds) {
        return toAjax(xtHostuserService.deleteXtHostuserByUserIds(userIds));
    }
}
