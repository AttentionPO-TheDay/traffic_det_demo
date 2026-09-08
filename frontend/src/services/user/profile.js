import request from '@/utils/request';

export async function getUserInfo() {
  return request({
    method: 'get',
    url: '/system/user/profile',
  });
}

export async function putUserInfo(userInfo) {
  return request({
    method: 'put',
    url: '/system/user/profile',
    data: userInfo,
  });
}
