import { useState } from "react";
import { Form, Input, Modal, Upload, Typography, Button, message } from "antd";
import { InboxOutlined } from "@ant-design/icons";

const { Dragger } = Upload;

const UploadModel = ({ isModalOpen, setIsModalOpen, handleUpload }) => {
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  const [loading, setLoading] = useState(false);

  // 创建模型提交任务，之后分片上传
  const handleSubmit = async (values) => {
    if (fileList.length === 0) {
      message.error('请先上传模型文件');
      return;
    }

    setLoading(true);
    try {
      await handleUpload({...values, file: fileList[0]});
    } finally {
      form.resetFields();
      setFileList([]);
      setIsModalOpen(false);
      setLoading(false);
    }
  };

  const handleCancel = () => {
    // 正在提交表单中，不允许关闭模态框
    if (loading) {
      message.error('正在创建上传任务，请稍后');
      return;
    }

    setIsModalOpen(false);
    // 模态框关闭时清空表单
    form.resetFields();
    setFileList([]);
  }

  return (
    <Modal
      title="上传新模型"
      width={800}
      open={isModalOpen}
      onCancel={handleCancel}
      footer={null}
      style={{
        top: '50px'
      }}
    >
      <Form
        form={form}
        layout="vertical"
        onFinish={handleSubmit}
        initialValues={{ dimensions: [{}] }}
      >
        <Form.Item
          label="模型文件"
          rules={[{ required: true }]}
          extra="请上传包含 .pt 模型和预处理脚本的压缩包"
        >
          <Dragger
            accept=".zip,.rar"
            fileList={fileList}
            beforeUpload={(file) => {
              const isValid = ['.zip', '.rar'].some(ext =>
                file.name.toLowerCase().endsWith(ext)
              );
              if (!isValid) {
                message.error('仅支持 ZIP/RAR 格式');
                return Upload.LIST_IGNORE;
              }
              setFileList([file]);
              return false;
            }}
            onRemove={() => setFileList([])}
            maxCount={1}
          >
            <p className="ant-upload-drag-icon">
              <InboxOutlined />
            </p>
            <p>点击或拖拽文件到此区域上传</p>
            <Typography.Text type="secondary">最大支持 2GB</Typography.Text>
          </Dragger>
        </Form.Item>

        <Form.Item
          name="name"
          label="模型名称"
          rules={[{ required: true, message: '请输入模型名称' }]}
        >
          <Input size="middle" placeholder="示例：流量分类模型 v2.0" />
        </Form.Item>

        <Form.Item
          name="dimension"
          label="输出类别配置"
          rules={[{ required: true, message: '请输入模型输出类别' }]}
        >
          <Input.TextArea
            placeholder="按顺序输入模型输出类别，以英文逗号分隔，实例：normal,worm,fuzzer"
            rows={3}
          />
        </Form.Item>

        <Form.Item
          name="description"
          label="模型描述"
          rules={[{ max: 200, message: '描述最多200字符' }]}
        >
          <Input.TextArea
            placeholder="请输入模型功能描述..."
            rows={3}
            showCount
            maxLength={200}
          />
        </Form.Item>

        <Form.Item style={{ marginTop: 32 }}>
          <Button
            type="primary"
            htmlType="submit"
            size="large"
            loading={loading}
            block
          >
            提交模型配置
          </Button>
        </Form.Item>
      </Form>
    </Modal>
  )
};

export default UploadModel;
