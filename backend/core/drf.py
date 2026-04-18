from collections.abc import Mapping

from rest_framework.views import exception_handler as drf_exception_handler


def _flatten_errors(data, field_path=""):
    errors = []

    if isinstance(data, Mapping):
        for key, value in data.items():
            next_path = f"{field_path}.{key}" if field_path else str(key)
            errors.extend(_flatten_errors(value, next_path))
        return errors

    if isinstance(data, list):
        for index, value in enumerate(data):
            if isinstance(value, (Mapping, list)):
                next_path = f"{field_path}[{index}]" if field_path else f"[{index}]"
                errors.extend(_flatten_errors(value, next_path))
                continue

            errors.append(
                {
                    "field": field_path or None,
                    "message": str(value),
                    "code": getattr(value, "code", "error"),
                }
            )
        return errors

    errors.append(
        {
            "field": field_path or None,
            "message": str(data),
            "code": getattr(data, "code", "error"),
        }
    )
    return errors


def custom_exception_handler(exc, context):
    response = drf_exception_handler(exc, context)
    if response is None:
        return None

    error_items = _flatten_errors(response.data)
    if not error_items:
        error_items = [
            {
                "field": None,
                "message": str(response.data),
                "code": "error",
            }
        ]

    request = context.get("request")
    response.data = {
        "success": False,
        "status_code": response.status_code,
        "message": error_items[0]["message"],
        "errors": error_items,
        "path": request.path if request else None,
    }
    return response