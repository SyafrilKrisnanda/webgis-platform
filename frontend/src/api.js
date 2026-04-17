const rawBaseUrl = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";

export const API_BASE_URL = rawBaseUrl.replace(/\/+$/, "");

const buildUrl = (path) => {
  if (!path) {
    return API_BASE_URL;
  }

  if (path.startsWith("/")) {
    return `${API_BASE_URL}${path}`;
  }

  return `${API_BASE_URL}/${path}`;
};

const fetchJson = async (path, options = {}) => {
  const response = await fetch(buildUrl(path), options);

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(
      `Request failed (${response.status}): ${errorText || response.statusText}`,
    );
  }

  if (response.status === 204) {
    return null;
  }

  return response.json();
};

export const registerUser = (payload) =>
  fetchJson("/api/auth/register/", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

export const loginUser = (payload) =>
  fetchJson("/api/auth/login/", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

export const getPost = (postId) => fetchJson(`/api/posts/${postId}/`);

export const getPostLayers = async (postId) => {
  const data = await fetchJson(`/api/posts/${postId}/layers/`);
  return Array.isArray(data) ? data : data?.results || [];
};

export const getLayerGeojson = (layerId) =>
  fetchJson(`/api/layers/${layerId}/features/`);
