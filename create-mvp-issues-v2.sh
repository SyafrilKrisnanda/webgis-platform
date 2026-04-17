#!/bin/bash

# Fungsi helper untuk create issue
create_issue() {
  local title=$1
  local body=$2
  local labels=$3
  
  gh issue create --title "$title" --body "$body" $labels
  sleep 1
}

echo "🚀 Membuat 12 MVP Issues WebGIS Platform..."

# Issue 1 - DevOps
create_issue \
  "[MVP][DevOps] Inisialisasi Struktur Proyek dan Docker Compose Dasar" \
  "## Deskripsi
Siapkan fondasi repository untuk backend, frontend, dan database PostGIS agar seluruh tim bisa menjalankan proyek secara konsisten di local environment.

## Acceptance Criteria
- [ ] Struktur direktori dasar backend dan frontend tersedia.
- [ ] Docker Compose menjalankan service postgres+postgis, backend, frontend.
- [ ] Healthcheck database dan backend tersedia.
- [ ] File environment contoh disediakan untuk local development.
- [ ] Perintah satu langkah untuk start stack terdokumentasi." \
  "--label devops --label mvp"

# Issue 2 - Backend Bootstrap
create_issue \
  "[MVP][Backend][API][GIS] Bootstrap Django, DRF, GeoDjango, dan Konfigurasi PostGIS" \
  "## Deskripsi
Inisialisasi project Django sebagai fondasi API dengan DRF dan GeoDjango yang terhubung ke PostGIS.

## Acceptance Criteria
- [ ] Project Django dan app inti terbentuk.
- [ ] DRF aktif dengan konfigurasi global pagination dan error format dasar.
- [ ] GeoDjango terhubung ke PostGIS tanpa error migration.
- [ ] Endpoint health API tersedia.
- [ ] CORS dasar untuk frontend local development sudah aktif.

## Dependencies
- #1 Inisialisasi Struktur Proyek" \
  "--label backend --label api --label gis --label mvp"

# Issue 3 - Auth
create_issue \
  "[MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User" \
  "## Deskripsi
Bangun modul autentikasi publik agar user dapat mendaftar, login, dan mengakses endpoint terlindungi.

## Acceptance Criteria
- [ ] Endpoint register user berfungsi.
- [ ] Endpoint login JWT dan refresh token berfungsi.
- [ ] Endpoint profil user saat ini tersedia untuk user login.
- [ ] Endpoint yang perlu auth menolak request tanpa token valid.
- [ ] Test minimal untuk alur register dan login tersedia.

## Dependencies
- #2 Bootstrap Django, DRF, GeoDjango" \
  "--label backend --label auth --label api --label security --label mvp"

# Issue 4 - Models
create_issue \
  "[MVP][Backend][GIS] Desain dan Implementasi Model Post, Dataset, Layer, dan Feature" \
  "## Deskripsi
Buat model data inti WebGIS agar posting, dataset, layer, dan feature tersimpan terstruktur di PostGIS.

## Acceptance Criteria
- [ ] Model Post, Dataset, Layer, Feature dibuat sesuai relasi.
- [ ] Geometry disimpan pada kolom spasial PostGIS dan properties pada JSON.
- [ ] Normalisasi SRID target ke EPSG:4326 ditetapkan di level model/service.
- [ ] Migration sukses dan dapat dijalankan ulang di environment baru.
- [ ] Admin view dasar untuk inspeksi data tersedia.

## Dependencies
- #2 Bootstrap Django, DRF, GeoDjango" \
  "--label backend --label gis --label mvp"

# Issue 5 - Upload Pipeline
create_issue \
  "[MVP][Backend][GIS][API] Pipeline Upload GeoJSON/KML dengan Parsing Multi-Layer dan Split Layer" \
  "## Deskripsi
Bangun service upload yang menerima GeoJSON/KML, membaca semua layer dalam file, lalu menyimpan tiap layer secara terpisah beserta fiturnya.

## Acceptance Criteria
- [ ] Endpoint upload multipart menerima file GeoJSON dan KML.
- [ ] File multilayer terdeteksi dan dipecah menjadi beberapa entitas Layer.
- [ ] Seluruh feature per layer tersimpan dengan geometri valid.
- [ ] Jika parsing gagal di tengah proses, transaksi rollback total.
- [ ] Respons upload mengembalikan ringkasan layer_count dan feature_count.
- [ ] Test untuk skenario GeoJSON dan KML multilayer tersedia.

## Dependencies
- #3 Implementasi Register, Login JWT
- #4 Model Post, Dataset, Layer, Feature" \
  "--label backend --label gis --label api --label mvp"

# Issue 6 - Backend API Endpoints
create_issue \
  "[MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset" \
  "## Deskripsi
Sediakan endpoint publik dan terautentikasi untuk feed posting, detail posting, akses layer, dan download data.

## Acceptance Criteria
- [ ] Endpoint list dan detail posting publik tersedia dengan pagination.
- [ ] Endpoint create/update/delete posting tersedia untuk owner/admin.
- [ ] Endpoint list layer per posting tersedia.
- [ ] Endpoint feature layer mengembalikan GeoJSON valid.
- [ ] Endpoint download file asli dataset tersedia.
- [ ] Endpoint download layer sebagai GeoJSON tersedia.

## Dependencies
- #3 Register, Login JWT
- #5 Pipeline Upload GeoJSON/KML" \
  "--label backend --label api --label gis --label mvp"

