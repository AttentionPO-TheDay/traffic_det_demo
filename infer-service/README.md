## infer-service

基于 `FastAPI + Kafka + PyTorch` 的多模型推理服务。项目提供统一的 HTTP 管理接口，用于上传模型、启停模型进程、查询模型参数，并通过 Kafka 消费流量消息后产出分类结果。

当前仓库同时包含三类内容：

- 在线推理服务代码
- 随仓库提供的推理模型资产
- 入侵检测与用户行为分类的训练/评估代码与实验结果

## 核心能力

- 通过 HTTP 接口管理模型生命周期
- 支持大模型压缩包分片上传、合并、解压和注册
- 为每个启用模型启动独立子进程，隔离推理任务
- 从 Kafka `traffic` 主题消费消息并输出到 `traffic_results`
- 查询模型元信息与 `hparams.json`

## 技术栈

- Python `3.12`
- FastAPI
- Uvicorn
- PyTorch / TorchScript
- Kafka (`kafka-python`)
- uv

项目元数据见 `pyproject.toml`，Python 版本见 `.python-version`。

## 目录结构

```text
infer-service/
├── main.py                              # FastAPI 主入口
├── upload.py                            # 分片上传与模型注册路由
├── model_manger.py                      # 模型进程管理器
├── model_worker.py                      # Kafka 消费/推理/结果发送工作进程
├── models/                              # 仓库内置的可部署模型目录
│   ├── instrusion_detection_lstm_model/
│   ├── traffic_classifcation_resnet_model/
│   ├── traffic_classifcation_transformer_model/
│   └── traffic_classifcation_vgg_model/
├── uploaded_models/                     # 运行时上传并注册的模型目录（默认不入库）
├── InstrusionDetection/                 # 入侵检测训练、评估与实验资产
├── UserBehavior/                        # 用户行为分类训练、评估与实验资产
├── Dockerfile                           # 容器化部署文件
├── pyproject.toml                       # 项目依赖定义
└── uv.lock                              # uv 锁文件
```

## 服务架构

### 1. 主服务

`main.py` 负责：

- 初始化 FastAPI 应用
- 在启动时读取 `uploaded_models/db.json`
- 自动拉起所有 `enabled=true` 的模型进程
- 暴露模型管理接口

### 2. 上传流程

`upload.py` 负责：

- 初始化上传任务
- 接收分片文件
- 合并压缩包
- 校验压缩包中是否至少包含 `.pt` 和 `.py`
- 解压到 `uploaded_models/<model_id>/`
- 将模型写入运行时数据库并启动推理进程

### 3. 模型进程

`model_manger.py` 和 `model_worker.py` 负责：

- 为每个启用模型创建独立子进程
- 在进程中加载 `model.pt` 与 `preprocessor.py`
- 从 Kafka 读取流量消息
- 执行预处理与模型推理
- 将结果写回 Kafka

## Kafka 约定

`model_worker.py` 中当前写死了以下主题：

- 输入主题：`traffic`
- 输出主题：`traffic_results`

当前代码内置了多个 Kafka broker 地址；部署前请根据目标环境调整 `model_worker.py` 中的 `broker_list`。

## HTTP API

### 模型管理

- `GET /models`
  - 返回当前已注册模型列表
- `GET /models/{model_id}/hparams`
  - 返回指定模型目录中的 `hparams.json`
- `PUT /models/{model_id}/status?enabled=true|false`
  - 启用或停用模型
- `DELETE /models/{model_id}`
  - 删除模型目录并停止对应进程

### 模型上传

- `POST /upload`
  - 初始化上传任务
- `GET /upload/status`
  - 查询所有上传任务
- `GET /upload/status?upload_id=<id>`
  - 查询单个上传任务
- `POST /upload/chunk`
  - 上传单个文件分片
- `POST /upload/merge/{upload_id}`
  - 合并分片、校验压缩包并注册模型
- `DELETE /upload/{upload_id}`
  - 删除上传任务记录

## 可上传模型目录格式

服务在合并上传包后，要求模型目录至少包含以下文件：

```text
your-model/
├── model.pt
├── preprocessor.py
└── hparams.json        # 可选，但推荐提供
```

其中：

