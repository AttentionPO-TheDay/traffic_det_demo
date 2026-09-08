import { useState, useEffect } from "react";
import { Divider, Flex } from "antd";
import { Col, Row } from "antd";
import { Space, Table, Tag } from "antd";
import { GridContent } from "@ant-design/pro-components";
import { 
  ContactsTwoTone,
  DesktopOutlined,
 } from "@ant-design/icons";
import { getRiskedAsset } from "../../services/Asset/riskedAsset";
import HostThreat from '../Threat/HostThreat';
import UserThreat from '../Threat/UserThreat';

const DemoTable = ({ addTabCallback }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (await getRiskedAsset(dataFilter)).data;

      if (response && response.data) {
        const list = Array.isArray(response.data.rows) ? response.data.rows : [];

        //映射后端字段
        const formattedData = list.map((item) => ({
          key: item.host.hostid,
          hostName: item.host?.hostname || "未知",
          hostIP: item.host?.address || "未知",
          responStaff: item.host?.userid || "未知",
          threatNum: item.threatNum,
          threatStatus: [item.threatNum > dataFilter.threshDanger ? "危险" : item.threatNum < dataFilter.threshRisked ? "正常" : "风险"],

          // 用于给子组件（分析主机、分析用户）传递参数
          hostId: item.host.hostid,
          userId: item.host.userid
        }));
        setData(formattedData);
        setPagination((prev) => ({
          ...prev,
          total: response.data.total || list.length, // 设置总条数
        }));
      }
    } catch (error) {
      console.error("获取风险资产数据失败:", error);
    }
    setLoading(false);
  };

  const threatFilter = {
    pageNum: pagination.current,
    pageSize: pagination.pageSize,
    threshDanger: 9,
    threshRisked: 6
  }

  useEffect(() => {
    fetchData(threatFilter);
  }, []);

  const handleTableChange = (pagination) => {
    setPagination(prev => {
      const newPagination = { ...prev, current: pagination.current, pageSize: pagination.pageSize };
      fetchData(threatFilter);
      return newPagination;
    });
  };

  const columns = [
    {
      title: "主机名称",
      dataIndex: "hostName",
      key: "hostName",
      render: (text) => <a>{text}</a>,
      align: 'center',
    },
    {
      title: "IP地址",
      dataIndex: "hostIP",
      key: "hostIP",
      align: 'center',
    },
    {
      title: "责任人",
      key: "responStaff",
      dataIndex: "responStaff",
      align: 'center',
    },
    {
      title: "受威胁数统计",
      key: "threatNum",
      dataIndex: "threatNum",
      sorter: (a, b) => a.threatNum - b.threatNum,
      align: 'center',
    },
    {
      title: "威胁状态",
      key: "threatStatus",
      dataIndex: "threatStatus",
      align: 'center',
      render: (_, { threatStatus }) => (
        <>
          {threatStatus.map((threatStatus) => {
            const statusColors = {
              "危险": "volcano",
              "风险": "orange",
              "正常": "green",
            };
            let color = statusColors[threatStatus] || "default";
            return (
              <Tag color={color} key={threatStatus}>
                {threatStatus.toUpperCase()}
              </Tag>
            );
          })}
        </>
      ),
      showSorterTooltip: {
        target: "full-header",
      },
      filters: [
        {
          text: "危险",
          value: "危险",
        },
        {
          text: "风险",
          value: "风险",
        },
        {
          text: "正常",
          value: "正常",
        },
      ],
      onFilter: (value, record) => record.threatStatus.includes(value),
    },
    {
      title: "配置",
      key: "threatSet",
      align: 'center',
      render: (_, record) => (
        <Space size="middle">
          <a onClick={() => addTabCallback("主机威胁分析", <HostThreat hostId={record.hostId} />,'hostthreat')}>
            <Space size={4}>
              <DesktopOutlined />
              分析主机
            </Space>
          </a>
          <a onClick={() => addTabCallback("用户威胁分析", <UserThreat userId={record.userId} />,'userthreat')}>
            <Space size={4}>
              <ContactsTwoTone />
              分析用户
            </Space>
          </a>
        </Space>
      ),
    },
  ];



  return (
    <Flex gap="middle" vertical>
      <Flex align="center" gap="middle">
      </Flex>

      <Table
        columns={columns}
        dataSource={data}
        loading={loading}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: pagination.total,
          showTotal: (total) => `共 ${total} 条`,
          showSizeChanger: true, // 允许用户修改每页条数
        }}
        onChange={handleTableChange}
        showSorterTooltip={{
          target: "sorter-icon",
        }}
      />
    </Flex>
  );
};

const RiskAsset = ({ addTabCallback }) => {
  return (
    <GridContent>
      <Divider orientation="left">风险资产列表</Divider>
      <Row justify="end">
        <div style={{ marginTop: "70px" }} />
        <Col span={24}>
          <DemoTable addTabCallback={addTabCallback} />
        </Col>
      </Row>
    </GridContent>
  );
};

export default RiskAsset;
