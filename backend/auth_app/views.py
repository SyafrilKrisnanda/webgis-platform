from django.contrib.auth.models import User
from django.core import signing
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json

@csrf_exempt
@require_POST
def register_user(request):
    try:
        data = json.loads(request.body)
        username = data.get("username")
        password = data.get("password")
        email = data.get("email", "")

        if not username or not password:
            return JsonResponse({"error": "Username dan password wajib."}, status=400)

        if User.objects.filter(username=username).exists():
            return JsonResponse({"error": "Username sudah digunakan."}, status=400)

        user = User.objects.create_user(username=username, password=password, email=email)
        return JsonResponse({"id": user.id, "username": user.username, "email": user.email})
    except json.JSONDecodeError:
        return JsonResponse({"error": "Payload tidak valid."}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

@csrf_exempt
@require_POST
def login_user(request):
    try:
        data = json.loads(request.body)
        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            return JsonResponse({"error": "Username dan password wajib."}, status=400)

        user = User.objects.filter(username=username).first()
        if not user or not user.check_password(password):
            return JsonResponse({"error": "Username atau password salah."}, status=401)

        # Token signed sederhana untuk bootstrap auth frontend tanpa dependensi eksternal.
        payload = {
            "id": user.id,
            "username": user.username,
        }
        token = signing.dumps(payload)

        return JsonResponse({"id": user.id, "username": user.username, "email": user.email, "token": token})
    except json.JSONDecodeError:
        return JsonResponse({"error": "Payload tidak valid."}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)