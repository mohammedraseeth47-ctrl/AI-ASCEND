import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/route.dart' as app_models;

/// Responsive bus route cards designed specifically to avoid overflow on narrow screens.
class NearbyRoutesList extends StatelessWidget {
  final List<app_models.Route> routes;
  final ValueChanged<app_models.Route> onRouteTap;

  const NearbyRoutesList({
    super.key,
    required this.routes,
    required this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: routes.map((route) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            onTap: () => onRouteTap(route),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Route Badge, Title, and Chevron
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RouteCodeBadge(
                      routeCode: route.routeNumber,
                      color: route.color,
                      isLarge: false,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route.routeName,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (route.viaSummary.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              route.viaSummary,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bottom Wrap Section: Buses active, Frequency, and Fare
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Active buses count badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_bus_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${route.activeBusesCount} buses active',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Frequency
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Every ${route.frequencyMinutes}m',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),

                    // Fare
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 35 : 15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹${route.fareRupees.toInt()}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
