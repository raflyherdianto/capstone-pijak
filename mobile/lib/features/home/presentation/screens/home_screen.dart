import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../shared/widgets/app_background.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBox() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Cari bahan pangan...',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Arjuna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: ClipRect(
            child: CustomPaint(
              painter: BatikKawungPainter(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.015)
                    : Colors.black.withValues(alpha: 0.025),
              ),
            ),
          ),
        ),
      ),
      body: commoditiesAsync.when(
        data: (commodities) {
          final filteredCommodities = commodities
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(commoditiesProvider),
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSearchBox(),
                  const SizedBox(height: 20),
                  if (filteredCommodities.isEmpty) ...[
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bahan pangan tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coba cari kata kunci lainnya',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCommodities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final commodity = filteredCommodities[index];
                        return CommodityCard(
                          commodity: commodity,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(commodity: commodity),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          );
        },
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildSearchBox(),
              const SizedBox(height: 20),
              const ShimmerListPlaceholder(itemCount: 4),
              const SizedBox(height: 100),
            ],
          ),
        ),
        error: (error, stackTrace) => AppErrorWidget(
          title: 'Gagal Memuat Data',
          message: error.toString(),
          onRetry: () => ref.refresh(commoditiesProvider),
        ),
      ),
    );
  }
}
