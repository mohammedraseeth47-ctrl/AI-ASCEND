import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated page indicator with active pill expansion.
class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 28 : 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
