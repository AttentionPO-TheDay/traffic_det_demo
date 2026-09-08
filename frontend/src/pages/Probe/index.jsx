import React, { useState, useEffect } from "react";
import {
  Card,
  List,
  Tag,
  Switch,
  Button,
  Modal,
  Form,
  Input,
  Select,
  Space,
  message,
} from "antd";
import { UploadOutlined, InboxOutlined } from "@ant-design/icons";
import { Upload, Divider, Flex } from "antd";
import { Col, Row } from "antd";
import { Table } from "antd";
import {
  CaretRightOutlined,
  PauseOutlined,
  MinusCircleOutlined,
  PlusOutlined,
  DownCircleTwoTone,
  DeleteTwoTone,
} from "@ant-design/icons";
import {
  getProbe,
  postProbe,
  downloadRule,
} from "../../services/Probe/manageProbe";
import {
  getTrafficRule,
  uploadTrafficRules,
  deleteTrafficRules,
  handleRuleStatus,
} from "../../services/Traffic/trafficRule";
const { Dragger } = Upload;

// 类型定义
const protocolOptions = ["HTTP", "HTTPS", "TCP", "UDP", "SSH"];
const actionOptions = [
  { value: "ignore", label: "忽略" },
  { value: "monitor", label: "监控" },
];

const UploadRuleFile = ({ onSuccess }) => {
  const props = {
    name: "file",
    accept: ".rules",
    showUploadList: true,
    beforeUpload: (file) => {
      const isRules = file.name.endsWith(".rules");
      if (!isRules) {
        message.error("只能上传 .rules 格式的文件！");
        return Upload.LIST_IGNORE;
      }

      const formData = new FormData();
      formData.append("file", file);
      uploadTrafficRules(formData)
        .then((res) => {
          if (res.data.code === 200) {
            message.success("文件上传成功");
            if (onSuccess) {
              onSuccess();
            }
          } else {
            message.error("文件上传失败，请检查后端响应");
          }
        })
        .catch((err) => {
          console.error(err);
          message.error("上传过程中发生错误");
        });
      return false; // 阻止自动上传
    },
  };

  return (
    <Card title="上传流量筛选规则文件">
      <Dragger {...props}>
        <p className="ant-upload-drag-icon">
          <InboxOutlined />
        </p>
        <p className="ant-upload-text">点击或拖拽上传 .rules 文件</p>
        <p className="ant-upload-hint" style={{ color: "#888" }}>
          仅支持以 .rules 结尾的规则文件，例如：traffic_filter.rules
        </p>
      </Dragger>
    </Card>
  );
};

