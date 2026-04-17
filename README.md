# WebGIS Platform

Fondasi proyek MVP WebGIS berbasis Docker Compose dengan stack:

- Backend Django
- PostgreSQL + PostGIS
- Frontend React (Vite)
- Opsional: pgAdmin
- Opsional: Nginx reverse proxy (production-like)

## Struktur Direktori

```
.
├── backend/
├── frontend/
├── deploy/
│   └── nginx/
├── docker-compose.yml
└── .env.example
```

## Quick Start (Dev)

1. Salin file environment.

```bash
cp .env.example .env
```

Untuk Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

2. Jalankan stack dengan satu perintah.

```bash
docker compose up --build
```

Layanan default yang aktif:

- Backend: http://localhost:8000/health/
- Frontend: http://localhost:5173
- PostGIS: localhost:5432

## Service Opsional

Jalankan pgAdmin:

```bash
docker compose --profile tools up -d pgadmin
```

Jalankan Nginx reverse proxy:

```bash
docker compose --profile prod up -d nginx
```

## Perintah Django Penting

Menjalankan migration manual:

```bash
docker compose exec backend python manage.py migrate
```

Membuat superuser:

```bash
docker compose exec backend python manage.py createsuperuser
```

## Volumes

- `postgres_data` untuk data PostgreSQL/PostGIS
- `media_data` untuk file upload backend
- `frontend_node_modules` untuk dependency frontend di container
- `pgadmin_data` untuk data konfigurasi pgAdmin
