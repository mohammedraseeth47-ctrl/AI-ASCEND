import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum BadgeStatus { onTime, delayed, approaching, cancelled, info }

/// Reusable status badge and transit line chip.
class AppBadge extends StatelessWidget {
  final String text;
  final BadgeStatus status;
  final IconData? icon;
  final bool isSmall;

  const AppBadge({
    super.key,
    required this.text,
    this.status = BadgeStatus.info,
    this.icon,
    this.isSmall = false,
  });

  const AppBadge.onTime({
    super.key,
    this.text = 'On Time',
    this.icon = Icons.check_circle_outline_rounded,
    this.isSmall = false,
  }) : status = BadgeStatus.onTime;

  const AppBadge.delayed({
    super.key,
    required this.text,
    this.icon = Icons.schedule_rounded,
    this.isSmall = false,
  }) : status = BadgeStatus.delayed;

  const AppBadge.approaching({
    super.key,
    this.text = 'Approaching',
    this.icon = Icons.near_me_rounded,
    this.isSmall = false,
  }) : status = BadgeStatus.approaching;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case BadgeStatus.onTime:
        bg = AppColors.statusOnTimeLight;
        fg = const Color(0xFF047857);
        break;
      case BadgeStatus.delayed:
        bg = AppColors.statusDelayedLight;
        fg = const Color(0xFFB45309);
        break;
      case BadgeStatus.approaching:
        bg = AppColors.statusApproachingLight;
        fg = const Color(0xFF1D4ED8);
        break;
      case BadgeStatus.cancelled:
        bg = AppColors.statusCancelledLight;
        fg = AppColors.statusCancelled;
        break;
      case BadgeStatus.info:
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimaryContainer;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 7 : 9,
        vertical: isSmall ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 11 : 13, color: fg),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              text,
              style: (isSmall ? AppTextStyles.labelSmall : AppTextStyles.labelMedium).copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: isSmall ? 10 : 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Transit Line / Route Badge (e.g. "101 Express", "TN-32-AB-1234")
class RouteCodeBadge extends StatelessWidget {
  final String routeCode;
  final Color color;
  final bool isLarge;

  const RouteCodeBadge({
    super.key,
    required this.routeCode,
    this.color = AppColors.primary,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 10 : 7,
        vertical: isLarge ? 5 : 3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(80),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        routeCode,
        style: TextStyle(
          color: Colors.white,
          fontSize: isLarge ? 13 : 11,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