const DemoTable = ({ onUpdate }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10 });

  //流量规则数据获取
  const fetchData = async (dataFilter) => {
    setLoading(true);
    try {
      const response = (await getTrafficRule(dataFilter)).data;

      if (response && response.data) {
        const list = Array.isArray(response.data) ? response.data : [];
        //映射后端字段
        const formattedData = list.map((item) => ({
          key: item.name,
          ruleName: item.name || "未知",
          ruleStatus: item.status,
        }));
        setData(formattedData);
        setPagination((prev) => ({
          ...prev,
          total: response.data.total || list.length,
        }));
      }
    } catch (error) {
      console.error("规则获取失败:", error);
    }
    setLoading(false);
  };

  const ruleFilter = {
    type: "rule",
  };

  useEffect(() => {
    fetchData(ruleFilter);
  }, [onUpdate]);

  const handleTableChange = (pagination) => {
    setPagination((prev) => {
      const newPagination = {
        ...prev,
        current: pagination.current,
        pageSize: pagination.pageSize,
      };
      fetchData(ruleFilter);
      return newPagination;
    });
  };

  const changeRuleStatus = async ({ id, status, type }) => {
    try {
      const newStatus = status === true ? false : true;
      const response = await handleRuleStatus({
        id: id,
        status: newStatus,
        type,
      });
      if (response.data.code === 200) {
        // 更新数据状态
        const newData = data.map((item) =>
          item.ruleName === id ? { ...item, ruleStatus: newStatus } : item
        );
        setData(newData);
        fetchData(ruleFilter); // 更新成功后刷新规则列表
        console.log(`规则状态更新为 ${newStatus}`);
      } else {
        console.log("规则状态更新失败");
      }
    } catch (error) {
      console.error("更新规则状态失败:", error);
      message.error("更新规则状态失败");
    }
  };

  const columns = [
    {
      title: "规则名称",
      dataIndex: "ruleName",
      key: "ruleName",
      render: (text) => <a>{text}</a>,
      align: "center",
    },
    {
      title: "规则状态",
      key: "ruleStatus",
      dataIndex: "ruleStatus",
      render: (ruleStatus) => {
        let color = ruleStatus ? "green" : "volcano";
        return <Tag color={color}>{ruleStatus ? "使用中" : "未使用"}</Tag>;
      },
      align: "center",
    },
    {
      title: "规则配置",
      key: "ruleSet",
      align: "center",
      render: (_, record) => (
        <Space size="middle">
          <Switch
            checked={record.ruleStatus}
            onChange={() =>
              changeRuleStatus({
                id: record.ruleName,
                status: record.ruleStatus,
                type: "rule",
              })
            }
            checkedChildren="启用"
            unCheckedChildren="关闭"
          />
          <a
            onClick={async () => {
              try {
                await downloadRule(record.ruleName);
              } catch (error) {
                message.error("下载失败");
                console.log(error);
              }
            }}
          >
            <Space size={4}>
              <DownCircleTwoTone />
              下载
            </Space>
          </a>
          <a
            style={{ color: "red" }}
            onClick={async () => {
              try {
                await deleteTrafficRules({ file: record.ruleName });
                fetchData(ruleFilter);
              } catch (error) {
                message.error("删除失败");
                console.log(error);
              }
            }}
          >
            <Space size={4}>
              <DeleteTwoTone twoToneColor="#eb2f96" />
              删除
            </Space>
          </a>
        </Space>
      ),
    },
  ];

  return (
    <Flex gap="middle" vertical>
      <Flex align="center" gap="middle"></Flex>

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
      />
    </Flex>
  );
};

