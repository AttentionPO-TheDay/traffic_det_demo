import { useState, useEffect } from "react";
import { InboxOutlined } from "@ant-design/icons";
import { Upload, message, Divider } from "antd";
import { Col, Row } from "antd";
import { Table } from "antd";
import { GridContent } from "@ant-design/pro-components";
import { uploadTraffic, getHistory } from "../../services/Traffic/uploadTraffic";
import { formatDataSize, formatTimestamp } from "../../utils/format";

const { Dragger } = Upload;

// 上传组件
const DemoUploadFrame = ({ onUploadSuccess }) => {
  const handleRequest = async ({ file, onSuccess, onError }) => {
    try {
      const response = await uploadTraffic(file);
      message.success(`${file.name} 上传成功`);
      onSuccess(response, file);

      // 添加到上传历史
      if (onUploadSuccess) {
        onUploadSuccess();
      }
    } catch (error) {
      message.error(`${file.name} 上传失败`);
      onError(error);
    }
  };

  const config = {
    name: "file",
    accept: ".pcap,.csv",
    multiple: true,
    customRequest: handleRequest,
    showUploadList: true,
  };

  return (
    <Dragger {...config}>
      <p className="ant-upload-drag-icon">
        <InboxOutlined />
      </p>
      <p className="ant-upload-text">点击，或拖拽文件到此区域上传</p>
      <p className="ant-upload-hint">
        支持单个或批量上传 pcap 以及 csv 文件的流量数据，
        <br />
        其他文件格式暂不支持。
      </p>
    </Dragger>
  );
};


const TrafficUpload = () => {
  const [fileHistory, setFileHistory] = useState([]);

  const loadHistory = async () => {
    try {
      const resp = (await getHistory()).data;
      if (resp.data) {
        setFileHistory(resp.data);
      }
    } catch (error) {
      message.error("加载上传历史失败，请重试")
      console.log(error);
    }
  };

  useEffect(() => {
    loadHistory()
  }, []);

  const columns = [
    {
      title: "文件名称",
      dataIndex: "name",
      key: "name",
      align: "center",
    },
    {
      title: "文件大小",
      dataIndex: "size",
      key: "size",
      align: "center",
      render: (value) => <p>{formatDataSize(value)}</p>
    },
    {
      title: "上传时间",
      dataIndex: "timestamp",
      key: "timestamp",
      align: "center",
      render: (value) => <p>{formatTimestamp(value)}</p>
    }
  ];

  return (
    <GridContent>
      <Divider orientation="left">流量数据上传</Divider>
      <Row justify="start">
        <Col span={8}>
          <DemoUploadFrame onUploadSuccess={loadHistory} />
        </Col>
      </Row>

      <div style={{ marginTop: "60px" }} />
      <Divider orientation="left">上传历史</Divider>
      <Row justify="start">
        <Col span={24}>
          <Table
            columns={columns}
            dataSource={fileHistory}
            rowKey="name"
          />
        </Col>
      </Row>
    </GridContent>
  );
};

export default TrafficUpload;
