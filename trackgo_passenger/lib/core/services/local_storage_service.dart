import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Local storage service managing persistence for onboarding completion, theme preferences, and favorites.
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Factory initializer for async SharedPreferences acquisition.
  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // --- Onboarding Completion ---
  bool get isOnboardingCompleted {
    return _prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
  }

  Future<bool> setOnboardingCompleted(bool completed) async {
    return _prefs.setBool(AppConstants.keyOnboardingCompleted, completed);
  }

  // --- Theme Mode ('system', 'light', 'dark') ---
  String get themeMode {
    return _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  Future<bool> setThemeMode(String mode) async {
    return _prefs.setString(AppConstants.keyThemeMode, mode);
  }

  // --- Favorite Routes List ---
  List<String> get favoriteRouteIds {
    return _prefs.getStringList(AppConstants.keyFavoriteRoutes) ?? ['R-101', 'R-104'];
  }

  Future<bool> toggleFavoriteRoute(String routeId) async {
    final favorites = favoriteRouteIds.toSet();
    if (favorites.contains(routeId)) {
      favorites.remove(routeId);
    } else {
      favorites.add(routeId);
    }
    return _prefs.setStringList(AppConstants.keyFavoriteRoutes, favorites.toList());
  }

  // --- Clear / Reset Preferences ---
  Future<bool> resetAll() async {
    return _prefs.clear();
  }
}
