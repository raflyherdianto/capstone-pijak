# 📊 Eksplorasi Model Prediksi Harga Komoditas Pangan Nasional

Repositori ini berisi eksplorasi model _machine learning_ dan _deep learning_ untuk memprediksi harga komoditas pangan nasional Indonesia, menggunakan data historis dari Bank Indonesia.

---

## 📁 Struktur Direktori

```
eksplorasi-model/
├── Eksplorasi_LSTM.ipynb                              # LSTM - Kategori Utama (level 1)
├── Eksplorasi_LSTM_Subcategory.ipynb                  # LSTM - Sub-Kategori (level 2)
├── Eksplorasi_Hybrid_ARIMA_Random_Forest.ipynb         # Hybrid ARIMA + RF - Kategori Utama
├── commodity_history.json                              # Data historis - Kategori Utama
├── commodity_history_subcategory.json                  # Data historis - Sub-Kategori
└── README.md
```

---

## 📦 Dataset

Data historis harga komoditas pangan nasional bersumber dari **Bank Indonesia** (bi.go.id), mencakup periode **1 Januari 2024 – 24 Mei 2026**.

### Kategori Utama (Level 1) — 10 Komoditas

| No | Komoditas     |
|----|---------------|
| 1  | Beras         |
| 2  | Daging Ayam   |
| 3  | Daging Sapi   |
| 4  | Telur Ayam    |
| 5  | Bawang Merah  |
| 6  | Bawang Putih  |
| 7  | Cabai Merah   |
| 8  | Cabai Rawit   |
| 9  | Minyak Goreng |
| 10 | Gula Pasir    |

### Sub-Kategori (Level 2) — 21 Komoditas

| Kategori Induk | Sub-Kategori                                                               |
|----------------|----------------------------------------------------------------------------|
| Beras          | Kualitas Bawah I, Kualitas Bawah II, Kualitas Medium I, Kualitas Medium II, Kualitas Super I, Kualitas Super II |
| Daging Ayam    | Daging Ayam Ras Segar                                                      |
| Daging Sapi    | Kualitas 1, Kualitas 2                                                     |
| Telur Ayam     | Telur Ayam Ras Segar                                                       |
| Bawang Merah   | Ukuran Sedang                                                              |
| Bawang Putih   | Ukuran Sedang                                                              |
| Cabai Merah    | Cabai Merah Besar, Cabai Merah Keriting                                    |
| Cabai Rawit    | Cabai Rawit Hijau, Cabai Rawit Merah                                       |
| Minyak Goreng  | Curah, Kemasan Bermerk 1, Kemasan Bermerk 2                                |
| Gula Pasir     | Kualitas Premium, Lokal                                                    |

---

## 🧠 Model yang Dieksplorasi

### 1. LSTM (Long Short-Term Memory)

Arsitektur _Stacked LSTM_ dengan fitur kalender dan fitur lag untuk menangkap pola temporal harga komoditas.

**Arsitektur:**
```
Input → LSTM(64, return_sequences=True) → Dropout(0.2) → LSTM(32) → Dropout(0.2) → Dense(1)
```

**Fitur yang Digunakan (10 fitur):**
- Fitur Kalender: `day_of_week`, `day_of_month`, `day_of_year`, `month`, `is_weekend`
- Fitur Lag: `lag_1`, `lag_2`, `lag_7`
- Fitur Rolling: `rolling_mean_7`, `rolling_std_7`

**Parameter Pelatihan:**
- Optimizer: Adam
- Loss: Mean Squared Error
- Epochs: 50 (dengan EarlyStopping, patience=10)
- Batch Size: 16
- Time Steps (Window): 7 hari
- Split: 80% Train / 20% Test

### 2. Hybrid ARIMA + Random Forest

Model hybrid yang menggabungkan ARIMA untuk menangkap komponen linear dan Random Forest untuk memprediksi residual (komponen non-linear).

**Alur Kerja:**
1. ARIMA(1,1,1) memprediksi harga berdasarkan pola _time series_ linear
2. Residual (error) dari ARIMA dihitung
3. Random Forest Regressor (100 trees, max_depth=10) memprediksi residual
4. Prediksi akhir = Prediksi ARIMA + Prediksi RF Residual

---

## 📈 Hasil Evaluasi

### LSTM — Kategori Utama (Beras, Level 1)

| Metrik     | Nilai          |
|------------|----------------|
| **MAE**    | 34.48 IDR      |
| **RMSE**   | 60.29 IDR      |
| **MAPE**   | 0.2181 %       |
| **R²**     | 0.5159         |

- **Data**: Beras (rata-rata nasional), 868 sampel
- **Train**: 694 sampel (Jan 2024 – Des 2025)
- **Test**: 174 sampel (Des 2025 – Mei 2026)
- **ADF Test**: Stasioner (p-value = 0.0061)