# Issue 7 - Frontend Auth Bootstrap
create_issue \
  "[MVP][Frontend][Auth] Bootstrap React App, Routing, API Client, dan State Autentikasi" \
  "## Deskripsi
Bangun pondasi frontend React untuk mendukung alur login dan konsumsi API backend.

## Acceptance Criteria
- [ ] Struktur app React dan routing halaman utama tersedia.
- [ ] API client terstandar untuk request ke backend tersedia.
- [ ] State autentikasi login/logout tersimpan dan dipakai route guard.
- [ ] Halaman register dan login terhubung ke API auth.
- [ ] Tampilan responsif dasar untuk desktop dan mobile tersedia.

## Dependencies
- #1 Inisialisasi Struktur Proyek
- #3 Implementasi Register, Login JWT" \
  "--label frontend --label auth --label mvp"

# Issue 8 - Frontend Feed & Upload
create_issue \
  "[MVP][Frontend][API] Implementasi Feed Posting, Form Buat Posting, dan Upload Dataset" \
  "## Deskripsi
Implementasi alur user frontend untuk melihat feed posting, membuat posting baru, dan upload dataset GeoJSON/KML.

## Acceptance Criteria
- [ ] Halaman feed menampilkan daftar posting publik dengan pagination.
- [ ] Halaman/detail posting menampilkan metadata utama dataset.
- [ ] Form buat posting mendukung upload file dataset.
- [ ] Error dan status sukses upload ditampilkan jelas.
- [ ] Tombol download dataset pada detail posting berfungsi.

## Dependencies
- #7 Bootstrap React App
- #6 API Posting Publik & Download Dataset" \
  "--label frontend --label api --label mvp"

# Issue 9 - React-Leaflet Integration
create_issue \
  "[MVP][Frontend][GIS][API] Integrasi React-Leaflet untuk Viewer Layer dan Popup Atribut" \
  "## Deskripsi
Tampilkan data spasial pada peta Leaflet di halaman detail posting, termasuk kontrol layer dan popup properti feature.

## Acceptance Criteria
- [ ] Peta Leaflet tampil di detail posting.
- [ ] Daftar layer per posting dapat dipilih/aktif-nonaktif.
- [ ] Feature GeoJSON layer ditampilkan dengan style dasar.
- [ ] Popup atribut tampil saat feature diklik.
- [ ] Peta auto fit bounds sesuai layer aktif.

## Dependencies
- #8 Implementasi Feed Posting
- #6 API Feature GeoJSON" \
  "--label frontend --label gis --label api --label mvp"

# Issue 10 - Security Hardening
create_issue \
  "[MVP][Security][Backend][API][Auth] Hardening Keamanan API dan Validasi Upload" \
  "## Deskripsi
Tambahkan baseline keamanan operasional agar platform publik aman untuk MVP release awal.

## Acceptance Criteria
- [ ] Validasi extension dan MIME untuk upload GeoJSON/KML diterapkan.
- [ ] Batas ukuran upload diterapkan di backend.
- [ ] Throttling endpoint auth dan upload diterapkan.
- [ ] Object-level permission owner/admin diterapkan konsisten.
- [ ] CORS whitelist dan security setting berbasis environment diterapkan.
- [ ] Checklist verifikasi keamanan MVP terdokumentasi.

## Dependencies
- #3 Implementasi Register, Login JWT
- #5 Pipeline Upload GeoJSON/KML
- #6 API Posting Publik" \
  "--label security --label backend --label api --label auth --label mvp"

# Issue 11 - CI/CD DevOps
create_issue \
  "[MVP][DevOps] CI Pipeline, Build Check, dan Packaging Deployment Docker" \
  "## Deskripsi
Siapkan quality gate minimum agar perubahan kode tervalidasi otomatis sebelum rilis.

## Acceptance Criteria
- [ ] GitHub Actions menjalankan test backend dan build frontend.
- [ ] Lint/check dasar berjalan di pipeline.
- [ ] Build image docker backend dan frontend tervalidasi.
- [ ] Pipeline gagal jika test/build gagal.
- [ ] Panduan variabel environment deployment terdokumentasi singkat.

## Dependencies
- #6 API Posting Publik
- #9 React-Leaflet Integration
- #10 Security Hardening" \
  "--label devops --label backend --label frontend --label mvp"

# Issue 12 - Documentation
create_issue \
  "[MVP][Docs] Dokumentasi Setup, Arsitektur, API, dan Panduan Pengguna" \
  "## Deskripsi
Lengkapi dokumentasi teknis dan pengguna agar MVP bisa dioperasikan developer dan dipakai user awal.

## Acceptance Criteria
- [ ] Dokumentasi setup local dengan Docker Compose tersedia.
- [ ] Ringkasan arsitektur backend-frontend-database tersedia.
- [ ] Daftar endpoint API utama dan contoh request respons tersedia.
- [ ] Panduan user untuk register, posting, upload, lihat peta, download tersedia.
- [ ] Catatan perilaku upload multilayer GeoJSON/KML dijelaskan jelas.

## Dependencies
- Semua issue teknis MVP sebelumnya" \
  "--label docs --label api --label gis --label devops --label mvp"

echo ""
echo "✅ Semua 12 MVP issues berhasil dibuat!"
echo ""
echo "📋 Cek status dengan: gh issue list -L 50"
