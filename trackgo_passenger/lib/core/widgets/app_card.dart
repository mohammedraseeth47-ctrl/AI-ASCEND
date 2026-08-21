import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppCardVariant { standard, elevated, outlined, tinted, gradient }

/// A container card with subtle borders, elevation shadows, and touch interactions.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? customColor;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.customColor,
    this.gradient,
    this.width,
    this.height,
  });

  const AppCard.elevated({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.customColor,
    this.gradient,
    this.width,
    this.height,
  }) : variant = AppCardVariant.elevated;

  const AppCard.tinted({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.customColor,
    this.gradient,
    this.width,
    this.height,
  }) : variant = AppCardVariant.tinted;

  const AppCard.gradient({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.customColor,
    this.gradient = AppColors.primaryGradient,
    this.width,
    this.height,
  }) : variant = AppCardVariant.gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Border? border;
    List<BoxShadow>? boxShadow;
    Gradient? effectiveGradient = gradient;

    switch (variant) {
      case AppCardVariant.standard:
        backgroundColor = customColor ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface);
        border = Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        );
        break;
      case AppCardVariant.elevated:
        backgroundColor = customColor ?? (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface);
        boxShadow = [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(80) : Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case AppCardVariant.outlined:
        backgroundColor = Colors.transparent;
        border = Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        );
        break;
      case AppCardVariant.tinted:
        backgroundColor = customColor ?? (isDark ? const Color(0xFF00382E) : AppColors.primaryContainer);
        border = Border.all(
          color: isDark ? AppColors.primaryDark : const Color(0xFFB2DFDB),
          width: 1,
        );
        break;
      case AppCardVariant.gradient:
        backgroundColor = Colors.transparent;
        effectiveGradient = gradient ?? AppColors.primaryGradient;
        boxShadow = [
          BoxShadow(
            color: AppColors.primary.withAlpha(50),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ];
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveGradient == null ? backgroundColor : null,
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
