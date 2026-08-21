import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/bus.dart';
import '../../../../models/route.dart' as app_models;

/// Interactive telemetry bottom sheet displaying Tamil Nadu vehicle status with zero overflow.
class TrackingBottomSheet extends StatelessWidget {
  final Bus bus;
  final app_models.Route route;
  final VoidCallback onRecenter;
  final VoidCallback onNotify;

  const TrackingBottomSheet({
    super.key,
    required this.bus,
    required this.route,
    required this.onRecenter,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard.elevated(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 32,
              height: 3.5,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          UIHelpers.vSpace8,

          // Header row with route badge, registration plate, and LIVE DRIVER badge (Responsive Wrap)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RouteCodeBadge(routeCode: bus.routeNumber, color: route.color, isLarge: false),
                  const SizedBox(width: 8),
                  Text(
                    bus.busNumber,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              AppBadge(
                text: bus.isDriver ? 'LIVE DRIVER' : 'DEMO BUS',
                status: bus.isDriver ? BadgeStatus.onTime : BadgeStatus.info,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Route Name / Corridor
          Text(
            bus.driverName != null ? '${bus.routeName} • ${bus.driverName}' : bus.routeName,
            style: AppTextStyles.headlineSmall.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Live Metrics Row (Responsive Expanded Layout)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _metricItem(
                    context,
                    icon: Icons.wifi_tethering_rounded,
                    value: bus.status,
                    label: 'Status',
                    valueColor: AppColors.statusOnTime,
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                Expanded(
                  child: _metricItem(
                    context,
                    icon: Icons.speed_rounded,
                    value: '${bus.speedKmh.toStringAsFixed(1)} km/h',
                    label: 'Speed',
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                Expanded(
                  child: _metricItem(
                    context,
                    icon: Icons.navigation_rounded,
                    value: '${bus.heading.toStringAsFixed(0)}°',
                    label: 'Heading',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Bus Route ID
          Row(
            children: [
              const Icon(Icons.alt_route_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Route: ${bus.routeId}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons (Recenter & Alert)
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  text: 'Recenter',
                  prefixIcon: Icons.my_location_rounded,
                  height: 40,
                  onPressed: onRecenter,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  text: 'Stop Alert',
                  prefixIcon: Icons.notifications_active_rounded,
                  height: 40,
                  onPressed: onNotify,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
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
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 9,
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
