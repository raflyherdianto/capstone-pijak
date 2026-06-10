import pandas as pd
import numpy as np
import time
import logging
from datetime import timedelta
from statsmodels.tsa.statespace.sarimax import SARIMAX
from sqlalchemy.orm import Session
from app.db.models import Commodity, CommodityPrice

logger = logging.getLogger(__name__)

# Konfigurasi Parameter Hasil Fine-Tuning yang Stabil & Production-Ready (Dataset 2021-2026)
MODEL_CONFIG = {
    "Bawang Merah Ukuran Sedang": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Bawang Putih Ukuran Sedang": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Bawah I": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Bawah II": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Medium I": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Medium II": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Super I": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Beras Kualitas Super II": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Cabai Merah Besar": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Cabai Merah Keriting ": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Cabai Rawit Hijau": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Cabai Rawit Merah": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Daging Ayam Ras Segar": {"sarima": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 0, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Daging Sapi Kualitas 1": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Daging Sapi Kualitas 2": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Gula Pasir Kualitas Premium": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Gula Pasir Lokal": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Minyak Goreng Curah": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Minyak Goreng Kemasan Bermerk 1": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Minyak Goreng Kemasan Bermerk 2": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
    "Telur Ayam Ras Segar": {"sarima": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}, "sarimax": {"order": [1, 1, 1], "seasonal_order": [0, 0, 0, 7]}},
}

class ForecastCache:
    def __init__(self, ttl_seconds=43200):  # Default TTL: 12 Jam
        self._cache = {}
        self.ttl = ttl_seconds

    def get(self, subcategory: str, model_type: str, steps: int):
        key = (subcategory, model_type, steps)
        if key in self._cache:
            timestamp, data = self._cache[key]
            if time.time() - timestamp < self.ttl:
                return data
        return None

    def set(self, subcategory: str, model_type: str, steps: int, data):
        key = (subcategory, model_type, steps)
        self._cache[key] = (time.time(), data)

    def clear(self):
        self._cache.clear()

_forecast_cache = ForecastCache()  # TTL 12 jam untuk ramalan masa depan
_audit_cache = ForecastCache(ttl_seconds=3600)  # TTL 1 jam untuk audit in-sample
_insight_cache = ForecastCache(ttl_seconds=3600)  # TTL 1 jam untuk AI Insight

def load_commodity_data_from_db(db: Session, subcategory: str) -> pd.Series:
    commodity = db.query(Commodity).filter(Commodity.name == subcategory).first()
    if not commodity:
        raise ValueError(f"Subkategori '{subcategory}' tidak ditemukan di database.")
        
    prices = db.query(CommodityPrice).filter(CommodityPrice.commodity_id == commodity.id).order_by(CommodityPrice.date).all()
    if not prices:
        raise ValueError(f"Tidak ada data historis untuk subkategori '{subcategory}'.")
        
    dates = [p.date for p in prices]
    vals = [p.price for p in prices]
    
    series = pd.Series(data=vals, index=pd.to_datetime(dates)).sort_index()
    # Atur frekuensi harian & imputasi interpolasi linear (independen)
    series = series.asfreq('D').interpolate(method='linear').ffill().bfill()
    return series

def get_in_sample_fit(db: Session, subcategory: str, days: int = 30) -> list:
    """
    Mengembalikan in-sample fitted values dari model SARIMAX untuk audit akurasi historis.
    
    Fitted values adalah nilai yang diperkirakan model untuk setiap titik data historis
    yang sudah ada (bukan prediksi masa depan). Ini merepresentasikan kemampuan model
    dalam menjelaskan pola harga masa lalu secara jujur.

    Args:
        db: Database session.
        subcategory: Nama subkategori komoditas.
        days: Jumlah hari terakhir yang dikembalikan (default 30).

    Returns:
        List of dicts: [{date, actual_price, fitted_price, residual_pct}]
    """
    if subcategory not in MODEL_CONFIG:
        raise ValueError(f"Subkategori '{subcategory}' tidak didukung oleh model.")

    # Cek cache audit terlebih dahulu
    cached = _audit_cache.get(subcategory, "audit", days)
    if cached is not None:
        return cached

    series = load_commodity_data_from_db(db, subcategory)

    orders = MODEL_CONFIG[subcategory]["sarimax"]
    order = tuple(orders["order"])
    seasonal_order = tuple(orders["seasonal_order"])

    # Transformasi log
    series_log = np.log1p(series)

    # Exog kalender: is_weekend (sama seperti generate_forecast)
    exog = pd.Series(
        [1 if d.dayofweek >= 5 else 0 for d in series.index],
        index=series.index,
        name="is_weekend"
    )

    try:
        model = SARIMAX(
            series_log, exog=exog,
            order=order, seasonal_order=seasonal_order,
            enforce_stationarity=True, enforce_invertibility=True
        )
        results = model.fit(disp=False)
        fitted_log = results.fittedvalues
    except Exception:
        # Fallback ke ARIMA(1,1,0) jika model utama gagal konvergensi
        fallback = SARIMAX(series_log, order=(1, 1, 0), enforce_stationarity=True)
        results = fallback.fit(disp=False)
        fitted_log = results.fittedvalues

    # Balikkan log-transform
    fitted = np.expm1(fitted_log)

    # Slice N hari terakhir setelah fitting seluruh series (penting: fit tetap pada full data)
    slice_series = series.iloc[-days:]
    slice_fitted = fitted.reindex(slice_series.index)

    result = []
    for date in slice_series.index:
        actual = float(slice_series[date])
        fit_val = slice_fitted.get(date)
        if fit_val is None or np.isnan(fit_val):
            fit_val = actual  # Fallback ke actual jika fitted NaN (biasanya titik awal AR)
        fit_val = float(fit_val)
        residual_pct = round(((actual - fit_val) / actual) * 100, 4) if actual > 0 else 0.0
        result.append({
            "date": date.strftime("%Y-%m-%d"),
            "actual_price": round(actual, 2),
            "fitted_price": round(fit_val, 2),
            "residual_pct": residual_pct
        })

    # Simpan ke audit cache
    _audit_cache.set(subcategory, "audit", days, result)
    return result


