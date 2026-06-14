import 'package:flutter/material.dart';
import '../../../../shared/widgets/arjuna_brand.dart';

class GlobalAnalysisCard extends StatelessWidget {
  final String analysis;
  final String disclaimer;

  const GlobalAnalysisCard({
    super.key,
    required this.analysis,
    required this.disclaimer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = ArjunaColors.accent(isDark);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A2638) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ArjunaColors.navy.withValues(alpha: isDark ? 0.24 : 0.09),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent band
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
              decoration: BoxDecoration(
                color: isDark
                    ? ArjunaColors.gold.withValues(alpha: 0.08)
                    : ArjunaColors.navy.withValues(alpha: 0.04),
                border: Border(
                  bottom: BorderSide(
                    color: accentColor.withValues(alpha: isDark ? 0.12 : 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.travel_explore_rounded,
                      color: accentColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sinyal Pasar Nusantara',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      height: 1.65,
                      letterSpacing: 0.1,
                    ),
                  ),
                  if (disclaimer.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Divider(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: isDark ? Colors.white30 : Colors.black26,
                          size: 13,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            disclaimer,
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
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
        ),
      ),
    );
  }
}
