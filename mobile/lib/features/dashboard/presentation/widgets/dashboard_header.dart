import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends StatelessWidget {
  final String? lastUpdatedAt;

  const DashboardHeader({super.key, this.lastUpdatedAt});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Selamat Pagi';
    if (hour >= 11 && hour < 15) return 'Selamat Siang';
    if (hour >= 15 && hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _formatLastUpdated(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      // Try parsing as ISO8601
      final dt = DateTime.parse(raw);
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dt.toLocal());
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? const Color(0xFFE8C766)
        : const Color(0xFF0B9F91);
    final navy = isDark ? const Color(0xFFEAF8F4) : const Color(0xFF07345A);
    final formattedDate = _formatLastUpdated(lastUpdatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFE8C766).withValues(alpha: 0.12)
                    : const Color(0xFFFFFFFF).withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.24 : 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF07345A,
                    ).withValues(alpha: isDark ? 0.24 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.architecture_rounded,
                color: accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()} • Nusantara Market Signal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : const Color(0xFF59707B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pantau Harga Pangan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                      color: navy,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Analisis harga & tinjauan pangan nasional',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : const Color(0xFF6A7D85),
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if (formattedDate.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF16C7B7).withValues(alpha: 0.1)
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.radar_rounded, size: 14, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  'Update: $formattedDate',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFE8C766)
                        : const Color(0xFF0B7C72),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
