import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Common layout helpers, spacing, and feedback notifications.
class UIHelpers {
  UIHelpers._();

  // Spacings - Vertical
  static const Widget vSpace4 = SizedBox(height: 4);
  static const Widget vSpace8 = SizedBox(height: 8);
  static const Widget vSpace12 = SizedBox(height: 12);
  static const Widget vSpace16 = SizedBox(height: 16);
  static const Widget vSpace20 = SizedBox(height: 20);
  static const Widget vSpace24 = SizedBox(height: 24);
  static const Widget vSpace32 = SizedBox(height: 32);
  static const Widget vSpace40 = SizedBox(height: 40);

  // Spacings - Horizontal
  static const Widget hSpace4 = SizedBox(width: 4);
  static const Widget hSpace8 = SizedBox(width: 8);
  static const Widget hSpace12 = SizedBox(width: 12);
  static const Widget hSpace16 = SizedBox(width: 16);
  static const Widget hSpace20 = SizedBox(width: 20);
  static const Widget hSpace24 = SizedBox(width: 24);

  // Paddings
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets compactPadding = EdgeInsets.all(12);

  // Border Radii
  static final BorderRadius radiusSmall = BorderRadius.circular(8);
  static final BorderRadius radiusMedium = BorderRadius.circular(14);
  static final BorderRadius radiusLarge = BorderRadius.circular(20);
  static final BorderRadius radiusSheet = const BorderRadius.vertical(top: Radius.circular(24));

  // Snackbar Notification Helpers
  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    bool isSuccess = false,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              hSpace12,
            ] else if (isError) ...[
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              hSpace12,
            ] else if (isSuccess) ...[
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              hSpace12,
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? AppColors.statusCancelled
            : isSuccess
                ? AppColors.statusOnTime
                : AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }
}
