import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/services/map_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/widgets/app_badge.dart';
import '../providers/tracking_provider.dart';
import 'widgets/map_floating_controls.dart';
import 'widgets/trackgo_map_widget.dart';
import 'widgets/tracking_bottom_sheet.dart';

/// Live Tracking screen with real-time OpenStreetMap rendering focused on Tamil Nadu.
class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _moveMap(LatLng center, double zoom) {
    _mapController.move(center, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // OpenStreetMap Layer - Tamil Nadu Region
          TrackGoMapWidget(
            mapController: _mapController,
            initialCenter: trackingState.mapCenter,
            initialZoom: trackingState.zoom,
            activeRoute: trackingState.selectedRoute,
            routes: trackingState.routes,
            buses: trackingState.activeBuses,
            selectedBus: trackingState.selectedBus,
            onBusTap: (bus) {
              ref.read(trackingProvider.notifier).selectBus(bus);
              _moveMap(LatLng(bus.latitude, bus.longitude), 13.5);
            },
            onStopTap: (stop) {
              UIHelpers.showSnackBar(
                context,
                message: '${stop.name} (Code: ${stop.code})',
                icon: Icons.pin_drop_rounded,
              );
            },
          ),

          // Top Header & Route Selection Pill (Responsive layout)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface.withAlpha(245) : Colors.white.withAlpha(245),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with Route Badge + Mode Label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RouteCodeBadge(
                          routeCode: trackingState.selectedRoute.routeNumber,
                          color: trackingState.selectedRoute.color,
                          isLarge: false,
                        ),
                        Builder(
                          builder: (context) {
                            final driverCount = trackingState.activeBuses.where((b) => b.isDriver).length;
                            final hasBuses = trackingState.activeBuses.isNotEmpty;
                            final isLive = driverCount > 0;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isLive
                                    ? AppColors.statusOnTimeLight
                                    : (hasBuses ? const Color(0xFFEDE9FE) : (isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade200)),
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (hasBuses) ...[
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isLive ? const Color(0xFF047857) : const Color(0xFF6D28D9),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    isLive ? 'LIVE DRIVER' : (hasBuses ? 'DEMO ACTIVE' : 'STANDBY'),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: isLive
                                          ? const Color(0xFF047857)
                                          : (hasBuses ? const Color(0xFF6D28D9) : (isDark ? AppColors.textTertiaryDark : Colors.grey.shade700)),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Route Name
                    Text(
                      trackingState.selectedRoute.routeName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Subtitle status
                    Builder(
                      builder: (context) {
                        final driverCount = trackingState.activeBuses.where((b) => b.isDriver).length;
                        final mockCount = trackingState.activeBuses.where((b) => b.isMock).length;

                        String subtitle;
                        if (trackingState.isLoading) {
                          subtitle = 'Connecting to transit network...';
                        } else if (driverCount > 0 && mockCount > 0) {
                          subtitle = '$driverCount Live Driver (Real GPS) • $mockCount Demo Buses';
                        } else if (driverCount > 0) {
                          subtitle = '$driverCount Live Driver active • Realtime GPS';
                        } else if (mockCount > 0) {
                          subtitle = '$mockCount Demo Buses simulated on road';
                        } else {
                          subtitle = 'No live buses available';
                        }

                        return Text(
                          subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: trackingState.activeBuses.isEmpty ? AppColors.textSecondaryLight : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Controls (Top Right)
          Positioned(
            right: 16,
            top: 130,
            child: SafeArea(
              child: MapFloatingControls(
                onZoomIn: () {
                  final currentZoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, currentZoom + 1);
                  ref.read(trackingProvider.notifier).setZoom(currentZoom + 1);
                },
                onZoomOut: () {
                  final currentZoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, currentZoom - 1);
                  ref.read(trackingProvider.notifier).setZoom(currentZoom - 1);
                },
                onRecenterBus: () {
                  ref.read(trackingProvider.notifier).centerOnBus();
                  if (trackingState.selectedBus != null) {
                    _moveMap(
                      LatLng(trackingState.selectedBus!.latitude, trackingState.selectedBus!.longitude),
                      13.5,
                    );
                  }
                },
                onViewTamilNaduRoutes: () {
                  ref.read(trackingProvider.notifier).resetToTamilNaduView();
                  _moveMap(MapService.tamilNaduCenter, MapService.defaultZoom);
                  UIHelpers.showSnackBar(
                    context,
                    message: 'Centered on Tamil Nadu corridor (Villupuram • Cuddalore • Puducherry)',
                    icon: Icons.map_rounded,
                  );
                },
              ),
            ),
          ),

          // Bottom Telemetry Sheet or Empty State Notice
          if (trackingState.selectedBus != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                child: TrackingBottomSheet(
                  bus: trackingState.selectedBus!,
                  route: trackingState.selectedRoute,
                  onRecenter: () {
                    ref.read(trackingProvider.notifier).centerOnBus();
                    _moveMap(
                      LatLng(trackingState.selectedBus!.latitude, trackingState.selectedBus!.longitude),
                      14.0,
                    );
                  },
                  onNotify: () {
                    UIHelpers.showSnackBar(
                      context,
                      message: 'Alert set for ${trackingState.selectedBus!.nextStopName} (${trackingState.selectedBus!.busNumber})',
                      isSuccess: true,
                      icon: Icons.notifications_active_rounded,
                    );
                  },
                ),
              ),
            )
          else if (!trackingState.isLoading && trackingState.activeBuses.isEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface.withAlpha(240) : Colors.white.withAlpha(240),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No live buses available',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Waiting for driver to begin trip tracking',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
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
