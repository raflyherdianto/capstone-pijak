import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';
import '../screens/model_audit_screen.dart';
import 'price_chart.dart';
import 'range_selector.dart';

class ChartSection extends ConsumerWidget {
  final String subcategory;
  final ChartData filteredData;
  final Color themeColor;
  final String reliability;
  final int selectedRange;
  final Function(int) onRangeSelected;
  final String trend;

  const ChartSection({
    super.key,
    required this.subcategory,
    required this.filteredData,
    required this.themeColor,
    required this.reliability,
    required this.selectedRange,
    required this.onRangeSelected,
    required this.trend,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String trendLower = trend.toLowerCase();
    final isNaik = trendLower == 'naik';
    final isTurun = trendLower == 'turun';

    // Calculate trend badge color purely based on the overall trend value
    final double changeValue = isNaik ? 1.0 : (isTurun ? -1.0 : 0.0);
    final badgeColor = ref
        .watch(settingsProvider.notifier)
        .getTrendColor(changeValue);

    final IconData trendIcon = isNaik
        ? Icons.trending_up
        : (isTurun ? Icons.trending_down : Icons.trending_flat);
    final String capitalizedTrend = trend.isNotEmpty
        ? 'Tren: ${trend[0].toUpperCase()}${trend.substring(1)}'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.09)
              : Colors.black.withValues(alpha: 0.07),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Grafik Harga',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    if (trend.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: badgeColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(trendIcon, size: 12, color: badgeColor),
                            const SizedBox(width: 4),
                            Text(
                              capitalizedTrend,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                RangeSelector(
                  selectedRange: selectedRange,
                  onRangeSelected: onRangeSelected,
                ),
              ],
            ),
            const SizedBox(height: 12),
            PriceChart(
              data: filteredData,
              themeColor: themeColor,
              reliability: reliability,
            ),
            const Divider(height: 24, thickness: 0.5),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ModelAuditScreen(
                      subcategory: subcategory,
                      themeColor: themeColor,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 15,
                      color: isDark
                          ? const Color(0xFFE8C766)
                          : const Color(0xFF0B9F91),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lihat Audit Akurasi Prediksi AI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFFE8C766)
                            : const Color(0xFF0B9F91),
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: isDark
                          ? const Color(0xFFE8C766)
                          : const Color(0xFF0B9F91),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
