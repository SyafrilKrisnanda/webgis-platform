#!/bin/bash

# Issue 1
gh issue create \
  --title "[MVP][DevOps] Inisialisasi Struktur Proyek dan Docker Compose Dasar" \
  --body "## Deskripsi
Siapkan fondasi repository untuk backend, frontend, dan database PostGIS agar seluruh tim bisa menjalankan proyek secara konsisten di local environment.

## Acceptance Criteria
- [ ] Struktur direktori dasar backend dan frontend tersedia.
- [ ] Docker Compose menjalankan service postgres+postgis, backend, frontend.
- [ ] Healthcheck database dan backend tersedia.
- [ ] File environment contoh disediakan untuk local development.
- [ ] Perintah satu langkah untuk start stack terdokumentasi.

## Dependencies
- Tidak ada" \
  --label devops --label mvp

# Issue 2
gh issue create \
  --title "[MVP][Backend][API][GIS] Bootstrap Django, DRF, GeoDjango, dan Konfigurasi PostGIS" \
  --body "## Deskripsi
Inisialisasi project Django sebagai fondasi API dengan DRF dan GeoDjango yang terhubung ke PostGIS.

## Acceptance Criteria
- [ ] Project Django dan app inti terbentuk.
- [ ] DRF aktif dengan konfigurasi global pagination dan error format dasar.
- [ ] GeoDjango terhubung ke PostGIS tanpa error migration.
- [ ] Endpoint health API tersedia.
- [ ] CORS dasar untuk frontend local development sudah aktif.

## Dependencies
- [ ] #1 [MVP][DevOps] Inisialisasi Struktur Proyek dan Docker Compose Dasar" \
  --label backend --label api --label gis --label mvp

# Issue 3
gh issue create \
  --title "[MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User" \
  --body "## Deskripsi
Bangun modul autentikasi publik agar user dapat mendaftar, login, dan mengakses endpoint terlindungi.

## Acceptance Criteria
- [ ] Endpoint register user berfungsi.
- [ ] Endpoint login JWT dan refresh token berfungsi.
- [ ] Endpoint profil user saat ini tersedia untuk user login.
- [ ] Endpoint yang perlu auth menolak request tanpa token valid.
- [ ] Test minimal untuk alur register dan login tersedia.

## Dependencies
- [ ] #2 [MVP][Backend][API][GIS] Bootstrap Django, DRF, GeoDjango, dan Konfigurasi PostGIS" \
  --label backend --label auth --label api --label security --label mvp

# Issue 4
gh issue create \
  --title "[MVP][Backend][GIS] Desain dan Implementasi Model Post, Dataset, Layer, dan Feature" \
  --body "## Deskripsi
Buat model data inti WebGIS agar posting, dataset, layer, dan feature tersimpan terstruktur di PostGIS.

## Acceptance Criteria
- [ ] Model Post, Dataset, Layer, Feature dibuat sesuai relasi.
- [ ] Geometry disimpan pada kolom spasial PostGIS dan properties pada JSON.
- [ ] Normalisasi SRID target ke EPSG:4326 ditetapkan di level model/service.
- [ ] Migration sukses dan dapat dijalankan ulang di environment baru.
- [ ] Admin view dasar untuk inspeksi data tersedia.

## Dependencies
- [ ] #2 [MVP][Backend][API][GIS] Bootstrap Django, DRF, GeoDjango, dan Konfigurasi PostGIS" \
  --label backend --label gis --label mvp

# Issue 5
gh issue create \
  --title "[MVP][Backend][GIS][API] Pipeline Upload GeoJSON/KML dengan Parsing Multi-Layer dan Split Layer" \
  --body "## Deskripsi
Bangun service upload yang menerima GeoJSON/KML, membaca semua layer dalam file, lalu menyimpan tiap layer secara terpisah beserta fiturnya.

## Acceptance Criteria
- [ ] Endpoint upload multipart menerima file GeoJSON dan KML.
- [ ] File multilayer terdeteksi dan dipecah menjadi beberapa entitas Layer.
- [ ] Seluruh feature per layer tersimpan dengan geometri valid.
- [ ] Jika parsing gagal di tengah proses, transaksi rollback total.
- [ ] Respons upload mengembalikan ringkasan layer_count dan feature_count.
- [ ] Test untuk skenario GeoJSON dan KML multilayer tersedia.

## Dependencies
- [ ] #3 [MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User
- [ ] #4 [MVP][Backend][GIS] Desain dan Implementasi Model Post, Dataset, Layer, dan Feature" \
  --label backend --label gis --label api --label mvp

# Issue 6
gh issue create \
  --title "[MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset" \
  --body "## Deskripsi
Sediakan endpoint publik dan terautentikasi untuk feed posting, detail posting, akses layer, dan download data.

## Acceptance Criteria
- [ ] Endpoint list dan detail posting publik tersedia dengan pagination.
- [ ] Endpoint create/update/delete posting tersedia untuk owner/admin.
- [ ] Endpoint list layer per posting tersedia.
- [ ] Endpoint feature layer mengembalikan GeoJSON valid.
- [ ] Endpoint download file asli dataset tersedia.
- [ ] Endpoint download layer sebagai GeoJSON tersedia.

## Dependencies
- [ ] #3 [MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User
- [ ] #5 [MVP][Backend][GIS][API] Pipeline Upload GeoJSON/KML dengan Parsing Multi-Layer dan Split Layer" \
  --label backend --label api --label gis --label mvp

# Issue 7
gh issue create \
  --title "[MVP][Frontend][Auth] Bootstrap React App, Routing, API Client, dan State Autentikasi" \
  --body "## Deskripsi
