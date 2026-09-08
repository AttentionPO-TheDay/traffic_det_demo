import { useState, useEffect } from "react";
import { Divider, Flex } from "antd";
import { Col, Row } from "antd";
import { Card, Spin, Table, Tag } from "antd";
import { GridContent } from "@ant-design/pro-components";
import { getRiskedThreat } from "../../services/Threat/riskedThreat";
import dayjs from "dayjs";
import request from "@/utils/request";

function formatTimestamp(timestamp) {
  return dayjs(timestamp * 1000).format("YYYY-MM-DD HH:mm:ss");
}

const DemoCard = ({ userId }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (
        await request({
          method: "get",
          url: `xt/hostuser/${userId}`,
          params: dataFilter,
        })
      ).data;

      if (response && response.data) {
        setData({
          userName: response.data.name,
          userPhone: response.data.phone,
          userDepart: response.data.departure,
        });
      }
    } catch (error) {
      console.error("获取风险资产数据失败:", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <Card title="用户详情" style={{ width: 300 }}>
      {loading ? (
        <Spin tip="加载中..." />
      ) : data ? (
        <>
          <p>用户名: {data.userName}</p>
          <p>手机号: {data.userPhone}</p>
          <p>所在部门: {data.userDepart}</p>
        </>
      ) : (
        <p>暂无数据</p>
      )}
    </Card>
  );
};

const DemoTable = () => {
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
          threatStatus: [
            //????如何添加判断条件
            "未处理",
          ],
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

  const threatFilter = {
    pageNum: pagination.current,
    pageSize: pagination.pageSize,
  };

  useEffect(() => {
    fetchData(threatFilter);
  }, []);

  const handleTableChange = (pagination) => {
    setPagination((prev) => {
      const newPagination = {
        ...prev,
        current: pagination.current,
        pageSize: pagination.pageSize,
      };
      fetchData(threatFilter);
      return newPagination;
    });
  };

  const columns = [
    {
      title: "告警名称",
      dataIndex: "threatName",
      key: "threatName",
      align: 'center',
      render: (text) => <a>{text}</a>,
    },
    {
      title: "发生时间",
      dataIndex: "threatTime",
      key: "threatTime",
      align: 'center',
      sorter: (a, b) => new Date(a.threatTime) - new Date(b.threatTime),
    },
    {
      title: "负责人",
      key: "responStaff",
      align: 'center',
      dataIndex: "responStaff",
    },
    {
      title: "威胁来源主机",
      key: "threatFromIP",
      align: 'center',
      dataIndex: "threatFromIP",
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

const userThreat = ({ userId }) => {
  return (
    <GridContent>
      <Divider orientation="left">用户信息</Divider>

      <DemoCard userId={userId} />

      <Divider orientation="left">告警信息</Divider>
      <Row justify="end">
        <div style={{ marginTop: "70px" }} />
        <Col span={24}>
          <DemoTable />
        </Col>
      </Row>
    </GridContent>
  );
};

export default userThreat;
