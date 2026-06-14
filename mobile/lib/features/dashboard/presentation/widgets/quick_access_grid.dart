import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';
import '../../../detail/presentation/screens/detail_screen.dart';

class QuickAccessGrid extends ConsumerWidget {
  final List<Commodity> commodities;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  const QuickAccessGrid({super.key, required this.commodities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Take first 4 commodities for quick access (assume sorted by importance from API)
    final items = commodities.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              'Akses Cepat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.2,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final commodity = items[index];
            return _QuickCard(
              commodity: commodity,
              isDark: isDark,
              currencyFormat: _currencyFormat,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(commodity: commodity),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickCard extends ConsumerWidget {
  final Commodity commodity;
  final bool isDark;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  const _QuickCard({
    required this.commodity,
    required this.isDark,
    required this.currencyFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayChange = commodity.priceChanges['day_1'] ?? 0;
    final trendColor =
        ref.read(settingsProvider.notifier).getTrendColor(dayChange);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Left accent strip
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: trendColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                ),
              ),

              // Background image
              Positioned(
                right: -8,
                top: 0,
                bottom: 0,
                width: 64,
                child: Opacity(
                  opacity: isDark ? 0.12 : 0.18,
                  child: Image.asset(
                    commodity.imageAsset,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    errorBuilder: (_, e, st) => const SizedBox.shrink(),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      commodity.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Price + change
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currencyFormat.format(commodity.currentPrice),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : const Color(0xFF0F0F0F),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              dayChange > 0
                                  ? Icons.arrow_upward_rounded
                                  : (dayChange < 0
                                      ? Icons.arrow_downward_rounded
                                      : Icons.trending_flat_rounded),
                              size: 11,
                              color: trendColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${dayChange.abs().toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: trendColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
