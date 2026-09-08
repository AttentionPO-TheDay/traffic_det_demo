import request from '@/utils/request';

export async function getRiskedAsset(dataFilter) {
  return request({
    method: 'get',
    url: 'threat/info/threat/asset',
    params: dataFilter
  });
}
