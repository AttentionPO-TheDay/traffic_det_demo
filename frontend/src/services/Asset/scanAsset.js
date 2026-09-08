import request from '@/utils/request';

export async function scanAsset(startIP, endIP) {
  return request({
    method: 'post',
    url: '/xt/assets/discovery',
    data: {
      start: startIP,
      end: endIP,
    }
  });
}

export async function scanAssetStatus() {
  return request({
    method: 'get',
    url: '/xt/assets/status'
  });
}