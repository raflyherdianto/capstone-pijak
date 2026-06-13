import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import 'setting_card_wrapper.dart';

class AboutAppSection extends StatelessWidget {
  final AppMetadata metadata;

  const AboutAppSection({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final about = metadata.aboutUs;

    return SettingCardWrapper(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Image.asset('assets/images/app_logo.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        about['app_name'] ?? 'Arjuna',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Versi ${about['version'] ?? '1.0.0'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
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
