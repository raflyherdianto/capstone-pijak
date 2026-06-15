import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import '../widgets/global_analysis_card.dart';
import '../widgets/quick_stats_grid.dart';

class InsightContent extends StatelessWidget {
  final List<Commodity> commodities;
  final AppMetadata metadata;
  final Future<void> Function() onRefresh;

  const InsightContent({
    super.key,
    required this.commodities,
    required this.metadata,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      edgeOffset: 4,
      displacement: 28,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 4),
            GlobalAnalysisCard(
              analysis: metadata.globalAnalysis,
              disclaimer: metadata.disclaimer,
            ),
            const SizedBox(height: 40),
            QuickStatsGrid(commodities: commodities),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
