import React, { useState } from 'react';
import route from './route';
import settings from './settings';
import { ProLayout, PageContainer } from '@ant-design/pro-components';
import { InfoCircleFilled, QuestionCircleFilled, UserOutlined, SettingOutlined, LogoutOutlined } from '@ant-design/icons';
import Overview from '../pages/Overview';
import AvatarDropdown from './AvatarDropdown';
import styles from './Screen.module.css';
import Traffic from '../pages/Traffic';
import UserCenter from '../pages/user/UserCenter';
import { useAuth } from '../context/AuthContext';
import { assetUrl } from '@/config';

import logo from '@/assets/logo.svg';

const defaultPanes = [
  {
    label: '威胁总览',
    children: <Overview />,
    key: '威胁总览',
    closable: false
  }
]

export default function Screen() {
  const [pathname, setPathname] = useState('/');
  const [activeKey, setActiveKey] = useState(defaultPanes[0].key);
  const [items, setItems] = useState(defaultPanes);

  const { logout, profile } = useAuth();

  const onChange = (key) => {
    setActiveKey(key);
  };

  const add = (label, component, key, override = true) => {
    const newKey = key ? key : label;

    // 由于React会合并（batching）多次setItems调用
    // items的状态更新并不及时，使用setItems([...item, {}])的方式添加标签可能导致标签丢失
    // 此处使用回调的形式获取最新状态prevItem
    setItems(prevItem => {
      const newItem = {
        label,
        children: component,
        key: newKey
      };

      if (override) {
        return [
          ...prevItem.filter(item => item.key !== newKey),
          newItem
        ];
      }
      
      const existed = prevItem.some(item => item.key === newKey);
      return existed ? prevItem : [
        ...prevItem,
        newItem
      ];
    });

    setActiveKey(newKey);
  };

  const remove = (targetKey) => {
    const targetIndex = items.findIndex(item => item.key === targetKey);
    const newPanes = items.filter(item => item.key !== targetKey);

    // select a new active tab
    if (newPanes.length && targetKey === activeKey) {
      const { key } = newPanes[targetIndex === newPanes.length ? targetIndex - 1 : targetIndex];
      setActiveKey(key);
    }
    setItems(newPanes);
  };

  const onEdit = (targetKey, action) => {
    if (action === 'add') {
      add();
    } else {
      remove(targetKey);
    }
  };

  const avatarItems = [
    {
      key: '1',
      label: '账号设置',
      disabled: true,
    },
    {
      type: 'divider',
    },
    {
      key: '2',
      label: <a onClick={() => {
        add('用户中心', <UserCenter />);
      }}>
        用户中心
      </a>,
      icon: <UserOutlined />
    },
    {
      key: '3',
      label: <a onClick={() => {
        add('系统设置', <Traffic />);
      }}>
        系统设置
      </a>,
      icon: <SettingOutlined />,
    },
    {
      type: 'divider'
    },
    {
      key: '4',
      label: <a onClick={() => {
        logout();
      }}>
        退出登录
      </a>,
      icon: <LogoutOutlined />,
    },
  ];

  return (
    <div className={styles.container}>
      <ProLayout
        route={route}
        title="智能检测系统"
        logo={logo}
        location={{
          pathname,
        }}
        menu={{
          type: 'group',
          locale: false
        }}
        avatarProps={{
          src: profile?.avatar ? assetUrl(profile.avatar) : 'default_avatar.svg',
          title: profile?.nickName,
          render: (_, avatarChildren) => {
            return (
              <AvatarDropdown menu={avatarItems}>
                {avatarChildren}
              </AvatarDropdown>
            );
          }
        }}
        actionsRender={(props) => {
          if (props.isMobile) return [];
          return [
            <InfoCircleFilled key="InfoCircleFilled" />,
            <QuestionCircleFilled key="QuestionCircleFilled" />
          ];
        }}
        menuItemRender={(item, dom) => (
          <a onClick={() => {
            if (item?.component) {
              // 为子组件传递增加标签页的方法
              add(item.name, React.cloneElement(item.component, { addTabCallback: add }));
            }
          }}>
            {dom}
          </a>
        )}
        {...settings}
      >
        <PageContainer tabList={items}
          tabProps={{
            type: 'editable-card',
            hideAdd: true,
            onEdit,
            activeKey,
            onChange,
            tabPosition: 'left'
          }}>

        </PageContainer>
      </ProLayout>
    </div>
  );
}