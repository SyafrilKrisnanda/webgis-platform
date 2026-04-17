import {
  BrowserRouter,
  Link,
  Navigate,
  Outlet,
  Route,
  Routes,
} from "react-router-dom";

import { useAuth } from "./auth/AuthContext";
import Home from "./pages/Home";
import Login from "./pages/Login";
import PostingDetail from "./pages/PostingDetail";
import Register from "./pages/Register";

const GuestOnly = () => {
  const { isAuthenticated, bootstrapping } = useAuth();

  if (bootstrapping) {
    return null;
  }

  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
};

const AppLayout = () => {
  const { isAuthenticated, user, logout, bootstrapping } = useAuth();
  const displayName = user?.username || user?.email;

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="brand">
          <Link to="/">WebGIS Platform</Link>
        </div>
        <nav className="nav-links">
          <Link to="/">Beranda</Link>
          {isAuthenticated ? (
            <button className="link-button" type="button" onClick={logout}>
              Keluar
            </button>
          ) : (
            <>
              <Link to="/login">Masuk</Link>
              <Link className="primary-link" to="/register">
                Daftar
              </Link>
            </>
          )}
        </nav>
        <div className="nav-meta">
          {bootstrapping ? (
            <span className="status-pill">Memuat sesi...</span>
          ) : displayName ? (
            <span className="user-badge">{displayName}</span>
          ) : null}
        </div>
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
};

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<AppLayout />}>
          <Route path="/" element={<Home />} />
          <Route path="/posts/:postId" element={<PostingDetail />} />
          <Route element={<GuestOnly />}>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
