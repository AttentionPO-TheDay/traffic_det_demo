import React, { useState, useEffect } from "react";
import { Form, Input, Dropdown, Space, Table, message, Button, Divider, Flex, Modal } from "antd";
import { SearchOutlined, RedoOutlined, EditOutlined } from "@ant-design/icons";
import { getAssetInfo, exportAssetInfo, deleteAssets, addAsset, downloadAssetList, addAssetBatch, updateAsset } from "@/services/Asset/manageAsset";
import { openFileUpload } from "@/utils/upload";

const isValidIP = (ip) => {
  const regex =
    /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
  return regex.test(ip);
};

const DemoInputSearch = ({ setFilter }) => {
  const [form] = Form.useForm();

  const handleSearch = ({ hostName, hostIP, responStaff }) => {
    if (!hostName && !hostIP && !responStaff) {
      message.warning("请至少输入一栏进行搜索");
      return;
    }
    if (hostIP && !isValidIP(hostIP)) {
      message.error("请填写正确格式的IP地址");
      return;
    }
    setFilter({
      hostName,
      hostIP,
      responStaff,
    });
  };

  const handleReset = () => {
    form.resetFields();
    setFilter({}); // 重置后刷新表格数据
  };

  return (
    <Form form={form} name="search" layout="inline" onFinish={handleSearch}>
      <Form.Item label="主机名" name="hostName">
        <Input size="small" placeholder="请输入主机名称" />
      </Form.Item>

      <Form.Item label="主机IP" name="hostIP">
        <Input size="small" placeholder="请输入主机IP" />
      </Form.Item>

      <Form.Item label="主机负责人" name="responStaff">
        <Input size="small" placeholder="请输入主机负责人" />
      </Form.Item>

      <Form.Item>
        <Space size="middle">
          <Button icon={<SearchOutlined />} type="primary" htmlType="submit">搜索</Button>
          <Button icon={<RedoOutlined />} htmlType="reset" onClick={handleReset}>重置</Button>
        </Space>
      </Form.Item>
    </Form>
  );
};

const AddHostModal = ({ isModalOpen, setIsModalOpen, doSearch, update = false, initialValues }) => {
  console.log(update);

  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    form.setFieldsValue(initialValues);
  }, [initialValues]);

  const handleCancel = () => {
    form.resetFields(); // 重置表单
    setIsModalOpen(false);
  };

  const handleSubmit = () => {
    form.validateFields()
      .then(async (values) => {
        setLoading(true);
        try {
          if (!update) await addAsset(values.hostName, values.hostIP, values.responStaff);
          else if (initialValues?.hostId) await updateAsset(initialValues.hostId, values.hostName, values.hostIP, values.responStaff);
          else console.error("invalid call of update, hostId must be provided when updating");

          await doSearch();
        } catch (error) {
          message.error(`${update ? "更新" : "添加"}失败`);
        } finally {
          setLoading(false);
          setIsModalOpen(false);
          form.resetFields();
        }
      }).catch((err) => {
        console.error('表单验证失败:', err);
      });
  };

  return (
    <Modal
      title="新增主机"
      open={isModalOpen}
      onCancel={handleCancel}
      footer={[
        <Button key="back" onClick={handleCancel}>
          取消
        </Button>,
        <Button key="submit" type="primary" onClick={handleSubmit} loading={loading}>
          提交
        </Button>,
      ]}
    >
      <Form form={form} name="addHost" layout="vertical" initialValues={initialValues}>
        <Form.Item
          name="hostName"
          label="主机名"
          rules={[{ required: true, message: '请输入主机名' }]}
        >
          <Input placeholder="请输入主机名" />
        </Form.Item>

        <Form.Item
          name="hostIP"
          label="主机IP地址"
          rules={[{ required: true, message: '请输入主机IP地址' }]}
        >
          <Input placeholder="请输入主机IP地址" />
        </Form.Item>

        <Form.Item
          name="responStaff"
          label="主机负责人ID"
          rules={[{ required: true, message: '请输入主机负责人ID' }]}
        >
          <Input placeholder="请输入主机负责人ID" />
        </Form.Item>
      </Form>
    </Modal>
  );
};


