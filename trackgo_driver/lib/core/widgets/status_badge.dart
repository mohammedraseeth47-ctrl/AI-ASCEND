import 'package:flutter/material.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';

enum StatusBadgeType {
  available,
  onDuty,
  onBreak,
  scheduled,
  ready,
  inProgress,
  completed,
  cancelled,
  custom,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final Color? customColor;
  final Color? customBackgroundColor;
  final IconData? icon;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.scheduled,
    this.customColor,
    this.customBackgroundColor,
    this.icon,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: customBackgroundColor ?? config.backgroundColor,
        borderRadius: AppRadius.roundedPill,
        border: Border.all(
          color: (customColor ?? config.textColor).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot && icon == null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: customColor ?? config.textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 1),
          ],
          if (icon != null) ...[
            Icon(icon, size: 13, color: customColor ?? config.textColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: customColor ?? config.textColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _StatusBadgeConfig _getConfig() {
    switch (type) {
      case StatusBadgeType.available:
      case StatusBadgeType.onDuty:
      case StatusBadgeType.completed:
        return const _StatusBadgeConfig(
          textColor: AppColors.successDark,
          backgroundColor: AppColors.successLight,
        );

      case StatusBadgeType.scheduled:
      case StatusBadgeType.onBreak:
        return const _StatusBadgeConfig(
          textColor: AppColors.warningDark,
          backgroundColor: AppColors.warningLight,
        );

      case StatusBadgeType.ready:
        return const _StatusBadgeConfig(
          textColor: Color(0xFF0284C7),
          backgroundColor: Color(0xFFE0F2FE),
        );

      case StatusBadgeType.inProgress:
        return const _StatusBadgeConfig(
          textColor: AppColors.primaryDark,
          backgroundColor: AppColors.primaryContainer,
        );

      case StatusBadgeType.cancelled:
        return const _StatusBadgeConfig(
          textColor: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
        );

      case StatusBadgeType.custom:
        return _StatusBadgeConfig(
          textColor: customColor ?? AppColors.textPrimaryLight,
          backgroundColor: customBackgroundColor ?? AppColors.primaryContainer,
        );
    }
  }
}

class _StatusBadgeConfig {
  final Color textColor;
  final Color backgroundColor;

  const _StatusBadgeConfig({
    required this.textColor,
    required this.backgroundColor,
  });
}
