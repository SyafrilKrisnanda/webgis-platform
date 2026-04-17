import { createContext, useContext, useEffect, useMemo, useState } from "react";

import { loginUser, registerUser } from "../api";
import { getAccessToken, getAuthUser, setAccessToken, setAuthUser } from "./storage";

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(getAccessToken());
  const [user, setUser] = useState(getAuthUser());
  const [bootstrapping] = useState(false);

  useEffect(() => {
    if (!token) {
      setUser(null);
      setAuthUser(null);
    }
  }, [token]);

  const login = async (payload) => {
    const data = await loginUser(payload);
    const accessToken = data?.access || data?.token;

    if (!accessToken) {
      throw new Error("Token tidak ditemukan pada respons login.");
    }

    setAccessToken(accessToken);
    setToken(accessToken);

    const nextUser = data?.user || {
      id: data?.id,
      username: data?.username,
      email: data?.email,
    };

    if (nextUser?.id || nextUser?.username || nextUser?.email) {
      setUser(nextUser);
      setAuthUser(nextUser);
    }

    return data;
  };

  const register = async (payload) => {
    const data = await registerUser(payload);
    const accessToken = data?.access || data?.token;

    if (accessToken) {
      setAccessToken(accessToken);
      setToken(accessToken);
    }

    const nextUser = data?.user || {
      id: data?.id,
      username: data?.username,
      email: data?.email,
    };

    if (nextUser?.id || nextUser?.username || nextUser?.email) {
      setUser(nextUser);
      setAuthUser(nextUser);
    }

    return data;
  };

  const logout = () => {
    setAccessToken("");
    setToken("");
    setUser(null);
    setAuthUser(null);
  };

  const value = useMemo(
    () => ({
      token,
      user,
      isAuthenticated: Boolean(token),
      bootstrapping,
      login,
      register,
      logout,
    }),
    [token, user, bootstrapping],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth harus dipakai di dalam AuthProvider.");
  }
  return context;
};
