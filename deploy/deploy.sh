#!/usr/bin/env bash
# 一键部署脚本：在校准好 .env 后，以 root（或 docker 组成员）运行
#   bash deploy/deploy.sh
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== 1/5 检查 Docker / Compose =="
docker version >/dev/null 2>&1 || { echo "[FAIL] Docker 不可用"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "[FAIL] 缺少 docker compose 插件"; exit 1; }

echo "== 2/5 内核参数 vm.max_map_count =="
map_count=$(cat /proc/sys/vm/max_map_count)
if [ "$map_count" -ge 262144 ]; then
  echo "已是 $map_count（满足）"
else
  sysctl -w vm.max_map_count=262144
fi

echo "== 3/5 校验 .env =="
if [ ! -f .env ]; then
  echo "[FAIL] 缺少 .env。请执行：cp .env.example .env 并填写 MYSQL_ROOT_PASSWORD 与 JWT_SECRET"
  exit 1
fi
set -a; . ./.env; set +a
if [ -z "${MYSQL_ROOT_PASSWORD:-}" ] || [ -z "${JWT_SECRET:-}" ]; then
  echo "[FAIL] .env 中 MYSQL_ROOT_PASSWORD / JWT_SECRET 不能为空"
  exit 1
fi

echo "== 4/5 构建并启动（首次构建较慢，请耐心等待） =="
docker compose up -d --build

echo "== 5/5 状态 =="
docker compose ps

echo
echo "✅ 已下发部署命令。请继续用以下命令观察启动："
echo "   docker compose logs -f db-init    # 数据库初始化"
echo "   docker compose logs -f backend    # 后端启动"
echo "   docker compose logs -f infer-service"
echo
echo "访问入口："
echo "   前端：     http://<本机IP>:${FRONTEND_PORT:-8085}"
echo "   后端：     http://<本机IP>:${BACKEND_PORT:-8082}"
echo "   推理服务： http://<本机IP>:${INFER_PORT:-8000}/docs"