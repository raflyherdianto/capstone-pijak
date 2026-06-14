import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/shimmer_placeholder.dart';
import '../../../../core/providers.dart';
import '../widgets/insight_content.dart';

class InsightScreen extends ConsumerWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final metadataAsync = ref.watch(metadataProvider);
    ref.watch(settingsProvider);

    const loadingPlaceholder = SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          ShimmerInsightPlaceholder(),
          SizedBox(height: 40),
          ShimmerGridPlaceholder(itemCount: 4),
          SizedBox(height: 100),
        ],
      ),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Insight Pasar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F0F0F).withValues(alpha: 0.95)
                : const Color(0xFFF4F6F8).withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: ClipRect(
            child: CustomPaint(
              painter: BatikKawungPainter(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.015)
                    : Colors.black.withValues(alpha: 0.025),
              ),
            ),
          ),
        ),
      ),
      body: metadataAsync.when(
        data: (metadata) {
          return commoditiesAsync.when(
            data: (commodities) => InsightContent(
              commodities: commodities,
              metadata: metadata,
              onRefresh: () async {
                ref.refresh(commoditiesProvider);
                ref.refresh(metadataProvider);
              },
            ),
            loading: () => loadingPlaceholder,
            error: (e, s) => AppErrorWidget(
              title: 'Gagal Memuat Data',
              message: e.toString(),
              onRetry: () {
                ref.refresh(commoditiesProvider);
                ref.refresh(metadataProvider);
              },
            ),
          );
        },
        loading: () => loadingPlaceholder,
        error: (e, s) => AppErrorWidget(
          title: 'Gagal Memuat Data',
          message: e.toString(),
          onRetry: () {
            ref.refresh(commoditiesProvider);
            ref.refresh(metadataProvider);
          },
        ),
      ),
    );
  }
}
