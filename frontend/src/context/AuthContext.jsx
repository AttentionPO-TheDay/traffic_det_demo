import { createContext, useContext, useState, useEffect } from 'react';
import { getUserInfo } from '@/services/user/profile';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [logged, setLogged] = useState(false);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  const checkAuth = async () => {
    const token = localStorage.getItem('token');
    if (token) {
      setLogged(true);
    }

    setLoading(false);
  };

  const loadProfile = async () => {
    const resp = (await getUserInfo()).data;
    const profile = resp.data;

    console.log(profile);
    setProfile(profile);
  };

  // executed once after app loading
  useEffect(() => {
    checkAuth();
  }, []);

  // executed every time the logging state changes
  useEffect(() => {
    loadProfile();
  }, [logged]);

  const login = (token) => {
    localStorage.setItem('token', token);
    setLogged(true);
  };

  const logout = () => {
    localStorage.removeItem('token');
    setLogged(false);
  };

  const refreshProfile = async () => {
    await loadProfile();
  };

  return (
    <AuthContext.Provider value={{ logged, profile, login, logout, loading, refreshProfile }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
