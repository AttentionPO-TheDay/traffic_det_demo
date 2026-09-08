#!/usr/bin/env bash
# 部署前置检查（普通/root 均可运行，只读检查，不做任何变更）
set -uo pipefail
cd "$(dirname "$0")/.."

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}[OK]${NC}   $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }

echo "== 部署前置检查 =="

# Docker / Compose
if docker version >/dev/null 2>&1; then
  ok "Docker 可用 (server $(docker version --format '{{.Server.Version}}'))"
else
  fail "Docker 不可用（安装 docker 并启动 dockerd）"
fi
docker compose version >/dev/null 2>&1 \
  && ok "Docker Compose 插件可用" \
  || fail "缺少 docker compose 插件"

# 内核参数
map_count=$(cat /proc/sys/vm/max_map_count 2>/dev/null || echo 0)
if [ "$map_count" -ge 262144 ]; then
  ok "vm.max_map_count=$map_count（满足 ES 要求）"
else
  fail "vm.max_map_count=$map_count，需 sysctl -w vm.max_map_count=262144"
fi

# .env
if [ -f .env ]; then
  ok "已存在 .env"
else
  fail "缺少 .env（先 cp .env.example .env 并填写密码）"
fi

# 端口占用（读取 .env 中的端口）
if [ -f .env ]; then
  set -a; . ./.env; set +a
fi
declare -A PORTS=(
  [frontend]=${FRONTEND_PORT:-8085}
  [backend]=${BACKEND_PORT:-8082}
  [mysql]=${MYSQL_PORT:-3306}
  [redis]=${REDIS_PORT:-6380}
  [es]=${ES_PORT:-9200}
  [infer]=${INFER_PORT:-8000}
  [kafka-ext]=${KAFKA_EXTERNAL_PORT:-9094}
)
for name in frontend backend mysql redis es infer kafka-ext; do
  p=${PORTS[$name]}
  if ss -tln 2>/dev/null | grep -qE ":$p[[:space:]]"; then
    warn "端口 $p ($name) 已被占用"
  else
    ok "端口 $p ($name) 空闲"
  fi
done

echo
echo "前端入口： http://<本机IP>:${PORTS[frontend]}"
echo "后端接口： http://<本机IP>:${PORTS[backend]}"