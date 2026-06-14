import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';

class MarketPulseCard extends ConsumerWidget {
  final List<Commodity> commodities;

  const MarketPulseCard({super.key, required this.commodities});

  String _getMarketLabel(int upCount, int downCount, int stableCount) {
    final total = upCount + downCount + stableCount;
    if (total == 0) return 'Tidak Ada Data';
    final upRatio = upCount / total;
    final downRatio = downCount / total;
    if (upRatio >= 0.6) return 'Pasar Cenderung Naik';
    if (downRatio >= 0.6) return 'Pasar Cenderung Turun';
    if (stableCount >= upCount && stableCount >= downCount) return 'Pasar Stabil';
    return 'Pasar Bergerak Campuran';
  }

  IconData _getMarketIcon(int upCount, int downCount) {
    if (upCount > downCount) return Icons.trending_up_rounded;
    if (downCount > upCount) return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final upColor = ref.read(settingsProvider.notifier).getTrendColor(1.0);
    final downColor = ref.read(settingsProvider.notifier).getTrendColor(-1.0);
    final stableColor = ref.read(settingsProvider.notifier).getTrendColor(0.0);

    final upCount = commodities
        .where((c) => (c.priceChanges['day_1'] ?? 0) > 0)
        .length;
    final downCount = commodities
        .where((c) => (c.priceChanges['day_1'] ?? 0) < 0)
        .length;
    final stableCount = commodities.length - upCount - downCount;
    final total = commodities.length;

    final marketLabel = _getMarketLabel(upCount, downCount, stableCount);
    final marketIcon = _getMarketIcon(upCount, downCount);

    // Dominant color for the card accent
    Color dominantColor;
    if (upCount > downCount && upCount > stableCount) {
      dominantColor = upColor;
    } else if (downCount > upCount && downCount > stableCount) {
      dominantColor = downColor;
    } else {
      dominantColor = accentColor;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  dominantColor.withValues(alpha: 0.12),
                  dominantColor.withValues(alpha: 0.04),
                ]
              : [
                  dominantColor.withValues(alpha: 0.08),
                  dominantColor.withValues(alpha: 0.02),
                ],
        ),
        border: Border.all(
          color: dominantColor.withValues(alpha: isDark ? 0.2 : 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: dominantColor.withValues(alpha: isDark ? 0.1 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dominantColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    marketIcon,
                    color: dominantColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kondisi Pasar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    Text(
                      marketLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: dominantColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '$total\nKomoditas',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white38 : Colors.black38,
                    height: 1.3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stacked progress bar
            if (total > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    if (upCount > 0)
                      Flexible(
                        flex: upCount,
                        child: Container(
                          height: 8,
                          color: upColor,
                        ),
                      ),
                    if (stableCount > 0)
                      Flexible(
                        flex: stableCount,
                        child: Container(
                          height: 8,
                          color: stableColor.withValues(alpha: 0.6),
                        ),
                      ),
                    if (downCount > 0)
                      Flexible(
                        flex: downCount,
                        child: Container(
                          height: 8,
                          color: downColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Legend row
            Row(
              children: [
                _LegendDot(color: upColor, label: 'Naik', value: upCount),
                const SizedBox(width: 16),
                _LegendDot(color: stableColor, label: 'Stabil', value: stableCount),
                const SizedBox(width: 16),
                _LegendDot(color: downColor, label: 'Turun', value: downCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '$value $label',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