def generate_forecast(db: Session, subcategory: str, model_type: str, steps: int):
    if subcategory not in MODEL_CONFIG:
        raise ValueError(f"Subkategori '{subcategory}' tidak didukung oleh model.")

    # Cek cache terlebih dahulu
    cached_result = _forecast_cache.get(subcategory, model_type, steps)
    if cached_result is not None:
        return cached_result

    series = load_commodity_data_from_db(db, subcategory)
    last_date = series.index[-1]
    last_price = float(series.iloc[-1])
    
    # Transformasi log
    series_log = np.log1p(series)
    
    # Ambil hyperparameter optimal hasil tuning
    orders = MODEL_CONFIG[subcategory][model_type]
    order = tuple(orders["order"])
    seasonal_order = tuple(orders["seasonal_order"])
    
    # Generate Tanggal Masa Depan
    future_dates = [last_date + timedelta(days=i) for i in range(1, steps + 1)]
    
    # Fitting dan Peramalan
    try:
        if model_type == "sarimax":
            # Siapkan exog kalender training ('is_weekend')
            exog_train = pd.Series(
                [1 if d.dayofweek >= 5 else 0 for d in series.index],
                index=series.index,
                name="is_weekend"
            )
            
            # Fitting SARIMAX
            model = SARIMAX(series_log, exog=exog_train, order=order, seasonal_order=seasonal_order,
                            enforce_stationarity=True, enforce_invertibility=True)
            results = model.fit(disp=False)
            
            # Siapkan exog kalender untuk masa depan (forecast horizon)
            exog_forecast = pd.Series(
                [1 if d.dayofweek >= 5 else 0 for d in future_dates],
                index=future_dates,
                name="is_weekend"
            )
            
            # Forecast
            forecast_log = results.forecast(steps=steps, exog=exog_forecast)
            
        else:
            # Fitting SARIMA Murni
            model = SARIMAX(series_log, order=order, seasonal_order=seasonal_order,
                            enforce_stationarity=True, enforce_invertibility=True)
            results = model.fit(disp=False)
            
            # Forecast
            forecast_log = results.forecast(steps=steps)
            
        # Balikkan log-transform (np.expm1) & rounding
        predictions = []
        for d, log_p in zip(future_dates, forecast_log):
            price = round(float(np.expm1(log_p)), 2)
            predictions.append({
                "date": d.strftime("%Y-%m-%d"),
                "day_name": d.strftime("%A"),
                "predicted_price": price
            })
            
        result = {
            "subcategory": subcategory,
            "model_used": model_type.upper(),
            "last_historical_price": last_price,
            "last_historical_date": last_date.strftime("%Y-%m-%d"),
            "predictions": predictions
        }
        _forecast_cache.set(subcategory, model_type, steps, result)
        return result
        
    except Exception as e:
        # Fallback jika terjadi kegagalan konvergensi matematis (Production Graceful Fail)
        # Kami lakukan fallback ke model autoregressive sederhana (AR 1)
        try:
            fallback_model = SARIMAX(series_log, order=(1, 1, 0), enforce_stationarity=True)
            fallback_results = fallback_model.fit(disp=False)
            forecast_log = fallback_results.forecast(steps=steps)
            
            predictions = []
            for d, log_p in zip(future_dates, forecast_log):
                price = round(float(np.expm1(log_p)), 2)
                predictions.append({
                    "date": d.strftime("%Y-%m-%d"),
                    "day_name": d.strftime("%A"),
                    "predicted_price": price
                })
            result = {
                "subcategory": subcategory,
                "model_used": "FALLBACK_ARIMA(1,1,0)",
                "last_historical_price": last_price,
                "last_historical_date": last_date.strftime("%Y-%m-%d"),
                "predictions": predictions
            }
            _forecast_cache.set(subcategory, model_type, steps, result)
            return result
        except Exception as fallback_err:
            raise ValueError(f"Gagal melakukan peramalan model utama maupun fallback. Error: {str(fallback_err)}")

