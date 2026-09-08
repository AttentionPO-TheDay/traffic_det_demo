import { useState, useEffect } from 'react';
import { useAuth } from '@/context/AuthContext';
import { Form, Input, Button, Checkbox, Row, Col, Flex, Spin } from 'antd';
import { UserOutlined, LockOutlined, SafetyCertificateOutlined } from '@ant-design/icons';
import styles from "./index.module.css";
import Footer from './Footer';

import { getCaptchaImage, login as apiLogin } from '@/services/user/auth';

const Item = Form.Item;

const Login = () => {
  const { login } = useAuth();

  const [captcha, setCaptcha] = useState('');
  const [captchaId, setCaptchaId] = useState('');

  const [form] = Form.useForm();

  const [captchaLoading, setCaptchaLoading] = useState(false);
  const [loading, setLoading] = useState(false);
  const fetchCaptcha = async () => {
    setCaptchaLoading(true);
    try {
      const result = (await getCaptchaImage()).data;
      setCaptcha('data:image/gif;base64,' + result.img);
      setCaptchaId(result.uuid);
    } catch (error) {
      console.error('获取验证码失败', error);
    } finally {
      setCaptchaLoading(false);
    }
  };

  const onFinish = async (values) => {
    setLoading(true);
    try {
      const result = (await apiLogin(values.username, values.password, values.code, captchaId)).data;
      login(result.token);
    } catch (error) {
      form.resetFields(['username', 'password', 'code'])
      fetchCaptcha();
    } finally {
      setLoading(false);
    }
  };

  // 组件加载时获取验证码
  useEffect(() => {
    fetchCaptcha();
  }, []);

  return (
    <div className={styles.container}>
      <Flex
        style={{
          height: '100vh',
          paddingTop: '30px',
          boxSizing: 'border-box',
          backgroundImage: 'url("./background.png")',
          backgroundSize: '100% 100%'
        }}
        align="center" justify="space-between" vertical>
        <span style={{
          textAlign: 'center',
          fontSize: '2.5em',
          fontWeight: 'bold',
          marginBottom: '40px'
        }}
        >网络威胁智能检测系统</span>
        <Form
          name="login"
          form={form}
          style={{
            width: '50%',
            maxWidth: '500px'
          }}
          initialValues={{
            remember: true
          }}
          onFinish={onFinish}>
          <Item
            name="username"
            rules={[{ required: true, message: '请输入用户名!' }]}>
            <Input prefix={<UserOutlined />} placeholder="用户名" />
          </Item>

          <Item
            name="password"
            rules={[{ required: true, message: '请输入密码!' }]}>
            <Input prefix={<LockOutlined />} type="password" placeholder="密码" />
          </Item>

          <Item>
            <Row align="middle" gutter={8}>
              <Col span={18}>
                <Item
                  style={{ marginBottom: 0 }}
                  name="code"
                  rules={[{ required: true, message: '请输入验证码!' }]}>
                  <Input prefix={<SafetyCertificateOutlined />} placeholder="验证码" />
                </Item>
              </Col>
              <Col span={6}>
                <Spin spinning={captchaLoading}>
                  <img
                    src={captcha}
                    onClick={fetchCaptcha}
                    className="captcha"
                  />
                </Spin>
              </Col>
            </Row>
          </Item>

          <Item name="remember" valuePropName="checked">
            <Checkbox>自动登录</Checkbox>
          </Item>

          <Item>
            <Button block type="primary" htmlType="submit" disabled={loading}>
              {loading ? '登录中...' : '登录'}
            </Button>
          </Item>
        </Form>
        <Footer />
      </Flex>
    </div>
  );
};

export default Login;