Bangun pondasi frontend React untuk mendukung alur login dan konsumsi API backend.

## Acceptance Criteria
- [ ] Struktur app React dan routing halaman utama tersedia.
- [ ] API client terstandar untuk request ke backend tersedia.
- [ ] State autentikasi login/logout tersimpan dan dipakai route guard.
- [ ] Halaman register dan login terhubung ke API auth.
- [ ] Tampilan responsif dasar untuk desktop dan mobile tersedia.

## Dependencies
- [ ] #1 [MVP][DevOps] Inisialisasi Struktur Proyek dan Docker Compose Dasar
- [ ] #3 [MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User" \
  --label frontend --label auth --label mvp

# Issue 8
gh issue create \
  --title "[MVP][Frontend][API] Implementasi Feed Posting, Form Buat Posting, dan Upload Dataset" \
  --body "## Deskripsi
Implementasi alur user frontend untuk melihat feed posting, membuat posting baru, dan upload dataset GeoJSON/KML.

## Acceptance Criteria
- [ ] Halaman feed menampilkan daftar posting publik dengan pagination.
- [ ] Halaman/detail posting menampilkan metadata utama dataset.
- [ ] Form buat posting mendukung upload file dataset.
- [ ] Error dan status sukses upload ditampilkan jelas.
- [ ] Tombol download dataset pada detail posting berfungsi.

## Dependencies
- [ ] #7 [MVP][Frontend][Auth] Bootstrap React App, Routing, API Client, dan State Autentikasi
- [ ] #6 [MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset" \
  --label frontend --label api --label mvp

# Issue 9
gh issue create \
  --title "[MVP][Frontend][GIS][API] Integrasi React-Leaflet untuk Viewer Layer dan Popup Atribut" \
  --body "## Deskripsi
Tampilkan data spasial pada peta Leaflet di halaman detail posting, termasuk kontrol layer dan popup properti feature.

## Acceptance Criteria
- [ ] Peta Leaflet tampil di detail posting.
- [ ] Daftar layer per posting dapat dipilih/aktif-nonaktif.
- [ ] Feature GeoJSON layer ditampilkan dengan style dasar.
- [ ] Popup atribut tampil saat feature diklik.
- [ ] Peta auto fit bounds sesuai layer aktif.

## Dependencies
- [ ] #8 [MVP][Frontend][API] Implementasi Feed Posting, Form Buat Posting, dan Upload Dataset
- [ ] #6 [MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset" \
  --label frontend --label gis --label api --label mvp

# Issue 10
gh issue create \
  --title "[MVP][Security][Backend][API][Auth] Hardening Keamanan API dan Validasi Upload" \
  --body "## Deskripsi
Tambahkan baseline keamanan operasional agar platform publik aman untuk MVP release awal.

## Acceptance Criteria
- [ ] Validasi extension dan MIME untuk upload GeoJSON/KML diterapkan.
- [ ] Batas ukuran upload diterapkan di backend.
- [ ] Throttling endpoint auth dan upload diterapkan.
- [ ] Object-level permission owner/admin diterapkan konsisten.
- [ ] CORS whitelist dan security setting berbasis environment diterapkan.
- [ ] Checklist verifikasi keamanan MVP terdokumentasi.

## Dependencies
- [ ] #3 [MVP][Auth][API][Security] Implementasi Register, Login JWT, Refresh Token, dan Profil User
- [ ] #5 [MVP][Backend][GIS][API] Pipeline Upload GeoJSON/KML dengan Parsing Multi-Layer dan Split Layer
- [ ] #6 [MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset" \
  --label security --label backend --label api --label auth --label mvp

# Issue 11
gh issue create \
  --title "[MVP][DevOps] CI Pipeline, Build Check, dan Packaging Deployment Docker" \
  --body "## Deskripsi
Siapkan quality gate minimum agar perubahan kode tervalidasi otomatis sebelum rilis.

## Acceptance Criteria
- [ ] GitHub Actions menjalankan test backend dan build frontend.
- [ ] Lint/check dasar berjalan di pipeline.
- [ ] Build image docker backend dan frontend tervalidasi.
- [ ] Pipeline gagal jika test/build gagal.
- [ ] Panduan variabel environment deployment terdokumentasi singkat.

## Dependencies
- [ ] #6 [MVP][Backend][API][GIS] API Posting Publik, Detail Layer, Feature GeoJSON, dan Download Dataset
- [ ] #9 [MVP][Frontend][GIS][API] Integrasi React-Leaflet untuk Viewer Layer dan Popup Atribut
- [ ] #10 [MVP][Security][Backend][API][Auth] Hardening Keamanan API dan Validasi Upload" \
  --label devops --label backend --label frontend --label mvp

# Issue 12
gh issue create \
  --title "[MVP][Docs] Dokumentasi Setup, Arsitektur, API, dan Panduan Pengguna" \
  --body "## Deskripsi
Lengkapi dokumentasi teknis dan pengguna agar MVP bisa dioperasikan developer dan dipakai user awal.

## Acceptance Criteria
- [ ] Dokumentasi setup local dengan Docker Compose tersedia.
- [ ] Ringkasan arsitektur backend-frontend-database tersedia.
- [ ] Daftar endpoint API utama dan contoh request respons tersedia.
- [ ] Panduan user untuk register, posting, upload, lihat peta, download tersedia.
- [ ] Catatan perilaku upload multilayer GeoJSON/KML dijelaskan jelas.

## Dependencies
- [ ] Seluruh issue MVP teknis sebelumnya selesai" \
  --label docs --label api --label gis --label devops --label mvp

echo "✅ Semua 12 MVP issues berhasil dibuat!"
