import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/driver_avatar.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/section_header.dart';
import 'package:trackgo_driver/core/widgets/status_badge.dart';
import 'package:trackgo_driver/core/widgets/trackgo_button.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/home/presentation/screens/assignment_detail_screen.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadDashboardData();
      context.read<TripsController>().loadTrips();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final authController = context.watch<AuthController>();
    final tripsController = context.watch<TripsController>();
    final user = authController.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: homeController.isLoading
            ? const LoadingStateView(
                message: 'Loading operational dashboard...',
              )
            : homeController.errorMessage != null
            ? ErrorStateView(
                message: homeController.errorMessage!,
                onRetry: () {
                  homeController.loadDashboardData();
                  tripsController.loadTrips();
                },
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await homeController.loadDashboardData();
                  if (context.mounted) {
                    await context.read<TripsController>().loadTrips();
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Driver Profile Header
                      _buildDriverHeader(user, authController, homeController),
                      const SizedBox(height: AppSpacing.lg),

                      // 2. Metrics Summary Row (Responsive)
                      if (homeController.metrics != null) ...[
                        _buildMetricsRow(homeController),
                        const SizedBox(height: AppSpacing.lg),
                      ],

                      // 3. Today's Assignment Card
                      SectionHeader(
                        title: "Today's Assignment",
                        actionText: homeController.assignment != null
                            ? 'View Details'
                            : null,
                        onActionTap: homeController.assignment != null
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AssignmentDetailScreen(),
                                  ),
                                );
                              }
                            : null,
                      ),
                      if (homeController.assignment != null)
                        _buildAssignmentCard(context, homeController)
                      else
                        _buildEmptyAssignmentCard(),
                      const SizedBox(height: AppSpacing.lg),

                      // 4. Upcoming Trip Card
                      SectionHeader(
                        title:
                            tripsController.upcomingTrip?.status ==
                                TripStatus.inProgress
                            ? 'Active Trip In Progress'
                            : 'Next Scheduled Trip',
                        actionText: 'View All Trips',
                        onActionTap: () => widget.onNavigateTab?.call(1),
                      ),
                      if (tripsController.upcomingTrip != null)
                        _buildUpcomingTripCard(tripsController.upcomingTrip!)
                      else
                        _buildEmptyUpcomingTripCard(),
                      const SizedBox(height: AppSpacing.lg),

                      // 5. Today's Schedule Timeline Section
                      SectionHeader(
                        title: "Today's Schedule",
                        actionText: 'Full Manifest',
                        onActionTap: () => widget.onNavigateTab?.call(1),
                      ),
                      _buildScheduleOverview(context, tripsController.trips),
                      const SizedBox(height: AppSpacing.lg),

                      // 6. Quick Actions Section
                      const SectionHeader(title: 'Quick Operational Actions'),
                      _buildQuickActionsGrid(context, user),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDriverHeader(
    DriverUser? user,
    AuthController authController,
    HomeController homeController,
  ) {
    final driverName = user?.name ?? 'Driver';
    final status = user?.status ?? DriverStatus.available;
    final driverId = user?.driverId ?? user?.id ?? 'DRV-1024';
    final region = user?.region ?? 'Villupuram Region';

    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      backgroundColor: const Color(0xFF0F172A), // Deep Slate Navy Header
      borderSide: BorderSide.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DriverAvatar(
            name: driverName,
            radius: 26,
            isOnline:
                status == DriverStatus.available ||
                status == DriverStatus.onDuty,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_getGreeting()},',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  driverName,
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: $driverId • $region',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Status Selector Dropdown / Pill
          PopupMenuButton<DriverStatus>(
            initialValue: status,
            onSelected: (newStatus) {
              authController.updateDriverStatus(newStatus);
              homeController.updateDriverStatus(newStatus);
            },
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DriverStatus.available,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.success, size: 12),
                    SizedBox(width: 8),
                    Text('Available'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: DriverStatus.onDuty,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.primary, size: 12),
                    SizedBox(width: 8),
                    Text('On Duty'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: DriverStatus.onBreak,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.warning, size: 12),
                    SizedBox(width: 8),
                    Text('On Break'),
                  ],
                ),
              ),
            ],
            child: StatusBadge(
              label: status.displayName,
              type: status == DriverStatus.available
                  ? StatusBadgeType.available
                  : status == DriverStatus.onDuty
                  ? StatusBadgeType.inProgress
                  : StatusBadgeType.onBreak,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(HomeController homeController) {
    final metrics = homeController.metrics!;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Trips Today',
            value:
                '${metrics.completedTripsToday} / ${metrics.totalScheduledTripsToday}',
            subtext: 'Completed',
            icon: Icons.checklist_rounded,
            accentColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildMetricCard(
            title: 'On-Time',
            value: '${metrics.onTimePercentage}%',
            subtext: 'Punctuality',
            icon: Icons.timer_outlined,
            accentColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildMetricCard(
            title: 'Driving',
            value: '${metrics.drivingHoursToday.toStringAsFixed(1)} h',
            subtext: 'Shift Total',
            icon: Icons.access_time_rounded,
            accentColor: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    return TrackGoCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedLight,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    HomeController homeController,
  ) {
    final assignment = homeController.assignment!;

    return TrackGoCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AssignmentDetailScreen()),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 2,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.roundedSm,
                  ),
                  child: Text(
                    assignment.route.routeNumber,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              StatusBadge(
                label: assignment.status.displayName,
                type: assignment.status == AssignmentStatus.active
                    ? StatusBadgeType.ready
                    : assignment.status == AssignmentStatus.completed
                    ? StatusBadgeType.completed
                    : StatusBadgeType.scheduled,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            assignment.route.routeName,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Shift Window: ${assignment.shiftStartTime} - ${assignment.shiftEndTime}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(
                          vehicleId: assignment.vehicle.id,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_bus_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${assignment.vehicle.vehicleCode} (${assignment.vehicle.registrationNumber})',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            RouteDetailScreen(routeId: assignment.route.id),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.alt_route_rounded,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${assignment.route.totalStopsCount} Planned Stops',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAssignmentCard() {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            size: 36,
            color: AppColors.textMutedLight,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No Active Shift Assignment',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No assignment record found for your driver account today. Please contact dispatch control.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTripCard(Trip upcomingTrip) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: upcomingTrip.status == TripStatus.inProgress
          ? const Color(0xFFF0FDF4)
          : const Color(0xFFF0F9FF),
      borderSide: BorderSide(
        color: upcomingTrip.status == TripStatus.inProgress
            ? AppColors.success.withValues(alpha: 0.4)
            : AppColors.primary.withValues(alpha: 0.3),
        width: 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      upcomingTrip.status == TripStatus.inProgress
                          ? Icons.navigation_rounded
                          : Icons.alarm_on_rounded,
                      size: 16,
                      color: upcomingTrip.status == TripStatus.inProgress
                          ? AppColors.successDark
                          : AppColors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        upcomingTrip.status == TripStatus.inProgress
                            ? 'Trip Active • GPS Tracking'
                            : 'Scheduled: ${upcomingTrip.scheduledDeparture}',
                        style: AppTypography.labelMedium.copyWith(
                          color: upcomingTrip.status == TripStatus.inProgress
                              ? AppColors.successDark
                              : AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(
                label: upcomingTrip.status.displayName,
                type: _mapTripStatusToBadge(upcomingTrip.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.roundedMd,
              border: Border.all(color: AppColors.cardBorderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.trip_origin_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From:',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMutedLight,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            upcomingTrip.origin,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Container(
                    width: 2,
                    height: 14,
                    color: AppColors.cardBorderLight,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To:',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMutedLight,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            upcomingTrip.destination,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.alt_route_rounded,
                size: 14,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${upcomingTrip.stopCount} Stops Itinerary • ${upcomingTrip.distanceKm} km',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TrackGoButton(
            text: upcomingTrip.status == TripStatus.inProgress
                ? 'Manage Active Trip Itinerary'
                : 'View Trip Itinerary & Operations',
            icon: Icons.map_outlined,
            variant: TrackGoButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TripDetailScreen(tripId: upcomingTrip.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUpcomingTripCard() {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 32,
            color: AppColors.textMutedLight,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No Upcoming Trips',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'All scheduled trips for today are completed or no new trips are assigned.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleOverview(BuildContext context, List<Trip> trips) {
    if (trips.isEmpty) {
      return const TrackGoCard(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: Text('No trips assigned today.')),
      );
    }

    return Column(
      children: trips.take(3).map((trip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: TrackGoCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TripDetailScreen(tripId: trip.id),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Text(
                  trip.scheduledDeparture,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.route.routeName,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${trip.route.routeNumber} • ${trip.vehicle.vehicleCode}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMutedLight,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                StatusBadge(
                  label: trip.status.displayName,
                  type: _mapTripStatusToBadge(trip.status),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, DriverUser? user) {
    final bus = user?.assignedBusId ?? 'BUS-402';
    final route = user?.assignedRouteId ?? 'VPM-101';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.45,
      children: [
        _buildActionTile(
          icon: Icons.directions_bus_rounded,
          title: 'Assigned Vehicle',
          subtitle: '$bus (Specs)',
          color: AppColors.primary,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VehicleDetailScreen(vehicleId: bus),
              ),
            );
          },
        ),
        _buildActionTile(
          icon: Icons.alt_route_rounded,
          title: 'Route Stops',
          subtitle: '$route (Stops)',
          color: AppColors.secondary,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RouteDetailScreen(routeId: route),
              ),
            );
          },
        ),
        _buildActionTile(
          icon: Icons.assignment_outlined,
          title: 'Shift Assignment',
          subtitle: 'Today’s details',
          color: AppColors.warning,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AssignmentDetailScreen()),
            );
          },
        ),
        _buildActionTile(
          icon: Icons.support_agent_rounded,
          title: 'Depot Dispatch',
          subtitle: user?.assignedDepot ?? 'Villupuram Hub',
          color: AppColors.success,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Villupuram Dispatch Control: +91 4146 222 333'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TrackGoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedLight,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  StatusBadgeType _mapTripStatusToBadge(TripStatus status) {
    switch (status) {
      case TripStatus.scheduled:
        return StatusBadgeType.scheduled;
      case TripStatus.ready:
        return StatusBadgeType.ready;
      case TripStatus.inProgress:
        return StatusBadgeType.inProgress;
      case TripStatus.completed:
        return StatusBadgeType.completed;
      case TripStatus.cancelled:
        return StatusBadgeType.cancelled;
    }
  }
}
