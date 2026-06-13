import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/domain/models.dart';

class PriceChart extends StatelessWidget {
  final ChartData data;
  final Color themeColor;
  final String reliability;

  const PriceChart({
    super.key,
    required this.data,
    required this.themeColor,
    required this.reliability,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Filter forecast to exclude dates already in history (e.g. if today is in both)
    final lastHistoryDate = data.history.isNotEmpty
        ? data.history.last.date
        : '';
    final filteredForecast = data.forecast
        .where((f) => f.date != lastHistoryDate)
        .toList();

    final allPoints = [...data.history, ...filteredForecast];
    if (allPoints.isEmpty) return const SizedBox.shrink();

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final minPrice = allPoints
        .map((e) => e.price)
        .reduce((a, b) => a < b ? a : b);
    final maxPrice = allPoints
        .map((e) => e.price)
        .reduce((a, b) => a > b ? a : b);
    final padding = (maxPrice - minPrice) * 0.15;

    double boundMultiplier;
    switch (reliability.toLowerCase()) {
      case 'sangat tinggi':
        boundMultiplier = 0.005;
        break;
      case 'tinggi':
        boundMultiplier = 0.015;
        break;
      case 'cukup':
        boundMultiplier = 0.03;
        break;
      case 'rendah':
        boundMultiplier = 0.05;
        break;
      default:
        boundMultiplier = 0.02;
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) =>
                      isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  tooltipRoundedRadius: 16,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipMargin: 8,
                  tooltipBorder: BorderSide(
                    color: themeColor.withValues(alpha: isDark ? 0.3 : 0.15),
                    width: 1.5,
                  ),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    bool shown = false;
                    return touchedBarSpots.map((barSpot) {
                      if ((barSpot.barIndex == 2 || barSpot.barIndex == 3) &&
                          !shown) {
                        shown = true;

                        final index = barSpot.x.toInt();
                        if (index < 0 || index >= allPoints.length) return null;

                        final dateStr = allPoints[index].date;
                        String formattedDate;
                        try {
                          final date = DateTime.parse(dateStr);
                          formattedDate = DateFormat(
                            'dd MMM yyyy',
                          ).format(date);
                        } catch (_) {
                          formattedDate = dateStr;
                        }

                        final formattedPrice = currencyFormat.format(barSpot.y);

                        return LineTooltipItem(
                          '$formattedPrice\n',
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ).copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: formattedDate,
                              style: TextStyle(
                                color: isDark ? Colors.white60 : Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (value >= 1000000) {
                        text = '${(value / 1000000).toStringAsFixed(1)}jt';
                      } else if (value >= 1000) {
                        text = '${(value / 1000).toStringAsFixed(0)}rb';
                      } else {
                        text = value.toStringAsFixed(0);
                      }
                      return Text(
                        text,
                        style: TextStyle(
                          color: Colors.grey[isDark ? 500 : 400],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: allPoints.length > 10 ? 7 : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= allPoints.length) {
                        return const SizedBox.shrink();
                      }

                      final dateStr = allPoints[index].date;
                      final date = DateTime.parse(dateStr);

                      if (allPoints.length > 10 &&
                          index % 7 != 0 &&
                          index != allPoints.length - 1) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: TextStyle(
                            color: Colors.grey[isDark ? 500 : 400],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (allPoints.length - 1).toDouble(),
              minY: minPrice - padding,
              maxY: maxPrice + padding,
              lineBarsData: [
                // Forecast Upper Bound (Invisible) - Index 0
                LineChartBarData(
                  spots: [
                    FlSpot(
                      (data.history.length - 1).toDouble(),
                      data.history.last.price,
                    ),
                    ...filteredForecast.asMap().entries.map(
                      (e) => FlSpot(
                        (data.history.length + e.key).toDouble(),
                        e.value.price * (1 + boundMultiplier),
                      ),
                    ),
                  ],
                  isCurved: true,
                  color: Colors.transparent,
                  dotData: const FlDotData(show: false),
                ),
                // Forecast Lower Bound (Invisible) - Index 1
                LineChartBarData(
                  spots: [
                    FlSpot(
                      (data.history.length - 1).toDouble(),
                      data.history.last.price,
                    ),
                    ...filteredForecast.asMap().entries.map(
                      (e) => FlSpot(
                        (data.history.length + e.key).toDouble(),
                        e.value.price * (1 - boundMultiplier),
                      ),
                    ),
                  ],
                  isCurved: true,
                  color: Colors.transparent,
                  dotData: const FlDotData(show: false),
                ),
                // History Line - Index 2
                LineChartBarData(
                  spots: data.history
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.price))
                      .toList(),
                  isCurved: true,
                  color: themeColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeColor.withValues(alpha: isDark ? 0.25 : 0.18),
                        themeColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                // Forecast Line (Dashed) - Index 3
                LineChartBarData(
                  spots: [
                    FlSpot(
                      (data.history.length - 1).toDouble(),
                      data.history.last.price,
                    ),
                    ...filteredForecast.asMap().entries.map(
                      (e) => FlSpot(
                        (data.history.length + e.key).toDouble(),
                        e.value.price,
                      ),
                    ),
                  ],
                  isCurved: true,
                  dashArray: [5, 5],
                  color: themeColor.withValues(alpha: 0.8),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, barData) {
                      // Hide dot for the connecting point (Today)
                      return spot.x != (data.history.length - 1).toDouble();
                    },
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                          radius: 3,
                          color: themeColor,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        ),
                  ),
                ),
              ],
              betweenBarsData: [
                BetweenBarsData(
                  fromIndex: 0,
                  toIndex: 1,
                  color: themeColor.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              context,
              'Riwayat Harga',
              themeColor,
              isDashed: false,
            ),
            const SizedBox(width: 24),
            _buildLegendItem(
              context,
              'Prediksi AI',
              themeColor.withValues(alpha: 0.5),
              isDashed: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    Color color, {
    required bool isDashed,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDashed ? null : color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        color: color,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
