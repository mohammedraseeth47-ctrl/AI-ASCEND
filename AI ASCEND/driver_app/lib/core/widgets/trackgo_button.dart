import 'package:flutter/material.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';

enum TrackGoButtonVariant { primary, secondary, outline, text, danger }

class TrackGoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final TrackGoButtonVariant variant;
  final bool isFullWidth;
  final double? height;

  const TrackGoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = TrackGoButtonVariant.primary,
    this.isFullWidth = true,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget childContent;
    if (isLoading) {
      childContent = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == TrackGoButtonVariant.outline ||
                    variant == TrackGoButtonVariant.text
                ? AppColors.primary
                : Colors.white,
          ),
        ),
      );
    } else {
      final textWidget = Flexible(
        child: Text(
          text,
          style: AppTypography.labelLarge.copyWith(
            color: _getTextColor(context),
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );

      if (icon != null) {
        childContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: _getTextColor(context)),
            const SizedBox(width: AppSpacing.sm),
            textWidget,
          ],
        );
      } else {
        childContent = textWidget;
      }
    }

    Widget button;
    switch (variant) {
      case TrackGoButtonVariant.primary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
            elevation: 0,
          ),
          child: childContent,
        );
        break;

      case TrackGoButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
            elevation: 0,
          ),
          child: childContent,
        );
        break;

      case TrackGoButtonVariant.outline:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            foregroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
          ),
          child: childContent,
        );
        break;

      case TrackGoButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
          ),
          child: childContent,
        );
        break;

      case TrackGoButtonVariant.danger:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
            elevation: 0,
          ),
          child: childContent,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }

    return SizedBox(height: height, child: button);
  }

  Color _getTextColor(BuildContext context) {
    if (onPressed == null && !isLoading) {
      return AppColors.textMutedLight;
    }
    switch (variant) {
      case TrackGoButtonVariant.primary:
      case TrackGoButtonVariant.danger:
        return Colors.white;
      case TrackGoButtonVariant.secondary:
        return AppColors.onPrimaryContainer;
      case TrackGoButtonVariant.outline:
      case TrackGoButtonVariant.text:
        return AppColors.primary;
    }
  }
}
