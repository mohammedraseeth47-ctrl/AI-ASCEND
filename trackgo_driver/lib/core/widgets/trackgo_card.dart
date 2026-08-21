import 'package:flutter/material.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';

class TrackGoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final double? elevation;
  final BorderRadius? borderRadius;

  const TrackGoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.backgroundColor,
    this.borderSide,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.roundedLg;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceLight,
        borderRadius: radius,
        border: Border.fromBorderSide(
          borderSide ??
              const BorderSide(color: AppColors.cardBorderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(onTap: onTap, borderRadius: radius, child: cardContent),
      );
    }

    return cardContent;
  }
}
