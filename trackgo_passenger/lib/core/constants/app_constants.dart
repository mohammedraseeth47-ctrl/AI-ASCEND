class AppConstants {
  AppConstants._();

  static const String appName = 'TrackGo';
  static const String appTagline = 'Smarter journeys. Real-time travel.';
  static const String appVersion = '1.0.0 (Phase 1 - Tamil Nadu)';

  // Storage Keys
  static const String keyOnboardingCompleted = 'trackgo_onboarding_completed';
  static const String keyThemeMode = 'trackgo_theme_mode';
  static const String keyFavoriteRoutes = 'trackgo_favorite_routes';
  static const String keyRecentSearches = 'trackgo_recent_searches';

  // Map Default Coordinates - Tamil Nadu (Villupuram - Cuddalore - Puducherry Region)
  static const double tamilNaduCenterLat = 11.8500;
  static const double tamilNaduCenterLng = 79.6500;
  static const double defaultZoom = 10.5;
  static const double minZoom = 7.0;
  static const double maxZoom = 18.0;

  // Specific Regional Hub Coordinates
  static const double villupuramLat = 11.9401;
  static const double villupuramLng = 79.4976;

  static const double cuddaloreLat = 11.7480;
  static const double cuddaloreLng = 79.7714;

  static const double puducherryLat = 11.9338;
  static const double puducherryLng = 79.8145;

  // Animation Timers
  static const Duration splashDuration = Duration(milliseconds: 2000);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration busPulseDuration = Duration(milliseconds: 1500);

  // Mock simulation intervals
  static const Duration busPositionUpdateInterval = Duration(seconds: 4);
}