const ProbeManagement = () => {
  const [probes, setProbes] = useState([]);
  const [selectedProbe, setSelectedProbe] = useState(null);
  const [form] = Form.useForm();
  const [modalVisible, setModalVisible] = useState(false);
  const [loading, setLoading] = useState(true);
  const [updateFlag, setUpdateFlag] = useState(false); // 用于控制DemoTable重新加载

  /*探针数据获取*/
  const fetchData = async () => {
    setLoading(true);
    try {
      const response = (await getProbe()).data;
      if (response && response.data) {
        const list = Array.isArray(response.data) ? response.data : [];

        //映射后端字段
        const formattedData = list.map((item) => ({
          key: item.sensor.sensorId,
          id: item.sensor.sensorId,
          hostId: item.sensor.hostId,
          name: item.sensor.type,
          status: item.status,
        }));
        setProbes(formattedData);
        //console.log(probes);
      }
    } catch (error) {
      console.error("获取探针数据失败:", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, []);

  /*后端数据更新 */
  const handleSubmit = async (values) => {
    // 保留原始信息

    setLoading(true);
    try {
      await postProbe(values);
      message.success("探针数据更新成功");
      fetchData();
    } catch (error) {
      console.error("更新信息失败:", error);
      message.error("更新失败，请稍后再试");
    } finally {
      setLoading(false);
    }
  };

  // 切换探针状态
  const toggleProbeStatus = (probeId) => {
    setProbes((prevProbes) => {
      const updated = prevProbes.map((probe) => {
        if (probe.id === probeId) {
          const newStatus = probe.status === true ? false : true;

          // 立即提交更新到后端
          handleSubmit({ id: probe.id, status: newStatus });

          return { ...probe, status: newStatus };
        }
        return probe;
      });
      return updated;
    });
  };

  // 保存规则配置
  const saveRules = async () => {
    try {
      const values = await form.validateFields();
      setProbes(
        probes.map((probe) =>
          probe.id === selectedProbe.id
            ? { ...probe, rules: values.rules }
            : probe
        )
      );
      setModalVisible(false);
    } catch (error) {
      console.log("Validation Failed:", error);
    }
  };

  const openRuleConfig = (probe) => {
    setSelectedProbe(probe);
    setModalVisible(true);
  };

  // 规则配置表单
  const ruleConfigForm = (
    <Form form={form} initialValues={{ rules: selectedProbe?.rules }}>
      <Form.List name="rules">
        {(fields, { add, remove }) => (
          <>
            {fields.map(({ key, name, ...restField }) => (
              <Space
                key={key}
                style={{ display: "flex", marginBottom: 8 }}
                align="baseline"
              >
                <Form.Item
                  {...restField}
                  name={[name, "ip"]}
                  label="IP地址"
                  rules={[
                    { required: true, message: "请输入IP" },
                    { pattern: /^((\d{1,3}\.){3}\d{1,3})$/, message: "无效IP" },
                  ]}
                >
                  <Input placeholder="0.0.0.0" style={{ width: 140 }} />
                </Form.Item>

                <Form.Item
                  {...restField}
                  name={[name, "port"]}
                  label="端口"
                  rules={[
                    { required: true, message: "请输入端口" },
                    { pattern: /^\d+$/, message: "必须为数字" },
                  ]}
                >
                  <Input placeholder="80" style={{ width: 80 }} />
                </Form.Item>

                <Form.Item
                  {...restField}
                  name={[name, "protocol"]}
                  label="协议"
                  rules={[{ required: true }]}
                >
                  <Select
                    options={protocolOptions.map((p) => ({
                      value: p,
                      label: p,
                    }))}
                  />
                </Form.Item>

                <Form.Item
                  {...restField}
                  name={[name, "action"]}
                  label="操作"
                  rules={[{ required: true }]}
                >
                  <Select options={actionOptions} />
                </Form.Item>

                <MinusCircleOutlined onClick={() => remove(name)} />
              </Space>
            ))}

            <Form.Item>
              <Button
                type="dashed"
                onClick={() => add()}
                block
                icon={<PlusOutlined />}
              >
                添加规则
              </Button>
            </Form.Item>
          </>
        )}
      </Form.List>
    </Form>
  );

  //规则文件上传的弹出窗口
  const [isModalVisible, setIsModalVisible] = useState(false);
  const showUploadModal = () => {
    setIsModalVisible(true);
  };
  const handleCloseModal = () => {
    setIsModalVisible(false);
  };

  const handleFileUploadSuccess = () => {
    setUpdateFlag((prev) => !prev); // 触发DemoTable数据重新加载
  };

  return (
    <>
      <div style={{ padding: 24 }}>
        <List
          loading={loading}
          grid={{ gutter: 16, column: 2 }}
          dataSource={probes}
          renderItem={(probe) => (
            <List.Item>
              <Card
                title={`探针 ${probe.key}`}
                // actions={[
                //   <SettingOutlined
                //     key="setting"
                //     onClick={() => openRuleConfig(probe)}
                //   />,
                // ]}
              >
                <div
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                  }}
                >
                  <div>
                    <Tag
                      color={probe.status === true ? "green" : "red"}
                      style={{ marginRight: 8 }}
                    >
                      {probe.status === true ? "运行中" : "已停止"}
                    </Tag>
                    <span>{probe.name}</span>
                  </div>

                  <Switch
                    checkedChildren={<CaretRightOutlined />}
                    unCheckedChildren={<PauseOutlined />}
                    checked={probe.status === true}
                    onChange={() => {
                      toggleProbeStatus(probe.id);
                    }}
                  />
                </div>
              </Card>
            </List.Item>
          )}
        />

        <Modal
          title="流量筛选规则配置"
          width={800}
          open={modalVisible}
          onOk={saveRules}
          onCancel={() => setModalVisible(false)}
        >
          {ruleConfigForm}
        </Modal>
      </div>

      <Divider orientation="left">规则列表</Divider>
      <Row justify="end">
        <Col span={3} style={{ textAlign: "right", marginBottom: "20px" }}>
          <Button
            type="primary"
            icon={<UploadOutlined />}
            onClick={showUploadModal}
          >
            规则文件上传
          </Button>
        </Col>

        <Modal
          open={isModalVisible}
          onCancel={handleCloseModal}
          footer={null}
          destroyOnClose
        >
          <UploadRuleFile onSuccess={handleFileUploadSuccess} />
        </Modal>
        <Col span={24}>
          <DemoTable onUpdate={updateFlag} />
        </Col>
      </Row>
    </>
  );
};

export default ProbeManagement;
