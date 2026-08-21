import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Reusable empty state view for lists, search results, and bookmarks.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
    this.actionText,
    this.onAction,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText!,
                prefixIcon: actionIcon,
                width: 200,
                height: 46,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
