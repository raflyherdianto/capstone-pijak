import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';

class CommodityCard extends ConsumerWidget {
  final Commodity commodity;
  final VoidCallback onTap;

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  const CommodityCard({
    super.key,
    required this.commodity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider);
    final trendColor = ref.read(settingsProvider.notifier).getTrendColor(
      commodity.priceChanges['day_1'] ?? 0,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayChange = commodity.priceChanges['day_1'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.09)
                : Colors.black.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 152,
            child: Stack(
              children: [
                // Left trend accent strip — 5px solid
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: trendColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),

                // Background image — higher opacity
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 140,
                  child: Opacity(
                    opacity: isDark ? 0.14 : 0.22,
                    child: Hero(
                      tag: 'commodity-${commodity.name}',
                      child: Image.asset(
                        commodity.imageAsset,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        errorBuilder: (ctx, err, st) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Commodity name
                      Text(
                        commodity.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Price — large + bold
                      Text(
                        _currencyFormat.format(commodity.currentPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          letterSpacing: -0.8,
                          color: isDark ? Colors.white : const Color(0xFF0F0F0F),
                          height: 1.0,
                        ),
                      ),
                      // Unit — separated below price
                      Text(
                        'per ${commodity.unit}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const Spacer(),

                      // Badges
                      Row(
                        children: [
                          _TrendBadge(
                            change: dayChange,
                            color: trendColor,
                          ),
                          const SizedBox(width: 8),
                          _TrendTextBadge(
                            trend: commodity.trend,
                            trendColor: trendColor,
                            isDark: isDark,
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
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final double change;
  final Color color;

  const _TrendBadge({
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon = change > 0
        ? Icons.arrow_upward_rounded
        : (change < 0 ? Icons.arrow_downward_rounded : Icons.trending_flat_rounded);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${change.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendTextBadge extends StatelessWidget {
  final String trend;
  final Color trendColor;
  final bool isDark;

  const _TrendTextBadge({
    required this.trend,
    required this.trendColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final capitalizedTrend = trend.isNotEmpty
        ? '${trend[0].toUpperCase()}${trend.substring(1)}'
        : '';
    final String trendLower = trend.toLowerCase();

    // Use responsive blue for stable, otherwise fallback to trendColor
    final Color badgeColor = trendLower == 'stabil'
        ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))
        : trendColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        capitalizedTrend,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
