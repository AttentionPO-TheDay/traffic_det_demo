import request from '@/utils/request';

export async function historyAsset(dataFilter) {
  return request({
    method: 'get',
    url: 'xt/assets/history',
    params: dataFilter
  });
}

export async function assetDetailedInfo(dataFilter) {
  return request({
    method: 'get',
    url: 'xt/assets/history/info',
    params: dataFilter
  });
}