- `model.pt`：TorchScript 模型文件
- `preprocessor.py`：必须导出可被工作进程调用的预处理逻辑
- `hparams.json`：用于 `/models/{model_id}/hparams` 展示模型参数和评估指标

## 仓库内置模型

`models/` 目录当前包含 4 组示例/预置模型资产：

- `models/instrusion_detection_lstm_model/`
  - 8 分类 LSTM 入侵检测模型
  - `hparams.json` 中记录的 accuracy 约为 `0.9003`
- `models/traffic_classifcation_resnet_model/`
  - 2 分类流量分类 ResNet 模型
  - accuracy 约为 `0.9211`
- `models/traffic_classifcation_transformer_model/`
  - 12 分类流量分类 Transformer 模型
  - accuracy 约为 `0.9548`
- `models/traffic_classifcation_vgg_model/`
  - 2 分类流量分类 VGG 模型
  - accuracy 约为 `0.9076`

注意：这些目录位于仓库中，但服务启动时真正自动加载的是 `uploaded_models/db.json` 中登记且处于启用状态的模型。

## 快速开始

### 方式一：使用 uv

```bash
uv sync
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

### 方式二：使用 pip

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

Windows PowerShell 可将激活命令替换为：

```powershell
.venv\Scripts\Activate.ps1
```

## Docker 运行

项目包含 `Dockerfile`，可直接构建镜像：

```bash
docker build -t infer-service .
docker run --rm -p 8000:8000 infer-service
```

容器默认启动命令：

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

## 运行时文件

- `uploaded_models/`
  - 上传成功后的模型会被解压到这里
- `uploaded_models/db.json`
  - 记录模型名称、描述、启停状态、目录路径和维度信息
- `uploaded_chunks/`
  - 分片上传时的临时目录

## 训练与研究目录说明

### `InstrusionDetection/`

该目录包含入侵检测相关训练代码、数据集、评估脚本和实验结果，例如：

- 数据模块与预处理脚本
- `modelAPI.py` 形式的独立实验 API
- 数据集副本
- 评估结果与图表

### `UserBehavior/`

该目录包含用户行为分类模型的训练脚本、数据集、评估结果与模型目录，例如：

- `train_resnet.py`
- `train_transformer.py`
- `train_vgg.py`

这两个目录更偏向训练/实验资产，不是线上服务启动所必需的最小集。

## 建议纳入版本控制的内容

如果目标是“尽可能完整地保留项目”，同时保证 GitHub 仓库可推送、可维护，建议至少提交：

- 在线服务代码：`main.py`、`upload.py`、`model_manger.py`、`model_worker.py`
- 依赖与部署文件：`pyproject.toml`、`uv.lock`、`requirements.txt`、`Dockerfile`
- 仓库内置模型：`models/`
- 训练源码：`InstrusionDetection/*.py`、`UserBehavior/*.py`、相关 `utils/`
- 评估配置与必要说明文件

## 默认忽略内容

当前 `.gitignore` 已忽略以下内容：

- Python 缓存与虚拟环境
- `uploaded_models/`
- `uploaded_chunks/`
- 编辑器目录 `.vscode/`
- 所有 `tb_logs/` 训练日志目录

这样做的目的是尽量保留源码和模型，同时避免把运行时临时数据、训练日志和 checkpoint 一起推上仓库。

## 发布前检查建议

在推送到 GitHub 前，建议至少执行：

```bash
git status
git diff --cached --stat
```

重点确认：

- 没有误提交 `tb_logs/`
- 没有误提交虚拟环境 `.venv/`
- 没有误提交运行时目录 `uploaded_models/` 和 `uploaded_chunks/`
- 新增文件中不存在超过 GitHub 限制的超大单文件

## 当前已知事项

- `README.md` 现已按当前仓库结构补全
- `main.py` 中开启了全量 CORS，生产环境建议收敛允许来源
- Kafka broker 地址当前硬编码在 `model_worker.py`
- 训练目录体积较大，若后续继续扩展，建议把数据集与实验资产迁移到独立仓库或对象存储

## 后续建议

- 为 Kafka、主题名和监听端口增加环境变量配置
- 增加接口鉴权与上传权限控制
- 为上传模型结构提供更明确的校验规范
- 为服务添加自动化测试和部署文档
