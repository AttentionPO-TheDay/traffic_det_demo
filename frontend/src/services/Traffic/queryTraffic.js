import request from '@/utils/request';


export async function getTraffic(queryBody) {
  return request({
    method: 'post',
    url: 'es/query_traffic',
    headers: {
      'Content-Type': 'application/json', // 指定 JSON 格式
    },
    data: queryBody,
  });
}

export async function getHandShakeData(dataFilter) {
  return request({
    method: 'get',
    url: 'xt/sensors/metadata',
    params: dataFilter
  });
}

export async function getTraffMetaData(dataFilter) {
  return request({
    method: 'get',
    url: 'es/getTraffic',
    params: dataFilter
  });
}
