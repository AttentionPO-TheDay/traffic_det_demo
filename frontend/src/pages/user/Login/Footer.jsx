import { DefaultFooter } from "@ant-design/pro-components";
import { GithubOutlined } from "@ant-design/icons";


const Footer = () => {
  return (
    <DefaultFooter
      style={{
        background: 'none',
      }}
      copyright="Powered by Ant Desgin"
      links={[
        {
          key: 'github',
          title: <GithubOutlined />,
          href: 'https://github.com/nta309/frontend',
          blankTarget: true,
        },
        {
          key: 'Ant Design',
          title: '网络威胁智能检测系统',
          href: 'https://github.com/nta309/frontend',
          blankTarget: true,
        },
      ]}
    />
  );
};

export default Footer;
