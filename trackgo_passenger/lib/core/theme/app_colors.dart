import 'package:flutter/material.dart';

/// App color palette for TrackGo Passenger application.
/// Provides rich, high-contrast, modern transit-oriented hues for both light and dark themes.
class AppColors {
  AppColors._();

  // Brand Primary (Transit Teal / Emerald)
  static const Color primary = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4EBaaa);
  static const Color primaryDark = Color(0xFF005B4F);
  static const Color primaryContainer = Color(0xFFE0F2F1);
  static const Color onPrimaryContainer = Color(0xFF004D40);

  // Secondary (Modern Deep Slate / Indigo)
  static const Color secondary = Color(0xFF0F172A);
  static const Color secondaryLight = Color(0xFF334155);
  static const Color secondaryDark = Color(0xFF020617);

  // Accent & Action (Vibrant Amber / Cyan)
  static const Color accent = Color(0xFF00B4D8);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentAmberLight = Color(0xFFFEF3C7);
  static const Color accentCoral = Color(0xFFFF6B6B);

  // Transit Status Badges
  static const Color statusOnTime = Color(0xFF10B981);
  static const Color statusOnTimeLight = Color(0xFFD1FAE5);
  static const Color statusDelayed = Color(0xFFF59E0B);
  static const Color statusDelayedLight = Color(0xFFFEF3C7);
  static const Color statusApproaching = Color(0xFF3B82F6);
  static const Color statusApproachingLight = Color(0xFFDBEAFE);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusCancelledLight = Color(0xFFFEE2E2);

  // Route Line Colors
  static const Color routeTeal = Color(0xFF0D9488);
  static const Color routeBlue = Color(0xFF2563EB);
  static const Color routeGreen = Color(0xFF16A34A);
  static const Color routePurple = Color(0xFF7C3AED);
  static const Color routeOrange = Color(0xFFEA580C);
  static const Color routePink = Color(0xFFDB2777);

  // Light Theme Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFECEFF1);

  // Dark Theme Surfaces
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF151D2C);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF2D3748);
  static const Color darkDivider = Color(0xFF1E293B);

  // Typography Colors - Light
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Typography Colors - Dark
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00897B), Color(0xFF004D40)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  static const LinearGradient ticketGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF047857)],
  );
}
