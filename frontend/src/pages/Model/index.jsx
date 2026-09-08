import React, { useState, useEffect, useRef, useMemo } from "react";
import {
  Button,
  Card,
  Row,
  Col,
  Progress,
  Switch,
  message,
  Typography,
  Divider,
  Tooltip,
  Popover,
} from "antd";
import { Modal, Descriptions } from "antd";
import {
  PlusOutlined,
  DeleteTwoTone,
  SettingOutlined,
  CloseOutlined,
  PauseOutlined,
  CloudUploadOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import {
  deleteModel,
  toggleModel,
  getModelList,
  getUploadTaskList,
  initUpload,
  cancelUpload,
  getUploadTask,
  uploadChunk,
  mergeChunks,
} from "@/services/model";
import UploadModel from "./UploadModel";
import styles from "./index.module.css";
import { formatDataSize, formatUptime } from "@/utils/format";
import { getFileHash } from "@/utils/hash";
import { getModelParams } from "../../services/model";
import { Bar } from "@ant-design/charts";
import { openFileUpload } from "../../utils/upload";

//可视化呈现
const DemoBar = ({ performanceData }) => {
  const metrics = [
    { label: "准确率（Accuracy）", field: "accuracy" },
    { label: "精确率（Precision）", field: "precision" },
    { label: "召回率（Recall）", field: "recall" },
    { label: "F1分值（F1 score）", field: "f1_score" },
  ];

  // 转换数据为适合图表的格式
  const data = [];
  performanceData.forEach((item) => {
    metrics.forEach((metric) => {
      const metricValue = item[metric.field];
      if (!metricValue) return;

      data.push({
        modelName: item.name,
        metric: metric.label,
        value: metricValue,
      });
    });
  });

  //console.log("item", data);

  const colorMap = {
    "准确率（Accuracy）": "rgb(247, 155, 127)",
    "精确率（Precision）": "rgb(247, 188, 116)",
    "召回率（Recall）": "rgb(109, 180, 246)",
    "F1分值（F1 score）": "rgb(167, 154, 241)",
  };

  const config = {
    data,
    isGroup: true,
    xField: "value",
    yField: "modelName",
    seriesField: "metric",
    color: ({ metric }) => colorMap[metric],
    label: {
      position: "middle",
      formatter: (val) => `${(val.value * 100).toFixed(2)}%`,
      style: {
        fill: "#fff",
      },
    },
    xAxis: {
      label: {
        formatter: (val) => `${val * 100}%`,
      },
    },
    yAxis: {
      label: {
        style: {
          fontSize: Math.max(window.innerWidth * 0.008, 16),
          fill: "#000",
        },
      },
    },
    legend: {
      itemName: {
        style: {
          fontSize: 16,
          fill: "#000",
        },
      },
    },
    responsive: true,
  };

  return <Bar {...config} />;
};

// 显示已上传模型基本信息的卡片
const ModelDetailCard = ({ model, handleToggle, handleDelete }) => {
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [modalContentType, setModalContentType] = useState("params"); //用于弹出Modal以显示不同内容的关联变量
  const [modelParams, setModelParams] = useState({});
  const [performParams, setPerformParams] = useState({});

  //模型参数展示映射表
  const modelLabels = {
    d_model: "模型维度",
    dropout: "Dropout丢弃率",
    input_dim: "输入维度",
    n_classes: "输出类别数",
    num_heads: "注意力头数",
    num_transformer_layers: "Transformer层数",
    num_all_layers: "总层数",
  };

  //模型训练结果展示映射表
  const performLabels = {
    accuracy: "准确率",
    precision: "精确率",
    recall: "召回率",
    f1_score: "F1分值",
  };

  const showParameters = async (type) => {
    try {
      const params = (await getModelParams(model.modelId)).data;
      const paramEntries = Object.entries(params);
      const modelParamsObj = {};
      const performanceMetricsObj = {};

      // 分离模型参数和性能指标
      paramEntries.forEach(([key, value]) => {
        if (key in modelLabels && value !== undefined) {
          modelParamsObj[key] = value;
        } else if (key in performLabels && value !== undefined) {
          performanceMetricsObj[key] = value;
        }
      });

      setModelParams(modelParamsObj);
      setPerformParams(performanceMetricsObj);
      setModalContentType(type);
      setIsModalVisible(true);
    } catch (error) {
      console.error("获取模型相关参数失败:", error);
    }
  };

  return (
    <>
      <Card
        title={model.name}
        extra={
          <Popover
            content={
              model.enabled ? (
                <div className="status-tag active">
                  已运行{formatUptime(model.uptime)}
                </div>
              ) : (
                <div className="status-tag inactive">已禁用</div>
              )
            }
          >
            <Switch
              checked={model.enabled}
              onChange={(checked) => handleToggle(model.modelId, checked)}
            />
          </Popover>
        }
        actions={[
          <Tooltip title="模型参数详情" key="params">
            <InfoCircleOutlined onClick={() => showParameters("params")} />
          </Tooltip>,
          <Tooltip title="模型性能详情" key="performance">
            <SettingOutlined
              key="setting"
              onClick={() => showParameters("performance")}
            />
          </Tooltip>,
          <DeleteTwoTone
            twoToneColor="#ff0000"
            key="delete"
            onClick={() => handleDelete(model.modelId)}
          />,
        ]}
      >
        <Typography.Paragraph
          ellipsis={{
            rows: 1,
            expandable: false,
            tooltip: {
              title: model.description || "无描述",
              color: "blue",
            },
          }}
        >
          {model.description === "undefined" ? "无描述" : model.description}
        </Typography.Paragraph>
      </Card>

      <Modal
        title={modalContentType === "params" ? "模型参数" : "性能指标"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Descriptions column={1} bordered>
          {(modalContentType === "params"
            ? Object.entries(modelParams)
            : Object.entries(performParams)
          ).map(([key, value]) => (
            <Descriptions.Item
              label={
                modalContentType === "params"
                  ? modelLabels[key] || key
                  : performLabels[key] || key
              }
              key={key}
            >
              {modalContentType === "params"
                ? value || "无数据"
                : typeof value === "number"
                ? new Intl.NumberFormat("zh-CN", {
                    style: "percent",
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 3,
                  }).format(value)
                : value || "无数据"}
            </Descriptions.Item>
          ))}
        </Descriptions>
      </Modal>
    </>
  );
};

const UploadingModelCard = ({ task, handleCancel, handleToggle }) => {
  const progress = (task.uploadChunks.length / task.totalChunks) * 100;

  return (
    <Card
      title={task.filename}
      extra={
        <>
          <Tooltip title={task.isActive ? "暂停上传" : "继续上传"}>
            <Button
              type="text"
              icon={task.isActive ? <PauseOutlined /> : <CloudUploadOutlined />}
              onClick={() => handleToggle(task.uploadId, !task.isActive)}
            />
          </Tooltip>
          <Tooltip title="取消上传">
            <Button
              danger
              type="text"
              icon={<CloseOutlined />}
              onClick={() => handleCancel(task.uploadId)}
            />
          </Tooltip>
        </>
      }
    >
      <Typography.Paragraph ellipsis>
        <span style={{ fontWeight: "bold" }}>文件名称: </span>
        {task.filename}
      </Typography.Paragraph>
      <Typography.Text>
        <span style={{ fontWeight: "bold" }}>文件大小: </span>
        {formatDataSize(task.totalSize)}
      </Typography.Text>
      <Progress
        percent={progress}
        status={
          progress < 100 ? (task.isActive ? "active" : "normal") : "success"
        }
        strokeColor={task.isActive ? "#1677ff" : "red"}
        format={(percent, _) => {
          if (!task.isActive) return "已暂停";
          return `${percent.toFixed(2)}%`;
        }}
      />
    </Card>
  );
};

const InitiateUploadCard = ({ onClick }) => {
  return (
    <Card
      hoverable
      style={{
        height: "100%",
        borderStyle: "dashed",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        cursor: "pointer",
      }}
      onClick={onClick}
    >
      <div style={{ textAlign: "center" }}>
        <PlusOutlined style={{ fontSize: 24, color: "#1890ff" }} />
        <Typography.Text style={{ display: "block", marginTop: 8 }}>
          添加新模型
        </Typography.Text>
      </div>
    </Card>
  );
};

const CHUNK_SIZE = 1 * 1024 * 1024; // 1MB
const MAX_PARALLEL = 3;

const ModelDashboard = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [models, setModels] = useState([]);
  const [uploadTask, setUploadTask] = useState([]);
  const [loadingModels, setLoadingModels] = useState(true);

  // store states of tasks that got file handles attached to them
  const activatedTask = useRef({});

  const fetchModels = async () => {
    try {
      setLoadingModels(true);
      const data = (await getModelList()).data;
      // 获取每个模型的性能指标
      const modelsWithPerformance = await Promise.all(
        data.map(async (model) => {
          const params = (await getModelParams(model.modelId)).data;
          return {
            ...model,
            ...params,
          };
        })
      );
      setModels(modelsWithPerformance);
    } catch (error) {
      message.error("获取模型列表失败");
    } finally {
      setLoadingModels(false);
    }
  };

  const fetchUploadTasks = async () => {
    try {
      const data = (await getUploadTaskList()).data;
      setUploadTask(data.data);
    } catch (error) {
      message.error("获取上传任务失败");
    }
  };

  useEffect(() => {
    fetchModels();
    fetchUploadTasks();
  }, []);

  // ------------------ Model Management ------------------
  const handleModelToggle = async (modelId, checked) => {
    try {
      await toggleModel(modelId, checked);
      fetchModels();
      message.success("状态更新成功");
    } catch (error) {
      message.error("状态更新失败");
    }
  };

  const handleModelDelete = async (modelId) => {
    try {
      await deleteModel(modelId);
      setModels(models.filter((m) => m.modelId !== modelId));
      message.success("模型已删除");
    } catch (error) {
      message.error("删除失败");
    }
  };
  // ------------------ Model Management ------------------

  // --------------- Upload Task Management ---------------
  const createTaskDescriptor = async (uploadId, fileHandle) => {
    const data = (await getUploadTask(uploadId)).data;
    const task = data.data;

    const uploadChunks = new Set(task.uploadChunks);
    const taskDesc = {
      uploadId,
      fileHandle: fileHandle,
      activeRequests: 0,
      paused: false, // flag indicating whether pending chunk-uploading tasks should be scheduled
      requestQueue: Array.from(
        { length: task.totalChunks },
        (_, i) => i
      ).filter((i) => !uploadChunks.has(i)),
    };

    activatedTask.current[uploadId] = taskDesc;
    return taskDesc;
  };

  const startUpload = (taskDesc) => {
    const uploadId = taskDesc.uploadId;
    const file = taskDesc.fileHandle;
    const queue = taskDesc.requestQueue;

    const doMerge = async () => {
      try {
        await mergeChunks(uploadId);
        setUploadTask(uploadTask.filter((v) => v.uploadId !== uploadId));
        fetchModels();
      } catch (error) {
        message.error("分块合并失败，请重试");
      }
    };

    const startNext = async () => {
      // the following code is thread-safe
      // because js engine execute it in a single thread
      while (
        !taskDesc.paused &&
        taskDesc.activeRequests < MAX_PARALLEL &&
        queue.length > 0
      ) {
        const chunkIdx = queue.shift();
        const fileSlice = file.slice(
          chunkIdx * CHUNK_SIZE,
          Math.min((chunkIdx + 1) * CHUNK_SIZE)
        );

        const uploadPromise = uploadChunk(chunkIdx, uploadId, fileSlice);
        uploadPromise.then(async () => {
          taskDesc.activeRequests--;
          startNext();

          // only update the progress provided the task is not paused
          // it's a white lie for better user experience
          if (!taskDesc.paused) {
            setUploadTask((prev) =>
              prev.map((v) =>
                v.uploadId === uploadId
                  ? {
                      ...v,
                      uploadChunks: [...v.uploadChunks, chunkIdx],
                    }
                  : v
              )
            );
          }

          // start merging when all chunked uploads completed
          // make sure only the last one initiates merge
          if (
            !taskDesc.paused &&
            taskDesc.activeRequests === 0 &&
            queue.length === 0
          ) {
            await doMerge();
          }
        });

        taskDesc.activeRequests++;
      }
    };

    if (queue.length === 0) {
      doMerge();
    } else {
      startNext();
    }
  };

  const handleUpload = async (values) => {
    const name = values.name;
    const description = values.description;
    const dimension = values.dimension;

    const file = values.file;

    const filename = file.name;
    const totalSize = file.size;
    const totalChunks = Math.ceil(totalSize / CHUNK_SIZE);
    const fileHash = await getFileHash(file);

    try {
      const task = {
        // model related
        name,
        description,
        dimension,

        // upload task related
        isActive: true,
        filename,
        totalSize,
        totalChunks,
        fileHash,
        uploadChunks: [],
      };

      const uploadId = (await initUpload(task)).data.uploadId;
      task.uploadId = uploadId;
      setUploadTask([...uploadTask, task]);
      console.log(uploadTask);

      startUpload(await createTaskDescriptor(uploadId, file));
    } catch (error) {
      console.error(error);
    }
  };

  const handleTaskToggle = async (uploadId, targetState) => {
    try {
      const task = uploadTask.find((t) => t.uploadId === uploadId);
      const taskDesc = activatedTask.current[uploadId];

      if (task.isActive === targetState) return;

      if (targetState) {
        if (taskDesc) {
          // create a new TaskDescriptor every time the user resumed
          // because we lied about the progress after paused
          startUpload(
            await createTaskDescriptor(uploadId, taskDesc.fileHandle)
          );
          console.log("resumed");
          task.isActive = true;
        } else {
          console.log("reselect file to resume");
          message.info(
            "由于浏览器限制，需要重新选择之前上传的文件方可恢复传输"
          );
          const files = await openFileUpload({ accept: ".zip" });

          if (files === 0) {
            message.error("未选择文件！");
            return;
          }

          const file = files[0];
          const currHash = await getFileHash(file);
          if (task.fileHash === currHash) {
            startUpload(await createTaskDescriptor(uploadId, file));
            task.isActive = true;
          } else {
            message.error("非原上传文件，请重新选择或删除该上传任务！");
          }
        }
      } else {
        // pause current upload task
        if (taskDesc) {
          taskDesc.paused = true;
          task.isActive = false;
        } else console.error("Invalid state"); // impossible state
      }

      setUploadTask(
        uploadTask.map((t) => (t.uploadId === uploadId ? task : t))
      );
    } catch (error) {
      message.error("上传恢复失败");
      console.log(error);
    }
  };

  const handleTaskCancel = async (uploadId) => {
    try {
      await cancelUpload(uploadId);
      setUploadTask(uploadTask.filter((t) => t.uploadId !== uploadId));
      message.success("删除上传任务成功");
    } catch (error) {
      message.error("删除上传任务失败");
    }
  };
  // --------------- Upload Task Management ---------------

  return (
    <div className={styles.container} style={{ padding: 24 }}>
      <Divider orientation="left">断点续传模型</Divider>
      <Row gutter={[24, 24]}>
        {uploadTask.map((task) => (
          <Col key={task.uploadId} span={6}>
            <UploadingModelCard
              task={task}
              handleToggle={handleTaskToggle}
              handleCancel={handleTaskCancel}
            />
          </Col>
        ))}
        <Col span={6}>
          <InitiateUploadCard onClick={() => setIsModalOpen(true)} />
        </Col>
      </Row>

      <UploadModel
        isModalOpen={isModalOpen}
        setIsModalOpen={setIsModalOpen}
        handleUpload={handleUpload}
      />

      <Divider orientation="left" style={{ marginTop: "50px" }}>
        已上传模型
      </Divider>
      <Row gutter={[24, 24]}>
        {models.map((model) => (
          <Col key={model.modelId} span={6}>
            <ModelDetailCard
              model={model}
              handleToggle={handleModelToggle}
              handleDelete={handleModelDelete}
            />
          </Col>
        ))}
      </Row>

      <Divider orientation="left" style={{ marginTop: "50px" }}>
        模型分类效果对比图
      </Divider>
      {models.length > 0 && <DemoBar performanceData={models} />}
    </div>
  );
};

export default ModelDashboard;