def extract_text_from_response(data: dict) -> str:
    """Helper untuk mengambil konten teks jawaban dari response Google AI Studio."""
    candidates = data.get("candidates", [])
    if not candidates:
        raise ValueError("Tidak ada kandidat jawaban dari API.")
        
    parts = candidates[0].get("content", {}).get("parts", [])
    content_text = ""
    # Kumpulkan seluruh part teks yang bukan internal chain-of-thought (thinking)
    for p in parts:
        if not p.get("thought"):
            content_text += p.get("text", "")
            
    if not content_text and parts:
        # Fallback jika semua parts berupa thought atau field text di parts pertama langsung
        content_text = parts[0].get("text", "")
        
    if not content_text:
        raise ValueError("Gagal mengekstrak teks respons.")
    return content_text.strip()

def get_ai_insight(subcategory: str, trend: float, horizon: int, current_price: float, predicted_price: float) -> str:
    """
    Menghasilkan analisis bisnis taktis menggunakan Google Gemma 4 (31B) dengan caching.
    Menerapkan fallback ke model gemini-1.5-flash jika limit gemma terlampaui (RPD=2).
    """
    cache_key_str = f"{subcategory}_{trend}_{horizon}_{current_price}_{predicted_price}"
    # Gunakan hash value sebagai parameter steps (integer) untuk ForecastCache
    steps_hash = abs(hash(cache_key_str)) % (10**8)
    cached = _insight_cache.get(subcategory, "insight", steps_hash)
    if cached is not None:
        return cached

    from app.core.config import settings
    import urllib.request
    import urllib.error
    import json

    if not settings.GEMMA_API_KEY:
        raise ValueError("Gemma API Key tidak dikonfigurasi.")

    trend_type = "kenaikan" if trend > 0 else ("penurunan" if trend < 0 else "kestabilan")
    trend_abs = abs(trend)
    
    prompt = (
        "Anda adalah seorang pakar analis bisnis komoditas pangan yang cerdas, praktis, dan profesional. "
        "Tugas Anda adalah memberikan rekomendasi bisnis taktis yang singkat, solutif, dan langsung dapat dieksekusi "
        "oleh pelaku UMKM kuliner/warung makan maupun masyarakat umum di Indonesia berdasarkan data prediksi pasar berikut:\n\n"
        f"- Komoditas: {subcategory}\n"
        f"- Harga Saat Ini: Rp {current_price:,.0f}/kg\n"
        f"- Harga Prediksi ({horizon} hari ke depan): Rp {predicted_price:,.0f}/kg\n"
        f"- Proyeksi Tren: {trend_type} sebesar {trend_abs:.1f}%\n\n"
        "Berikan rekomendasi taktis dalam 2 sampai 3 kalimat pendek berbahasa Indonesia (maksimal 70 kata) "
        "yang fokus pada tindakan nyata (misalnya: kapan harus menyetok bahan, bagaimana menyiasati harga jual, atau substitusi menu). "
        "Langsung berikan jawaban rekomendasi tanpa kata pengantar basa-basi seperti 'Berikut rekomendasi saya:'."
    )

    headers = {"Content-Type": "application/json"}
    body = {
        "contents": [{
            "parts": [{
                "text": prompt
            }]
        }]
    }

    # Skenario 1: Coba gemma-4-31b-it terlebih dahulu
    try:
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemma-4-31b-it:generateContent?key={settings.GEMMA_API_KEY}"
        req = urllib.request.Request(
            url,
            data=json.dumps(body).encode("utf-8"),
            headers=headers,
            method="POST"
        )
        with urllib.request.urlopen(req, timeout=30) as response:
            res_body = response.read().decode("utf-8")
            data = json.loads(res_body)
            result_text = extract_text_from_response(data)
            _insight_cache.set(subcategory, "insight", steps_hash, result_text)
            logger.info("AI Insight berhasil dibuat menggunakan model gemma-4-31b-it.")
            return result_text
            
    except Exception as e:
        logger.warning(f"Percobaan gemma-4-31b-it gagal (limit terlampaui/RPM/RPD/error): {str(e)}. Melakukan fallback ke gemini-2.5-flash...")
        
        # Skenario 2: Fallback ke gemini-2.5-flash jika gemma gagal/terkena rate limit
        try:
            fallback_url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={settings.GEMMA_API_KEY}"
            fallback_req = urllib.request.Request(
                fallback_url,
                data=json.dumps(body).encode("utf-8"),
                headers=headers,
                method="POST"
            )
            with urllib.request.urlopen(fallback_req, timeout=30) as response:
                res_body = response.read().decode("utf-8")
                data = json.loads(res_body)
                result_text = extract_text_from_response(data)
                _insight_cache.set(subcategory, "insight", steps_hash, result_text)
                logger.info("AI Insight berhasil dibuat menggunakan fallback model gemini-2.5-flash.")
                return result_text
        except Exception as fallback_err:
            raise RuntimeError(f"Gagal mengambil AI Insight dari gemma-4-31b-it maupun model fallback Gemini: {str(fallback_err)}")
