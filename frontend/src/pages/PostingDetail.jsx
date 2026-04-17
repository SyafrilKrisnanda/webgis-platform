import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";

import { getLayerGeojson, getPost, getPostLayers } from "../api";
import MapViewer from "../components/MapViewer";

const buildLayerLabel = (layer) =>
  layer.name || layer.title || `Layer ${layer.id}`;

const PostingDetail = () => {
  const { postId } = useParams();
  const [post, setPost] = useState(null);
  const [layers, setLayers] = useState([]);
  const [activeLayerIds, setActiveLayerIds] = useState([]);
  const [geojsonByLayerId, setGeojsonByLayerId] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let isMounted = true;

    const load = async () => {
      setLoading(true);
      setError("");

      try {
        const [postResponse, layersResponse] = await Promise.all([
          getPost(postId),
          getPostLayers(postId),
        ]);

        if (!isMounted) {
          return;
        }

        setPost(postResponse);
        setLayers(layersResponse || []);
        setActiveLayerIds((layersResponse || []).map((layer) => layer.id));
      } catch (err) {
        if (!isMounted) {
          return;
        }

        setError(err.message || "Gagal memuat detail posting.");
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    };

    load();

    return () => {
      isMounted = false;
    };
  }, [postId]);

  const activeLayers = useMemo(
    () => layers.filter((layer) => activeLayerIds.includes(layer.id)),
    [layers, activeLayerIds],
  );

  const hasLayerData = layers.length > 0;
  const hasRenderableGeojson = activeLayers.some((layer) =>
    Boolean(geojsonByLayerId[layer.id]),
  );

  const toggleLayer = async (layerId) => {
    if (activeLayerIds.includes(layerId)) {
      setActiveLayerIds((prev) => prev.filter((id) => id !== layerId));
      return;
    }

    setActiveLayerIds((prev) => [...prev, layerId]);

    if (!geojsonByLayerId[layerId]) {
      try {
        const data = await getLayerGeojson(layerId);
        setGeojsonByLayerId((prev) => ({
          ...prev,
          [layerId]: data,
        }));
      } catch (err) {
        setError(err.message || "Gagal memuat GeoJSON.");
      }
    }
  };

  useEffect(() => {
    const loadMissing = async () => {
      const missing = activeLayerIds.filter((id) => !geojsonByLayerId[id]);
      if (!missing.length) {
        return;
      }

      const entries = await Promise.all(
        missing.map(async (id) => {
          try {
            const data = await getLayerGeojson(id);
            return [id, data];
          } catch (err) {
            setError(err.message || "Gagal memuat GeoJSON.");
            return [id, null];
          }
        }),
      );

      setGeojsonByLayerId((prev) => ({
        ...prev,
        ...Object.fromEntries(entries.filter((entry) => entry[1])),
      }));
    };

    loadMissing();
  }, [activeLayerIds, geojsonByLayerId]);

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <Link className="back-link" to="/">
            Kembali
          </Link>
          <h1>Detail Posting</h1>
          <p className="subtitle">
            {post?.title || post?.name || `Posting #${postId}`}
          </p>
        </div>
      </header>

      {error ? <div className="alert">{error}</div> : null}

      <section className="split">
        <aside className="card layer-panel">
          <div className="card-header">
            <h2>Layer Aktif</h2>
            <p>Pilih layer untuk ditampilkan pada peta.</p>
          </div>

          {loading ? (
            <p>Memuat layer...</p>
          ) : layers.length === 0 ? (
            <div className="empty-state">
              <h3>Belum ada layer</h3>
              <p>
                Posting ini belum memiliki layer GIS. Coba posting lain,
                misalnya
                <strong> posting #1</strong>, untuk melihat contoh data spasial.
              </p>
            </div>
          ) : (
            <ul className="layer-list">
              {layers.map((layer) => (
                <li key={layer.id}>
                  <label className="layer-item">
                    <input
                      type="checkbox"
                      checked={activeLayerIds.includes(layer.id)}
                      onChange={() => toggleLayer(layer.id)}
                    />
                    <span>{buildLayerLabel(layer)}</span>
                  </label>
                </li>
              ))}
            </ul>
          )}
        </aside>

        <section className="card map-card">
          <div className="card-header">
            <h2>Peta</h2>
            <p>Popup atribut akan muncul saat feature diklik.</p>
          </div>
          <div className="map-wrapper">
            {loading ? (
              <div className="map-empty-state">Memuat layer untuk peta...</div>
            ) : !hasLayerData ? (
              <div className="map-empty-state">
                Belum ada layer yang bisa ditampilkan pada peta.
              </div>
            ) : activeLayerIds.length === 0 ? (
              <div className="map-empty-state">
                Semua layer nonaktif. Centang minimal satu layer untuk
                menampilkan geometri.
              </div>
            ) : !hasRenderableGeojson ? (
              <div className="map-empty-state">
                Memuat geometri layer aktif...
              </div>
            ) : (
              <MapViewer
                activeLayers={activeLayers}
                geojsonByLayerId={geojsonByLayerId}
              />
            )}
          </div>
        </section>
      </section>
    </div>
  );
};

export default PostingDetail;
