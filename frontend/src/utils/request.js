import axios from 'axios';

export const callbacks = {
  logoutCallback: () => {}
};

const request = axios.create({
  baseURL: 'http://217.77.3.118/prod-api/',
  timeout: 30000
});

// Axios请求拦截器，自动携带认证token
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers['Authorization'] = 'Bearer ' + token;
  }

  return config;
});

// Axios响应拦截器，解析返回json对象中的code字段作为响应状态
request.interceptors.response.use(
  // HTTP status正常
  res => {
    const code = res.data.code || 200;
    const msg = res.data.msg || '未知错误';

    if (code === 401) {
      // token过期，重定向至登录页面
      callbacks.logoutCallback();
    }

    if (code !== 200) {
      console.log('error occured');
      console.log(res);
    }

    return code === 200 ? res : Promise.reject({ code, msg });
  },

  // HTTP status异常或发生其他错误
  error => {
    console.log('err' + error)
    return Promise.reject(error)
  }
)

export default request;
