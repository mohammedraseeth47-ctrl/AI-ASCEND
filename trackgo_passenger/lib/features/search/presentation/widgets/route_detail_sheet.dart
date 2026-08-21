import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../models/route.dart' as app_models;
import '../../../main_shell/providers/navigation_provider.dart';
import '../../../tracking/providers/tracking_provider.dart';

/// Modal bottom sheet presenting complete stop sequences and schedule for a Tamil Nadu transit route.
class RouteDetailSheet extends ConsumerWidget {
  final app_models.Route route;

  const RouteDetailSheet({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
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
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (route.viaSummary.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            route.viaSummary,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Key Metrics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _metricItem(
                      context,
                      label: 'Frequency',
                      value: 'Every ${route.frequencyMinutes}m',
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  Expanded(
                    child: _metricItem(
                      context,
                      label: 'Fare',
                      value: '₹${route.fareRupees.toInt()}',
                      icon: Icons.currency_rupee_rounded,
                    ),
                  ),
                  Expanded(
                    child: _metricItem(
                      context,
                      label: 'Mock Buses',
                      value: '${route.activeBusesCount} Units',
                      icon: Icons.directions_bus_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Stops Timeline Header (Responsive wrap)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Route Stops (${route.stops.length})',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      route.operatingHours,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Stop Timeline List
            Expanded(
              child: route.stops.isEmpty
                  ? Center(
                      child: Text(
                        'Stop schedule details loading...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: route.stops.length,
                      itemBuilder: (context, index) {
                        final stop = route.stops[index];
                        final isFirst = index == 0;
                        final isLast = index == route.stops.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline Line and Node
                            SizedBox(
                              width: 22,
                              child: Column(
                                children: [
                                  Container(
                                    width: 2,
                                    height: 8,
                                    color: isFirst ? Colors.transparent : route.color,
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: (isFirst || isLast)
                                          ? route.color
                                          : (isDark ? AppColors.darkSurface : Colors.white),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: route.color, width: 2.5),
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 36,
                                    color: isLast ? Colors.transparent : route.color,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Stop info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stop.name,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: (isFirst || isLast) ? FontWeight.w700 : FontWeight.w500,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Stop Code: #${stop.code}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ETA Badge
                            if (stop.nextArrivalMinutes != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: AppBadge.onTime(
                                  text: 'In ${stop.nextArrivalMinutes}m',
                                  isSmall: true,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),

            // Bottom Track Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AppButton(
                text: 'Track on OpenStreetMap',
                prefixIcon: Icons.map_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(trackingProvider.notifier).selectRoute(route);
                  ref.read(navigationProvider.notifier).goToTracking();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
