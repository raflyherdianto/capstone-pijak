import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/domain/models.dart';

class StickyPriceHeader extends SliverPersistentHeaderDelegate {
  final Commodity commodity;
  final NumberFormat currencyFormat;
  final Color trendColor;
  final double currentChange;

  StickyPriceHeader({
    required this.commodity,
    required this.currencyFormat,
    required this.trendColor,
    required this.currentChange,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = shrinkOffset / maxExtent;
    
    // Calculate opacity for expanded/collapsed elements
    final expandedOpacity = (1 - progress * 2).clamp(0.0, 1.0);
    final collapsedOpacity = (progress * 2 - 1).clamp(0.0, 1.0);

    final currentHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);

    return Container(
      height: currentHeight,
      decoration: BoxDecoration(
        color: shrinkOffset > 0
            ? (isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF4F6F8))
            : Colors.transparent,
        border: progress > 0.5
            ? Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Expanded Header
          if (progress < 0.7)
            Opacity(
              opacity: expandedOpacity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commodity.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormat.format(commodity.currentPrice),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              'Per ${commodity.unit}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: trendColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    currentChange > 0 ? Icons.trending_up : Icons.trending_down,
                                    color: trendColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${currentChange.abs().toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: trendColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'commodity-${commodity.name}',
                      child: Image.asset(
                        commodity.imageAsset,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Collapsed Header (Sticky)
          if (progress > 0.3)
            Opacity(
              opacity: collapsedOpacity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset(
                      commodity.imageAsset,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commodity.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Per ${commodity.unit}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(commodity.currentPrice),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              currentChange > 0 ? Icons.trending_up : Icons.trending_down,
                              color: trendColor,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${currentChange.abs().toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: trendColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 160;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant StickyPriceHeader oldDelegate) {
    return oldDelegate.commodity != commodity ||
        oldDelegate.currentChange != currentChange ||
        oldDelegate.trendColor != trendColor;
  }
}
