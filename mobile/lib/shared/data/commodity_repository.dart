import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _marketSummaryCacheKey = 'market_summary_cache_v1';

  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  CommodityRepository(this._apiClient, this._prefs);

  Future<Map<String, dynamic>> _fetchFullData() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.marketSummary);
      final data = response.data as Map<String, dynamic>;
      await _prefs.setString(_marketSummaryCacheKey, jsonEncode(data));
      return data;
    } on DioException catch (error) {
      final cachedData = _readCachedMarketSummary();
      if (cachedData != null) {
        debugPrint(
          'Using cached market summary after network failure: ${error.message}',
        );
        return cachedData;
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic>? _readCachedMarketSummary() {
    final cached = _prefs.getString(_marketSummaryCacheKey);
    if (cached == null || cached.isEmpty) return null;

    try {
      final decoded = jsonDecode(cached);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (error) {
      debugPrint('Failed to read cached market summary: $error');
    }
    return null;
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
      queryParameters: {
        'subcategory': subcategory,
        'model_type': 'sarimax',
        'steps': 7,
      },
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
