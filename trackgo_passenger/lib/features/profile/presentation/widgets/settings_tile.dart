import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Clean settings tile row with customizable trailing and click action.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryIconColor = iconColor ?? AppColors.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryIconColor.withAlpha(isDark ? 35 : 20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryIconColor, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            )
          : null,
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            size: 20,
          ),
    );
  }
}
