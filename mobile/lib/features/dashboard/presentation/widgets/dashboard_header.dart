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

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return '🌅';
    if (hour >= 11 && hour < 15) return '☀️';
    if (hour >= 15 && hour < 18) return '🌤️';
    return '🌙';
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
    final accentColor =
        isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final formattedDate = _formatLastUpdated(lastUpdatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting row
        Row(
          children: [
            Text(
              _getGreetingEmoji(),
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  'Pantau Harga Pangan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                ),
              ],
            ),
          ],
        ),

        // Last updated badge
        if (formattedDate.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update_rounded,
                  size: 12,
                  color: accentColor,
                ),
                const SizedBox(width: 5),
                Text(
                  'Update: $formattedDate',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
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
