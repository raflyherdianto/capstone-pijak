import '../../../../shared/domain/models.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final List<PricePoint> history;
  final List<PricePoint> forecast;
  final Insight? liveInsight;
  final bool isInsightLoading;
  final double trend;
  final int horizon;
  final double predictedPrice;

  DetailLoaded({
    required this.history,
    required this.forecast,
    this.liveInsight,
    this.isInsightLoading = false,
    required this.trend,
    required this.horizon,
    required this.predictedPrice,
  });

  DetailLoaded copyWith({
    List<PricePoint>? history,
    List<PricePoint>? forecast,
    Insight? liveInsight,
    bool? isInsightLoading,
    double? trend,
    int? horizon,
    double? predictedPrice,
  }) {
    return DetailLoaded(
      history: history ?? this.history,
      forecast: forecast ?? this.forecast,
      liveInsight: liveInsight ?? this.liveInsight,
      isInsightLoading: isInsightLoading ?? this.isInsightLoading,
      trend: trend ?? this.trend,
      horizon: horizon ?? this.horizon,
      predictedPrice: predictedPrice ?? this.predictedPrice,
    );
  }
}

class DetailError extends DetailState {
  final String message;

  DetailError(this.message);
}
