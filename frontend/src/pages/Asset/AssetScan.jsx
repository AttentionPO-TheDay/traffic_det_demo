import React, { useState, useEffect, useRef } from "react";
import {
  Button,
  Input,
  Space,
  Divider,
  Flex,
  Progress,
  Card,
  message,
  Result,
} from "antd";
import {
  CloseCircleOutlined,
  SearchOutlined,
  RedoOutlined,
} from "@ant-design/icons";
import { GridContent } from "@ant-design/pro-components";
import { scanAsset, scanAssetStatus } from "../../services/Asset/scanAsset";

const isValidIP = (ip) => {
  const regex =
    /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
  return regex.test(ip);
};

const DemoInput = ({ onStartScan, onStopScan, loading }) => {
  const [startIP, setStartIP] = useState("");
  const [endIP, setEndIP] = useState("");

  const handleScan = () => {
    if (!startIP || !endIP) {
      message.error("请填写完整的起始和结束 IP 地址");
      return;
    }
    if (!isValidIP(startIP) || !isValidIP(endIP)) {
      message.error("请输入正确的 IP 格式");
      return;
    }
    onStartScan(startIP, endIP);
  };

  const handleReset = () => {
    setStartIP("");
    setEndIP("");
  };

  return (
    <Flex gap="middle" align="center" wrap="wrap">
      <Space.Compact size="middle">
        <Input
          placeholder="起始 IP 地址"
          value={startIP}
          onChange={(e) => setStartIP(e.target.value)}
          style={{ width: 200 }}
        />
        <Input
          placeholder="结束 IP 地址"
          value={endIP}
          onChange={(e) => setEndIP(e.target.value)}
          style={{ width: 200 }}
        />
      </Space.Compact>

      <Button
        type="primary"
        icon={<SearchOutlined />}
        loading={loading}
        onClick={handleScan}
      >
        开始扫描
      </Button>
      <Button
        danger
        icon={<CloseCircleOutlined />}
        onClick={onStopScan}
        disabled={!loading}
      >
        停止扫描
      </Button>
      <Button icon={<RedoOutlined />} onClick={handleReset}>
        范围重置
      </Button>
    </Flex>
  );
};

const ScanProgress = ({ visible, progress }) => {
  if (!visible) return null;

  return (
    <Card title="扫描进度" style={{ marginTop: 24 }}>
      <Progress
        percent={progress}
        status={progress < 100 ? "active" : "success"}
      />
      {progress === 100 && (
        <Result
          status="success"
          title="扫描完成"
          subTitle="您可以查看扫描结果或重新开始。"
        />
      )}
    </Card>
  );
};

const Model = () => {
  const [loading, setLoading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [progressVisible, setProgressVisible] = useState(true);
  const progressTimerRef = useRef(null);
  const checkerTimerRef = useRef(null);

  const simulateProgress = () => {
    progressTimerRef.current = setInterval(() => {
      setProgress((prev) => {
        const next = prev + 5;
        return next >= 95 ? 95 : next;
      });
    }, 1000);
  };

  const fetchScanProgress = async (startIP, endIP) => {
    try {
      await scanAsset(startIP, endIP); // 启动扫描
      simulateProgress(); // 启动模拟进度

      checkerTimerRef.current = setInterval(async () => {
        try {
          const res = (await scanAssetStatus()).data;
          if (res?.data.success) {
            clearInterval(progressTimerRef.current);
            clearInterval(checkerTimerRef.current);
            setProgress(100);
            setLoading(false);
          }
        } catch (e) {
          console.error("获取扫描状态失败", e);
        }
      }, 2000);
    } catch (error) {
      message.error("资产扫描启动失败");
      setLoading(false);
    }
  };

  const startScan = (startIP, endIP) => {
    clearInterval(progressTimerRef.current);
    clearInterval(checkerTimerRef.current);
    setProgress(0);
    setProgressVisible(true);
    setLoading(true);
    fetchScanProgress(startIP, endIP);
  };

  const stopScan = () => {
    clearInterval(progressTimerRef.current);
    clearInterval(checkerTimerRef.current);
    setProgress(0);
    setLoading(false);
    setProgressVisible(true);
    message.info("扫描已手动停止");
  };

  useEffect(() => {
    return () => {
      clearInterval(progressTimerRef.current);
      clearInterval(checkerTimerRef.current);
    };
  }, []);

  return (
    <GridContent>
      <Divider orientation="left">资产扫描范围配置</Divider>
      <DemoInput
        onStartScan={startScan}
        onStopScan={stopScan}
        loading={loading}
      />
      <ScanProgress visible={progressVisible} progress={progress} />
    </GridContent>
  );
};

export default Model;
