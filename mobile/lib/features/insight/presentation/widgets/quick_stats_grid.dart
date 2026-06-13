import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models.dart';
import '../../../../core/providers.dart';

class QuickStatsGrid extends ConsumerWidget {
  final List<Commodity> commodities;

  const QuickStatsGrid({super.key, required this.commodities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final upCount = commodities
        .where((c) => (c.priceChanges['day_1'] ?? 0) > 0)
        .length;
    final downCount = commodities.length - upCount;

    return Row(
      children: [
        _buildStatItem(
          context,
          'Meningkat',
          upCount.toString(),
          Icons.trending_up,
          ref.read(settingsProvider.notifier).getTrendColor(1.0),
          isDark,
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          context,
          'Menurun',
          downCount.toString(),
          Icons.trending_down,
          ref.read(settingsProvider.notifier).getTrendColor(-1.0),
          isDark,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? color.withValues(alpha: 0.1) : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
