import request from '@/utils/request';

export async function getDataFrame(queryBody) {
  return request({
    method: 'post',
    url: 'xt/assets/dataFrame',
    data: queryBody,
  });
}