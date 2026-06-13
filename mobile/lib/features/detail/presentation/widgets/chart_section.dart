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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Grafik Harga', style: Theme.of(context).textTheme.titleLarge),
            RangeSelector(
              selectedRange: selectedRange,
              onRangeSelected: onRangeSelected,
            ),
          ],
        ),
        const SizedBox(height: 16),
        PriceChart(
          data: filteredData,
          themeColor: themeColor,
          reliability: reliability,
        ),
      ],
    );
  }
}
