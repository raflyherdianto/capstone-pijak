import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/shimmer_placeholder.dart';
import '../../../../core/providers.dart';
import '../widgets/setting_section_title.dart';
import '../widgets/personalization_section.dart';
import '../widgets/about_app_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadataAsync = ref.watch(metadataProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: metadataAsync.when(
        data: (metadata) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SettingSectionTitle(title: 'Personalisasi'),
              const SizedBox(height: 12),
              const PersonalizationSection(),
              const SizedBox(height: 32),
              const SettingSectionTitle(title: 'Tentang Aplikasi'),
              const SizedBox(height: 12),
              AboutAppSection(metadata: metadata),
            ],
          );
        },
        loading: () => const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingSectionTitle(title: 'Personalisasi'),
              SizedBox(height: 12),
              PersonalizationSection(),
              SizedBox(height: 32),
              SettingSectionTitle(title: 'Tentang Aplikasi'),
              SizedBox(height: 12),
              ShimmerInsightPlaceholder(),
            ],
          ),
        ),
        error: (error, stack) => AppErrorWidget(
          title: 'Gagal Memuat Data',
          message: error.toString(),
          onRetry: () => ref.refresh(commoditiesProvider),
        ),
      ),
    );
  }
}
