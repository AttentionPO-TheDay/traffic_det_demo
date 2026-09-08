import React, { useState, useEffect, useRef } from "react";
import { Divider, Flex, Table, Tag, Card, Spin, Space } from "antd";
import { assetDetailedInfo } from "../../services/Asset/historyAsset";
import cytoscape from "cytoscape";

const AssetTopology = ({ rawData }) => {
  const cyRef = useRef(null);
  const tooltipRef = useRef(null);
  const cyInstance = useRef(null);

  useEffect(() => {
    if (!rawData || !rawData.data || !rawData.data.length) return;

    if (cyInstance.current) {
      cyInstance.current.destroy();
    }

    const parsed = JSON.parse(rawData.data[0]);
    const nodesData = parsed.res;

    const nodeElements = nodesData.map((node, index) => {
      const isStart = index === 0;
      const isEnd = index === nodesData.length - 1;
      return {
        data: {
          id: node.ip,
          fullLabel: node.ip,
          os: node.os,
          status: node.status,
          isStart,
          isEnd,
          label: "", // 默认不显示 label
        },
      };
    });

    const edgeElements = [];
    for (let i = 0; i < nodesData.length - 1; i++) {
      edgeElements.push({
        data: {
          id: `edge-${i}`,
          source: nodesData[i].ip,
          target: nodesData[i + 1].ip,
        },
      });
    }

    const cy = cytoscape({
      container: cyRef.current,
      elements: [...nodeElements, ...edgeElements],
      style: [
        {
          selector: "node",
          style: {
            "background-color": (ele) => {
              if (ele.data("isStart")) return "#cce5ff";
              if (ele.data("isEnd")) return "#ffe0b3";
              const status = ele.data("status");
              return status === "up"
                ? "green"
                : status === "down"
                ? "red"
                : "gray";
            },
            "border-color": (ele) =>
              ele.data("isStart") || ele.data("isEnd") ? "#333" : "#fff",
            "border-width": (ele) =>
              ele.data("isStart") || ele.data("isEnd") ? 3 : 1,
            shape: (ele) => {
              const os = ele.data("os") || "";
              if (os.includes("Linux")) return "ellipse";
              if (os.includes("Windows")) return "rectangle";
              return "triangle";
            },
            width: 40,
            height: 40,
            label: "", // 不显示 label
            "text-valign": "center",
            "text-halign": "center",
            "font-size": 10,
            "text-wrap": "wrap",
            color: "#000",
            "text-outline-color": "#fff",
            "text-outline-width": 1,
            opacity: 1,
          },
        },
        {
          selector: "edge",
          style: {
            width: 2,
            "line-color": "#ccc",
            "target-arrow-color": "#ccc",
            "target-arrow-shape": "triangle",
            "curve-style": "bezier",
            opacity: 1,
          },
        },
      ],
      layout: {
        name: "cose",
        animate: true,
        padding: 30,
      },
    });

    const tooltip = tooltipRef.current;

    // 悬停时显示 IP
    cy.nodes().on("mouseover", (e) => {
      const node = e.target;
      tooltip.style.display = "block"; // 显示 tooltip
      tooltip.innerText = `IP: ${node.data("fullLabel")}`;

      const pos = node.renderedPosition();
      tooltip.style.left = `${
        pos.x + cyRef.current.getBoundingClientRect().left + 10
      }px`;
      tooltip.style.top = `${
        pos.y + cyRef.current.getBoundingClientRect().top - 10
      }px`;

      cy.nodes().not(node).style("opacity", 0.2);
      cy.edges().style("opacity", 0.2);
    });

    // 鼠标移开时隐藏 IP
    cy.nodes().on("mouseout", () => {
      tooltip.style.display = "none";
      cy.nodes().style("opacity", 1);
      cy.edges().style("opacity", 1);
    });

    cyInstance.current = cy;

    return () => {
      if (cyInstance.current) {
        cyInstance.current.destroy();
      }
    };
  }, [rawData]);

  // 图例形状模拟器
  const LegendShape = ({ shape }) => {
    const size = 8; // 图例形状尺寸设为 8px
    const style = {
      display: "inline-block",
      width: size,
      height: size,
      marginRight: 6,
      verticalAlign: "middle",
      border: "2px solid #000",
      backgroundColor: "#000",
    };

    if (shape === "ellipse") style.borderRadius = "50%";
    if (shape === "triangle") {
      return (
        <span
          style={{
            display: "inline-block",
            width: 0,
            height: 0,
            borderLeft: "5px solid transparent",
            borderRight: "5px solid transparent",
            borderBottom: "8px solid #000",
            marginRight: 2,
            verticalAlign: "middle",
          }}
        />
      );
    }

    return <span style={style} />;
  };

  return (
    <Card
      title="资产拓扑图"
      style={{ marginTop: 16, position: "relative" }}
      extra={
        <Space direction="vertical" size="small" style={{ lineHeight: 1 }}>
          <div>
            <strong style={{ fontSize: "12px" }}>状态：</strong>
            <Tag color="green" style={{ fontSize: "10px", marginRight: 5 }}>
              正常
            </Tag>
            <Tag color="red" style={{ fontSize: "10px", marginRight: 5 }}>
              宕机
            </Tag>
            <Tag color="gray" style={{ fontSize: "10px" }}>
              未知
            </Tag>
          </div>
          <div>
            <strong style={{ fontSize: "12px" }}>系统类型：</strong>
            <LegendShape shape="ellipse" />
            <span style={{ fontSize: "10px" }}>Linux</span>&nbsp;&nbsp;
            <LegendShape shape="rectangle" />
            <span style={{ fontSize: "10px" }}>Windows</span>&nbsp;&nbsp;
            <LegendShape shape="triangle" />
            <span style={{ fontSize: "10px" }}>其他</span>
          </div>
          <div>
            <strong style={{ fontSize: "12px" }}>特殊节点：</strong>
            <Tag
              color="#cce5ff"
              style={{
                border: "1px solid #333",
                fontSize: "10px",
                marginRight: 5,
              }}
            >
              开始节点
            </Tag>
            <Tag
              color="#ffe0b3"
              style={{ border: "1px solid #333", fontSize: "10px" }}
            >
              终止节点
            </Tag>
          </div>
        </Space>
      }
    >
      <div
        ref={tooltipRef}
        style={{
          position: "fixed",
          background: "rgba(0, 0, 0, 0.75)",
          color: "white",
          padding: "6px 10px",
          borderRadius: 6,
          fontSize: 12,
          pointerEvents: "none",
          display: "none",
          zIndex: 1000,
        }}
      />
      <div style={{ height: 600, overflow: "auto" }}>
        <div ref={cyRef} style={{ width: "100%", height: 600 }} />
      </div>
    </Card>
  );
};

