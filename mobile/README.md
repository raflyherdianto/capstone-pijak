# Arjuna Mobile 🌾📈

<p align="center">
  <img src="assets/images/app_logo.png" width="160" alt="Arjuna Mobile Logo">
</p>

**Arjuna Mobile** adalah aplikasi *mobile* cerdas yang dirancang untuk memantau dan memprediksi pergerakan harga komoditas pangan pokok di Indonesia. Dibangun dengan teknologi mutakhir untuk memberikan wawasan pasar yang akurat, analisis model yang transparan, dan wawasan personal bagi konsumen maupun pelaku usaha pangan.

---

## ✨ Fitur Unggulan

- **📊 Prediksi Harga AI**: Visualisasi tren harga 7 hari ke depan menggunakan model peramalan *time-series* hibrida yang canggih.
- **🔄 Mode Perspektif Cerdas**: 
  - 🛒 **Mode Pembeli**: Fokus pada penghematan—kenaikan harga ditandai sebagai peringatan (**Merah**).
  - 🏪 **Mode Pedagang**: Fokus pada profit—kenaikan harga ditandai sebagai peluang (**Hijau**).
- **🔍 Audit Akurasi Model**: Akses langsung ke metrik evaluasi model prediksi (MAE, MAPE, RMSE) demi transparansi kualitas peramalan AI.
- **📰 Berita & Analisis Pasar**: Umpan berita terintegrasi terkait harga komoditas, inflasi, dan ketahanan pangan nasional.
- **💾 Pengaturan Persisten**: Aplikasi mengingat preferensi Anda (Mode Perspektif & Tema) secara lokal meskipun aplikasi ditutup.
- **🚀 Splash & Onboarding**: Pengalaman navigasi yang halus dimulai dari animasi logo minimalis hingga panduan pengenalan fitur interaktif.
- **📈 Insight Global AI**: Analisis otomatis mengenai kondisi pasar nasional untuk membantu pengambilan keputusan yang tepat bagi pemangku kepentingan.
- **🌓 Tema Dinamis**: Dukungan penuh untuk *Dark Mode* dan *Light Mode* dengan sistem warna yang dirancang secara profesional.
- **🛡️ Manajemen Data Tangguh**: Sinkronisasi API yang efisien dengan penanganan kondisi *offline* yang informatif serta *shimmer load* yang responsif.

---

## 🛠️ Teknologi yang Digunakan

### Frontend (Mobile)
- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev/) (Core dependency injection & global states) & [Flutter BLoC/Cubit](https://pub.dev/packages/flutter_bloc) (Screen-specific interactive states)
- **Persistence**: `shared_preferences`
- **Networking**: `dio` (dengan penanganan error & interseptor kustom)
- **Charting**: `fl_chart`
- **Design System**: Font kustom *Outfit*, skema warna harmoni dengan dukungan penuh dark/light mode.

### Backend (AI Engine & API)
- **API Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Python)
- **AI/ML**: Model peramalan *Quad-Hybrid* untuk akurasi prediksi maksimal.

---

## 🚀 Memulai Penggunaan

### 1. Prasyarat
- Flutter SDK (^3.10.7)
- Dart SDK
- Perangkat Android/iOS atau Emulator/Simulator.

### 2. Persiapan Proyek
```bash
# Clone repository
git clone https://github.com/username-anda/arjuna-mobile.git

# Masuk ke direktori mobile
cd arjuna_mobile

# Ambil dependensi
flutter pub get
```

### 3. Konfigurasi API
Ubah `baseUrl` di `lib/core/api_config.dart` sesuai dengan lokasi server backend Anda.
```dart
static const String baseUrl = 'http://127.0.0.1:8000'; // Sesuaikan IP jika menggunakan device fisik
```

### 4. Menjalankan Aplikasi
```bash
flutter run
```

---

## 📂 Struktur Proyek

Proyek ini menerapkan pendekatan **Clean Architecture** dengan struktur folder berbasis fitur (feature-first) untuk modularitas dan kemudahan pemeliharaan:

```text
lib/
├── core/
│   ├── api_client.dart       # API client dengan dio dan interceptors
│   ├── api_config.dart       # Konfigurasi basis endpoint
│   ├── providers.dart        # Riverpod providers untuk core dependencies
│   └── theme.dart            # Sistem desain (Colors, Typography, Dark & Light themes)
├── features/
│   ├── splash/               # Splash screen dengan animasi masuk
│   ├── onboarding/           # Pengenalan fitur aplikasi bagi pengguna baru
│   ├── dashboard/            # Dashboard utama dengan ringkasan pergerakan pasar & berita
│   ├── home/                 # Daftar komoditas pangan pokok
│   ├── detail/               # Visualisasi prediksi harga, grafik, & mode perspektif cerdas
│   │   └── presentation/cubit/ # Flutter BLoC (Cubit) untuk manajemen state detail & audit
│   ├── insight/              # Halaman wawasan AI global mengenai ketahanan pangan
│   └── settings/             # Personalisasi tema, mode perspektif, & informasi aplikasi
├── shared/
│   ├── data/                 # Repository data bersama (CommodityRepository)
│   ├── domain/               # Model data entitas (Commodity, Price, dll)
│   └── widgets/              # Widget umum (ErrorState, ArjunaBrand, ShimmerPlaceholder)
└── main.dart                 # Titik masuk utama aplikasi & inisialisasi state
```

---

## 🤝 Kontribusi
Aplikasi ini bersifat terbuka untuk pengembangan lebih lanjut. Jika Anda menemukan *bug* atau memiliki ide fitur baru, silakan ajukan melalui *Issue* atau *Pull Request*.

---
*Membangun ketahanan pangan melalui inovasi kecerdasan buatan.*
