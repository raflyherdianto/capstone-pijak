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
    final trendColor = ref.read(settingsProvider.notifier).getTrendColor(commodity.priceChanges['day_1'] ?? 0);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: trendColor.withValues(alpha: isDark ? 0.25 : 0.12),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 160,
            child: Stack(
              children: [
                // Large Image on the right (faded background)
                Positioned(
                  right: -30,
                  top: -10,
                  bottom: -10,
                  child: Opacity(
                    opacity: isDark ? 0.12 : 0.18,
                    child: Hero(
                      tag: 'commodity-${commodity.name}',
                      child: Image.asset(
                        commodity.imageAsset,
                        width: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.shopping_basket_outlined,
                          size: 80,
                          color: trendColor.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ),
                ),
                // Content Layer
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commodity.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_currencyFormat.format(commodity.currentPrice)} / ${commodity.unit}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: trendColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: trendColor.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    (commodity.priceChanges['day_1'] ?? 0) > 0 ? Icons.trending_up : Icons.trending_down,
                                    size: 16,
                                    color: trendColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${commodity.priceChanges['day_1']?.abs().toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: trendColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: (commodity.forecastPct > 0 ? Colors.blue : Colors.orange).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Prediksi: ${commodity.forecastPct > 0 ? "+" : ""}${commodity.forecastPct}%',
                                style: TextStyle(
                                  color: commodity.forecastPct > 0 ? Colors.blue : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