### LSTM — Sub-Kategori (Beras Kualitas Bawah I, Level 2)

| Metrik     | Nilai          |
|------------|----------------|
| **MAE**    | 47.61 IDR      |
| **RMSE**   | 113.59 IDR     |
| **MAPE**   | 0.3324 %       |
| **R²**     | -0.4176        |

- **Data**: Beras Kualitas Bawah I, 875 sampel
- **Train**: 700 sampel (Jan 2024 – Des 2025)
- **Test**: 175 sampel (Des 2025 – Mei 2026)
- **ADF Test**: Stasioner (p-value = 0.0316)

### Hybrid ARIMA + Random Forest — Kategori Utama (Beras, Level 1)

| Metrik     | ARIMA Murni | Random Forest Baseline | Hybrid ARIMA + RF |
|------------|-------------|------------------------|--------------------|
| **MAE**    | 6.67 IDR    | 12.62 IDR              | 7.95 IDR           |
| **RMSE**   | 16.74 IDR   | 22.55 IDR              | 15.82 IDR          |
| **MAPE**   | 0.0419 %    | 0.0791 %               | 0.0500 %           |
| **R²**     | 0.8897      | 0.7998                 | 0.9015             |

- **Data**: Beras (rata-rata nasional), 257 sampel
- **Train**: 205 sampel (Mei 2025 – Mar 2026)
- **Test**: 52 sampel (Mar 2026 – Mei 2026)

---

## 📝 Kesimpulan

### 1. Perbandingan Antar Model (Kategori Utama — Beras)

| Model              | MAE (IDR) | MAPE (%) | R²     |
|--------------------|-----------|----------|--------|
| LSTM               | 34.48     | 0.2181   | 0.5159 |
| ARIMA Murni        | 6.67      | 0.0419   | 0.8897 |
| Random Forest      | 12.62     | 0.0791   | 0.7998 |
| **Hybrid ARIMA+RF**| **7.95**  | **0.0500**| **0.9015** |

- **Model Hybrid ARIMA + Random Forest** memberikan performa terbaik secara keseluruhan dengan **R² tertinggi (0.9015)** dan **RMSE terendah (15.82 IDR)**.
- **ARIMA Murni** unggul dalam MAE dan MAPE, menunjukkan bahwa pola harga beras cenderung linear dan dapat ditangkap dengan baik oleh model statistik klasik.
- **LSTM** memiliki R² paling rendah (0.5159), kemungkinan karena jumlah data yang terbatas dan pola harga beras yang relatif stabil (variasi kecil).

### 2. LSTM Kategori vs Sub-Kategori

| Level            | Target                    | MAE (IDR) | MAPE (%) | R²      |
|------------------|---------------------------|-----------|----------|---------|
| Kategori (Lv.1)  | Beras (Rata-rata)        | 34.48     | 0.2181   | 0.5159  |
| Sub-Kategori (Lv.2) | Beras Kualitas Bawah I | 47.61     | 0.3324   | -0.4176 |

- Performa LSTM pada **sub-kategori** lebih rendah dibandingkan kategori utama. Hal ini disebabkan oleh **variasi harga sub-kategori yang sangat kecil** — harga Beras Kualitas Bawah I sangat stabil sehingga model LSTM kesulitan menangkap fluktuasi minor.
- R² negatif pada sub-kategori menunjukkan bahwa prediksi model lebih buruk dari sekadar menggunakan rata-rata (*baseline*), bukan berarti model salah, tetapi data terlalu _flat_.

### 3. Rekomendasi

1. **Model Hybrid ARIMA + RF** direkomendasikan sebagai model utama untuk prediksi harga komoditas pangan karena memiliki performa terbaik.
2. Untuk data dengan **variasi rendah** (seperti harga beras sub-kategori), pertimbangkan untuk menggunakan **ARIMA murni** yang lebih cocok untuk pola linear dan stabil.
3. **LSTM** dapat lebih optimal jika:
   - Data pelatihan lebih banyak (> 2 tahun)
   - Diterapkan pada komoditas dengan fluktuasi tinggi (misalnya: Cabai Merah, Bawang Merah)
   - Dilakukan _hyperparameter tuning_ lebih lanjut

---

## ⚙️ Cara Menjalankan

### Prasyarat
```bash
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels tensorflow
```

### Menjalankan Notebook
1. Buka file `.ipynb` menggunakan Jupyter Notebook, JupyterLab, atau VS Code
2. Pilih kernel Python yang sudah terinstall semua dependensi
3. Jalankan seluruh sel (_Run All_)

---

## 👥 Tim

**PIJAK** — Capstone Project Arjuna
