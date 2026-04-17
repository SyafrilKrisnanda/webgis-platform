from django.urls import path

from .views import health, layer_features, post_detail, post_layers

urlpatterns = [
    path("health/", health, name="health"),
    path("api/health/", health, name="api-health"),
    path("api/posts/<int:post_id>/", post_detail, name="api-post-detail"),
    path("api/posts/<int:post_id>/layers/", post_layers, name="api-post-layers"),
    path(
        "api/layers/<int:layer_id>/features/",
        layer_features,
        name="api-layer-features",
    ),
]