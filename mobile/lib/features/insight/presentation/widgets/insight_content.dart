import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../shared/domain/models.dart';
import '../widgets/global_analysis_card.dart';

class InsightContent extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isSeller = settings.mode == UserMode.seller;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      edgeOffset: 4,
      displacement: 28,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalAnalysisCard(
              analysis: metadata.globalAnalysis,
              disclaimer: metadata.disclaimer,
              updatedAt: metadata.updatedAt,
              isSeller: isSeller,
              commodities: commodities,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
