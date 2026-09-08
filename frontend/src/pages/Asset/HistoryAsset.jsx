import  { useState, useEffect } from "react";
import { Divider, Flex } from "antd";
import { Space, Table } from "antd";
import { historyAsset } from "../../services/Asset/historyAsset";
import { DotChartOutlined } from "@ant-design/icons";
import dayjs from "dayjs";
import ScanResult from "./ScanResult";

function formatTimestamp(timestamp) {
  return dayjs(timestamp).format("YYYY-MM-DD HH:mm:ss");
}

const DemoTable = ({addTabCallback}) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (await historyAsset(dataFilter)).data;

      if (response && response.data) {
        const list = Array.isArray(response.data.result)
          ? response.data.result
          : [];

        //映射后端字段
        const formattedData = list.map((item) => {
          const requestData = JSON.parse(item.request || "{}");
          return {
            key: item.id,
            scanTime: formatTimestamp(item.timestamp),
            scanRange: requestData.start + " - " + requestData.end,
          };
        });
        setData(formattedData);
        setPagination((prev) => ({
          ...prev,
          total: response.data.total || list.length, // 设置总条数
        }));
      }
    } catch (error) {
      console.error("获取历史资产数据失败:", error);
    }
    setLoading(false);
  };

  const assetFilter = {
    pageNum: pagination.current,
    pageSize: pagination.pageSize,
  };

  useEffect(() => {
    fetchData(assetFilter);
  }, []);

  const handleTableChange = (pagination) => {
    setPagination((prev) => {
      const newPagination = {
        ...prev,
        current: pagination.current,
        pageSize: pagination.pageSize,
      };
      fetchData(assetFilter);
      return newPagination;
    });
  };

  const columns = [
    {
      title: "扫描发起时间",
      dataIndex: "scanTime",
      key: "scanTime",
      align: 'center',
      sorter: (a, b) => Date.parse(a.scanTime) - Date.parse(b.scanTime),
    },
    {
      title: "扫描范围",
      dataIndex: "scanRange",
      key: "scanRange",
      align: 'center',
    },
    {
      title: "操作",
      key: "scanSet",
      align: 'center',
      render: (_, record) => (
        <Space size="middle">
          <a
            onClick={() => {
              addTabCallback(
                "资产扫描结果详情",
                <ScanResult
                  assetInfoID={record.key}
                />,
                'assetscan'
              );
            }}
          >
            <Space size={4}>
              <DotChartOutlined />
              结果可视化查看
            </Space>
          </a>
        </Space>
      ),
    },
  ];

  return (
    <Flex gap="middle" vertical>
      <Table
        columns={columns}
        dataSource={data}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: pagination.total,
          showTotal: (total) => `共 ${total} 条`,
          showSizeChanger: true, // 允许用户修改每页条数
        }}
        onChange={handleTableChange}
      />
    </Flex>
  );
};

const HistoryAsset = ({addTabCallback}) => {
  return (
    <div>
      <Divider orientation="left">历史资产扫描列表</Divider>
      <DemoTable addTabCallback={addTabCallback}/>
    </div>
  );
};

export default HistoryAsset;
