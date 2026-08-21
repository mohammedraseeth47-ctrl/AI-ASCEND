import 'package:flutter/material.dart';

/// TrackGo Centralized Color Palette
/// Designed for high readability, transit-grade contrast, and professional aesthetics.
abstract class AppColors {
  // Brand / Primary Palette (Transit Blue / Deep Navy)
  static const Color primary = Color(0xFF0284C7); // Vibrant Transit Sky Blue
  static const Color primaryDark = Color(0xFF0369A1);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryContainer = Color(0xFFE0F2FE);
  static const Color onPrimaryContainer = Color(0xFF0369A1);

  // Secondary Accent (Electric Indigo / Teal)
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color secondaryDark = Color(0xFF0284C7);
  static const Color secondaryContainer = Color(0xFFF0F9FF);
  static const Color accent = Color(0xFF06B6D4);

  // Neutral Background & Surface Tones (Dark & Light)
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE2E8F0); // Slate-200

  static const Color backgroundDark = Color(0xFF0B132B); // Deep Night Blue
  static const Color surfaceDark = Color(0xFF1C2541);
  static const Color surfaceElevatedDark = Color(0xFF243258);
  static const Color cardBorderDark = Color(0xFF3A506B);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate-900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate-600
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate-400

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF64748B);

  // Status & Semantic Colors
  static const Color success = Color(
    0xFF10B981,
  ); // Emerald Green (Available / On Time)
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF065F46);

  static const Color warning = Color(
    0xFFF59E0B,
  ); // Amber (Scheduled / Delay / Notice)
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF92400E);

  static const Color error = Color(
    0xFFEF4444,
  ); // Crimson Red (Cancelled / Alert)
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);

  static const Color info = Color(0xFF3B82F6); // Blue Info
  static const Color infoLight = Color(0xFFDBEAFE);

  // Transit Specific Colors
  static const Color busActive = Color(0xFF10B981);
  static const Color busInactive = Color(0xFF94A3B8);
  static const Color routeIndicator = Color(0xFF0284C7);
  static const Color terminalStop = Color(0xFF6366F1);
}
