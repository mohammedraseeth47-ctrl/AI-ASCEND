import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/bus_stop.dart';
import '../../../../models/route.dart' as app_models;

/// Search result card for a Tamil Nadu transit route with zero overflow.
class RouteSearchResultItem extends StatelessWidget {
  final app_models.Route route;
  final VoidCallback onTap;

  const RouteSearchResultItem({
    super.key,
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RouteCodeBadge(routeCode: route.routeNumber, color: route.color, isLarge: false),
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
                          fontSize: 14,
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
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Metadata Wrap (Fare, Frequency, Active Units)
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                Text(
                  'Fare ₹${route.fareRupees.toInt()}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '•',
                  style: TextStyle(color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                ),
                Text(
                  'Every ${route.frequencyMinutes}m',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Search result card for a Tamil Nadu bus stand or stop with responsive wrap.
class StopSearchResultItem extends StatelessWidget {
  final BusStop stop;
  final VoidCallback onTap;

  const StopSearchResultItem({
    super.key,
    required this.stop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 35 : 20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stop.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (stop.nextArrivalMinutes != null)
                        AppBadge.onTime(
                          text: '${stop.nextArrivalMinutes}m',
                          isSmall: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Code: #${stop.code} • Lines: ${stop.passingRouteNumbers.join(', ')}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
