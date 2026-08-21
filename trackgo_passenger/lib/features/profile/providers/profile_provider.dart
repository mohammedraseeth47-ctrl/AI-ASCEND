import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/services/local_storage_service.dart';

/// State for Passenger Profile and App Preferences.
class ProfileState {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool soundAlertsEnabled;
  final int totalTrips;
  final double co2SavedKg;
  final int hoursSaved;

  const ProfileState({
    required this.themeMode,
    this.notificationsEnabled = true,
    this.soundAlertsEnabled = true,
    this.totalTrips = 42,
    this.co2SavedKg = 28.4,
    this.hoursSaved = 14,
  });

  ProfileState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? soundAlertsEnabled,
    int? totalTrips,
    double? co2SavedKg,
    int? hoursSaved,
  }) {
    return ProfileState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundAlertsEnabled: soundAlertsEnabled ?? this.soundAlertsEnabled,
      totalTrips: totalTrips ?? this.totalTrips,
      co2SavedKg: co2SavedKg ?? this.co2SavedKg,
      hoursSaved: hoursSaved ?? this.hoursSaved,
    );
  }
}

/// Notifier handling Theme switching, notification preferences, and eco metrics.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final LocalStorageService _storageService;

  ProfileNotifier(this._storageService)
      : super(ProfileState(
          themeMode: _parseThemeMode(_storageService.themeMode),
        ));

  static ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeString = 'system';
    if (mode == ThemeMode.light) modeString = 'light';
    if (mode == ThemeMode.dark) modeString = 'dark';

    await _storageService.setThemeMode(modeString);
    state = state.copyWith(themeMode: mode);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleSoundAlerts(bool value) {
    state = state.copyWith(soundAlertsEnabled: value);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return ProfileNotifier(storageService);
});
