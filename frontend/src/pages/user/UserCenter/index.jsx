import { Button, Row, Col, message, Upload, Card, Flex } from "antd";
import { Form, Input, Tabs, Spin } from "antd";
import React, { useState, useEffect } from "react";
import { LoadingOutlined, PlusOutlined } from "@ant-design/icons";
import ImgCrop from 'antd-img-crop';
import styles from "./index.module.css";
import { getUserInfo, putUserInfo } from "@/services/user/profile";
import { uploadAvatar } from "@/services/user/avatar";
import { useAuth } from "@/context/AuthContext";
import { changePassword } from "@/services/user/auth";


// 头像上传组件
const AvatarUpload = () => {
  const [loading, setLoading] = useState(false);

  const { profile, refreshProfile } = useAuth();

  const getBase64 = (img, callback) => {
    const reader = new FileReader();
    reader.addEventListener("load", () => callback(reader.result));
    reader.readAsDataURL(img);
  };


  const beforeUpload = (file) => {
    const isJpgOrPng = file.type === "image/jpeg" || file.type === "image/png";
    const isLt2M = file.size / 1024 / 1024 < 2;

    if (!isJpgOrPng) {
      message.error("只能上传 JPG/PNG 文件!");
    } else if (!isLt2M) {
      message.error("图片必须小于 2MB!");
    }
    return isJpgOrPng && isLt2M;
  };

  const handleChange = (info) => {
    const status = info.file.status;
    console.log('state changed', status);

    if (status === "uploading") {
      setLoading(true);
    } else if (status === "done") {
      refreshProfile().then(() => {
        setLoading(false);
      });
    } else if (status === 'error') {
      message.error('上传失败');
      setLoading(false);
    }
  };

  const handleUpload = ({ file, onSuccess, onError }) => {
    uploadAvatar(file)
      .then(result => onSuccess(result))
      .catch(error => onError(error));
  };

  return (
    <ImgCrop rotationSlider showReset>
      <Upload
        name="avatar"
        listType="picture-circle"
        showUploadList={false}
        customRequest={handleUpload}
        beforeUpload={beforeUpload}
        onChange={handleChange}
      >
        {(
          <img
            src={profile?.avatar ? `http://217.77.3.118/prod-api${profile.avatar}` : 'default_avatar.svg'}
            alt="avatar"
            style={{
              width: "100%",
            }}
          />
        )}
        <button
          className={'upload-btn-overlay' + (loading ? ' upload-btn-loading' : '')}
          type="button"
        >
          {loading ? <LoadingOutlined /> : <PlusOutlined />}
          <div
            style={{
              marginTop: 8,
            }}
          >
            上传头像
          </div>
        </button>
      </Upload>
    </ImgCrop>
  );
};

const UserInfo = ({ label, value }) => {
  return (
    <Row style={{ width: "100%", marginBottom: "10px" }}>
      <Col span={8}>
        <div style={{ textAlign: "left", fontWeight: "bold" }}>{label}</div>
      </Col>
      <Col span={16}>
        <div style={{ textAlign: "right" }}>{value}</div>
      </Col>
    </Row>
  );
};

const UserInfoCard = ({ userInfo }) => {
  if (!userInfo) return <Spin />;
  return (
    <Card title="个人信息">
      <Flex align="center" vertical>
        <AvatarUpload />
        <div style={{ width: "100%", marginTop: 20 }}>
          <UserInfo label="用户名称" value={userInfo.userName} />
          <UserInfo label="手机号码" value={userInfo.phonenumber} />
          <UserInfo label="用户邮箱" value={userInfo.email} />
          <UserInfo label="所属部门" value={`${userInfo.dept.deptName} / ${userInfo.postGroup}`} />
          <UserInfo label="所属角色" value={userInfo.roleGroup} />
          <UserInfo label="创建日期" value={userInfo.createTime} />
        </div>
      </Flex>
    </Card>
  );
};

