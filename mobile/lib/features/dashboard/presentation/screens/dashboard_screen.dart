import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/shimmer_placeholder.dart';
import '../../../../shared/widgets/error_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/market_pulse_card.dart';
import '../widgets/top_movers_section.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/news_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final metadataAsync = ref.watch(metadataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, e, st) => Icon(
                Icons.eco_rounded,
                size: 22,
                color: isDark
                    ? const Color(0xFFE8C766)
                    : const Color(0xFF0B9F91),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Arjuna', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF031827).withValues(alpha: 0.95)
                : const Color(0xFFEAF8F4).withValues(alpha: 0.92),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: ClipRect(
            child: CustomPaint(
              painter: BatikKawungPainter(
                color: isDark
                    ? const Color(0xFFE8C766).withValues(alpha: 0.025)
                    : const Color(0xFF07345A).withValues(alpha: 0.03),
              ),
            ),
          ),
        ),
      ),
      body: commoditiesAsync.when(
        data: (commodities) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(commoditiesProvider);
              ref.refresh(metadataProvider);
              ref.refresh(newsProvider);
            },
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 116),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting header
                  metadataAsync.when(
                    data: (meta) =>
                        DashboardHeader(lastUpdatedAt: meta.updatedAt),
                    loading: () => const DashboardHeader(),
                    error: (e, st) => const DashboardHeader(),
                  ),

                  const SizedBox(height: 24),

                  // 2. Market Pulse hero card
                  MarketPulseCard(commodities: commodities),

                  const SizedBox(height: 28),

                  // 3. Quick Access Grid (top 4)
                  if (commodities.isNotEmpty) ...[
                    QuickAccessGrid(commodities: commodities),
                    const SizedBox(height: 28),
                  ],

                  // 4. Top Movers section
                  if (commodities.isNotEmpty) ...[
                    TopMoversSection(commodities: commodities),
                    const SizedBox(height: 28),
                  ],

                  // 5. Berita Pangan (GNews.io)
                  const NewsSection(),
                ],
              ),
            ),
          );
        },
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 20),
              const ShimmerCardPlaceholder(height: 140),
              const SizedBox(height: 20),
              const ShimmerCardPlaceholder(height: 180),
              const SizedBox(height: 20),
              const ShimmerListPlaceholder(itemCount: 3),
            ],
          ),
        ),
        error: (error, _) => AppErrorWidget(
          title: 'Gagal Memuat Dashboard',
          message: error.toString(),
          onRetry: () {
            ref.refresh(commoditiesProvider);
            ref.refresh(metadataProvider);
          },
        ),
      ),
    );
  }
}


