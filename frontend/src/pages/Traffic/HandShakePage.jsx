import React, { useEffect, useState, useRef } from "react";
import { Descriptions, Tag, Divider, Typography, Spin, Card, Tabs } from "antd";
import { getHandShakeData } from "../../services/Traffic/queryTraffic";
import { Graph } from "@antv/g6";

const { TabPane } = Tabs;

const HandshakeFlowDiagram = ({ type, srcIp, dstIp, payload }) => {
  const containerRef = useRef(null);
  const graphRef = useRef(null);

  useEffect(() => {
    if (!containerRef.current) return;
    // 清除旧图
    const localGraphRef = graphRef.current;
    if (localGraphRef && !localGraphRef.destroyed) {
      localGraphRef?.destroy();
      graphRef.current = null;
    }

    // 计算需要的行数和列数
    const payloadLength = payload?.length || 0;
    const rows = Math.max(3, payloadLength + 2); // 至少3行，根据payload长度增加
    const cols = 2;

    const nodes = [
      { id: "source_leftTop", location: "源IP" },
      { id: "dest_leftTop", location: "目的IP" },
    ];

    // 生成动态中间节点
    for (let i = 0; i < payloadLength; i++) {
      nodes.push({
        id: `middle_left_${i}`,
        style: {
          opacity: 0,
          fill: "none",
          stroke: "none",
        },
        row: i + 1,
        col: 0,
      });
      nodes.push({
        id: `middle_right_${i}`,
        style: {
          opacity: 0,
          fill: "none",
          stroke: "none",
        },
        row: i + 1,
        col: 1,
      });
    }
    nodes.push(
      { id: "source_leftBottom", location: "源IP" },
      { id: "dest_leftBottom", location: "目的IP" }
    );

    const edges = [
      // 垂直连接源IP上下节点
      {
        id: "edge-source-vertical",
        source: "source_leftTop",
        target: "source_leftBottom",
        style: {
          stroke: "#aaa",
          line: [4, 2],
          endArrow: false,
        },
      },
      // 垂直连接目的IP上下节点
      {
        id: "edge-dest-vertical",
        source: "dest_leftTop",
        target: "dest_leftBottom",
        style: {
          stroke: "#aaa",
          line: [4, 2],
          endArrow: false,
        },
      },
      // 数据包数据连线
      ...(payload?.map((item, index) => {
        const isOrig = item.is_orig;
        return {
          id: `edge-${index}`,
          source: `middle_left_${index}`,
          target: `middle_right_${index}`,
          style: {
            labelText: `数据包长度: ${item.length}`,
            labelBackground: true,
            startArrow: true,
            startArrowSize: isOrig ? 1 : 10,
            endArrowSize: isOrig ? 10 : 1,
            endArrow: true,
            lineWidth: 2,
            startArrowOffset: isOrig ? -105 : -100, //endArrowOffset-5
            endArrowOffset: isOrig ? -100 : -105, //节点长度/2-5
          },
        };
      }) || []),
    ];

    const graph = new Graph({
      container: containerRef.current,
      data: { nodes, edges },
      width: 1000,
      height: Math.max(600, 100 * rows), // 动态调整高度

      layout: {
        type: "grid",
        begin: [10, 20],
        preventOverlap: true,
        rows: rows,
        cols: cols,
        nodeSize: [210, 55],
        sortBy: (a, b) => {
          // 自定义排序确保节点位置正确
          const getOrder = (id) => {
            if (id.includes("Top")) return 0;
            if (id.includes("middle")) {
              const num = parseInt(id.split("_").pop());
              return 1 + num;
            }
            return rows - 1;
          };
          return getOrder(a.id) - getOrder(b.id);
        },
      },
      modes: {
        default: ["drag-canvas", "zoom-canvas", "activate-relations"],
      },
      node: {
        type: "html",
        style: {
          size: [210, 55],
          dx: -120,
          dy: -40,
          innerHTML: (d) => {
            const { location, id } = d;
            const color = id.includes("source") ? "#52c41a" : "#1890ff";
            const ipLabel = id.includes("source") ? srcIp : dstIp;

            return `
              <div style="
                width:100%; 
                height: 100%; 
                background: ${color}bb; 
                border: 1px solid ${color};
                color: #fff;
                user-select: none;
                display: flex; 
                flex-direction:column;
                justify-content:center;
                align-items:center;
                box-sizing:border-box;
              ">
                <div style="font-weight:bold;margin-bottom:2px;">
                  ${location}
                </div>
                <div style="border:1px solid white;">
                  ${ipLabel || "N/A"}
                </div>
              </div>`;
          },
        },
      },
      animation: true,
    });

    graph.render();
    graphRef.current = graph;

    return () => {
      graph?.destroy();
    };
  }, [type, srcIp, dstIp, payload]);

  return (
    <div
      ref={containerRef}
      style={{
        flex: 1,
        width: "100%",
        height: "100%",
        minHeight: 300,
      }}
    />
  );
};

