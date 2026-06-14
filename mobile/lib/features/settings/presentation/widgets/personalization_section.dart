import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import 'setting_card_wrapper.dart';

class PersonalizationSection extends ConsumerWidget {
  const PersonalizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return SettingCardWrapper(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Mode Perspektif'),
            subtitle: Text(
              settings.mode == UserMode.buyer
                  ? 'Mode Pembeli (Waspada kenaikan)'
                  : 'Mode Pedagang (Senang kenaikan)',
            ),
            trailing: Switch(
              value: settings.mode == UserMode.seller,
              onChanged: (value) async {
                final isBuyer = settings.mode == UserMode.buyer;
                final description = isBuyer
                    ? 'Perspektif akan diubah ke Pedagang. Warna harga naik akan menjadi hijau (menguntungkan) dan harga turun menjadi merah.'
                    : 'Perspektif akan diubah ke Pembeli. Warna harga turun akan menjadi hijau (menguntungkan) dan harga naik menjadi merah.';

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return AlertDialog(
                      backgroundColor: isDark ? const Color(0xFF0A2638) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFFE8C766).withValues(alpha: 0.12)
                              : const Color(0xFF07345A).withValues(alpha: 0.08),
                        ),
                      ),
                      title: Text(
                        'Ubah Perspektif?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF07345A),
                        ),
                      ),
                      content: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : const Color(0xFF6A7D85),
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFFE8C766) : const Color(0xFF16C7B7),
                            foregroundColor: isDark ? const Color(0xFF031827) : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Ubah',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  ref.read(settingsProvider.notifier).toggleMode();
                }
              },
              activeThumbColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Mode Gelap'),
            subtitle: const Text('Gunakan tema gelap'),
            trailing: Switch(
              value: settings.isDarkMode,
              onChanged: (_) =>
                  ref.read(settingsProvider.notifier).toggleDarkMode(),
              activeThumbColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
