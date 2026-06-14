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
    if (stableCount >= upCount && stableCount >= downCount) {
      return 'Pasar Stabil';
    }
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
    final upColor = ref.read(settingsProvider.notifier).getTrendColor(1.0);
    final downColor = ref.read(settingsProvider.notifier).getTrendColor(-1.0);

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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF07345A), Color(0xFF05243F), Color(0xFF041A2A)]
              : const [Color(0xFF07345A), Color(0xFF0C5B75), Color(0xFF0B9F91)],
        ),
        border: Border.all(
          color: const Color(0xFFE8C766).withValues(alpha: isDark ? 0.2 : 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF07345A,
            ).withValues(alpha: isDark ? 0.32 : 0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SignalLinesPainter(
                  color: Colors.white.withValues(alpha: 0.12),
                  gold: const Color(0xFFE8C766).withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned(right: -42, top: -10, child: const _FoodSignalCluster()),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Icon(
                          marketIcon,
                          color: const Color(0xFFE8C766),
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kondisi Pasar Nasional',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.68),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              marketLabel,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.2,
                                height: 1.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 10,
                      //     vertical: 7,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withValues(alpha: 0.12),
                      //     borderRadius: BorderRadius.circular(14),
                      //     border: Border.all(
                      //       color: const Color(
                      //         0xFFE8C766,
                      //       ).withValues(alpha: 0.22),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     '$total\nKomoditas',
                      //     textAlign: TextAlign.right,
                      //     style: TextStyle(
                      //       fontSize: 11,
                      //       fontWeight: FontWeight.w800,
                      //       color: Colors.white.withValues(alpha: 0.82),
                      //       height: 1.18,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (total > 0) ...[
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          if (upCount > 0)
                            Flexible(
                              flex: upCount,
                              child: Container(color: upColor),
                            ),
                          if (stableCount > 0)
                            Flexible(
                              flex: stableCount,
                              child: Container(
                                color: const Color(
                                  0xFFA9B4C0,
                                ).withValues(alpha: 0.9),
                              ),
                            ),
                          if (downCount > 0)
                            Flexible(
                              flex: downCount,
                              child: Container(color: downColor),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      _LegendDot(color: upColor, label: 'Naik', value: upCount),
                      _LegendDot(
                        color: const Color(0xFFA9B4C0),
                        label: 'Stabil',
                        value: stableCount,
                      ),
                      _LegendDot(
                        color: downColor,
                        label: 'Turun',
                        value: downCount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodSignalCluster extends StatelessWidget {
  const _FoodSignalCluster();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 188,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFFE8C766).withValues(alpha: 0.16),
              ),
            ),
          ),
          Image.asset(
            'assets/images/arjuna_hero_3d.png',
            width: 176,
            height: 118,
            fit: BoxFit.contain,
            errorBuilder: (_, e, st) => Icon(
              Icons.arrow_outward_rounded,
              size: 54,
              color: const Color(0xFFE8C766).withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalLinesPainter extends CustomPainter {
  final Color color;
  final Color gold;

  const _SignalLinesPainter({required this.color, required this.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    final goldPaint = Paint()
      ..color = gold
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = color;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.72)
      ..lineTo(size.width * 0.28, size.height * 0.56)
      ..lineTo(size.width * 0.48, size.height * 0.62)
      ..lineTo(size.width * 0.66, size.height * 0.38)
      ..lineTo(size.width * 0.88, size.height * 0.48);
    canvas.drawPath(path, linePaint);

    final arrow = Path()
      ..moveTo(size.width * 0.08, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.02,
        size.width * 0.92,
        size.height * 0.18,
      );
    canvas.drawPath(arrow, goldPaint);

    for (final point in [
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.28, size.height * 0.56),
      Offset(size.width * 0.48, size.height * 0.62),
      Offset(size.width * 0.66, size.height * 0.38),
      Offset(size.width * 0.88, size.height * 0.48),
    ]) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$value $label',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}
