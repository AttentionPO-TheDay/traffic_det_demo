import request from '@/utils/request';

export async function login(username, password, code, uuid) {
  return request({
    method: 'post',
    url: '/login',
    data: {
      username,
      password,
      code,
      uuid
    }
  });
}

export async function getCaptchaImage() {
  return request({
    method: 'get',
    url: '/captchaImage'
  });
}

export async function changePassword(oldPassword, newPassword) {
  return request({
    method: 'put',
    url: '/system/user/profile/updatePwd',
    params: {
      oldPassword,
      newPassword
    }
  });
}