import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/empty_state_view.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/status_badge.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trip_detail_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripsController>().loadTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsController = context.watch<TripsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Trips Manifest & Schedule')),
      body: Column(
        children: [
          // Filter Chips Row
          _buildFilterChips(tripsController),

          // Trips List Content
          Expanded(child: _buildTripsList(tripsController)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(TripsController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All Trips',
              isSelected: controller.activeFilter == null,
              onTap: () => controller.setFilter(null),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterChip(
              label: 'Scheduled',
              isSelected: controller.activeFilter == TripStatus.scheduled,
              onTap: () => controller.setFilter(TripStatus.scheduled),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterChip(
              label: 'Ready / Active',
              isSelected: controller.activeFilter == TripStatus.inProgress,
              onTap: () => controller.setFilter(TripStatus.inProgress),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterChip(
              label: 'Completed',
              isSelected: controller.activeFilter == TripStatus.completed,
              onTap: () => controller.setFilter(TripStatus.completed),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterChip(
              label: 'Cancelled',
              isSelected: controller.activeFilter == TripStatus.cancelled,
              onTap: () => controller.setFilter(TripStatus.cancelled),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.roundedPill,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: AppRadius.roundedPill,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorderLight,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTripsList(TripsController controller) {
    if (controller.isLoading) {
      return const LoadingStateView(message: 'Loading scheduled trips...');
    }

    if (controller.errorMessage != null) {
      return ErrorStateView(
        message: controller.errorMessage!,
        onRetry: () => controller.loadTrips(filter: controller.activeFilter),
      );
    }

    if (controller.trips.isEmpty) {
      return const EmptyStateView(
        icon: Icons.alt_route_outlined,
        title: 'No Trips Found',
        message: 'There are no trips matching the selected filter criteria.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadTrips(filter: controller.activeFilter),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: controller.trips.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final trip = controller.trips[index];
          return _TripCard(
            trip: trip,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TripDetailScreen(tripId: trip.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const _TripCard({required this.trip, required this.onTap});

  StatusBadgeType _mapStatusToBadge(TripStatus status) {
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

  @override
  Widget build(BuildContext context) {
    return TrackGoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Route tag and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                  vertical: AppSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Text(
                  trip.route.routeNumber,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              StatusBadge(
                label: trip.status.displayName,
                type: _mapStatusToBadge(trip.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Route Name
          Text(
            trip.route.routeName,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Timing
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${trip.date} • ${trip.scheduledDeparture} - ${trip.scheduledArrival}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),

          // Footer: Vehicle & Stop count (Fully Responsive)
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_bus_outlined,
                      size: 16,
                      color: AppColors.textMutedLight,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        '${trip.vehicle.vehicleCode} (${trip.vehicle.registrationNumber})',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${trip.stops.length} Stops (${trip.route.distanceKm} km)',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
