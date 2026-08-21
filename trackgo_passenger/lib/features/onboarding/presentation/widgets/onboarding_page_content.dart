import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/onboarding_item_model.dart';

/// Single page content representation for the onboarding carousel.
class OnboardingPageContent extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingPageContent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration / Icon Container with dynamic backdrop
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.primaryColor.withAlpha(isDark ? 20 : 35),
                  ),
                ),
                // Inner ring
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.primaryColor.withAlpha(isDark ? 35 : 60),
                  ),
                ),
                // Main Icon Box
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [item.primaryColor, item.secondaryColor],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: item.primaryColor.withAlpha(120),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    size: 46,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Feature Badge Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: item.primaryColor.withAlpha(isDark ? 40 : 25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: item.primaryColor.withAlpha(100),
                  width: 1,
                ),
              ),
              child: Text(
                item.badgeText,
                style: AppTextStyles.labelSmall.copyWith(
                  color: item.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              item.title,
              style: AppTextStyles.displaySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              item.description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
