import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../shared/widgets/arjuna_brand.dart';
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
  String _searchQuery = '';
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commoditiesAsync = ref.watch(commoditiesProvider);
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
          onChanged: (value) => setState(() => _searchQuery = value),
          onClear: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),
        titleSpacing: 16,
        toolbarHeight: 64,
      ),

      // ── Body ──────────────────────────────────────────────────────────
      body: commoditiesAsync.when(
        data: (commodities) {
          final filtered = commodities
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(commoditiesProvider),
            color: accentColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Result count header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                    child: _ResultHeader(
                      filteredCount: filtered.length,
                      totalCount: commodities.length,
                      isFiltering: _searchQuery.isNotEmpty,
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                  ),
                ),

                // Empty state
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(query: _searchQuery, isDark: isDark),
                  )
                else
                  // Commodity list
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 10),
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
                itemBuilder: (_, i) => const ShimmerCardPlaceholder(height: 92),
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
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.accentColor,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? ArjunaColors.gold.withValues(alpha: 0.14)
              : ArjunaColors.navy.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
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
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : ArjunaColors.navy.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: isDark ? Colors.white60 : ArjunaColors.navy,
                    ),
                  ),
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
    );
  }
}

// ── Result Header ──────────────────────────────────────────────────────────

class _ResultHeader extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final bool isFiltering;
  final bool isDark;
  final Color accentColor;

  const _ResultHeader({
    required this.filteredCount,
    required this.totalCount,
    required this.isFiltering,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFiltering ? 'Hasil Pencarian' : 'Semua Bahan Pangan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                isFiltering
                    ? '$filteredCount dari $totalCount komoditas'
                    : '$totalCount komoditas tersedia',
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

        // Right badge — total pill
        if (!isFiltering)
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
                Icon(Icons.storefront_rounded, size: 13, color: accentColor),
                const SizedBox(width: 4),
                Text(
                  '$totalCount item',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          )
        else
          // Filter active badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentColor.withValues(alpha: 0.15)),
            ),
            child: Text(
              '$filteredCount ditemukan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  final bool isDark;

  const _EmptyState({required this.query, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 36,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tidak Ditemukan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$query" tidak ada dalam daftar bahan pangan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : Colors.black.withValues(alpha: 0.38),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
