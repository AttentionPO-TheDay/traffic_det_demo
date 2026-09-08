/* 获取流量总览界面，流量筛选条件框中的后端条件数据 */
import request from '@/utils/request';

export async function getTrafficTerm(indexName) {
  return request({
    method: 'get',
    url: 'es/getIndex',
    params: {
      index: indexName
    }
  });
}