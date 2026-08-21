import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App typography definitions for TrackGo.
class AppTextStyles {
  AppTextStyles._();

  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // Labels & Badges
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Transit Specific (Bus Numbers, Timers, ETAs)
  static const TextStyle busNumber = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle etaLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: -0.5,
  );

  static const TextStyle etaSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );
}
