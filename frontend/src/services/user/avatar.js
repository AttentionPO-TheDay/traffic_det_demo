import request from '@/utils/request';

export async function uploadAvatar(avatar) {
  const formData = new FormData();
  formData.append('avatarfile', avatar);

  return request({
    method: 'post',
    url: 'system/user/profile/avatar',
    data: formData
  });
}