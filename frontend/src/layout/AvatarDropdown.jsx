import { Dropdown } from "antd";
import { SettingOutlined, UserOutlined } from '@ant-design/icons';

const AvatarDropdown = ({ children, menu }) => {
  const items = [...menu];
  return (
    <Dropdown menu={{items}} placement="bottomLeft">
      {children}
    </Dropdown>
  )
};

export default AvatarDropdown;
