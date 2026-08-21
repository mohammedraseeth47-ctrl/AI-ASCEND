import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

/// A modern, customizable button supporting multiple variants, loading states, and icons.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  });

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  }) : variant = AppButtonVariant.outlined;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 44,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  }) : variant = AppButtonVariant.text;

  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  }) : variant = AppButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.darkSurfaceVariant : AppColors.secondary;
        foregroundColor = Colors.white;
        break;
      case AppButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.primaryLight : AppColors.primary;
        borderSide = BorderSide(
          color: isDark ? AppColors.primaryLight : AppColors.primary,
          width: 1.5,
        );
        break;
      case AppButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.primaryLight : AppColors.primary;
        break;
      case AppButtonVariant.danger:
        backgroundColor = AppColors.statusCancelled;
        foregroundColor = Colors.white;
        break;
    }

    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18, color: foregroundColor),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 6),
                Icon(suffixIcon, size: 18, color: foregroundColor),
              ],
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: effectiveOnPressed == null && !isLoading
            ? (isDark ? AppColors.darkSurfaceVariant.withAlpha(128) : AppColors.lightBorder)
            : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        shape: borderSide != BorderSide.none
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: borderSide,
              )
            : null,
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
