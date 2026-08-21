import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/section_header.dart';
import 'package:trackgo_driver/core/widgets/status_badge.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

class AssignmentDetailScreen extends StatefulWidget {
  const AssignmentDetailScreen({super.key});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HomeController>();
      if (controller.assignment == null) {
        controller.loadDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final assignment = homeController.assignment;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Today's Shift Assignment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(context, homeController, assignment),
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeController controller,
    DriverAssignment? assignment,
  ) {
    if (controller.isLoading) {
      return const LoadingStateView(message: 'Loading shift assignment...');
    }

    if (controller.errorMessage != null || assignment == null) {
      return ErrorStateView(
        message: controller.errorMessage ?? 'No active shift assignment found.',
        onRetry: () => controller.loadDashboardData(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Shift Banner Card
          _buildShiftBannerCard(assignment),
          const SizedBox(height: AppSpacing.lg),

          // 2. Assigned Vehicle Card (Tappable)
          const SectionHeader(title: 'Assigned Bus Fleet'),
          _buildVehicleCard(context, assignment),
          const SizedBox(height: AppSpacing.lg),

          // 3. Assigned Route Card (Tappable)
          const SectionHeader(title: 'Assigned Transit Corridor'),
          _buildRouteCard(context, assignment),
          const SizedBox(height: AppSpacing.lg),

          // 4. Shift Trips Manifest
          SectionHeader(
            title: 'Shift Trips Schedule (${assignment.trips.length})',
          ),
          _buildTripsList(context, assignment.trips),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildShiftBannerCard(DriverAssignment assignment) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: const Color(0xFF0F172A), // Dark Navy
      borderSide: BorderSide.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shift Assignment',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textMutedDark,
                ),
              ),
              StatusBadge(
                label: assignment.status.displayName,
                type: StatusBadgeType.available,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${assignment.shiftStartTime} – ${assignment.shiftEndTime}',
            style: AppTypography.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${assignment.date} • Assigned Driver: ${assignment.driverName} (${assignment.driverId})',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  assignment.notes,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedDark,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, DriverAssignment assignment) {
    final vehicle = assignment.vehicle;

    return TrackGoCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(vehicleId: vehicle.id),
          ),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: AppRadius.roundedMd,
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              color: AppColors.primaryDark,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.vehicleCode} (${vehicle.registrationNumber})',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${vehicle.model} • ${vehicle.fuelOrBatteryStatus}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, DriverAssignment assignment) {
    final route = assignment.route;

    return TrackGoCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteDetailScreen(routeId: route.id),
          ),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppRadius.roundedMd,
            ),
            child: const Icon(
              Icons.alt_route_rounded,
              color: AppColors.secondaryDark,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.routeNumber,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  route.routeName,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${route.distanceKm} km • ${route.totalStopsCount} Planned Stops',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMutedLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildTripsList(BuildContext context, List<Trip> trips) {
    if (trips.isEmpty) {
      return const TrackGoCard(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: Text('No trips assigned for this shift.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trips.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final trip = trips[index];

        return TrackGoCard(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TripDetailScreen(tripId: trip.id),
              ),
            );
          },
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trip.scheduledDeparture} – ${trip.route.routeName}',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Trip Code: ${trip.tripCode}',
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
        );
      },
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
