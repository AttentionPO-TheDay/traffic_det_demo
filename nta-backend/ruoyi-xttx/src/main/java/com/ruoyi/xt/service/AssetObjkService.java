package com.ruoyi.xt.service;

import com.ruoyi.xt.domain.AssetsDiscoveryRes;
import org.springframework.stereotype.Component;

/**
 * @Auther: eniac
 * @Date: 5/18/22 18:17
 * @Description:
 */

@Component
public class AssetObjkService {
    private AssetsDiscoveryRes assetsDiscoveryRes;

    public AssetsDiscoveryRes getAssetsDiscoveryRes() {
        return assetsDiscoveryRes;
    }

    public void setAssetsDiscoveryRes(AssetsDiscoveryRes assetsDiscoveryRes) {
        this.assetsDiscoveryRes = assetsDiscoveryRes;
    }
}
