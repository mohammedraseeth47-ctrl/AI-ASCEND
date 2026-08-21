import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/driver_avatar.dart';
import 'package:trackgo_driver/core/widgets/section_header.dart';
import 'package:trackgo_driver/core/widgets/trackgo_button.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/login_screen.dart';
import 'package:trackgo_driver/features/home/presentation/screens/assignment_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title: Text(
          'Confirm Sign Out',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to end your current session and sign out of TrackGo Driver Portal?',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final authController = context.read<AuthController>();
              await authController.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final driver = authController.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Driver Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Driver Profile Header Card
            _buildProfileHeaderCard(driver),
            const SizedBox(height: AppSpacing.lg),

            // 2. Active Operational Assignment Card
            SectionHeader(
              title: 'Active Operations',
              actionText: 'Shift Overview',
              onActionTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AssignmentDetailScreen(),
                  ),
                );
              },
            ),
            _buildOperationsCard(context, driver),
            const SizedBox(height: AppSpacing.lg),

            // 3. Credentials & License Section
            const SectionHeader(title: 'Driver & License Credentials'),
            _buildCredentialsCard(driver),
            const SizedBox(height: AppSpacing.lg),

            // 4. Depot & Vehicle Qualifications
            const SectionHeader(title: 'Depot & Region Qualifications'),
            _buildQualificationsCard(driver),
            const SizedBox(height: AppSpacing.lg),

            // 5. App & System Information
            const SectionHeader(title: 'Application & System'),
            _buildSystemInfoCard(context),
            const SizedBox(height: AppSpacing.xxl),

            // 6. Logout Action Button
            TrackGoButton(
              text: 'Sign Out of Driver Account',
              icon: Icons.logout_rounded,
              variant: TrackGoButtonVariant.danger,
              onPressed: () => _handleLogout(context),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(DriverUser? driver) {
    final name = driver?.name ?? 'Driver';
    final email = driver?.email ?? '';
    final id = driver?.driverId ?? driver?.id ?? 'DRV-1024';
    final region = driver?.region ?? 'Villupuram Region';
    final rating = driver?.rating ?? 4.94;
    final exp = driver?.experienceYears ?? 7;

    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          DriverAvatar(
            name: name,
            radius: 38,
            isOnline: driver?.status != DriverStatus.offline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Driver ID: $id • $region',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              email,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMutedLight,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Rating & Experience Pill Badges
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.roundedPill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.warningDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating Rating',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.roundedPill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 16,
                      color: AppColors.successDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$exp Yrs Experience',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.successDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsCard(BuildContext context, DriverUser? driver) {
    final bus = driver?.assignedBusId ?? 'BUS-402';
    final route = driver?.assignedRouteId ?? 'VPM-101';

    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VehicleDetailScreen(vehicleId: bus),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(
                  Icons.directions_bus_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Bus',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedLight,
                        ),
                      ),
                      Text(
                        bus,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RouteDetailScreen(routeId: route),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(
                  Icons.alt_route_rounded,
                  size: 20,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Route Corridor',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMutedLight,
                        ),
                      ),
                      Text(
                        'Route $route',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsCard(DriverUser? driver) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            value: driver?.phone.isNotEmpty == true
                ? driver!.phone
                : '+91 98421 78940',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            title: 'Commercial Driver License (CDL)',
            value: driver?.licenseNumber.isNotEmpty == true
                ? driver!.licenseNumber
                : 'TN-32-2015-0048291',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.event_available_outlined,
            title: 'License Validity & Category',
            value:
                '${driver?.licenseExpiry ?? 'Valid'} (${driver?.licenseCategory ?? 'Commercial HMV'})',
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationsCard(DriverUser? driver) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.location_city_outlined,
            title: 'Assigned Depot & Division',
            value:
                driver?.assignedDepot ??
                'Villupuram Central Depot (Division 1)',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.directions_bus_outlined,
            title: 'Authorized Vehicle Class',
            value: driver?.vehicleClass ?? 'PSV Heavy Passenger Transit',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.medical_services_outlined,
            title: 'Medical Fitness Certificate',
            value: driver?.medicalCertificate ?? 'Class 1 (Valid)',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard(BuildContext context) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.layers_outlined,
            title: 'Release Version',
            value: 'TrackGo Driver v1.3.0 (Firebase & GPS Live)',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.speed_rounded,
            title: 'Architecture Layer',
            value: 'Clean Feature-First Architecture (Provider + Firestore)',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            icon: Icons.cloud_done_outlined,
            title: 'Data Mode',
            value: 'Cloud Firestore & Realtime Database',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
