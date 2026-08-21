import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Error state display widget with custom retry action.
class AppError extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final IconData icon;
  final bool isCompact;

  const AppError({
    super.key,
    this.title = 'Unable to Load Data',
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Try Again',
    this.icon = Icons.error_outline_rounded,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.statusCancelledLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.statusCancelled.withAlpha(50)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.statusCancelled),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.statusCancelled,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onRetry != null)
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.statusCancelled),
                onPressed: onRetry,
                tooltip: retryButtonText,
              ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.statusCancelledLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: AppColors.statusCancelled,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: retryButtonText,
                prefixIcon: Icons.refresh_rounded,
                width: 160,
                height: 46,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
