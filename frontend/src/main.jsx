import { createRoot } from 'react-dom/client'
import './index.css'
import Screen from './layout/Screen'
import Login from './pages/user/Login'
import { AuthProvider, useAuth } from './context/AuthContext'
import { useEffect } from 'react'

import { callbacks } from './utils/request'

const App = () => {
  const { logged, loading, logout } = useAuth();

  // 由于在React组件外无法访问Context
  // 因此需要在根组件加载时，为axios拦截器手动设置退出登录回调
  useEffect(() => {
    callbacks.logoutCallback = () => logout();
  }, []);

  if (loading) {
    return <div>Loading...</div>
  }

  return logged ? <Screen/> : <Login/>;
}


createRoot(document.getElementById("root")).render(
  <AuthProvider>
    <App />
  </AuthProvider>
);