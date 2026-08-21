import 'package:flutter/material.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';

class DriverAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;
  final bool isOnline;
  final bool showStatusIndicator;

  const DriverAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24.0,
    this.isOnline = true,
    this.showStatusIndicator = true,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length > 1 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryContainer,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(
              _initials,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primaryDark,
                fontSize: radius * 0.8,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );

    if (!showStatusIndicator) {
      return avatar;
    }

    final indicatorSize = radius * 0.55;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.textMutedLight,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
