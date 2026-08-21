import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../features/profile/providers/profile_provider.dart';
import 'app_routes.dart';
import 'app_theme.dart';

/// Main Application Root Widget for TrackGo Passenger.
class TrackGoApp extends ConsumerWidget {
  const TrackGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: TrackGoTheme.light,
      darkTheme: TrackGoTheme.dark,
      themeMode: profileState.themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
