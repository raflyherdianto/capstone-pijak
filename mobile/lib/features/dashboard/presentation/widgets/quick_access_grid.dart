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
              color: isDark ? const Color(0xFFE8C766) : const Color(0xFF07345A),
            ),
            const SizedBox(width: 8),
            Text(
              'Akses Cepat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.2,
                color: isDark ? Colors.white : const Color(0xFF07345A),
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
            childAspectRatio: 1.34,
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
    final trendColor = ref
        .read(settingsProvider.notifier)
        .getTrendColor(dayChange);
    final isPositive = dayChange > 0;
    final isFlat = dayChange == 0;
    final navy = isDark ? const Color(0xFFEAF8F4) : const Color(0xFF07345A);
    final imageAsset = _premiumAssetFor(commodity);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF07345A,
            ).withValues(alpha: isDark ? 0.28 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isDark
                ? const Color(0xFFE8C766).withValues(alpha: 0.12)
                : const Color(0xFF07345A).withValues(alpha: 0.06),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF0A2638), const Color(0xFF061D2D)]
                          : [Colors.white, const Color(0xFFFFFAED)],
                    ),
                  ),
                ),
              ),

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
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: -14,
                bottom: -12,
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: trendColor.withValues(alpha: isDark ? 0.08 : 0.06),
                  ),
                ),
              ),

              Positioned(
                right: 10,
                top: 38,
                child: Image.asset(
                  imageAsset,
                  width: 58,
                  height: 58,
                  fit: BoxFit.contain,
                  errorBuilder: (_, e, st) =>
                      Icon(Icons.eco_rounded, color: trendColor, size: 34),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            commodity.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  color: navy,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 42),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomPaint(
                          size: const Size(70, 20),
                          painter: _MiniSparklinePainter(
                            color: trendColor,
                            isPositive: isPositive,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          currencyFormat.format(commodity.currentPrice),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: trendColor.withValues(
                              alpha: isDark ? 0.16 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.arrow_upward_rounded
                                    : (isFlat
                                          ? Icons.trending_flat_rounded
                                          : Icons.arrow_downward_rounded),
                                size: 12,
                                color: trendColor,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${dayChange.abs().toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: trendColor,
                                ),
                              ),
                            ],
                          ),
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

class _MiniSparklinePainter extends CustomPainter {
  final Color color;
  final bool isPositive;

  const _MiniSparklinePainter({required this.color, required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final guide = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height * 0.62),
      Offset(size.width, size.height * 0.62),
      guide,
    );

    final path = Path();
    final points = isPositive
        ? [
            Offset(0, size.height * 0.74),
            Offset(size.width * 0.22, size.height * 0.58),
            Offset(size.width * 0.46, size.height * 0.64),
            Offset(size.width * 0.7, size.height * 0.36),
            Offset(size.width, size.height * 0.28),
          ]
        : [
            Offset(0, size.height * 0.32),
            Offset(size.width * 0.24, size.height * 0.42),
            Offset(size.width * 0.5, size.height * 0.38),
            Offset(size.width * 0.74, size.height * 0.68),
            Offset(size.width, size.height * 0.76),
          ];

    path.moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _premiumAssetFor(Commodity commodity) {
  final name = commodity.name.toLowerCase();

  if (name.contains('beras')) {
    return 'assets/images/arjuna_3d_beras.png';
  }
  if (name.contains('telur')) {
    return 'assets/images/arjuna_3d_telur_ayam.png';
  }
  if (name.contains('daging ayam') ||
      name == 'ayam' ||
      name.contains(' ayam')) {
    return 'assets/images/arjuna_3d_daging_ayam.png';
  }
  if (name.contains('daging sapi') || name.contains('sapi')) {
    return 'assets/images/arjuna_3d_daging_sapi.png';
  }

  return commodity.imageAsset;
}
