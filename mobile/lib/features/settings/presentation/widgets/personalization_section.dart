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
              onChanged: (_) =>
                  ref.read(settingsProvider.notifier).toggleMode(),
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