export default function HandshakePage({ dataFilter }) {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (await getHandShakeData(dataFilter)).data;

      if (response) {
        //映射后端字段
        const item = response.data;
        console.log(item);
        const formattedData = [
          {
            key: item.uid,
            sourceIp: item.srcIp || "无",
            sourcePort: item.srcPort,
            destinationIp: item.dstIp || "无",
            destinationPort: item.dstPort,
            type: item.isEncrypted === "0" ? "未加密" : "加密",
            handshakeType:
              item.srcPort != null
                ? JSON.parse(item.metadata).ip.protocol===17
                  ? "ip and udp"
                  : "ip and tcp"
                : "ip",
            metadata: item.metadata,
          },
        ];
        setData(formattedData[0]);
      }
    } catch (error) {
      console.error("获取流量元数据失败:", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    if (dataFilter?.id) {
      fetchData(dataFilter);
    }
  }, [dataFilter]);

  if (loading || !data) {
    return <Spin tip="加载中..." />;
  }
  const parsedMetadata = data.metadata ? JSON.parse(data.metadata) : {};
  const payloadData_ip = parsedMetadata?.ip?.payload || [];
  const payloadData_tcp = parsedMetadata?.tcp?.payload || [];
  const payloadData_udp = parsedMetadata?.udp?.payload || [];
  const string= payloadData_tcp.length===0? payloadData_udp.length===0? "无数据":"udp":"tcp";

  return (
    <div
      style={{
        padding: 16,
        display: "flex",
        flexDirection: "column",
        minHeight: "100vh",
        boxSizing: "border-box",
      }}
    >
      <Divider orientation="left">握手相关数据</Divider>
      <Descriptions
        column={3}
        size="small"
        layout="horizontal"
        bordered
        style={{ marginBottom: 6 }}
        labelStyle={{ width: 30, fontSize: 12, padding: 4 }}
        contentStyle={{ width: 50, fontSize: 12, padding: 2 }}
      >
        <Descriptions.Item label="握手类型">
          {data.handshakeType || "无"}
        </Descriptions.Item>
        <Descriptions.Item label="源 IP">
          <Tag color="green">{data.sourceIp || "无"}</Tag>
        </Descriptions.Item>
        <Descriptions.Item label="源端口号">
          {data.sourcePort || "无"}
        </Descriptions.Item>
        <Descriptions.Item label="流量类型">
          {data.type || "无"}
        </Descriptions.Item>
        <Descriptions.Item label="目的 IP">
          <Tag color="blue">{data.destinationIp || "无"}</Tag>
        </Descriptions.Item>
        <Descriptions.Item label="目的端口号">
          {data.destinationPort || "无"}
        </Descriptions.Item>
      </Descriptions>

      <Divider />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Card
          title="握手过程展示"
          bordered={false}
          style={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            boxShadow: "0 2px 2px rgba(0,0,0,0.1)",
            borderRadius: "16px",
            minHeight: "calc(100vh - 250px)",
          }}
        >
          {/* 动态渲染Tabs：仅在至少一个payload非空时显示 */}
          {payloadData_ip?.length > 0 || payloadData_tcp?.length > 0 || payloadData_udp?.length>0 ? (
            <Tabs
              defaultActiveKey={payloadData_ip?.length > 0 ? "ip" : payloadData_tcp?.length > 0 ? "tcp":"udp"} // 默认选中第一个有数据的Tab
              style={{ flex: 1, display: "flex", flexDirection: "column" }}
              tabBarStyle={{ marginBottom: 0 }}
              tabPosition="top"
            >
              {/* 仅当payloadData_ip非空时渲染IP Tab */}
              {payloadData_ip?.length > 0 && (
                <TabPane
                  tab="ip数据包传输"
                  key="ip"
                  style={{ flex: 1, height: "100%" }}
                >
                  <HandshakeFlowDiagram
                    type="ip"
                    srcIp={data.sourceIp}
                    dstIp={data.destinationIp}
                    payload={payloadData_ip}
                  />
                </TabPane>
              )}
              {/* 仅当payloadData_tcp非空时渲染TCP Tab */}
              {(payloadData_tcp?.length > 0 || payloadData_udp?.length > 0) && (
                <TabPane
                  tab={`${string}数据包传输`}
                  key={string}
                  style={{ flex: 1, height: "100%" }}
                >
                  <HandshakeFlowDiagram
                    type={string}
                    srcIp={data.sourceIp}
                    dstIp={data.destinationIp}
                    payload={string === "tcp" ? payloadData_tcp : payloadData_udp}
                  />
                </TabPane>
              )}
            </Tabs>
          ) : (
            // 当payload均为空时显示的占位内容
            <div
              style={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                height: "100%",
              }}
            >
              <Typography.Text type="secondary">
                无握手数据包可展示
              </Typography.Text>
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}
