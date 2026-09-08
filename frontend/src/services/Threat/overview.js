import request from '@/utils/request';

export async function getTrend() {
  return request({
    method: 'get',
    url: 'threat/info/',
    params: {
      trendTop: 5,
      thretenHostNum: 10
    }
  });
}