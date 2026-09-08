# ================= 构建阶段 =================
FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
# --legacy-peer-deps 解决 react-json-view@1.21.3 与 React 18 的 peer 依赖冲突
RUN npm install --no-audit --no-fund --legacy-peer-deps

COPY . .
RUN npm run build

# ================= 运行阶段：Caddy 网关 + 静态托管 =================
FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/dist /srv

EXPOSE 80