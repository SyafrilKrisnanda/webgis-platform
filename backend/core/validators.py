import os

from django.conf import settings
from django.core.exceptions import ValidationError


def get_upload_validation_config():
    allowed_extensions = getattr(settings, "UPLOAD_ALLOWED_EXTENSIONS", (".geojson", ".kml"))
    allowed_mime_types = getattr(
        settings,
        "UPLOAD_ALLOWED_MIME_TYPES",
        (
            "application/geo+json",
            "application/json",
            "application/vnd.google-earth.kml+xml",
        ),
    )
    max_size_bytes = getattr(settings, "UPLOAD_MAX_BYTES", 5 * 1024 * 1024)

    return allowed_extensions, allowed_mime_types, max_size_bytes


def validate_upload_file(uploaded_file, allowed_extensions=None, allowed_mime_types=None, max_size_bytes=None):
    allowed_extensions = allowed_extensions or get_upload_validation_config()[0]
    allowed_mime_types = allowed_mime_types or get_upload_validation_config()[1]
    max_size_bytes = max_size_bytes or get_upload_validation_config()[2]

    file_name = getattr(uploaded_file, "name", "")
    extension = os.path.splitext(file_name)[1].lower()
    if extension not in allowed_extensions:
        raise ValidationError("File extension tidak diizinkan.")

    content_type = (getattr(uploaded_file, "content_type", "") or "").lower()
    if content_type and content_type not in allowed_mime_types:
        raise ValidationError("MIME type tidak sesuai.")

    size = getattr(uploaded_file, "size", 0)
    if max_size_bytes and size > max_size_bytes:
        raise ValidationError("Ukuran file melebihi batas.")
