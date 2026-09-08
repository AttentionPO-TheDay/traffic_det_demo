import request from '@/utils/request';

export async function getTrafficRule(dataFilter) {
  return request({
    method: 'get',
    url: 'xt/aimodel/status',
    params: dataFilter
  });
}

export async function uploadTrafficRules(formData) {
  return request({
    method: 'post',
    url: 'xt/aimodel/addRules',
    data: formData
  });
}

export async function deleteTrafficRules(deleteFilter) {
  return request({
    method: 'post',
    url: 'xt/aimodel/deleteRules',
    params: deleteFilter
  });
}

export async function handleRuleStatus(statusBody) {
  return request({
    method: 'post',
    url: 'xt/aimodel/enable',
    data: statusBody
  });
}