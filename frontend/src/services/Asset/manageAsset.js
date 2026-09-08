import request from '@/utils/request';
import { API_BASE_URL } from '@/config';

export async function getAssetInfo(pageNum, pageSize, hostName, hostIP, responStaff) {
  const requestParams = {
    pageNum,
    pageSize,
    ...(hostName && { hostname: hostName }),
    ...(hostIP && { address: hostIP }),
    ...(responStaff && { userid: responStaff })
  };

  return request({
    method: 'get',
    url: '/system/host/list',
    params: requestParams
  });
}

export async function exportAssetInfo() {
  return request({
    method: 'get',
    url: '/system/host/export'
  });
}

export async function deleteAssets(assetIdList) {
  return request({
    method: 'delete',
    url: '/system/host/' + assetIdList.join(',')
  });
}

export async function addAsset(hostName, hostIP, responStaff) {
  return request({
    method: 'post',
    url: '/system/host',
    data: {
      hostid: null,
      hostname: hostName,
      address: hostIP,
      userid: responStaff
    }
  });
}

export async function updateAsset(hostId, hostName, hostIP, responStaff) {
  return request({
    method: 'put',
    url: '/system/host',
    data: {
      hostid: hostId,
      hostname: hostName,
      address: hostIP,
      userid: responStaff
    }
  });
}

export async function addAssetBatch(file) {
  console.log(file);

  const data = new FormData();
  data.append("file", file);

  return request({
    method: "post",
    url: '/system/host/InsertHostsFromExcel',
    data
  });
}

export async function downloadAssetList(filename) {
  const baseURL = API_BASE_URL.replace(/\/+$/, '');
  window.location.href = baseURL + "/common/download?fileName=" + encodeURI(filename) + "&delete=" + true;
}
