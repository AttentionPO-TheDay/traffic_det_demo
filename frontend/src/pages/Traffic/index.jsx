import { useState, useEffect } from "react";
import { Divider, message, Space, Table, Modal, Button, Tag } from "antd";
import dayjs from "dayjs";
import { getTraffic, getTraffMetaData } from "@/services/Traffic/queryTraffic";
import { SwapOutlined, SnippetsTwoTone, EyeTwoTone, FileTwoTone} from "@ant-design/icons";
import { getTrafficTerm } from "@/services/Traffic/getTrafficTerm";
import TrafficFilter from "./TrafficFilter";
import ReactJson from "react-json-view";
import { getDataFrame } from "@/services/Traffic/getDataFrame";
import HandshakePage from "./HandShakePage";
import TrafficModelAnalyze from "./TrafficModelAnalyze";
import { formatTimestamp } from '@/utils/format';

export default function Traffic({ addTabCallback, appTag }) {
  /**后端数据获取**/
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  const [total, setTotal] = useState(0);
  const [optionRuleData, setOptionRuleData] = useState([]);
  const [query, setQuery] = useState({ bool: { must: [], filter: [] } });

  //流量元数据查看对应的数据记录
  const [trafficData, setTrafficData] = useState([]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [selectedRecord, setSelectedRecord] = useState(null); //点击了某数据行的握手过程的记录

  const fetchOptionRuleData = async (dataFilter) => {
    try {
      const response = (await getTrafficTerm(dataFilter)).data;
      if (response && response.data) {
        const options = Object.keys(response.data).map((key) => ({
          value: key,
          label: key,
          type: response.data[key],
        }));
        setOptionRuleData(options);
      }
    } catch (error) {
      console.error("筛选条件选项获取失败:", error);
    }
  };

  useEffect(() => {
    fetchOptionRuleData("test-traffic");
  }, []);

  useEffect(() => {
    fetchData();
  }, [pagination, query]);

  const fetchData = async () => {
    const queryBody = {
      _source: {
        includes: [
          "normal",
          "live",
          "ip.src",
          "ip.dst",
          "udp.src",
          "udp.dst",
          "tcp.client_port",
          "tcp.server_port",
          "handled",
          "timestamp",
        ],
        excludes: ["ipsec.*", "ssl.*", "ssh.*"],
      },
      sort: { timestamp: "desc" },
      from: (pagination.current - 1) * pagination.pageSize,
      //动态调整，使与 pagination.pageSize 保持一致
      size: pagination.pageSize,
      query: (appTag 
        ? {bool: {...query?.bool, filter: [{ exists: { field: appTag } }]}} 
        : query)
    };

    setLoading(true);
    try {
      const response = JSON.parse((await getTraffic(queryBody)).data.msg);
      if (response?.hits?.hits) {
        setTrafficData(response.hits.hits);
        const formattedData = response.hits.hits.map((item) => ({
          key: item._id,
          type: item._type == "doc" ? "未加密" : "加密",
          sourceIp: item._source.ip?.src || "无",
          sourcePort:
            item._source.tcp?.client_port || item._source.udp?.src || "无",
          destinationIp: item._source.ip?.dst || "无",
          destinationPort:
            item._source.tcp?.server_port || item._source.udp?.dst || "无",
          arrivalTime: formatTimestamp(item._source.timestamp),
          live: item._source?.live !== false,
        }));
        setData(formattedData);

        // 后端返回的总条数
        // 性能考虑，ES不允许该值超过10000
        setTotal(Math.min(response.hits.total, 10000));
      } else {
        message.error("获取流量数据失败！");
      }
    } catch (error) {
      message.error("请求失败: " + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleTableChange = (newPagination) => {
    setPagination({
      current: newPagination.current,
      pageSize: newPagination.pageSize,
    });
  };

  const showTrafficMetaData = async (dataFilter) => {
    try {
      const response = (await getTraffMetaData(dataFilter)).data;
      //不显示response.data.analyse_result的数据
      const { analyse_result, ...rest } = response.data;
      setSelectedRecord(rest);
      setIsModalVisible(true);
    } catch (error) {
      console.error("获取流量元数据失败:", error);
    }
    setLoading(false);
  };

  const handleCloseModal = () => {
    setSelectedRecord(null);
    setIsModalVisible(false);
  };

  const handleDownload = () => {
    if (!selectedRecord) return;

    const dataStr =
      "data:text/json;charset=utf-8," +
      encodeURIComponent(JSON.stringify(selectedRecord, null, 2));
    const downloadAnchorNode = document.createElement("a");
    downloadAnchorNode.setAttribute("href", dataStr);
    downloadAnchorNode.setAttribute("download", "traffic_metadata.json");
    document.body.appendChild(downloadAnchorNode);
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
  };

  const columns = [
    {
      title: "",
      dataIndex: "live",
      key: "live",
      render: (_, record) =>
        record.live ? (
          <Tag color="orange">live</Tag>
        ) : (
          <Tag color="green">pcap</Tag>
        ),
    },
    {
      title: "源IP地址",
      dataIndex: "sourceIp",
      key: "sourceIp",
      align: "center",
    },
    {
      title: "源端口",
      dataIndex: "sourcePort",
      key: "sourcePort",
      align: "center",
    },
    {
      title: "目的IP地址",
      dataIndex: "destinationIp",
      key: "destinationIp",
      align: "center",
    },
    {
      title: "目的端口",
      dataIndex: "destinationPort",
      key: "destinationPort",
      align: "center",
    },
    {
      title: "时间",
      dataIndex: "arrivalTime",
      key: "arrivalTime",
      defaultSortOrder: "descend",
      sorter: (a, b) => {
        // 将时间字符串转换为时间戳进行比较
        const timeA = dayjs(a.arrivalTime, "YYYY-MM-DD HH-mm-ss").valueOf();
        const timeB = dayjs(b.arrivalTime, "YYYY-MM-DD HH-mm-ss").valueOf();
        return timeA - timeB;
      },
      align: "center",
    },
    {
      title: "操作",
      key: "action",
      align: "center",
      render: (_, record) => (
        <Space size="middle">
          <a
            onClick={() => {
              setSelectedRecord(record);
              addTabCallback(
                "握手过程详情",
                <HandshakePage dataFilter={{ id: record.key }} />,
                "handshake"
              );
            }}
          >
            <Space size={4}>
              <SwapOutlined />
              握手过程
            </Space>
          </a>

          <a onClick={() => showTrafficMetaData({ uid: record.key })}>
            <Space size={4}>
              <SnippetsTwoTone />
              流量元数据
            </Space>
          </a>

          <a
            onClick={() => {
              setSelectedRecord(record);
              addTabCallback(
                "模型分析详情",
                <TrafficModelAnalyze dataFilter={{ uid: record.key }} />,
                'analyze_detail'
              );
            }}
          >
            <Space size={4}>
              <EyeTwoTone />
              流量分析
            </Space>
          </a>

          <a onClick={() => generateDataFrame({ id: record.key })}>
            <Space size={4}>
              <FileTwoTone />
              生成DataFrame
            </Space>
          </a>
        </Space>
      ),
    },
  ];

  const generateDataFrame = async (dataFilter) => {
    try {
      const response = (await getDataFrame(dataFilter)).data;
      if (response.code == "200") {
        message.success("DataFrame生成成功！");
      }
    } catch (error) {
      message.error("DataFrame生成失败:", error);
    }
  };

  return (
    <div>
      <Divider orientation="left">流量筛选列表</Divider>
      <TrafficFilter
        fieldList={optionRuleData}
        handleSearch={(res) => setQuery(res)}
      />

      <Divider orientation="left" style={{ marginTop: "50px" }}>
        流量数据展示
      </Divider>
      <Table
        columns={columns}
        dataSource={data}
        loading={loading}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: total,
          showTotal: (total) => `共 ${total} 条`,
          showSizeChanger: true,
        }}
        onChange={handleTableChange}
        addTabCallback={addTabCallback}
      />

      <Modal
        title="流量元数据查看"
        visible={isModalVisible}
        onCancel={handleCloseModal}
        footer={[
          <Button key="download" type="primary" onClick={handleDownload}>
            下载元数据
          </Button>,
          <Button key="close" onClick={handleCloseModal}>
            关闭
          </Button>,
        ]}
        width={1200}
      >
        <div
          style={{
            maxHeight: "600px",
            overflowY: "auto",
            paddingRight: "16px",
          }}
        >
          {selectedRecord && (
          <ReactJson
            src={selectedRecord}
            name={false}
            collapsed={false}
            enableClipboard={true}
            displayDataTypes={false}
            theme="monokai"
          />
        )}
        </div>
      </Modal>
    </div>
  );
}
