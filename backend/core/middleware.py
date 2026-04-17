import os

from django.conf import settings
from django.core.cache import cache
from django.http import HttpResponse, JsonResponse


class SimpleCorsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.allowed_origins = self._load_allowed_origins()
        self.allowed_methods = self._load_allowed_methods()
        self.allowed_headers = self._load_allowed_headers()
        self.max_age = getattr(settings, "CORS_MAX_AGE", 86400)
        self.allow_credentials = getattr(settings, "CORS_ALLOW_CREDENTIALS", False)

    def __call__(self, request):
        origin = request.headers.get("Origin")

        if request.method == "OPTIONS" and self._is_origin_allowed(origin):
            response = HttpResponse(status=204)
        else:
            response = self.get_response(request)

        if self._is_origin_allowed(origin):
            response["Access-Control-Allow-Origin"] = origin
            response["Vary"] = "Origin"
            response["Access-Control-Allow-Methods"] = ", ".join(self.allowed_methods)
            response["Access-Control-Allow-Headers"] = ", ".join(self.allowed_headers)
            response["Access-Control-Max-Age"] = str(self.max_age)
            if self.allow_credentials:
                response["Access-Control-Allow-Credentials"] = "true"

        return response

    def _is_origin_allowed(self, origin):
        return bool(origin and origin in self.allowed_origins)

    def _load_allowed_origins(self):
        setting_value = getattr(settings, "CORS_ALLOWED_ORIGINS", None)
        if isinstance(setting_value, (list, tuple, set)):
            return {origin.strip() for origin in setting_value if origin}

        raw_origins = os.getenv(
            "CORS_ALLOWED_ORIGINS",
            "http://localhost:5173,http://127.0.0.1:5173",
        )
        return {origin.strip() for origin in raw_origins.split(",") if origin.strip()}

    def _load_allowed_methods(self):
        setting_value = getattr(settings, "CORS_ALLOWED_METHODS", None)
        if isinstance(setting_value, (list, tuple, set)):
            return [method.strip() for method in setting_value if method]

        raw_methods = os.getenv("CORS_ALLOWED_METHODS", "GET,POST,PUT,PATCH,DELETE,OPTIONS")
        return [method.strip() for method in raw_methods.split(",") if method.strip()]

    def _load_allowed_headers(self):
        setting_value = getattr(settings, "CORS_ALLOWED_HEADERS", None)
        if isinstance(setting_value, (list, tuple, set)):
            return [header.strip() for header in setting_value if header]

        raw_headers = os.getenv("CORS_ALLOWED_HEADERS", "Content-Type,Authorization")
        return [header.strip() for header in raw_headers.split(",") if header.strip()]


class SimpleRateLimitMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.enabled = getattr(settings, "RATE_LIMIT_ENABLED", False)
        self.rules = getattr(settings, "RATE_LIMIT_RULES", [])

    def __call__(self, request):
        if not self.enabled or not self.rules:
            return self.get_response(request)

        path = request.path or ""
        for rule in self.rules:
            prefix = rule.get("path_prefix")
            if not prefix or not path.startswith(prefix):
                continue

            limit = int(rule.get("limit", 0))
            window = int(rule.get("window", 60))
            if limit <= 0:
                break

            client_id = self._get_client_id(request)
            cache_key = f"rl:{prefix}:{client_id}"
            current = cache.get(cache_key, 0)
            if current >= limit:
                return JsonResponse({"detail": "Rate limit exceeded."}, status=429)

            cache.set(cache_key, current + 1, timeout=window)
            break

        return self.get_response(request)

    def _get_client_id(self, request):
        forwarded_for = request.META.get("HTTP_X_FORWARDED_FOR")
        if forwarded_for:
            return forwarded_for.split(",")[0].strip()

        return request.META.get("REMOTE_ADDR", "unknown")
