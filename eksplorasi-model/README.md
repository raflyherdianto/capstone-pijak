# 🌾 Dashboard Analisis & Prediksi Harga Pangan Nasional (Arjuna Pijak)

Repositori ini menyimpan hasil eksplorasi model peramalan (*forecasting*) deret waktu (*time-series*) dan *machine learning* untuk memprediksi harga komoditas pangan pokok strategis di Indonesia. Analisis dilakukan pada dua tingkat kedetailan data: **Kategori Utama** (10 komoditas tingkat makro) dan **Sub-kategori** (21 jenis komoditas granular).

---

## 📊 Akses Dashboard Interaktif
Kami menyediakan dua file dashboard HTML mandiri (*self-contained*) yang interaktif, premium, dan responsif. Anda dapat langsung membukanya di browser tanpa memerlukan server backend:

*   **[Dashboard Kategori Utama (result.html)](file:///d:/Projects/arjuna-pijak/dev/eksplorasi-model/result.html)**
    *   *Fokus:* 10 komoditas makro (Beras, Daging, Cabai, Bawang, Minyak, Telur, Gula).
    *   *Model:* ARIMA, Hybrid ARIMA + RF, Random Forest, XGBoost, FB Prophet.
*   **[Dashboard Sub-kategori (result_subcategory.html)](file:///d:/Projects/arjuna-pijak/dev/eksplorasi-model/result_subcategory.html)**
    *   *Fokus:* 21 sub-kategori spesifik (misal: Beras Kualitas Bawah I, Cabai Rawit Hijau, Bawang Merah Sedang).
    *   *Model:* SARIMA, SARIMAX (dengan Exog), ARIMA, LSTM (PyTorch), Hybrid, RF, XGBoost, KNN, FB Prophet.

---

## 📈 Tabel Ringkasan Performa Model (Rata-rata Keseluruhan / Overall)

### 1. Pemodelan Kategori Utama (10 Komoditas Pokok)
Evaluasi performa rata-rata keseluruhan model pada data kategori utama (tanpa sub-kategori):

| Peringkat | Model | R² Score | MAPE (%) | MAE (Rp) | RMSE (Rp) | Karakteristik Utama |
| :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| 🥇 | **ARIMA Murni** | **0.9176** | **0.41%** | **222** | **452** | Akurasi statistik tertinggi, sangat adaptif pada tren linier |
| 🥈 | **Hybrid ARIMA + RF** | 0.8795 | 0.60% | 346 | 537 | Menggabungkan model linier statsmodels dengan residu Random Forest |
| 🥉 | **Random Forest Baseline** | 0.2870 | 1.45% | 775 | 1.075 | Model non-linier berbasis *decision tree*, stabil tetapi sensitif data lag |
| 4 | **XGBoost** | -0.1003 | 1.77% | 954 | 1.241 | Inferensi sub-milidetik, sangat hemat memori pada skala besar |
| 5 | **FB Prophet** | -20.2471 | 19.27% | 9.026 | 10.014 | Sangat lambat, rawan meleset jauh pada deret waktu volatil harian |

### 2. Pemodelan Sub-kategori (21 Komoditas Granular)
Evaluasi performa rata-rata setelah pemodelan diturunkan ke level sub-kategori yang lebih spesifik dan volatil:

| Peringkat | Model | R² Score | MAPE (%) | MAE (Rp) | RMSE (Rp) | Karakteristik Utama |
| :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| 🥇 | **ARIMA Murni** | **0.8213** | 0.38% | 197 | 407 | Sangat kokoh pada data harian makro |
| 🥈 | **SARIMA Murni** | 0.8166 | **0.37%** | **195** | **395** | Teratas dalam meminimalkan persentase kesalahan (MAPE) |
| 🥉 | **SARIMAX (dengan Exog)** | 0.8147 | 0.39% | 204 | 405 | Memanfaatkan fitur kalender eksternal (`is_weekend`) |
| 4 | **Hybrid ARIMA + RF** | 0.7936 | 0.53% | 300 | 479 | Menjaga keseimbangan linier & non-linier tingkat sub-kategori |
| 5 | **LSTM (Deep Learning)** | 0.4750 | 1.57% | 790 | 1.016 | **Pemenang mutlak kategori non-linier**, menangkap pola tren kompleks |
| 6 | **Random Forest Baseline** | 0.1570 | 1.30% | 665 | 940 | Stabil secara operasional, rekayasa fitur lag rumit |
| 7 | **XGBoost** | -0.0854 | 1.51% | 799 | 1.066 | Latensi tercepat (<1ms), andal melayani ribuan model paralel |
| 8 | **KNN** | -0.2043 | 2.68% | 1.334 | 1.708 | Pembelajaran berbasis memori (*distance lookup*), bebas isu konvergensi |
| 9 | **FB Prophet** | -28.0432 | 22.60% | 10.722 | 11.664 | Kurang optimal untuk data beresolusi tinggi tanpa penalaan musiman |

---

## 💡 Temuan Utama & Analisis Eksplorasi

1.  **Dominasi Model Klasik (ARIMA/SARIMA):**
    Model statistik tradisional (ARIMA dan SARIMA/SARIMAX) mendominasi kedua skenario dengan skor $R^2$ di atas **0.81 - 0.91**. Hal ini menunjukkan bahwa harga pangan pokok nasional memiliki ketergantungan linier yang sangat kuat terhadap harga di hari-hari sebelumnya (autokorelasi tinggi) dan tren jangka pendek yang jelas.
2.  **LSTM sebagai Raja Non-Linier:**
    Ketika dituntut untuk menggunakan arsitektur non-linier (untuk skalabilitas atau pola non-linier yang rumit), **LSTM (PyTorch)** yang dioptimalkan dengan *weight initialization*, *early stopping*, dan *learning rate scheduler* menjadi model terbaik dengan skor $R^2$ sebesar **0.4750**. LSTM jauh mengungguli Random Forest (0.1570) dan XGBoost (-0.0854).
3.  **Dampak Granularitas Data:**
    Ketika model diturunkan dari tingkat kategori utama ke sub-kategori granular:
    *   Rata-rata akurasi ARIMA menurun dari **0.9176** menjadi **0.8213**. Ini disebabkan oleh peningkatan volatilitas dan variansi harga pada tingkat sub-kategori (misal, harga cabai merah keriting jauh lebih fluktuatif dibandingkan rata-rata cabai merah secara umum).
    *   SARIMAX dengan variabel eksogen kalender (`is_weekend`) menunjukkan keunggulan pada komoditas yang sangat dipengaruhi oleh hari pasar, seperti Daging Ayam Ras Segar dan Beras Kualitas Super.
4.  **Kelemahan FB Prophet:**
    FB Prophet mengalami kesulitan besar pada dataset ini ($R^2$ rata-rata sangat negatif). Hal ini karena Prophet dirancang untuk mendeteksi tren jangka panjang dengan musiman multi-tahunan yang kuat (seperti tren makro atau pencarian Google). Pada harga pangan harian yang stasioner dengan fluktuasi jangka pendek, model Prophet sering kali mengalami *over-smoothing* atau prediksi yang meleset jauh.

---

## 🛠️ Rekomendasi Deployment Skala Produksi

Berdasarkan analisis performa statistik dan kelayakan infrastruktur IT, kami merekomendasikan skenario deployment sebagai berikut:

*   **Skenario A: Akurasi Jangka Pendek Maksimal (Prioritas Bisnis)**
    *   *Rekomendasi:* Gunakan **SARIMA Murni** atau **SARIMAX**.
    *   *Ketentuan:* Memerlukan pipeline otomatis (seperti Apache Airflow) untuk melatih ulang (*retrain*) model secara berkala (misal harian) karena model ini sangat bergantung pada data historis terdekat. Wajib menambahkan mekanisme penanganan kesalahan untuk kegagalan konvergensi numerik (*matrix singularity*).
*   **Skenario B: Skalabilitas Skala Besar (1.000+ Seri Harga & Wilayah)**
    *   *Rekomendasi:* Gunakan **XGBoost** atau **Random Forest**.
    *   *Ketentuan:* Meskipun akurasinya lebih rendah pada pengujian baseline, model berbasis pohon keputusan (*decision tree*) sangat stabil secara matematis (tidak pernah crash), ramah memori, dan memiliki latensi inferensi sub-milidetik (`<1ms`). Sangat cocok jika harus melayani prediksi ribuan warung pangan/pasar secara paralel.
*   **Skenario C: Model Machine Learning Terbaik (Complex Pattern Extraction)**
    *   *Rekomendasi:* Gunakan **LSTM (PyTorch)**.
    *   *Ketentuan:* Direkomendasikan jika tim pengembang memiliki infrastruktur GPU/CPU yang memadai untuk pelatihan model deep learning secara berkala dan memerlukan model yang mampu menangkap dinamika tren jangka panjang non-linier yang rumit.

---
*Laporan ini diperbarui secara berkala sesuai dengan eksplorasi model terbaru dalam sistem peramalan Arjuna Pijak.*
