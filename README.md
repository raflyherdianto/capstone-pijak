<p align="center">
  <img src="pijak-logo.png" alt="Pijak Logo" width="400"/>
</p>

---

<p align="center">
  <img src="arjuna-logo.png" alt="ARJUNA Logo" width="200" style="border-radius: 50%;"/>
</p>

# 🏹 ARJUNA (Analisis Harga & Tinjauan Pangan Nusantara)

<p align="center">
  <img src="https://img.shields.io/badge/Version-V1.0-brightgreen?style=for-the-badge" alt="Version V1.0" />
  <img src="https://img.shields.io/badge/Status-Stable-brightgreen?style=for-the-badge" alt="Status Stable" />
</p>

ARJUNA adalah platform **Business Intelligence berbasis AI** yang dirancang untuk memperluas akses masyarakat terhadap informasi harga pangan di Indonesia. Platform ini menerjemahkan data teknis yang rumit dari **Pusat Informasi Harga Pangan Strategis (PIHPS)** menjadi visualisasi dashboard yang intuitif, membantu masyarakat umum, konsumen rumah tangga, dan pelaku usaha kecil (UMKM F&B) memantau serta memprediksi fluktuasi harga komoditas pangan secara akurat.

---

## 🔗 Tautan Cepat & Akses Proyek

Berikut adalah tautan penting untuk mengakses dan mengunduh komponen proyek ARJUNA:

