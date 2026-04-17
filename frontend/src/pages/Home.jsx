import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

const Home = () => {
  const [postId, setPostId] = useState("");
  const navigate = useNavigate();

  const handleSubmit = (event) => {
    event.preventDefault();
    const trimmed = postId.trim();
    if (!trimmed) {
      return;
    }

    navigate(`/posts/${trimmed}`);
  };

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <p className="eyebrow">WebGIS Platform</p>
          <h1>Viewer Layer</h1>
          <p className="subtitle">
            Masukkan ID posting untuk menampilkan layer pada peta.
          </p>
        </div>
      </header>

      <section className="card">
        <form className="post-form" onSubmit={handleSubmit}>
          <label htmlFor="postId">ID Posting</label>
          <div className="post-form-row">
            <input
              id="postId"
              type="text"
              placeholder="contoh: 12"
              value={postId}
              onChange={(event) => setPostId(event.target.value)}
            />
            <button type="submit">Buka Detail</button>
          </div>
        </form>
        <p className="helper">
          Atau coba contoh: <Link to="/posts/1">Posting #1</Link>.
        </p>
      </section>
    </div>
  );
};

export default Home;
