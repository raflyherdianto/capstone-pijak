import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';
import '../../../detail/presentation/screens/detail_screen.dart';

class TopMoversSection extends ConsumerWidget {
  final List<Commodity> commodities;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  const TopMoversSection({super.key, required this.commodities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort by day_1 change descending for top movers
    final sorted = [...commodities]
      ..sort((a, b) =>
          (b.priceChanges['day_1'] ?? 0).compareTo(a.priceChanges['day_1'] ?? 0));

    final topGainers = sorted.where((c) => (c.priceChanges['day_1'] ?? 0) > 0).take(4).toList();
    final topLosers = sorted.reversed.where((c) => (c.priceChanges['day_1'] ?? 0) < 0).take(4).toList();

    if (topGainers.isEmpty && topLosers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        _SectionTitle(
          icon: Icons.local_fire_department_rounded,
          label: 'Top Movers Hari Ini',
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        // Gainers
        if (topGainers.isNotEmpty) ...[
          _SubLabel(label: '🔺 Kenaikan Terbesar', isDark: isDark),
          const SizedBox(height: 8),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topGainers.length,
              separatorBuilder: (_, i) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _MoverCard(
                commodity: topGainers[i],
                isDark: isDark,
                currencyFormat: _currencyFormat,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(commodity: topGainers[i]),
                  ),
                ),
              ),
            ),
          ),
        ],

        // Losers
        if (topLosers.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SubLabel(label: '🔻 Penurunan Terbesar', isDark: isDark),
          const SizedBox(height: 8),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topLosers.length,
              separatorBuilder: (_, i) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _MoverCard(
                commodity: topLosers[i],
                isDark: isDark,
                currencyFormat: _currencyFormat,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(commodity: topLosers[i]),
                  ),
                ),
              ),
            ),
          ),
        ],

      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
        ),
      ],
    );
  }
}

class _SubLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SubLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white54 : Colors.black45,
      ),
    );
  }
}

class _MoverCard extends ConsumerWidget {
  final Commodity commodity;
  final bool isDark;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  const _MoverCard({
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
    final isPositive = dayChange > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: isDark
              ? trendColor.withValues(alpha: 0.08)
              : trendColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: trendColor.withValues(alpha: isDark ? 0.2 : 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: trendColor.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + change badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  commodity.imageAsset,
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                  errorBuilder: (_, e, st) => Icon(
                    Icons.eco_rounded,
                    color: trendColor,
                    size: 28,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 10,
                        color: trendColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${dayChange.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Name
            Text(
              commodity.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F0F0F),
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Price
            Text(
              currencyFormat.format(commodity.currentPrice),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
