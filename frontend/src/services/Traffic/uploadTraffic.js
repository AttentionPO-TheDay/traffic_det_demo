import request from '@/utils/request';

export async function uploadTraffic(file) {
  console.log(file);

  const formData = new FormData();
  formData.append("files", file);

  return request({
    method: 'post',
    url: 'xt/pcap/upload',
    data: formData
  });
}

export async function getHistory() {
  return request({
    method: "get",
    url: "xt/pcap/upload/history"
  });
}