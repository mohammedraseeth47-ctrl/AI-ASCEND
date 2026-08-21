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
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String? vehicleId;

  const VehicleDetailScreen({super.key, this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  Vehicle? _vehicle;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = context.read<VehicleRepository>();
      final vehicle = widget.vehicleId != null
          ? await repo.getVehicleById(widget.vehicleId!)
          : await repo.getAssignedVehicle('DRV-1024');

      setState(() {
        _vehicle = vehicle;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Assigned Vehicle Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateView(
        message: 'Loading vehicle telemetry & specifications...',
      );
    }

    if (_errorMessage != null || _vehicle == null) {
      return ErrorStateView(
        message: _errorMessage ?? 'Vehicle details could not be found.',
        onRetry: _loadVehicle,
      );
    }

    final vehicle = _vehicle!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Vehicle Identity Header Card
          _buildIdentityCard(vehicle),
          const SizedBox(height: AppSpacing.lg),

          // 2. Telemetry & Energy Status Card
          const SectionHeader(title: 'Fuel & Operating Status'),
          _buildTelemetryCard(vehicle),
          const SizedBox(height: AppSpacing.lg),

          // 3. Passenger Capacity Breakdown Card
          const SectionHeader(title: 'Passenger Capacity'),
          _buildCapacityCard(vehicle),
          const SizedBox(height: AppSpacing.lg),

          // 4. Compliance & Fleet Specs Card
          const SectionHeader(title: 'Compliance & Fleet Specs'),
          _buildSpecsCard(vehicle),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(Vehicle vehicle) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: const Color(0xFF0F172A), // Dark Navy
      borderSide: BorderSide.none,
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
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: AppRadius.roundedSm,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  vehicle.vehicleCode,
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StatusBadge(
                label: vehicle.status.displayName,
                type: StatusBadgeType.available,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            vehicle.registrationNumber,
            style: AppTypography.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${vehicle.model} • ${vehicle.vehicleType}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.location_city_rounded,
                size: 16,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  vehicle.assignedDepot,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryCard(Vehicle vehicle) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.roundedMd,
                ),
                child: const Icon(
                  Icons.local_gas_station_rounded,
                  color: AppColors.successDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diesel Fuel Tank Level',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      vehicle.fuelOrBatteryStatus,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.roundedPill,
                ),
                child: Text(
                  'Optimal',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.successDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.roundedPill,
            child: LinearProgressIndicator(
              value: 0.92,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            'Last verified at depot dispatch check (Mock telemetry)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedLight,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityCard(Vehicle vehicle) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _buildCapacityCol(
              icon: Icons.airline_seat_recline_normal_rounded,
              title: 'Seated',
              count: '${vehicle.seatingCapacity}',
              subtext: 'Standard Seats',
              color: AppColors.primary,
            ),
          ),
          Container(height: 48, width: 1, color: AppColors.cardBorderLight),
          Expanded(
            child: _buildCapacityCol(
              icon: Icons.directions_walk_rounded,
              title: 'Standing',
              count: '${vehicle.standingCapacity}',
              subtext: 'Aisle Capacity',
              color: AppColors.warning,
            ),
          ),
          Container(height: 48, width: 1, color: AppColors.cardBorderLight),
          Expanded(
            child: _buildCapacityCol(
              icon: Icons.groups_rounded,
              title: 'Total',
              count: '${vehicle.totalCapacity}',
              subtext: 'Max Passenger',
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityCol({
    required IconData icon,
    required String title,
    required String count,
    required String subtext,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          count,
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryLight,
          ),
        ),
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsCard(Vehicle vehicle) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildSpecRow('Emission Standard', vehicle.emissionClass),
          const Divider(height: AppSpacing.lg),
          _buildSpecRow(
            'Fitness Certificate (FC)',
            vehicle.fitnessCertificateExpiry,
          ),
          const Divider(height: AppSpacing.lg),
          _buildSpecRow('Depot Mechanical Check', vehicle.lastInspectionDate),
          const Divider(height: AppSpacing.lg),
          _buildSpecRow(
            'Assigned Driver',
            '${vehicle.assignedDriverName} (${vehicle.assignedDriverId})',
          ),
          const Divider(height: AppSpacing.lg),
          _buildSpecRow(
            'Primary Route',
            vehicle.assignedRouteNumber ?? 'Route VPM-101',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedLight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
