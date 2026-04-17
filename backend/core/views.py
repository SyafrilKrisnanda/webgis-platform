from django.db import DatabaseError, connection
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response


SAMPLE_POSTS = {
    1: {
        "id": 1,
        "title": "Contoh Posting WebGIS",
        "description": "Dataset contoh untuk validasi viewer React-Leaflet.",
    },
    2: {
        "id": 2,
        "title": "Posting Tanpa Layer",
        "description": "Digunakan untuk menguji empty-state yang informatif.",
    },
}

SAMPLE_LAYERS_BY_POST = {
    1: [
        {
            "id": 101,
            "name": "Titik Fasilitas",
            "geometry_type": "Point",
            "feature_count": 2,
        },
        {
            "id": 102,
            "name": "Jalur Akses",
            "geometry_type": "LineString",
            "feature_count": 2,
        },
        {
            "id": 103,
            "name": "Zona Administratif",
            "geometry_type": "Polygon",
            "feature_count": 2,
        },
    ],
    2: [],
}

SAMPLE_GEOJSON_BY_LAYER = {
    101: {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "id": "pt-1",
                "geometry": {"type": "Point", "coordinates": [106.8272, -6.1754]},
                "properties": {
                    "name": "Monas",
                    "category": "Landmark",
                    "status": "active",
                },
            },
            {
                "type": "Feature",
                "id": "pt-2",
                "geometry": {"type": "Point", "coordinates": [106.8456, -6.2088]},
                "properties": {
                    "name": "Bundaran HI",
                    "category": "Transport Hub",
                    "status": "active",
                },
            },
        ],
    },
    102: {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "id": "ln-1",
                "geometry": {
                    "type": "LineString",
                    "coordinates": [
                        [106.8170, -6.1700],
                        [106.8300, -6.1820],
                        [106.8420, -6.1950],
                    ],
                },
                "properties": {
                    "name": "Koridor Barat-Timur",
                    "surface": "asphalt",
                    "length_km": 4.8,
                },
            },
            {
                "type": "Feature",
                "id": "mln-1",
                "geometry": {
                    "type": "MultiLineString",
                    "coordinates": [
                        [
                            [106.8450, -6.2050],
                            [106.8520, -6.2130],
                        ],
                        [
                            [106.8520, -6.2130],
                            [106.8610, -6.2210],
                        ],
                    ],
                },
                "properties": {
                    "name": "Jalur Feeder Selatan",
                    "surface": "concrete",
                    "length_km": 2.1,
                },
            },
        ],
    },
    103: {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "id": "pg-1",
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                        [
                            [106.8100, -6.2100],
                            [106.8350, -6.2100],
                            [106.8350, -6.1900],
                            [106.8100, -6.1900],
                            [106.8100, -6.2100],
                        ]
                    ],
                },
                "properties": {
                    "name": "Zona A",
                    "classification": "residential",
                    "priority": "medium",
                },
            },
            {
                "type": "Feature",
                "id": "mpg-1",
                "geometry": {
                    "type": "MultiPolygon",
                    "coordinates": [
                        [
                            [
                                [106.8450, -6.2150],
                                [106.8600, -6.2150],
                                [106.8600, -6.2000],
                                [106.8450, -6.2000],
                                [106.8450, -6.2150],
                            ]
                        ],
                        [
                            [
                                [106.8650, -6.2250],
                                [106.8750, -6.2250],
                                [106.8750, -6.2150],
                                [106.8650, -6.2150],
                                [106.8650, -6.2250],
                            ]
                        ],
                    ],
                },
                "properties": {
                    "name": "Zona B",
                    "classification": "commercial",
                    "priority": "high",
                },
            },
        ],
    },
}


@api_view(["GET"])
def health(request):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT PostGIS_Version();")
            postgis_version = cursor.fetchone()[0]
    except DatabaseError:
        return Response(
            {
                "status": "error",
                "detail": "PostGIS extension is not available.",
            },
            status=status.HTTP_503_SERVICE_UNAVAILABLE,
        )

    return Response(
        {
            "status": "ok",
            "database": "connected",
            "postgis_version": postgis_version,
        }
    )


@api_view(["GET"])
def post_detail(request, post_id):
    post = SAMPLE_POSTS.get(post_id)
    if not post:
        return Response({"detail": "Post not found."}, status=status.HTTP_404_NOT_FOUND)

    return Response(post)


@api_view(["GET"])
def post_layers(request, post_id):
    if post_id not in SAMPLE_POSTS:
        return Response({"detail": "Post not found."}, status=status.HTTP_404_NOT_FOUND)

    return Response(SAMPLE_LAYERS_BY_POST.get(post_id, []))


@api_view(["GET"])
def layer_features(request, layer_id):
    geojson = SAMPLE_GEOJSON_BY_LAYER.get(layer_id)
    if not geojson:
        return Response({"detail": "Layer not found."}, status=status.HTTP_404_NOT_FOUND)

    return Response(geojson, content_type="application/geo+json")