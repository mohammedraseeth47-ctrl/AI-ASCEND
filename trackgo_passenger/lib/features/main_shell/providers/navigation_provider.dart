import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation tabs in TrackGo passenger app.
enum MainTab { home, search, tracking, trips, profile }

/// Notifier managing active tab in the main application shell.
class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setTab(int index) {
    if (index >= 0 && index <= 4) {
      state = index;
    }
  }

  void goToHome() => state = 0;
  void goToSearch() => state = 1;
  void goToTracking() => state = 2;
  void goToTrips() => state = 3;
  void goToProfile() => state = 4;
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});
