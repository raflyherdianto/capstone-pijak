import '../../core/api_client.dart';
import '../../core/api_config.dart';
import '../domain/models.dart';

abstract class ICommodityRepository {
  Future<List<Commodity>> getCommodities();
  Future<AppMetadata> getMetadata();
  Future<List<PricePoint>> getHistoricalData(String subcategory);
  Future<Map<String, dynamic>> getPredictionData(String subcategory);
  Future<Insight> getLiveInsight(
    String subcategory,
    double trend,
    int horizon,
    double currentPrice,
    double predictedPrice,
  );
  Future<List<AuditPoint>> getAuditData(String subcategory);
}

class CommodityRepository implements ICommodityRepository {
  final ApiClient _apiClient;

  CommodityRepository(this._apiClient);

  Future<Map<String, dynamic>> _fetchFullData() async {
    final response = await _apiClient.dio.get(ApiConfig.marketSummary);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<Commodity>> getCommodities() async {
    final data = await _fetchFullData();
    return (data['commodities'] as List)
        .map((e) => Commodity.fromJson(e))
        .toList();
  }

  @override
  Future<AppMetadata> getMetadata() async {
    final data = await _fetchFullData();
    return AppMetadata.fromJson(data['metadata'] as Map<String, dynamic>);
  }

  @override
  Future<List<PricePoint>> getHistoricalData(String subcategory) async {
    final response = await _apiClient.dio.get(
      ApiConfig.historical,
      queryParameters: {'subcategory': subcategory, 'days': 30},
    );
    final list = response.data as List;
    return list.map((e) => PricePoint.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getPredictionData(String subcategory) async {
    final response = await _apiClient.dio.get(
      ApiConfig.predict,
      queryParameters: {'subcategory': subcategory, 'model_type': 'sarimax', 'steps': 7},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Insight> getLiveInsight(
    String subcategory,
    double trend,
    int horizon,
    double currentPrice,
    double predictedPrice,
  ) async {
    final response = await _apiClient.dio.get(
      ApiConfig.insight,
      queryParameters: {
        'subcategory': subcategory,
        'trend': trend,
        'horizon': horizon,
        'current_price': currentPrice,
        'predicted_price': predictedPrice,
      },
    );
    return Insight.fromJson(response.data['insight']);
  }

  @override
  Future<List<AuditPoint>> getAuditData(String subcategory) async {
    final response = await _apiClient.dio.get(
      ApiConfig.audit,
      queryParameters: {'subcategory': subcategory, 'days': 30},
    );
    final list = response.data as List;
    return list.map((e) => AuditPoint.fromJson(e)).toList();
  }
}
