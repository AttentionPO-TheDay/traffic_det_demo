import axios from "axios";

const prefix = 'http://217.77.3.119:8000';
const request = axios.create({
  baseURL: prefix,
  timeout: 10000
});

export async function getModelList() {
  return request({
    method: 'get',
    url: '/models',
  });
}


export async function getModelParams(modelId) {
  return request({
    method: 'get',
    url: `/models/${modelId}/hparams`
  });
}

export async function toggleModel(modelId, checked) {
  return request({
    method: 'put',
    url: `models/${modelId}/status?enabled=${checked}`
  });
}

export async function deleteModel(modelId) {
  return request({
    method: 'delete',
    url: `/models/${modelId}`
  });
}

export async function uploadModel(file, name, description, dimensions) {
  const formData = new FormData();

  formData.append('file', file);
  formData.append('name', name);
  formData.append('description', description);

  const dimension_list = dimensions.map(item => item.label);
  formData.append('dimensions', JSON.stringify(dimension_list));

  const resp = await fetch(prefix + '/models/upload', {
    method: 'POST',
    body: formData
  });

  return await resp.json();
}

export async function initUpload({
  name,
  description,
  dimension,

  filename,
  totalSize,
  totalChunks,
  fileHash
}) {
  const formData = new FormData();

  formData.append('name', name);
  formData.append('description', description);
  formData.append('dimension', dimension);

  formData.append('filename', filename);
  formData.append('total_size', totalSize);
  formData.append('total_chunks', totalChunks);
  formData.append('file_hash', fileHash);

  return request({
    method: 'post',
    url: '/upload',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data: formData
  });
}

export async function uploadChunk(chunkIndex, uploadId, blob) {
  const formData = new FormData();

  formData.append('file', blob);
  formData.append('chunk_index', chunkIndex);
  formData.append('upload_id', uploadId);

  return request({
    method: 'post',
    url: '/upload/chunk',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data: formData
  });
}

export async function mergeChunks(uploadId) {
  return request({
    method: 'post',
    url: `/upload/merge/${uploadId}`
  });
}

export async function cancelUpload(uploadId) {
  return request({
    method: 'delete',
    url: `upload/${uploadId}`
  });
}

export async function getUploadTaskList() {
  return request({
    method: 'get',
    url: '/upload/status'
  });
}

export async function getUploadTask(uploadId) {
  return request({
    method: 'get',
    url: '/upload/status',
    params: {
      'upload_id': uploadId
    }
  });
}
