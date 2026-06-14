class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Change to server IP for physical device
  static const String marketSummary = '/api/market-summary';
  static const String historical = '/historical';
  static const String predict = '/predict';
  static const String insight = '/insight';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 45);

  // GNews.io — https://gnews.io (free: 100 req/day, no mobile restriction)
  // Gunakan --dart-define=GNEWS_API_KEY=key_anda saat menjalankan aplikasi
  static const String newsApiKey = String.fromEnvironment('GNEWS_API_KEY');
  static const String newsApiBaseUrl = 'https://gnews.io/api/v4';
  static const String newsQuery = 'pangan Indonesia OR harga beras OR harga cabai OR komoditas pangan';
}
