# 单机部署指南

本说明面向单机（一台服务器）部署整套「内网流量智能检测系统」。核心服务均已容器化，通过根目录的
`docker-compose.yml` 一键编排；探针（Zeek/Suricata）需要抓包权限与宿主网络，作为可选步骤单独说明。

## 〇、先排查本机是否已有旧部署

本机当前已有 Kafka(:9092)、Redis(:6379)、MySQL、Nginx(:80) 等进程在运行（与其它系统或旧部署并存）。
部署前请以 root 执行以下命令，确认是否为本项目的旧部署，避免重复建库/端口冲突：

```bash
# 1. 查看所有容器（重点看镜像/容器名是否含 traffic/nta/ruoyi/infer/frontend/zeek/suricata）
docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}'

# 2. 查看占用了 80/8080/9092/6379 的容器
docker ps --format '{{.Names}} {{.Image}} {{.Ports}}' | grep -E ':(80|8080|9092|6379)->'

# 3. 是否有本项目的 compose 项目在跑
docker compose ls
```

判断标准：若容器名/镜像含 `nginx/caddy/ruoyi/infer-service/zeek/suricata/kafka/redis/mysql` 且
启动参数与本项目一致（MySQL 用了 `utf8mb4/--default-time-zone=+08:00`），很可能就是旧部署。
此时应选择「复用其数据」或「先 `docker compose -p <旧项目> down` 停掉」再继续，避免同时有两套。

## 一、整体架构（部署后）

```
                      ┌──────────────────────────────────────────────┐
                      │                docker compose 网络             │
  浏览器 ──────────▶  │  frontend(Caddy:80) ──/prod-api──▶ backend:8080│
                      │        │            ──/infer-api─▶ infer:8000  │
                      │        ▼                                      │
                      │  backend ──▶ mysql / redis / es / kafka        │
                      │  infer-service ──▶ kafka                      │
                      │  py-edge-services ──▶ es                      │
                      └──────────────────────────────────────────────┘
  探针(宿主网络) ───────▶ kafka(宿主机 localhost:9094)
```

外部访问端口（宿主机映射，均可通过 `.env` 覆盖）：

| 宿主机端口 | 服务 | 说明 |
|---|---|---|
| 8085 | 前端网关 (Caddy) | 系统入口，静态页面 + `/prod-api`、`/infer-api` 反代 |
| 8082 | 后端 (RuoYi) | 也可直接访问 |
| 8000 | 推理服务 | 也可直接访问 `/models`、`/docs` |
| 9200 | Elasticsearch | |
| 9094 | Kafka | 宿主侧/探针外部接入（内部服务经 compose 网络连 kafka:9092，不占宿主端口） |
| 3306 | MySQL | |
| 6380 | Redis |（原 6379 已被本机其它服务占用，故改 6380） |

> 因本机 80/8080/9092/6379 已被其它服务占用，故采用上表端口；如需改回或换其它端口，
> 编辑 `.env` 中的 `FRONTEND_PORT/BACKEND_PORT/REDIS_PORT/...` 即可。

## 二、前置条件

1. 安装 Docker 与 Docker Compose 插件（`docker compose version` 可用）。
2. 调大 ES 所需的内存映射上限（否则 elasticsearch 可能启动失败）：
   ```bash
   sysctl -w vm.max_map_count=262144
   # 持久化
   echo "vm.max_map_count=262144" >> /etc/sysctl.conf
   ```
3. 服务器需允许访问 Docker Hub 以拉取镜像与构建依赖。
4. 注意：推理服务镜像会安装 PyTorch（默认 CUDA 版，镜像体积较大，约 8GB+），首次构建需耐心等待；
   若无需 GPU，可后续把依赖切换为 CPU 版 torch 以显著减容（当前为保持与 `uv.lock` 一致而保留）。

## 三、快速启动（提供了两个脚本）

```bash
# ① 先做只读前置检查（Docker/Compose/内核参数/端口占用）
bash deploy/check.sh

# ② 若无问题，一键部署（会自动校验 .env、调整 sysctl、构建并启动）
bash deploy/deploy.sh

# ③ 观察状态与日志
docker compose ps
docker compose logs -f backend
```

> 也可手动执行等价命令：`cp .env.example .env` → 改密码 → `docker compose up -d --build`。

数据库会在 `db-init` 一次性容器中，按顺序自动导入：

1. `nta-backend/sql/ry_20210731.sql`（若依基础库）
2. `nta-backend/sql/quartz.sql`（定时任务表）
3. `nta-backend/sql/nta.sql`（业务表 xt_* 与菜单）

