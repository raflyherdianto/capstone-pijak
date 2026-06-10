# Komoditas-AI 🌾📈

<p align="center">
  <img src="assets/images/app_logo.png" width="160" alt="Komoditas-AI Logo">
</p>

**Komoditas-AI** adalah aplikasi *mobile* cerdas yang dirancang untuk memantau dan memprediksi pergerakan harga komoditas pangan pokok di Indonesia. Dibangun dengan teknologi mutakhir untuk memberikan wawasan pasar yang akurat dan personal bagi konsumen maupun pelaku usaha.

---

## ✨ Fitur Unggulan

- **📊 Prediksi Harga AI**: Visualisasi tren harga 7 hari ke depan menggunakan model peramalan *time-series* hibrida yang canggih.
- **🔄 Mode Perspektif Cerdas**: 
  - 🛒 **Mode Pembeli**: Fokus pada penghematan—kenaikan harga ditandai sebagai peringatan (**Merah**).
  - 🏪 **Mode Pedagang**: Fokus pada profit—kenaikan harga ditandai sebagai peluang (**Hijau**).
- **💾 Pengaturan Persisten**: Aplikasi mengingat preferensi Anda (Mode Perspektif & Tema) meskipun aplikasi ditutup.
- **🚀 Splash Screen Modern**: Pengalaman *onboarding* yang halus dengan animasi logo minimalis.
- **📈 Insight Global AI**: Analisis otomatis mengenai kondisi pasar nasional untuk membantu pengambilan keputusan yang lebih tepat.
- **🌓 Tema Dinamis**: Dukungan penuh untuk *Dark Mode* dan *Light Mode* dengan desain yang premium dan modern.
- **🛡️ Manajemen Data Tangguh**: Sinkronisasi API yang efisien dengan penanganan kondisi *offline* yang informatif.

## 🛠️ Teknologi yang Digunakan

### Frontend (Mobile)
- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev/) (Modern & Type-safe)
- **Persistence**: `shared_preferences`
- **Networking**: `dio` (dengan interceptors)
- **Charting**: `fl_chart`

### Backend (AI Engine)
- **API Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Python)
- **AI/ML**: Model peramalan *Quad-Hybrid* untuk akurasi prediksi maksimal.

## 🚀 Memulai Penggunaan

### 1. Prasyarat
- Flutter SDK (^3.10.0)
- Dart SDK
- Perangkat Android/iOS atau Emulator/Simulator.

### 2. Persiapan Proyek
```bash
# Clone repository
git clone https://github.com/username-anda/komoditas-ai.git

# Masuk ke direktori
cd komoditas_ai

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

## 📂 Struktur Proyek

```text
lib/
├── core/
│   ├── api_client.dart    # Client API dengan penanganan error
│   ├── api_config.dart    # Konfigurasi endpoint
│   ├── models.dart        # Model data entitas
│   ├── providers.dart     # Logika bisnis & State Management
│   └── theme.dart         # Sistem desain (Colors & Typography)
├── data/
│   └── commodity_data.dart # Abstraksi akses data
├── screens/
│   ├── splash_screen.dart # Layar awal animasi logo
│   ├── home_screen.dart   # Dashboard & Ringkasan Pasar
│   ├── detail_screen.dart # Analisis mendalam & Grafik Prediksi
│   ├── insight_screen.dart# Analisis AI Global
│   └── settings_screen.dart # Preferensi & Personalisasi
├── widgets/
│   ├── commodity_card.dart# Kartu informasi komoditas
│   ├── error_state.dart   # UI penanganan kesalahan
│   └── price_chart.dart   # Visualisasi data harga
└── main.dart              # Inisialisasi & Navigasi
```

## 🤝 Kontribusi
Aplikasi ini bersifat terbuka untuk pengembangan lebih lanjut. Jika Anda menemukan *bug* atau memiliki ide fitur baru, silakan ajukan melalui *Issue* atau *Pull Request*.

---
*Membangun ketahanan pangan melalui inovasi kecerdasan buatan.*
