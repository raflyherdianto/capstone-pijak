import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import '../../../../shared/widgets/shimmer_placeholder.dart';

class AIInsightPerspectiveCard extends StatefulWidget {
  final Insight? insight;
  final bool isLoading;

  const AIInsightPerspectiveCard({
    super.key,
    this.insight,
    this.isLoading = false,
  });

  @override
  State<AIInsightPerspectiveCard> createState() =>
      _AIInsightPerspectiveCardState();
}

class _AIInsightPerspectiveCardState extends State<AIInsightPerspectiveCard> {
  int _selectedPerspective = 0; // 0: Masyarakat, 1: Pedagang

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.insight == null) {
      return const ShimmerInsightPlaceholder();
    }

    final insight = widget.insight!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMasyarakat = _selectedPerspective == 0;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPerspectiveTab(
                  'Masyarakat',
                  Icons.people_outline,
                  0,
                ),
              ),
              Expanded(
                child: _buildPerspectiveTab(
                  'Pedagang',
                  Icons.storefront_outlined,
                  1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isMasyarakat
                        ? Icons.shopping_bag_outlined
                        : Icons.trending_up,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isMasyarakat ? 'Tips Belanja Cerdas' : 'Analisis Bisnis',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isMasyarakat
                    ? insight.masyarakat
                    : insight.pedagang,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              if (insight.disclaimer.isNotEmpty) ...[
                const SizedBox(height: 16),
                Divider(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight.disclaimer,
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.white38 : Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerspectiveTab(
    String label,
    IconData icon,
    int index,
  ) {
    final isSelected = _selectedPerspective == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedPerspective = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? primaryColor
                  : (isDark ? Colors.white38 : Colors.black45),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white38 : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