const DemoTable = ({ assetInfoID }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 10,
    total: 0,
  });

  const fetchData = async () => {
    setLoading(true);
    try {
      const response = (await assetDetailedInfo({ id: assetInfoID })).data;
      const resList = JSON.parse(response.data[0]).res || [];

      const formattedData = resList.map((item) => ({
        key: item.ip,
        assetIP: item.ip,
        assetOS: item.os,
        assetStatus:
          item.status === "unknown"
            ? "未知"
            : item.status === "up"
            ? "开启"
            : "关闭",
      }));

      setData(formattedData);
      setPagination((prev) => ({ ...prev, total: formattedData.length }));
    } catch (error) {
      console.error("获取资产扫描的详细数据失败:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [assetInfoID]);

  const handleTableChange = (newPagination) => {
    setPagination((prev) => ({
      ...prev,
      current: newPagination.current,
      pageSize: newPagination.pageSize,
    }));
  };

  const columns = [
    {
      title: "IP地址",
      dataIndex: "assetIP",
      key: "assetIP",
      align: "center",
    },
    {
      title: "操作系统",
      dataIndex: "assetOS",
      key: "assetOS",
      align: "center",
    },
    {
      title: "资产状态",
      dataIndex: "assetStatus",
      key: "assetStatus",
      align: "center",
      render: (status) => (
        <Tag
          color={
            status === "未知" ? "grey" : status === "开启" ? "green" : "red"
          }
        >
          {status.toUpperCase()}
        </Tag>
      ),
    },
  ];

  return (
    <Flex gap="middle" vertical>
      <Table
        columns={columns}
        dataSource={data}
        loading={loading}
        pagination={{
          ...pagination,
          showTotal: (total) => `共 ${total} 条`,
          showSizeChanger: true,
        }}
        onChange={handleTableChange}
      />
    </Flex>
  );
};

const ScanResult = ({ assetInfoID }) => {
  const [topologyData, setTopologyData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTopologyData = async () => {
      try {
        const response = (await assetDetailedInfo({ id: assetInfoID })).data;
        setTopologyData(response);
      } catch (error) {
        console.error("获取资产拓扑数据失败:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchTopologyData();
  }, [assetInfoID]);

  return (
    <div>
      <Divider orientation="left">资产扫描可视化</Divider>
      {loading ? (
        <Spin />
      ) : topologyData?.data[0] === null ? (
        <div style={{ padding: "20px", color: "#888" }}>
          扫描结果正在汇总分析，请稍后查看。
        </div>
      ) : (
        <AssetTopology rawData={topologyData} />
      )}

      <Divider orientation="left">资产扫描详情</Divider>
      <DemoTable
        assetInfoID={topologyData?.data === null ? null : assetInfoID}
      />
    </div>
  );
};

export default ScanResult;
