class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Change to server IP for physical device
  static const String marketSummary = '/api/market-summary';
  static const String historical = '/historical';
  static const String predict = '/predict';
  static const String insight = '/insight';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 45);
}
