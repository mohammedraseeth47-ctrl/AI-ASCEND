import 'package:flutter/material.dart';
import '../features/main_shell/presentation/main_shell_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

/// Central named routing configuration for TrackGo.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String main = '/main';

  /// Standard route generator for named route navigation.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainShellScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
