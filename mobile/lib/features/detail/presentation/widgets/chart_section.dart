import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import 'price_chart.dart';
import 'range_selector.dart';

class ChartSection extends StatelessWidget {
  final ChartData filteredData;
  final Color themeColor;
  final String reliability;
  final int selectedRange;
  final Function(int) onRangeSelected;

  const ChartSection({
    super.key,
    required this.filteredData,
    required this.themeColor,
    required this.reliability,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                Text(
                  'Grafik Harga',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
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
          ],
        ),
      ),
    );
  }
}
