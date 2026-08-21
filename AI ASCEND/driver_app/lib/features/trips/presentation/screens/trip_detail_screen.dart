import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/status_badge.dart';
import 'package:trackgo_driver/core/widgets/trackgo_button.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip_stop.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tripsController = context.read<TripsController>();
      await tripsController.loadTripDetail(widget.tripId);

      // Check if this trip is already in progress and resume tracking if needed
      if (mounted) {
        final trip = tripsController.selectedTrip;
        final trackingController = context.read<TrackingController>();
        if (trip != null &&
            trip.status == TripStatus.inProgress &&
            !trackingController.isTracking) {
          await trackingController.resumeTracking(
            tripId: trip.id,
            driverId: trip.driverId,
            vehicleId: trip.vehicle.id,
          );
        }
      }
    });
  }

  Future<void> _handleStatusAction(TripStatus newStatus, Trip trip) async {
    final tripsController = context.read<TripsController>();
    final homeController = context.read<HomeController>();
    final trackingController = context.read<TrackingController>();

    // 1. If starting trip -> verify GPS permissions and start location stream FIRST
    if (newStatus == TripStatus.inProgress) {
      final gpsStarted = await trackingController.startTracking(
        tripId: trip.id,
        driverId: trip.driverId,
        vehicleId: trip.vehicle.id,
      );

      if (!gpsStarted) {
        if (mounted) {
          _showGpsErrorDialog(
            trackingController.trackingError ??
                'Unable to acquire GPS tracking.',
          );
        }
        return; // Abort status update if GPS is unavailable
      }
    }

    // 2. If completing trip -> prompt confirmation, stop GPS tracking
    if (newStatus == TripStatus.completed) {
      final confirm = await _showEndTripConfirmationDialog();
      if (!confirm) return;

      await trackingController.stopTracking();
    }

    // 3. Update status in Firestore
    final success = await tripsController.updateStatus(
      widget.tripId,
      newStatus,
    );
    if (success && mounted) {
      // Re-sync dashboard assignment and metrics
      await homeController.loadDashboardData();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trip status updated to "${newStatus.displayName}".'),
          backgroundColor: newStatus == TripStatus.completed
              ? AppColors.successDark
              : newStatus == TripStatus.cancelled
              ? AppColors.error
              : AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<bool> _showEndTripConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Complete Trip Assignment?'),
            content: const Text(
              'Are you sure you have reached the terminal stop and completed this trip? GPS tracking will stop.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Complete Trip'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showGpsErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off_rounded, color: AppColors.error),
            SizedBox(width: AppSpacing.sm),
            Text('GPS Required'),
          ],
        ),
        content: Text(
          '$errorMessage\n\nTrackGo requires active GPS location permissions to track and report your bus live location to passengers.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripsController = context.watch<TripsController>();
    final trackingController = context.watch<TrackingController>();
    final trip = tripsController.selectedTrip;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Trip Manifest & Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(tripsController, trackingController, trip),
      bottomNavigationBar: trip != null
          ? _buildBottomActionBar(tripsController, trip)
          : null,
    );
  }

  Widget _buildBody(
    TripsController controller,
    TrackingController trackingController,
    Trip? trip,
  ) {
    if (controller.isLoading) {
      return const LoadingStateView(message: 'Loading trip manifest...');
    }

    if (controller.errorMessage != null || trip == null) {
      return ErrorStateView(
        message: controller.errorMessage ?? 'Trip details not found.',
        onRetry: () => controller.loadTripDetail(widget.tripId),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Route Header Card (Tappable -> RouteDetailScreen)
          _buildRouteHeaderCard(trip),
          const SizedBox(height: AppSpacing.lg),

          // 2. Live GPS Tracking Card (Visible when in progress)
          if (trip.status == TripStatus.inProgress) ...[
            _buildLiveTrackingStatusCard(trackingController),
            const SizedBox(height: AppSpacing.lg),
          ],

          // 3. Vehicle & Shift Info (Tappable -> VehicleDetailScreen)
          _buildVehicleCard(trip),
          const SizedBox(height: AppSpacing.lg),

          // 4. Operational Notice
          _buildOperationalNotice(trip),
          const SizedBox(height: AppSpacing.lg),

          // 5. Stops Timeline Itinerary
          _buildStopsSection(trip),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingStatusCard(TrackingController trackingController) {
    final location = trackingController.currentLocation;
    final isTracking = trackingController.isTracking;

    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: const Color(0xFF0F172A), // Deep Navy
      borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isTracking ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isTracking ? AppColors.success : AppColors.error)
                                  .withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isTracking ? 'GPS Tracking Active' : 'GPS Tracking Standby',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                label: isTracking ? 'Live Sync' : 'Offline',
                type: isTracking
                    ? StatusBadgeType.available
                    : StatusBadgeType.cancelled,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: AppSpacing.sm),

          // Coordinates & GPS Metrics
          if (location != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Coordinates',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GPS Accuracy',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '± ${location.accuracy.toStringAsFixed(1)} m',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.successLight,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Speed',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${location.speed.toStringAsFixed(1)} km/h',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Heading',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedDark,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${location.heading.toStringAsFixed(0)}°',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Acquiring live GPS fix...',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMutedDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteHeaderCard(Trip trip) {
    return TrackGoCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteDetailScreen(routeId: trip.route.id),
          ),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Text(
                  trip.route.routeNumber,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.route.routeName,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${trip.date} • Code: ${trip.tripCode}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),

          // Departure -> Arrival Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.directions_bus_rounded,
                  label: 'Departure',
                  value: trip.scheduledDeparture,
                  subtext: trip.route.origin,
                ),
              ),
              Container(height: 40, width: 1, color: AppColors.cardBorderLight),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: _buildMetricItem(
                    icon: Icons.location_on_rounded,
                    label: 'Arrival',
                    value: trip.scheduledArrival,
                    subtext: trip.route.destination,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required String subtext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryLight,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
            fontSize: 15,
          ),
        ),
        Text(
          subtext,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVehicleCard(Trip trip) {
    return TrackGoCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(vehicleId: trip.vehicle.id),
          ),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.roundedMd,
                ),
                child: const Icon(
                  Icons.directions_bus_filled_rounded,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bus: ${trip.vehicle.vehicleCode} (${trip.vehicle.registrationNumber})',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${trip.vehicle.model} • ${trip.vehicle.vehicleType}',
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
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildVehicleSpec(
                  Icons.local_gas_station_rounded,
                  'Status',
                  trip.vehicle.fuelOrBatteryStatus,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildVehicleSpec(
                  Icons.airline_seat_recline_normal_rounded,
                  'Capacity',
                  '${trip.vehicle.seatingCapacity} Seated / ${trip.vehicle.standingCapacity} Stdg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSpec(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.success),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMutedLight,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperationalNotice(Trip trip) {
    Color bgColor = AppColors.infoLight.withValues(alpha: 0.5);
    Color borderColor = AppColors.info.withValues(alpha: 0.3);
    IconData icon = Icons.info_outline_rounded;
    Color iconColor = AppColors.info;
    String title = 'Operational Lifecycle';
    String message =
        'Live GPS coordinates are published to Firebase Realtime Database during an active trip.';

    if (trip.status == TripStatus.inProgress) {
      bgColor = AppColors.primaryContainer.withValues(alpha: 0.5);
      borderColor = AppColors.primary.withValues(alpha: 0.4);
      icon = Icons.navigation_rounded;
      iconColor = AppColors.primaryDark;
      title = 'Trip Currently In Progress';
      message =
          'Live tracking is active. Real-time bus location is being broadcast to the TrackGo passenger network.';
    } else if (trip.status == TripStatus.completed) {
      bgColor = AppColors.successLight.withValues(alpha: 0.5);
      borderColor = AppColors.success.withValues(alpha: 0.4);
      icon = Icons.check_circle_outline_rounded;
      iconColor = AppColors.successDark;
      title = 'Trip Completed on Schedule';
      message =
          'All stops fulfilled. Vehicle cleared for next scheduled departure.';
    } else if (trip.status == TripStatus.cancelled) {
      bgColor = AppColors.errorLight.withValues(alpha: 0.5);
      borderColor = AppColors.error.withValues(alpha: 0.4);
      icon = Icons.cancel_outlined;
      iconColor = AppColors.error;
      title = 'Trip Cancelled';
      message =
          trip.notes ?? 'This trip has been cancelled by depot operations.';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopsSection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Planned Stops Itinerary (${trip.stops.length})',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Total Route Distance: ${trip.route.distanceKm} km',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trip.stops.length,
          itemBuilder: (context, index) {
            final stop = trip.stops[index];
            final isFirst = index == 0;
            final isLast = index == trip.stops.length - 1;

            return _StopTimelineTile(
              stop: stop,
              isFirst: isFirst,
              isLast: isLast,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(TripsController controller, Trip trip) {
    final isLoading = controller.isActionLoading;

    if (trip.status == TripStatus.completed ||
        trip.status == TripStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trip.status == TripStatus.scheduled) ...[
              TrackGoButton(
                text: 'Mark Ready for Departure',
                icon: Icons.checklist_rtl_rounded,
                variant: TrackGoButtonVariant.primary,
                isLoading: isLoading,
                onPressed: () => _handleStatusAction(TripStatus.ready, trip),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => _handleStatusAction(TripStatus.cancelled, trip),
                child: Text(
                  'Cancel Trip Assignment',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else if (trip.status == TripStatus.ready) ...[
              TrackGoButton(
                text: 'Start Trip & Begin GPS Tracking',
                icon: Icons.play_arrow_rounded,
                variant: TrackGoButtonVariant.primary,
                isLoading: isLoading,
                onPressed: () =>
                    _handleStatusAction(TripStatus.inProgress, trip),
              ),
            ] else if (trip.status == TripStatus.inProgress) ...[
              TrackGoButton(
                text: 'Complete Trip (Arrived at Destination)',
                icon: Icons.check_circle_outline_rounded,
                variant: TrackGoButtonVariant.primary,
                isLoading: isLoading,
                onPressed: () =>
                    _handleStatusAction(TripStatus.completed, trip),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
}

class _StopTimelineTile extends StatelessWidget {
  final TripStop stop;
  final bool isFirst;
  final bool isLast;

  const _StopTimelineTile({
    required this.stop,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : AppColors.cardBorderLight,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: stop.isTerminal
                        ? AppColors.primary
                        : stop.isCompleted
                        ? AppColors.success
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: stop.isTerminal
                          ? AppColors.primaryDark
                          : stop.isCompleted
                          ? AppColors.success
                          : AppColors.textMutedLight,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${stop.sequenceNumber}',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 9,
                        color: (stop.isTerminal || stop.isCompleted)
                            ? Colors.white
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : AppColors.cardBorderLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.roundedMd,
                  border: Border.all(
                    color: stop.isTerminal
                        ? AppColors.primaryContainer
                        : AppColors.cardBorderLight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stop.stopName,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                              if (stop.isTerminal) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: AppRadius.roundedXs,
                                  ),
                                  child: Text(
                                    'Terminal',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 9,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (stop.landmarks != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              stop.landmarks!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMutedLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      stop.scheduledTime,
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
