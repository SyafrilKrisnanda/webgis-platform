const ACCESS_TOKEN_KEY = "webgis_access_token";
const AUTH_USER_KEY = "webgis_auth_user";

export const getAccessToken = () =>
  localStorage.getItem(ACCESS_TOKEN_KEY) || "";

export const setAccessToken = (token) => {
  if (token) {
    localStorage.setItem(ACCESS_TOKEN_KEY, token);
  } else {
    localStorage.removeItem(ACCESS_TOKEN_KEY);
  }
};

export const getAuthUser = () => {
  const raw = localStorage.getItem(AUTH_USER_KEY);
  if (!raw) {
    return null;
  }

  try {
    return JSON.parse(raw);
  } catch {
    localStorage.removeItem(AUTH_USER_KEY);
    return null;
  }
};

export const setAuthUser = (user) => {
  if (user) {
    localStorage.setItem(AUTH_USER_KEY, JSON.stringify(user));
  } else {
    localStorage.removeItem(AUTH_USER_KEY);
  }
};

export { ACCESS_TOKEN_KEY };
