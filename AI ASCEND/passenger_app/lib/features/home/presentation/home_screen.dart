import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../main_shell/providers/navigation_provider.dart';
import '../../search/presentation/widgets/route_detail_sheet.dart';
import '../providers/home_provider.dart';
import 'widgets/live_tracking_banner.dart';
import 'widgets/nearby_routes_list.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_stops_section.dart';
import 'widgets/tamil_nadu_map_preview.dart';

/// Home Dashboard screen for TrackGo passenger app focused on Tamil Nadu.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeProvider.notifier).loadHomeData(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row with Location Placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 15),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  homeState.locationName,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          UIHelpers.vSpace4,
                          Text(
                            _getGreeting(),
                            style: AppTextStyles.displaySmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => ref.read(navigationProvider.notifier).goToProfile(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.vSpace16,

                // Quick Search Bar Trigger
                AppTextField.search(
                  readOnly: true,
                  onTap: () => ref.read(navigationProvider.notifier).goToSearch(),
                  hintText: 'Search Villupuram, Cuddalore, Puducherry...',
                ),
                UIHelpers.vSpace16,

                // Live Hero Tracking Banner
                if (homeState.nearbyLiveBus != null) ...[
                  LiveTrackingBanner(
                    bus: homeState.nearbyLiveBus!,
                    onTrackPressed: () {
                      ref.read(navigationProvider.notifier).goToTracking();
                    },
                  ),
                  UIHelpers.vSpace16,
                ],

                // OpenStreetMap Mini Preview
                TamilNaduMapPreview(
                  onTap: () => ref.read(navigationProvider.notifier).goToTracking(),
                ),
                UIHelpers.vSpace16,

                // Quick Action Buttons Grid (Responsive 2x2)
                QuickActionsGrid(
                  actions: [
                    QuickActionItem(
                      title: 'Live Map',
                      icon: Icons.map_outlined,
                      color: AppColors.primary,
                      onTap: () => ref.read(navigationProvider.notifier).goToTracking(),
                    ),
                    QuickActionItem(
                      title: 'TN Routes',
                      icon: Icons.alt_route_rounded,
                      color: AppColors.routeBlue,
                      onTap: () => ref.read(navigationProvider.notifier).goToSearch(),
                    ),
                    QuickActionItem(
                      title: 'Bus Stands',
                      icon: Icons.pin_drop_outlined,
                      color: AppColors.routePurple,
                      onTap: () => ref.read(navigationProvider.notifier).goToSearch(),
                    ),
                    QuickActionItem(
                      title: 'My Trips',
                      icon: Icons.confirmation_number_outlined,
                      color: AppColors.accentAmber,
                      onTap: () => ref.read(navigationProvider.notifier).goToTrips(),
                    ),
                  ],
                ),
                UIHelpers.vSpace20,

                // Nearby Routes Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Tamil Nadu Routes',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.read(navigationProvider.notifier).goToSearch(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                UIHelpers.vSpace8,

                // Loading / Error / Content states
                if (homeState.isLoading) ...[
                  const AppSkeletonLoader(height: 80, borderRadius: 16),
                  UIHelpers.vSpace12,
                  const AppSkeletonLoader(height: 80, borderRadius: 16),
                ] else if (homeState.errorMessage != null) ...[
                  AppError(
                    message: homeState.errorMessage!,
                    onRetry: () => ref.read(homeProvider.notifier).loadHomeData(),
                  ),
                ] else if (homeState.nearbyRoutes.isEmpty) ...[
                  const AppEmptyState(
                    title: 'No Routes Found',
                    message: 'There are no active bus routes near your current location.',
                  ),
                ] else ...[
                  NearbyRoutesList(
                    routes: homeState.nearbyRoutes,
                    onRouteTap: (route) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => RouteDetailSheet(route: route),
                      );
                    },
                  ),
                ],
                UIHelpers.vSpace16,

                // Recent / Nearby Bus Stands Section Header
                if (homeState.recentStops.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Nearby Bus Stands',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  UIHelpers.vSpace12,
                  RecentStopsSection(
                    stops: homeState.recentStops,
                    onStopTap: (stop) {
                      UIHelpers.showSnackBar(
                        context,
                        message: '${stop.name} (${stop.code})',
                        icon: Icons.pin_drop_rounded,
                      );
                    },
                  ),
                  UIHelpers.vSpace16,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
