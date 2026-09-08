import request from '@/utils/request';

export async function getProbe() {
  return request({
    method: 'get',
    url: 'xt/sensors/status',
  });
}

export async function postProbe(dataFilter) {
  return request({
    method: 'post',
    url: 'xt/sensors/status',
    data:dataFilter,
  });
}

export async function downloadRule(fileName) {
  try {
    const response = await request({
      method: 'get',
      url: '/xt/aimodel/downloadRules',
      params: { fileName },
      responseType: 'blob'
    });

    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
  } catch (error) {
    console.error('下载失败:', error);
  }
}
