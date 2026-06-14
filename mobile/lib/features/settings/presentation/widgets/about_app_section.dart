import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import '../../../../shared/widgets/arjuna_brand.dart';
import 'setting_card_wrapper.dart';

class AboutAppSection extends StatelessWidget {
  final AppMetadata metadata;

  const AboutAppSection({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final about = metadata.aboutUs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SettingCardWrapper(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ArjunaLogoMark(size: 58, padding: 3, radius: 18),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        about['app_name'] ?? 'Arjuna',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: ArjunaColors.title(isDark),
                        ),
                      ),
                      Text(
                        'Versi ${about['version'] ?? '1.0.0'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              about['description'] ?? '',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('Developer', about['developer'] ?? ''),
            _buildInfoRow('Status', 'Stable Release'),
            _buildInfoRow('Update Terakhir', metadata.updatedAt),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