const DemoTable = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  const [filter, setFilter] = useState({});
  const [isModalOpen, setIsModalOpen] = useState(false);

  // for updating asset info
  const [update, setUpdate] = useState(false);
  const [initialValues, setInitialValues] = useState(null);
  

  const doSearch = async () => {
    setLoading(true);
    try {
      const data = (await getAssetInfo(
        pagination.current,
        pagination.pageSize,
        filter.hostName,
        filter.hostIP,
        filter.responStaff
      )).data;
      setData(data.rows);
      setLoading(false);
    } catch (error) {
      message.error('拉取资产信息失败');
    }
  };

  const handleDelete = async () => {
    console.log(selectedRowKeys);
    try {
      await deleteAssets(selectedRowKeys);
      setSelectedRowKeys([]);
      await doSearch();
    } catch (error) {
      message.error('删除失败');
    }
  };

  const handleAdd = async () => {
    setUpdate(false);
    setInitialValues(null);
    setIsModalOpen(true);
  }

  useEffect(() => {
    doSearch();
  }, [filter, pagination]);

  const handleExport = async () => {
    try {
      const exportFilename = (await exportAssetInfo()).data.msg;
      downloadAssetList(exportFilename);
    } catch (error) {
      message.error('导出失败');
    }
  };

  const columns = [
    {
      title: "主机ID",
      dataIndex: "hostid",
      render: (text) => <a>{text}</a>,
    },
    {
      title: "主机名",
      dataIndex: "hostname",
    },
    {
      title: "主机IP",
      dataIndex: "address",
    },
    {
      title: "主机责任人",
      dataIndex: "userid",
    },
    {
      title: "配置",
      key: "hostSet",
      render: (record) => (
        <Space size="middle">
          <a onClick={() => {
            setUpdate(true);
            setInitialValues({
              hostId: record.hostid,
              hostName: record.hostname,
              hostIP: record.address,
              responStaff: record.userid
            });
            setIsModalOpen(true);
          }}>
            <Space size={4}>
              <EditOutlined />
              修改
            </Space>
            
            </a>
        </Space>
      ),
    },
  ];

  const handleTableChange = (newPagination) => {
    setPagination(newPagination);
  };

  // 加入checkbox，用于批量删除
  const [selectedRowKeys, setSelectedRowKeys] = useState([]);

  const onSelectChange = newSelectedRowKeys => {
    console.log('selectedRowKeys changed: ', newSelectedRowKeys);
    setSelectedRowKeys(newSelectedRowKeys);
  };

  const rowSelection = {
    selectedRowKeys,
    onChange: onSelectChange,
  };

  const items = [
    {
      label: '批量导入',
      key: '1',
      onClick: async () => {
        const files = await openFileUpload({
          accept: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          multiple: false
        });

        if (files.length === 0) return;

        try {
          await addAssetBatch(files[0]);
          await doSearch();
        } catch (err) {
          console.error(err);
        }
      }
    },
  ];

  return (
    <>
      <Divider orientation="left">资产信息搜索</Divider>
      <DemoInputSearch setFilter={setFilter} />

      <Divider style={{ marginTop: "30px" }} orientation="left">资产信息列表</Divider>
      <Flex gap="middle" vertical>
        <Flex justify="right">
          <Space size="small">
            <Dropdown.Button
              type="primary"
              menu={{ items }}
              onClick={handleAdd}
            >
              添加
            </Dropdown.Button>

            <Button danger onClick={handleDelete} disabled={selectedRowKeys.length === 0}>删除</Button>
            <Button color="primary" variant="outlined" onClick={handleExport}>导出</Button>
          </Space>
        </Flex>

        <Table
          rowKey="hostid"
          rowSelection={rowSelection}
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
        />
      </Flex>

      <AddHostModal
        isModalOpen={isModalOpen}
        setIsModalOpen={setIsModalOpen}
        doSearch={doSearch}
        update={update}
        initialValues={initialValues}
      />
    </>
  );
};

export default DemoTable;