> 若需要重来：`docker compose down -v` 会清空数据卷（含 MySQL/ES/Kafka/模型），请谨慎。

## 四、配置外部化说明

本次改造把原先硬编码在各处的地址/主题统一收敛为环境变量，`docker-compose.yml` 与 `.env` 已注入默认值。
各组件涉及的关键配置：

| 组件 | 环境变量 | 默认值 | 说明 |
|---|---|---|---|
| infer-service | `KAFKA_BOOTSTRAP_SERVERS` | 127.0.0.1:9092 | Kafka 地址（逗号分隔可多 broker） |
| infer-service | `TRAFFIC_TOPIC` / `RESULT_TOPIC` | traffic / traffic_results | 消费/产出主题 |
| infer-service | `CORS_ALLOW_ORIGINS` | * | CORS 允许来源（逗号分隔） |
| infer-service | `UPLOAD_FOLDER` | ./uploaded_models | 模型存储目录 |
| backend | `DB_URL` / `DB_USERNAME` / `DB_PASSWORD` | 见 application.yml | 数据源 |
| backend | `REDIS_HOST/PORT/PASSWORD` | 127.0.0.1/6379/空 | Redis |
| backend | `ES_HOST` | 127.0.0.1 | Elasticsearch |
| backend | `KAFKA_BOOTSTRAP_SERVERS` | 127.0.0.1:9092 | Kafka |
| backend | `INFER_BASE_URL` | http://127.0.0.1:8000 | 推理服务地址（新版 /models 接口） |
| backend | `EDGE_BASE_URL` | http://127.0.0.1:8888/ | 边缘辅助服务 |
| backend | `SENSOR_ROOT_PATH` / `PCAP_DIR` | /root/sensor / /root/pcap | 探针脚本与 pcap 目录 |
| backend | `JWT_SECRET` | 无 | 登录令牌密钥（必填） |
| 前端 | `VITE_API_BASE_URL` | /prod-api/ | 后端前缀 |
| 前端 | `VITE_INFER_BASE_URL` | /infer-api/ | 推理前缀 |
| py-edge-services | `ELASTIC_SEARCH_ADDRESS` | 127.0.0.1 | ES 地址 |
| 探针 | `KAFKA_BROKER_LIST`(zeek redef) | localhost:9092 | Kafka（宿主机侧用 localhost:9094） |

后端 `application.yml` / `application-druid.yml` 中所有 `${...}` 占位符均可通过环境变量覆盖，
详见 `nta-backend/ruoyi-admin/src/main/resources/application.yml`。

## 五、已修复的接口对齐

后端 `AiModel` 现已对接推理服务新版 REST 接口：

- `GET  /models` → 模型列表（映射为前端所需的 {name, id, type, status}）
- `GET  /models` 按 `modelId` 匹配 → 单模型状态
- `PUT  /models/{id}/status?enabled=true|false` → 模型启停

原有的 `sendVector`（旧的 HTTP 推理链路）与 Kafka 链路（`traffic` → 推理 → `traffic_results`）均保留，
仅做了地址外部化；是否需要走 `traffic` 主题的投递方由业务侧决定。

## 六、探针（Zeek/Suricata）单独部署

探针需要抓取网卡流量，通常以 `--net=host --privileged` 方式运行，不入主编排。使用预先构建的镜像
`ohyee/zeek:1.0.5`：

```bash
cd nta-sensor
# 输出到宿主 Kafka（单机部署时探针走 localhost:9094）
redef Kafka::broker_list = "localhost:9094";   # 在 local.zeek 中覆盖
bash scripts/zeek/zeek.bash run -i eth0 <your-flags>
```

探针会把元数据写入 Kafka 主题 `zeek`，后端 `KafkaListenerSensor` 会自动消费入库。

## 七、常见问题

- **elasticsearch 启动失败**：多为 `vm.max_map_count` 未调大，见「前置条件」。
- **backend 反复重启**：先 `docker compose logs backend` 查看，常见为 MySQL 未完成初始化（等待
  `db-init` 退出）或 `JWT_SECRET`/`MYSQL_ROOT_PASSWORD` 未设置。
- **前端能登录但模型页报错**：确认 infer-service 已启动且 `/infer-api` 反代正确（Caddy 在 frontend
  容器内，目标 `infer-service:8000`）。
- **Kafka 探针收不到数据**：探针在宿主侧应连 `localhost:9094`（外部监听），容器内服务连 `kafka:9092`。