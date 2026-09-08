import request from '@/utils/request';

export async function getRiskedThreat(dataFilter) {
  return request({
    method: 'get',
    url: 'threat/info/threat/detail',
    params: dataFilter
  });
}