import React, { useState, useEffect } from "react";
import { Button, Divider, Flex } from "antd";
import { Col, Row } from "antd";
import { Space, Table, Tag } from "antd";
import { 
  ContactsTwoTone,
  DesktopOutlined,
  BlockOutlined
 } from "@ant-design/icons";
import { GridContent } from "@ant-design/pro-components";
import { getRiskedThreat } from "../../services/Threat/riskedThreat";
import dayjs from "dayjs";
import HostThreat from '../Threat/HostThreat';
import UserThreat from '../Threat/UserThreat';
import Traffic from '../Traffic';

function formatTimestamp(timestamp) {
  return dayjs(timestamp * 1000).format("YYYY-MM-DD HH:mm:ss");
}

const DemoTable = ({ addTabCallback }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (await getRiskedThreat(dataFilter)).data;

      if (response && response.data) {
        const list = Array.isArray(response.data.rows)
          ? response.data.rows
          : [];

        //映射后端字段
        const formattedData = list.map((item) => ({
          key: item.threat_id.toString(),
          threatName: item.name || "未知",
          threatTime: formatTimestamp(item.timestamp),
          responStaff: item.threatenHost?.userid,
          threatFromIP: item.srcIp,
          threatToIP: item.dstIp,
          threatStatus: [
            "未处理",
          ],
          hostId: item.threatenHost?.hostid
        }));
        setData(formattedData);
        setPagination((prev) => ({
          ...prev,
          total: response.data.total || list.length,
        }));
      }
    } catch (error) {
      console.error("获取风险资产数据失败:", error);
    }
    setLoading(false);
  };

  const threatFilter={
    pageNum:pagination.current, 
    pageSize:pagination.pageSize,
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
      title: "告警名称",
      dataIndex: "threatName",
      key: "threatName",
      render: (text) => <a>{text}</a>,
      align: 'center',
    },
    {
      title: "发生时间",
      dataIndex: "threatTime",
      key: "threatTime",
      sorter: (a, b) => new Date(a.threatTime) - new Date(b.threatTime),
      align: 'center',
    },
    {
      title: "责任人",
      key: "responStaff",
      dataIndex: "responStaff",
      align: 'center',
    },
    {
      title: "威胁来源主机",
      key: "threatFromIP",
      dataIndex: "threatFromIP",
      align: 'center',
    },
    {
      title: "受威胁主机",
      key: "threatToIP",
      dataIndex: "threatToIP",
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
            let color = threatStatus == "未处理" ? "volcano" : "green";

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
          text: "未处理",
          value: "未处理",
        },
        {
          text: "已处理",
          value: "已处理",
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
          <a onClick={() => addTabCallback("用户威胁分析", <UserThreat userId={record.responStaff} />,'userthreat')}>
            <Space size={4}>
              <ContactsTwoTone />
              分析用户
            </Space>
          </a>
          <a onClick={() => addTabCallback("流量关联分析", <Traffic threatFilter={{threatFromIP:record.threatFromIP,threatToIP:record.threatToIP}}/>,'traffcorrelate')}>
            <Space size={4}>
              <BlockOutlined />
              关联搜索
            </Space>
          </a>
        </Space>
      ),
    },
  ];

  return (
    <Flex gap="middle" vertical>

      <Table
        // rowSelection={rowSelection}
        columns={columns}
        dataSource={data}
        loading={loading}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: pagination.total,
          showTotal: (total) => `共 ${total} 条`,
          showSizeChanger: true,
        }}
        onChange={handleTableChange}
        showSorterTooltip={{
          target: "sorter-icon",
        }}
      />
    </Flex>
  );
};

const Threat = ({ addTabCallback }) => {
  return (
    <GridContent>
      <Divider orientation="left">威胁列表</Divider>
      <Row justify="end">
        <div style={{ marginTop: "70px" }} />
        <Col span={24}>
          <DemoTable addTabCallback={addTabCallback}/>
        </Col>
      </Row>
    </GridContent>
  );
};

export default Threat;
