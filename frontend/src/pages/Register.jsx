import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

import { useAuth } from "../auth/AuthContext";

const Register = () => {
  const [form, setForm] = useState({
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
  });
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const navigate = useNavigate();
  const { register } = useAuth();

  const handleChange = (event) => {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");

    if (form.password !== form.confirmPassword) {
      setError("Konfirmasi password tidak sama.");
      return;
    }

    setSubmitting(true);

    try {
      const data = await register({
        username: form.username.trim(),
        email: form.email.trim() || undefined,
        password: form.password,
      });

      if (data?.access || data?.token) {
        navigate("/", { replace: true });
      } else {
        navigate("/login", { replace: true });
      }
    } catch (err) {
      setError(err.message || "Gagal membuat akun.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="page narrow-page">
      <section className="card auth-card">
        <div className="card-header">
          <h2>Buat Akun</h2>
          <p>Daftarkan akun baru untuk mengunggah dataset.</p>
        </div>

        {error ? <div className="alert">{error}</div> : null}

        <form className="form" onSubmit={handleSubmit}>
          <label htmlFor="username">Username</label>
          <input
            id="username"
            name="username"
            type="text"
            placeholder="contoh: gis_user"
            value={form.username}
            onChange={handleChange}
            autoComplete="username"
            required
          />

          <label htmlFor="email">Email (opsional)</label>
          <input
            id="email"
            name="email"
            type="email"
            placeholder="email@domain.com"
            value={form.email}
            onChange={handleChange}
            autoComplete="email"
          />

          <label htmlFor="password">Password</label>
          <input
            id="password"
            name="password"
            type="password"
            placeholder="Minimal 8 karakter"
            value={form.password}
            onChange={handleChange}
            autoComplete="new-password"
            required
          />

          <label htmlFor="confirmPassword">Konfirmasi Password</label>
          <input
            id="confirmPassword"
            name="confirmPassword"
            type="password"
            placeholder="Ulangi password"
            value={form.confirmPassword}
            onChange={handleChange}
            autoComplete="new-password"
            required
          />

          <button
            className="primary-button"
            type="submit"
            disabled={submitting}
          >
            {submitting ? "Menyimpan..." : "Daftar"}
          </button>
        </form>

        <p className="helper">
          Sudah punya akun? <Link to="/login">Masuk</Link>
        </p>
      </section>
    </div>
  );
};

export default Register;
