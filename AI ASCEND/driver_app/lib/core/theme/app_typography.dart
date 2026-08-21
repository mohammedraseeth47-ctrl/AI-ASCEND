import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TrackGo Typography Design System
class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
    height: 1.4,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMutedLight,
  );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
