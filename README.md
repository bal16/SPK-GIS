# SPK-GIS — Sistem Pendukung Keputusan Prioritas Pemeliharaan Gedung

[![Next.js](https://img.shields.io/badge/Next.js-16-000000?logo=nextdotjs&logoColor=white)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=black)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com/)
[![NestJS](https://img.shields.io/badge/NestJS-11-E0234E?logo=nestjs&logoColor=white)](https://nestjs.com/)
[![Prisma](https://img.shields.io/badge/Prisma-7-2D3748?logo=prisma&logoColor=white)](https://www.prisma.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![MapLibre](https://img.shields.io/badge/MapLibre_GL-295DAA?logo=maplibre&logoColor=white)](https://maplibre.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Podman](https://img.shields.io/badge/Podman-Compose-892CA0?logo=podman&logoColor=white)](https://podman.io/)

SPK-GIS adalah aplikasi berbasis peta yang membantu pengelola aset menentukan **gedung mana yang perlu dipelihara lebih dulu**. Penilaian dilakukan secara otomatis memakai metode **SAW (Simple Additive Weighting)**, lalu hasilnya ditampilkan dalam bentuk peringkat dan sebaran lokasi gedung di peta.

Dengan aplikasi ini, keputusan pemeliharaan tidak lagi bergantung pada perkiraan, tetapi pada data penilaian yang terukur dan dapat dipertanggungjawabkan.

---

## Mengapa aplikasi ini dibuat

Mengelola banyak gedung dengan anggaran terbatas membuat prioritas menjadi hal yang sulit. SPK-GIS menjawab pertanyaan sederhana:

> "Gedung mana yang paling mendesak untuk diperbaiki, dan mengapa?"

Setiap gedung dinilai dari beberapa aspek (usia, struktur, arsitektur, MEP, utilitas, dan tingkat kerusakan). Sistem menggabungkan nilai tersebut dengan bobot yang bisa diatur, lalu menghasilkan skor dan peringkat yang mudah dipahami.

---

## Fitur Utama

### 🗺️ Peta Interaktif
- Menampilkan seluruh gedung pada peta dengan penanda berwarna sesuai tingkat prioritas.
- Klik penanda untuk melihat ringkasan kondisi gedung.
- Daftar prioritas dapat dicari dan difilter, baik di desktop maupun mobile.

### 🏢 Manajemen Gedung
- Menambah, mengubah, dan menghapus data gedung.
- Setiap gedung menyimpan kode, nama, serta titik koordinat.

### 📝 Penilaian Kondisi
- Formulir penilaian per gedung dengan validasi input.
- Riwayat penilaian tersimpan, sehingga perubahan kondisi gedung dapat dilacak.

### ⚙️ Pengaturan Bobot Kriteria
- Bobot tiap kriteria dapat disesuaikan oleh admin.
- Mendukung bobot bertingkat (kriteria utama dan sub-kriteria).

### 📊 Perhitungan & Riwayat Keputusan
- Jalankan perhitungan prioritas kapan saja dengan satu tombol.
- Setiap perhitungan disimpan sebagai *snapshot*, lengkap dengan bobot yang dipakai saat itu.
- Hasil lama dapat dibuka kembali sebagai laporan, sehingga keputusan tetap dapat diaudit.

### 🔐 Area Admin
- Halaman publik untuk melihat peta dan peringkat.
- Area admin yang dilindungi login untuk mengelola data, bobot, dan perhitungan.

### 🧭 Tur Interaktif
- Panduan singkat saat pertama kali masuk ke dashboard admin.
- Membantu pengguna baru memahami alur kerja aplikasi tanpa harus membaca dokumentasi teknis.

---

## Cara Kerja Singkat

1. **Data gedung dimasukkan** beserta lokasinya di peta.
2. **Setiap gedung dinilai** pada aspek-aspek yang telah ditentukan.
3. **Admin mengatur bobot** sesuai prioritas organisasi.
4. **Sistem menghitung skor** dengan metode SAW dan mengurutkannya.
5. **Hasil ditampilkan di peta** dalam bentuk peringkat prioritas.
6. **Hasil disimpan** sebagai riwayat untuk evaluasi di kemudian hari.

---

## Teknologi yang Digunakan

| Bagian | Teknologi |
| --- | --- |
| Tampilan (Frontend) | Next.js 16, React 19, TypeScript, Tailwind CSS 4 |
| Komponen UI | shadcn/ui, Radix UI, Lucide Icons |
| Peta | MapLibre GL, react-map-gl |
| Data & Formulir | TanStack Query, TanStack Table, React Hook Form, Zod, Zustand |
| Grafik | Recharts |
| Tur & Dokumentasi | Driver.js, Scalar (OpenAPI) |
| Layanan (Backend) | NestJS 11, TypeScript |
| Basis Data | PostgreSQL 16, Prisma 7 |
| Keamanan | JWT, bcrypt |
| Lainnya | Docker Compose, Podman Compose, Pino (logging), Jest (pengujian) |

---

## Struktur Proyek

```
SPK-GIS/
├── frontend/          # Aplikasi web: peta, dashboard, dan area admin
├── backend/           # Layanan API: autentikasi, data gedung, dan mesin SAW
├── docker/            # Dockerfile backend & frontend
├── compose.dev.yml    # Stack development (hot reload)
└── compose.prod.yml   # Stack production
```

Kedua folder dikelola sebagai **git submodule** dan memiliki dokumentasi teknisnya masing-masing:

- Frontend: [`frontend/README.md`](frontend/README.md)
- Backend: [`backend/README.md`](backend/README.md)
- API & spesifikasi: [`backend/docs/API Reference.md`](backend/docs/API%20Reference.md) dan [`backend/docs/OpenApi.yaml`](backend/docs/OpenApi.yaml)
- Dokumentasi API interaktif (saat mode development): **http://localhost:3001/api/docs**

> Jika repositori sudah pernah di-clone, sinkronkan submodule dengan:
> `git submodule update --init --recursive`

---

## Menjalankan Aplikasi

Tersedia dua cara: memakai container (paling mudah) atau menjalankan langsung di komputer.

### Cara 1 — Docker / Podman (disarankan)

**Persiapan**

```bash
# Ambil proyek beserta submodule-nya
git clone --recursive https://github.com/bal16/SPK-GIS.git
cd SPK-GIS

# Siapkan konfigurasi
cp .env.example .env
# ubah password database dan kunci rahasia di file .env
```

**Mode development (hot reload aktif)**

```bash
# Docker
docker compose -f compose.dev.yml up --build

# Podman
podman-compose -f compose.dev.yml up --build
```

Perubahan pada `frontend/` dan `backend/` langsung terlihat tanpa restart container:

- **Frontend** — Next.js dev server dengan hot reload.
- **Backend** — NestJS watch mode, otomatis restart saat kode berubah.

> Migrasi database dijalankan otomatis saat backend start. Database awalnya kosong;
> isi data contoh satu kali dengan:
> `docker compose -f compose.dev.yml exec backend pnpm db:seed`
> (ganti dengan `podman-compose` jika memakai Podman).

**Mode production**

```bash
# Docker
docker compose -f compose.prod.yml up -d --build

# Podman
podman-compose -f compose.prod.yml up -d --build
```

Setelah berjalan, buka **http://localhost:3000** di browser. API berjalan di **http://localhost:3001**.

> Migrasi database dijalankan otomatis saat backend production start. Untuk mengisi data awal:
> `docker compose -f compose.prod.yml exec backend ./node_modules/.bin/prisma db seed`
>
> Jika memakai Podman, ganti `docker compose` dengan `podman-compose`.

### Cara 2 — Menjalankan langsung

**Backend**

```bash
cd backend
cp .env.example .env          # sesuaikan DATABASE_URL
docker compose up -d          # menjalankan PostgreSQL

pnpm install
pnpm db:generate
pnpm db:migrate
pnpm db:seed                  # cukup sekali untuk data awal
pnpm start:dev                # http://localhost:3001
```

**Frontend** (terminal terpisah)

```bash
cd frontend
bun install

# buat file .env.local:
# NEST_API_URL=http://localhost:3001
# NEXT_PUBLIC_NEST_API_URL=http://localhost:3001

bun run dev                   # http://localhost:3000
```

> Catatan: backend memakai `.env`, frontend memakai `.env.local`. Jangan commit file tersebut.

---

## Peran Pengguna

| Peran | Dapat melakukan |
| --- | --- |
| **Pengunjung** | Melihat peta, peringkat, dan detail gedung |
| **Admin** | Mengelola gedung, penilaian, bobot kriteria, serta menjalankan perhitungan |

---

## Lisensi

Proyek ini dikembangkan untuk keperluan internal. Silakan hubungi pemilik repositori untuk informasi lebih lanjut.
