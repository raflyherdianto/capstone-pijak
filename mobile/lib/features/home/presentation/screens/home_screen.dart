import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../shared/domain/models.dart';
import '../../../../shared/widgets/arjuna_brand.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/shimmer_placeholder.dart';
import '../../../detail/presentation/screens/detail_screen.dart';
import '../widgets/commodity_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchInput = '';
  String _searchQuery = '';
  String _lastFilterKey = '';
  List<Commodity>? _lastFiltered;
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    setState(() => _searchInput = value);
    _searchDebounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _searchQuery = value);
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() {
      _searchInput = '';
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final metadataAsync = ref.watch(metadataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = ArjunaColors.accent(isDark);

    return Scaffold(
      backgroundColor: Colors.transparent,
      // ── AppBar with integrated search ──────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const ArjunaAppBarBackground(),
        // Integrated search in the title area
        title: _SearchField(
          controller: _searchController,
          focusNode: _searchFocus,
          isDark: isDark,
          accentColor: accentColor,
          hasText: _searchInput.isNotEmpty,
          onChanged: _onSearchChanged,
          onClear: _clearSearch,
        ),
        titleSpacing: 16,
        toolbarHeight: 64,
      ),

      // ── Body ──────────────────────────────────────────────────────────
      body: commoditiesAsync.when(
        data: (commodities) {
          final normalizedQuery = _searchQuery.trim().toLowerCase();
          final filterKey =
              '${identityHashCode(commodities)}::$normalizedQuery';
          final filtered = _lastFilterKey == filterKey && _lastFiltered != null
              ? _lastFiltered!
              : commodities
                    .where(
                      (c) => c.name.toLowerCase().contains(normalizedQuery),
                    )
                    .toList();
          if (_lastFilterKey != filterKey) {
            _lastFilterKey = filterKey;
            _lastFiltered = filtered;
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(commoditiesProvider),
            color: accentColor,
            edgeOffset: 4,
            displacement: 28,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                // Result count header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: _ResultHeader(
                      filteredCount: filtered.length,
                      totalCount: commodities.length,
                      isFiltering: _searchQuery.isNotEmpty,
                      lastUpdatedAt: metadataAsync.maybeWhen(
                        data: (metadata) => metadata.updatedAt,
                        orElse: () => '',
                      ),
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                  ),
                ),

                // Empty state
                if (commodities.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Data Komoditas Belum Tersedia',
                      message:
                          'Tarik untuk memuat ulang atau coba lagi saat koneksi lebih stabil.',
                      actionLabel: 'Muat Ulang',
                      onAction: () => ref.refresh(commoditiesProvider),
                    ),
                  )
                else if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Tidak Ada Hasil',
                      message:
                          '"$_searchQuery" tidak cocok dengan daftar bahan pangan. Coba kata kunci yang lebih umum.',
                      actionLabel: 'Bersihkan',
                      onAction: _clearSearch,
                    ),
                  )
                else
                  // Commodity list
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final commodity = filtered[index];
                        return CommodityCard(
                          commodity: commodity,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(commodity: commodity),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    ShimmerCardPlaceholder(height: 28),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: 5,
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                itemBuilder: (_, i) => const CommodityCardShimmer(),
              ),
            ),
          ],
        ),
        error: (error, _) => AppErrorWidget(
          title: 'Gagal Memuat Data',
          message: error.toString(),
          onRetry: () => ref.refresh(commoditiesProvider),
        ),
      ),
    );
  }
}

// ── Search Field ───────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final Color accentColor;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.accentColor,
    required this.hasText,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0A2638)
            : Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? ArjunaColors.gold.withValues(alpha: 0.14)
              : ArjunaColors.navy.withValues(alpha: 0.08),
        ),
      ),
      child: Semantics(
        textField: true,
        label: 'Cari bahan pangan',
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : ArjunaColors.navy,
          ),
          decoration: InputDecoration(
            hintText: 'Cari bahan pangan...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : ArjunaColors.muted,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 18,
              color: isDark ? Colors.white38 : ArjunaColors.muted,
            ),
            suffixIcon: hasText
                ? IconButton(
                    onPressed: onClear,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: isDark ? Colors.white60 : ArjunaColors.navy,
                    ),
                    tooltip: 'Bersihkan pencarian',
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 12,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

// ── Result Header ──────────────────────────────────────────────────────────

class _ResultHeader extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final bool isFiltering;
  final String lastUpdatedAt;
  final bool isDark;
  final Color accentColor;

  const _ResultHeader({
    required this.filteredCount,
    required this.totalCount,
    required this.isFiltering,
    required this.lastUpdatedAt,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFiltering ? 'Hasil Pencarian' : 'Semua Bahan Pangan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              Text(
                isFiltering
                    ? '$filteredCount dari $totalCount komoditas'
                    : _subtitleText,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.45)
                      : Colors.black.withValues(alpha: 0.38),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accentColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFiltering ? Icons.search_rounded : Icons.storefront_rounded,
                size: 13,
                color: accentColor,
              ),
              const SizedBox(width: 4),
              Text(
                isFiltering ? '$filteredCount ditemukan' : '$totalCount item',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _subtitleText {
    if (lastUpdatedAt.trim().isEmpty) {
      return '$totalCount komoditas tersedia';
    }

    try {
      final date = DateTime.parse(lastUpdatedAt);
      final formatted =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      return '$totalCount komoditas tersedia - Update $formatted';
    } catch (_) {
      return '$totalCount komoditas tersedia - Update $lastUpdatedAt';
    }
  }
}
