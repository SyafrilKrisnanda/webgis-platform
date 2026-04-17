import { useEffect, useMemo } from "react";
import PropTypes from "prop-types";
import {
  GeoJSON,
  LayersControl,
  MapContainer,
  TileLayer,
  useMap,
} from "react-leaflet";
import L from "leaflet";

const defaultStyle = () => ({
  color: "#1e3a8a",
  weight: 2,
  fillColor: "#3b82f6",
  fillOpacity: 0.35,
});

const pointToLayer = (_feature, latlng) =>
  L.circleMarker(latlng, {
    radius: 6,
    fillColor: "#ef4444",
    color: "#991b1b",
    weight: 1,
    fillOpacity: 0.9,
  });

const escapeHtml = (value) =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");

const formatAttributeValue = (value) => {
  if (value === null || value === undefined) {
    return "-";
  }

  if (typeof value === "object") {
    return JSON.stringify(value);
  }

  return String(value);
};

const buildPopupContent = (feature) => {
  const props = feature?.properties || {};
  const keys = Object.keys(props);
  const geometryType = feature?.geometry?.type || "Unknown";

  const geometryRow = `<tr><th style="text-align:left;padding-right:8px;vertical-align:top;">geometry</th><td>${escapeHtml(
    geometryType,
  )}</td></tr>`;

  if (keys.length === 0) {
    return `<div style="min-width:180px;"><table>${geometryRow}<tr><th style="text-align:left;padding-right:8px;vertical-align:top;">attributes</th><td>No attributes</td></tr></table></div>`;
  }

  const rows = keys
    .map((key) => {
      const value = props[key];
      return `<tr><th style="text-align:left;padding-right:8px;vertical-align:top;">${escapeHtml(
        key,
      )}</th><td>${escapeHtml(formatAttributeValue(value))}</td></tr>`;
    })
    .join("");

  return `<div style="min-width:180px;"><table>${geometryRow}${rows}</table></div>`;
};

const FitBounds = ({ geojsonList }) => {
  const map = useMap();

  useEffect(() => {
    if (!geojsonList.length) {
      return;
    }

    const bounds = L.latLngBounds();

    geojsonList.forEach((data) => {
      if (!data) {
        return;
      }

      const layerBounds = L.geoJSON(data).getBounds();
      if (layerBounds.isValid()) {
        bounds.extend(layerBounds);
      }
    });

    if (bounds.isValid()) {
      map.fitBounds(bounds, { padding: [20, 20] });
    }
  }, [geojsonList, map]);

  return null;
};

FitBounds.propTypes = {
  geojsonList: PropTypes.arrayOf(PropTypes.object).isRequired,
};

const MapViewer = ({ activeLayers, geojsonByLayerId }) => {
  const geojsonList = useMemo(
    () =>
      activeLayers.map((layer) => geojsonByLayerId[layer.id]).filter(Boolean),
    [activeLayers, geojsonByLayerId],
  );

  return (
    <MapContainer
      className="map"
      center={[-2.5, 118.0]}
      zoom={5}
      scrollWheelZoom
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />

      <LayersControl position="topright">
        {activeLayers.map((layer) => {
          const data = geojsonByLayerId[layer.id];
          if (!data) {
            return null;
          }

          return (
            <LayersControl.Overlay
              key={layer.id}
              checked
              name={layer.name || layer.title || `Layer ${layer.id}`}
            >
              <GeoJSON
                data={data}
                style={defaultStyle}
                pointToLayer={pointToLayer}
                onEachFeature={(feature, leafletLayer) => {
                  leafletLayer.bindPopup(buildPopupContent(feature));
                }}
              />
            </LayersControl.Overlay>
          );
        })}
      </LayersControl>

      <FitBounds geojsonList={geojsonList} />
    </MapContainer>
  );
};

MapViewer.propTypes = {
  activeLayers: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
      name: PropTypes.string,
      title: PropTypes.string,
    }),
  ).isRequired,
  geojsonByLayerId: PropTypes.object.isRequired,
};

export default MapViewer;
