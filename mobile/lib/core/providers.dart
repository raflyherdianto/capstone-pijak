import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import '../shared/data/commodity_repository.dart';
import '../shared/domain/models.dart';

enum UserMode { buyer, seller }

class AppSettings {
  final UserMode mode;
  final bool isDarkMode;
  final Color upColor;
  final Color downColor;
  final Color stableColor;

  AppSettings({
    required this.mode,
    this.isDarkMode = false,
    this.upColor = const Color(0xFFF43F5E), // Premium Crimson Rose
    this.downColor = const Color(0xFF10B981), // Premium Emerald Green
    this.stableColor = const Color(0xFF64748B), // Premium Slate Grey
  });

  AppSettings copyWith({
    UserMode? mode,
    bool? isDarkMode,
    Color? upColor,
    Color? downColor,
    Color? stableColor,
  }) {
    return AppSettings(
      mode: mode ?? this.mode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      upColor: upColor ?? this.upColor,
      downColor: downColor ?? this.downColor,
      stableColor: stableColor ?? this.stableColor,
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(_loadInitialSettings(_prefs));

  static AppSettings _loadInitialSettings(SharedPreferences prefs) {
    final modeIndex = prefs.getInt('user_mode') ?? 0;
    final isDark = prefs.getBool('is_dark_mode') ?? false;

    return AppSettings(
      mode: modeIndex < UserMode.values.length
          ? UserMode.values[modeIndex]
          : UserMode.buyer,
      isDarkMode: isDark,
    );
  }

  void toggleMode() {
    final newMode =
        state.mode == UserMode.buyer ? UserMode.seller : UserMode.buyer;
    state = state.copyWith(mode: newMode);
    _prefs.setInt('user_mode', newMode.index);
  }

  void toggleDarkMode() {
    final newDark = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newDark);
    _prefs.setBool('is_dark_mode', newDark);
  }

  void setMode(UserMode mode) {
    state = state.copyWith(mode: mode);
    _prefs.setInt('user_mode', mode.index);
  }

  Color getTrendColor(double change) {
    if (change == 0) return state.stableColor;

    if (state.mode == UserMode.buyer) {
      return change > 0 ? state.upColor : state.downColor;
    } else {
      return change > 0 ? state.downColor : state.upColor;
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final commodityRepositoryProvider = Provider<ICommodityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommodityRepository(apiClient);
});

final commoditiesProvider = FutureProvider<List<Commodity>>((ref) async {
  final repository = ref.watch(commodityRepositoryProvider);
  return repository.getCommodities();
});

final metadataProvider = FutureProvider<AppMetadata>((ref) async {
  final repository = ref.watch(commodityRepositoryProvider);
  return repository.getMetadata();
});
