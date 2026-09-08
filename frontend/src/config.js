// 前端统一服务地址配置
// 生产环境默认使用同源相对路径，由网关（Caddy/Nginx）反代到对应后端服务；
// 开发或特殊部署可通过 Vite 环境变量覆盖（见 .env.example）。

export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || '/prod-api/';

export const INFER_BASE_URL = import.meta.env.VITE_INFER_BASE_URL || '/infer-api/';

// 拼接后端静态资源（如头像）地址
export function assetUrl(path) {
  const base = API_BASE_URL.replace(/\/+$/, '');
  if (!path) return '';
  const p = path.startsWith('/') ? path : '/' + path;
  return base + p;
}
