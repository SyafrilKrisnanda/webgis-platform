const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";

function App() {
  return (
    <main style={{ fontFamily: "Segoe UI, Tahoma, sans-serif", padding: 24 }}>
      <h1 style={{ marginTop: 0 }}>WebGIS Platform - Frontend Foundation</h1>
      <p>
        Frontend dev server aktif. API backend dapat diakses melalui:{" "}
        <strong>{apiBaseUrl}</strong>
      </p>
      <ul>
        <li>Service frontend tersedia</li>
        <li>Integrasi API base URL tersedia</li>
        <li>Siap dilanjutkan ke issue frontend berikutnya</li>
      </ul>
    </main>
  );
}

export default App;