*   **🌐 Akses Website**: [arjunapijak.web.id](https://arjunapijak.web.id/)
*   **📱 Unduh APK Mobile**: [Google Drive APK Rilis](https://drive.google.com/file/d/1AfCJkrZPf9cQtvdhoat2pau-lPcPGGjr/view)
*   **📂 Tautan Model AI/ML (`model_params.json`)**: [Google Drive Model Weights](https://drive.google.com/file/d/1tTfc6PNTzsujHYLr4SW8KkTIg4ZWOAO2/view?usp=sharing)
*   **📄 Panduan Pengguna**: [Google Drive Dokumen Panduan](https://drive.google.com/file/d/1H2X00HDgQ_gioOG8x0Lusd1R9QpR9GxD/view?usp=sharing)

---

## 📌 Ringkasan Proyek

### 1. Latar Belakang & Alasan Pemilihan Proyek
Volatilitas harga pangan sering kali menjadi beban ekonomi harian bagi masyarakat Indonesia, khususnya konsumen rumah tangga dan pelaku usaha kecil. Selama ini, informasi harga pangan dan alat analisis pendukungnya masih belum disajikan dalam bentuk yang mudah dipahami publik. ARJUNA hadir sebagai **"navigasi inflasi harian"** yang menerjemahkan data teknis menjadi informasi visual sederhana agar masyarakat dapat merencanakan belanja dan pengadaan bahan baku dengan lebih presisi.

### 2. Rumusan Masalah (Problem Statement)
Tingginya volatilitas harga pangan dan terbatasnya akses terhadap informasi pasar yang mudah dipahami membuat masyarakat kesulitan mengantisipasi fluktuasi harga secara mendadak. Belum adanya platform yang menyediakan data prediktif sederhana menyebabkan konsumen sering kali membeli bahan pokok pada harga puncak, yang dapat menurunkan daya beli masyarakat secara keseluruhan.

### 3. Pertanyaan Penelitian (Research Questions)
*   Bagaimana merancang dashboard berbasis data PIHPS yang intuitif, *mobile-first*, dan mudah dipahami oleh masyarakat dengan tingkat literasi data yang beragam?
*   Seberapa akurat model *Machine Learning* dalam memprediksi tren kenaikan atau penurunan harga komoditas pangan jangka pendek?
*   Sejauh mana prediksi harga yang transparan dapat membantu masyarakat merencanakan belanja dan membantu usaha kecil mengelola pengadaan bahan baku secara lebih efisien?

---

## 🚀 Fitur & Cakupan Proyek

### ✅ In-Scope (Cakupan Proyek)
*   **Aplikasi Lintas Platform:** Tersedia dalam versi Web dan Mobile sebagai pemandu harga pangan harian.
*   **Ekstraksi Otomatis:** Pipeline ETL yang secara berkala menarik data dari PIHPS Nasional.
*   **Prediksi AI/ML:** Pemrosesan forecasting harga menggunakan kecerdasan buatan berbasis cloud.
*   **Visualisasi UI/UX Sederhana:** Representasi visual dengan indikator yang mudah dimengerti (Naik / Turun / Stabil).

### ❌ Out-of-Scope (Di Luar Cakupan)
*   Transaksi e-commerce jual beli sembako.
*   Layanan pesan-antar bahan pangan.
*   Sistem pelaporan dan distribusi subsidi pemerintah.

---

## 🛠️ Arsitektur & Teknologi

ARJUNA dibangun menggunakan pendekatan arsitektur **microservices** yang scalable dan andal:

*   **Bahasa Pemrograman:** Python 3.12+ (Backend, Scraping, & ML)
*   **Framework Backend & AI:**
    *   **FastAPI:** Framework web berkinerja tinggi untuk API gateway.
    *   **SARIMAX (Statsmodels):** Model peramalan time-series (fine-tuned) untuk memprediksi harga pangan secara akurat.
    *   **Pandas & NumPy:** Library analisis data dan komputasi numerik.
*   **Integrasi AI Generatif:**
    *   **OpenAI API & Google Gemini API:** Untuk menyusun narasi analisis pasar secara otomatis menjadi wawasan yang mudah dicerna.
*   **Infrastruktur & Cloud:**
    *   **GCP/AWS/Virtual Private Server (VPS):** Untuk deployment 24/7.
    *   **Docker & Kubernetes:** Containerization untuk skalabilitas dan portabilitas.
    *   **CI/CD Pipeline:** Jalur integrasi dan pengantaran otomatis.
    *   **PostgreSQL / MySQL:** Database relasional penyimpan riwayat harga pangan.
*   **Antarmuka Pengguna (Frontend & Mobile):**
    *   **Web Dashboard:** Dashboard Business Intelligence responsif dengan pendekatan *mobile-first*.
    *   **Mobile App:** Aplikasi seluler (Android & iOS) berbasis *cross-platform* (Flutter / React Native).

---

## ⚙️ Petunjuk Setup Environment

### 1. Prasyarat Umum
Sebelum melakukan setup, pastikan sistem Anda telah terpasang:
- **Docker & Docker Compose** (Sangat direkomendasikan untuk Backend dan Frontend)
- **Node.js (v20+)** dan **npm** (opsional, jika ingin menjalankan frontend secara native)
- **Python (3.12+)** (opsional, jika ingin menjalankan backend/scraping secara native)
- **Flutter SDK (^3.10.7)** dan **Dart SDK** (untuk pengembangan aplikasi Mobile)

### 2. Pengaturan Jaringan Docker
Buatlah shared-network di Docker agar kontainer frontend, backend, dan database dapat terhubung secara lancar:
```bash
docker network create shared-network
```

### 3. Setup Backend (FastAPI & PostgreSQL)
1. Buka folder `backend/`.
2. Salin berkas `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```
3. Sesuaikan konfigurasi di `.env` (misalnya masukkan `NVIDIA_API_KEY` untuk menyalakan fitur AI Insight).

### 4. Setup Model AI/ML (model_params.json)
1. Unduh berkas parameter model `model_params.json` dari [Tautan Unduh Model](https://drive.google.com/file/d/1tTfc6PNTzsujHYLr4SW8KkTIg4ZWOAO2/view?usp=sharing).
2. Tempatkan berkas tersebut langsung ke dalam direktori dataset backend:
   `backend/dataset/model_params.json`
3. Saat aplikasi backend dijalankan, modul `ForecastCache` dan `ModelParamsCache` secara otomatis memuat (load) parameter hasil fine-tuning model SARIMAX ini untuk kalkulasi prediksi.

### 5. Setup Frontend (Vue 3, Vite & Tailwind)
1. Buka folder `frontend/`.
2. Opsional: buat berkas `.env` jika URL API backend Anda berbeda dari default (`http://localhost:8000`):
   ```env
   VITE_API_URL=http://localhost:8000
   ```

### 6. Setup Mobile App (Flutter)
1. Buka folder `mobile/`.
2. Ambil dan pasang seluruh dependensi proyek Flutter:
   ```bash
   flutter pub get
   ```
3. Sesuaikan alamat IP backend Anda pada berkas `lib/core/api_config.dart`:
   ```dart
   static const String baseUrl = 'http://127.0.0.1:8000'; // Sesuaikan IP mesin jika menggunakan perangkat fisik
   ```

---

## 🏃 Cara Menjalankan Aplikasi

### 1. Menjalankan Backend (FastAPI + PostgreSQL via Docker)
1. Masuk ke direktori `backend/`.
2. Jalankan perintah Docker Compose untuk membangun dan menghidupkan kontainer database & API:
   ```bash
   docker compose up -d --build
   ```
3. Lakukan seeding data historis awal dari dataset ke database PostgreSQL:
   ```bash
   docker compose exec api python seeder.py
   ```
4. API Swagger Docs dapat diakses secara lokal di: `http://localhost:8000/docs`.

### 2. Menjalankan Frontend (Vue 3 + Vite via Docker)
1. Masuk ke direktori `frontend/`.
2. Jalankan perintah Docker Compose:
   ```bash
   docker compose up -d --build
   ```
3. Dashboard web dapat diakses secara lokal di browser melalui: `http://localhost:5173`.

### 3. Menjalankan Mobile App (Flutter)
1. Masuk ke direktori `mobile/`.
2. Siapkan emulator atau hubungkan perangkat Android/iOS fisik Anda.
3. Buat berkas `secrets.json` di root direktori `mobile/` untuk konfigurasi kunci GNews API:
   ```json
   {
     "GNEWS_API_KEY": "kunci_api_gnews_anda"
   }
   ```
4. Jalankan aplikasi dengan perintah:
   ```bash
   flutter run --dart-define-from-file=secrets.json
   ```

---

## 📸 Tangkapan Layar Aplikasi (Screenshots)

Berikut adalah beberapa hasil tangkapan layar antarmuka dari platform ARJUNA:

### 🖥️ Versi Website (Desktop Dashboard)
Tersedia secara online pada [arjunapijak.web.id](https://arjunapijak.web.id/)

<table>
  <tr>
    <td align="center"><img src="screenshots/website/dashboard-screenshot.png" width="400"/><br/><sub>Dasbor Utama & Simulasi Peramalan</sub></td>
    <td align="center"><img src="screenshots/website/ai-insight-screenshot.png" width="400"/><br/><sub>AI Insight (Rekomendasi Pintar)</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/website/overview-screenshot.png" width="400"/><br/><sub>Ringkasan Pasar (Overview)</sub></td>
    <td align="center"><img src="screenshots/website/history-screenshot.png" width="400"/><br/><sub>Riwayat & Audit Model SARIMAX</sub></td>
  </tr>
</table>

### 📱 Versi Mobile App (Flutter)
Unduh APK rilis langsung dari [Tautan APK Mobile](https://drive.google.com/file/d/1AfCJkrZPf9cQtvdhoat2pau-lPcPGGjr/view)

<table>
  <tr>
    <td align="center"><img src="screenshots/mobile/arjuna-splashscreen.png" width="180"/><br/><sub>Splash Screen</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-onboarding1.png" width="180"/><br/><sub>Onboarding 1</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-onboarding2.png" width="180"/><br/><sub>Onboarding 2</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-onboarding3.png" width="180"/><br/><sub>Onboarding 3</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/mobile/arjuna-beranda.png" width="180"/><br/><sub>Beranda (Light Mode)</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-berandadark.png" width="180"/><br/><sub>Beranda (Dark Mode)</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-komoditas.png" width="180"/><br/><sub>Kategori Komoditas</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-details-aithinking.png" width="180"/><br/><sub>Grafik & Prediksi</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/mobile/arjuna-details-aimasyarakat.png" width="180"/><br/><sub>AI Insight Masyarakat</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-details-aipedagang.png" width="180"/><br/><sub>AI Insight Pedagang</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-details-aiaudit.png" width="180"/><br/><sub>Audit Model SARIMAX</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-insightglobal.png" width="180"/><br/><sub>Insight Global & Maskot</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/mobile/arjuna-news.png" width="180"/><br/><sub>Arjuna News</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-settings.png" width="180"/><br/><sub>Pengaturan (Light Mode)</sub></td>
    <td align="center"><img src="screenshots/mobile/arjuna-settingsdark.png" width="180"/><br/><sub>Pengaturan (Dark Mode)</sub></td>
    <td align="center"> - </td>
  </tr>
</table>

---

## 🗓️ Jadwal Pelaksanaan & Milestone

Proyek ini dilaksanakan selama 5 minggu (11 Mei – 14 Juni 2026):

*   **Minggu 1: Arsitektur Sistem, Desain, & Persiapan Data (11 – 17 Mei 2026)**
    *   *Milestone 1:* Infrastruktur dasar siap, desain UI/UX disetujui, dan data historis terkumpul.
*   **Minggu 2: Pengembangan API & Model Prediktif AI (18 – 24 Mei 2026)**
    *   *Milestone 2:* API prediksi AI aktif dan mulai mengirimkan output data JSON secara lokal.
*   **Minggu 3: Pengembangan Antarmuka Web & Mobile (25 – 31 Mei 2026)**
    *   *Milestone 3:* Prototipe interaktif Web dan Mobile terhubung dengan data riil dari Backend.
*   **Minggu 4: Integrasi Penuh & Internal System Testing (1 – 7 Juni 2026)**
    *   *Milestone 4:* Aplikasi ARJUNA versi Beta berfungsi penuh tanpa *critical error*.
*   **Minggu 5: UAT, Optimasi Server, & Rilis Final (8 – 14 Juni 2026)**
    *   *Milestone 5:* Proyek selesai, ARJUNA versi stabil live di Web Server dan Mobile Store.

---

## 👥 Tim Capstone (PJK-GU106)

Kolaborasi tim pengembang dalam program Pijak x IBM SkillsBuild:

| No | Nama | Cohort ID | Peran / Learning Path | Email |
| :---: | :--- | :---: | :--- | :--- |
| 1 | **Wilda Ariffatul Faisalnur** | APQ000D6Y0561 | Cloud Engineer & DevOps (Cloud Computing) | APQ000D6Y0561@student.devacademy.id |
| 2 | **Mochammad Rafly Herdianto** | APQ000D6Y0567 | Backend & AI Integration Developer (Back-End Development) | APQ000D6Y0567@student.devacademy.id |
| 3 | **Baso Rizky Hamdana** | APQ000D6Y0574 | Mobile Application Developer (Mobile Development) | APQ000D6Y0574@student.devacademy.id |
| 4 | **Neor Wildan** | APQ000D6Y0633 | Web Developer & UI/UX Designer (Front-End Development) | APQ000D6Y0633@student.devacademy.id |

### 📋 Uraian Peran & Tanggung Jawab

*   **Wilda Ariffatul Faisalnur**
    *   Merancang dan mengelola infrastruktur server di Google Cloud Platform (GCP).
    *   Mengatur containerization menggunakan Docker/Kubernetes dan jalur CI/CD agar pembaruan kode terunggah otomatis dan aman.
*   **Mochammad Rafly Herdianto**
    *   Membangun logika bisnis server dan database PostgreSQL/MySQL penyimpan riwayat harga.
    *   Membuat pipeline ETL otomatis dari PIHPS dan membungkus model prediksi AI ke dalam RESTful API.
*   **Baso Rizky Hamdana**
    *   Membangun aplikasi client-side Android & iOS dengan framework cross-platform.
    *   Mengembangkan notifikasi lonjakan harga real-time dan integrasi lokasi pasar terdekat.
*   **Neor Wildan**
    *   Mengembangkan dashboard web responsif mobile-first.
    *   Menampilkan grafik tren interaktif dan peta persebaran harga pangan untuk kemudahan literasi pengguna.

---

## 🌿 Commit & Branch Tracking

Berikut adalah status commit terakhir dan tautan riwayat untuk masing-masing branch pengembangan:

| Nama Branch | Status Commit Terakhir (Shields.io) | Tautan Riwayat |
| :--- | :--- | :--- |
| **`main`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/main?style=flat-square&logo=github&label=main)](https://github.com/raflyherdianto/capstone-pijak/commits/main) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/main) |
| **`dev`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/dev?style=flat-square&logo=github&label=dev)](https://github.com/raflyherdianto/capstone-pijak/commits/dev) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/dev) |
| **`rafly`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/rafly?style=flat-square&logo=github&label=rafly)](https://github.com/raflyherdianto/capstone-pijak/commits/rafly) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/rafly) |
| **`wilda`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/wilda?style=flat-square&logo=github&label=wilda)](https://github.com/raflyherdianto/capstone-pijak/commits/wilda) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/wilda) |
| **`wildan`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/wildan?style=flat-square&logo=github&label=wildan)](https://github.com/raflyherdianto/capstone-pijak/commits/wildan) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/wildan) |
| **`rizky`** | [![Last Commit](https://img.shields.io/github/last-commit/raflyherdianto/capstone-pijak/rizky?style=flat-square&logo=github&label=rizky)](https://github.com/raflyherdianto/capstone-pijak/commits/rizky) | [Lihat Komit](https://github.com/raflyherdianto/capstone-pijak/commits/rizky) |