const UserCenter = () => {
  const [userInfo, setUserInfo] = useState(null);
  const [loading, setLoading] = useState(false);

  const [form] = Form.useForm();
  const { logout } = useAuth();

  const fetchData = async () => {
    try {
      const response = (await getUserInfo()).data;
      if (response && response.data) {
        const profile = response.data;
        profile.postGroup = response.postGroup;
        profile.roleGroup = response.roleGroup;

        console.log(profile);
        setUserInfo(profile);
      }
    } catch (error) {
      console.error("获取用户基本信息失败:", error);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  /* 后端数据更新部分*/
  const handleSubmit = async (values) => {
    // 保留原始信息，但需要删除postGroup和roleGroup属性
    const { postGroup: _, roleGroup: __, ...updatedUserInfo } = {
      ...userInfo,
      ...values,
    };

    setLoading(true);
    try {
      await putUserInfo(updatedUserInfo);
      message.success("更新基本信息成功");
      fetchData();
    } catch (error) {
      console.error("更新信息失败:", error);
      message.error("更新失败，请稍后再试");
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordChange = async (values) => {
    setLoading(true);
    try {
      await changePassword(values.oldPassword, values.newPassword);
      logout();
      message.success('密码修改成功，请重新登陆');
    } catch (error) {
      message.error('修改密码失败');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <Row gutter={16}>
        <Col span={8}>
          <UserInfoCard userInfo={userInfo} />
        </Col>
        <Col span={16}>
          <Card title="信息修改">
            <Tabs defaultActiveKey="1">
              <Tabs.TabPane tab="基本资料" key="1">{
                userInfo ?
                  <Form
                    form={form}
                    layout="vertical"
                    onFinish={handleSubmit}
                  >
                    <Form.Item
                      name="nickName"
                      label="用户名"
                      initialValue={userInfo.nickName}
                      rules={[{ required: true, message: "请输入用户名" }]}
                    >
                      <Input />
                    </Form.Item>
                    <Form.Item
                      name="phonenumber"
                      label="手机号码"
                      initialValue={userInfo.phonenumber}
                      rules={[{ required: true, message: "请输入手机号" }]}
                    >
                      <Input />
                    </Form.Item>
                    <Form.Item
                      name="email"
                      label="邮箱"
                      initialValue={userInfo.email}
                      rules={[{ required: true, message: "请输入邮箱" }]}
                    >
                      <Input />
                    </Form.Item>
                    <Form.Item>
                      <Button type="primary" htmlType="submit" loading={loading}>
                        提交
                      </Button>
                    </Form.Item>
                  </Form> :
                  <Spin />
              }
              </Tabs.TabPane>
              <Tabs.TabPane tab="密码修改" key="2">
                <Form layout="vertical" onFinish={handlePasswordChange}>
                  <Form.Item
                    name="oldPassword"
                    label="旧密码"
                    rules={[{ required: true, message: "请输入旧密码" }]}
                  >
                    <Input.Password />
                  </Form.Item>
                  <Form.Item
                    name="newPassword"
                    label="新密码"
                    rules={[{ required: true, message: "请输入新密码" }]}
                  >
                    <Input.Password />
                  </Form.Item>
                  <Form.Item
                    name="confirmPassword"
                    label="确认新密码"
                    dependencies={["newPassword"]}
                    rules={[
                      { required: true, message: "请确认新密码" },
                      ({ getFieldValue }) => ({
                        validator(_, value) {
                          if (!value || getFieldValue("newPassword") === value) {
                            return Promise.resolve();
                          }
                          return Promise.reject(new Error("两次密码不一致"));
                        },
                      }),
                    ]}
                  >
                    <Input.Password />
                  </Form.Item>
                  <Form.Item>
                    <Button type="primary" htmlType="submit" loading={loading}>
                      修改密码
                    </Button>
                  </Form.Item>
                </Form>
              </Tabs.TabPane>
            </Tabs>
          </Card>
        </Col>
      </Row>
    </div>
  );
};
export default UserCenter;
