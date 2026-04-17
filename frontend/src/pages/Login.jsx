import { useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";

import { useAuth } from "../auth/AuthContext";

const Login = () => {
  const [form, setForm] = useState({ username: "", password: "" });
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { login } = useAuth();

  const handleChange = (event) => {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setSubmitting(true);

    try {
      await login({
        username: form.username.trim(),
        password: form.password,
      });
      const redirectTo = location.state?.from || "/";
      navigate(redirectTo, { replace: true });
    } catch (err) {
      setError(err.message || "Gagal masuk.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="page narrow-page">
      <section className="card auth-card">
        <div className="card-header">
          <h2>Masuk</h2>
          <p>Gunakan akun yang sudah terdaftar untuk lanjut.</p>
        </div>

        {error ? <div className="alert">{error}</div> : null}

        <form className="form" onSubmit={handleSubmit}>
          <label htmlFor="username">Username</label>
          <input
            id="username"
            name="username"
            type="text"
            placeholder="contoh: gis_admin"
            value={form.username}
            onChange={handleChange}
            autoComplete="username"
            required
          />

          <label htmlFor="password">Password</label>
          <input
            id="password"
            name="password"
            type="password"
            placeholder="Masukkan password"
            value={form.password}
            onChange={handleChange}
            autoComplete="current-password"
            required
          />

          <button
            className="primary-button"
            type="submit"
            disabled={submitting}
          >
            {submitting ? "Memproses..." : "Masuk"}
          </button>
        </form>

        <p className="helper">
          Belum punya akun? <Link to="/register">Daftar</Link>
        </p>
      </section>
    </div>
  );
};

export default Login;
