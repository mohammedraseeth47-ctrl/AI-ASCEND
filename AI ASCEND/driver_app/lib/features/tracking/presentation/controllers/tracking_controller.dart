import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';
import 'package:trackgo_driver/features/tracking/services/location_tracking_service.dart';

/// Presentation controller for orchestrating GPS tracking operations and exposing UI state.
class TrackingController extends ChangeNotifier {
  final LocationTrackingService _trackingService;

  TrackingController(this._trackingService) {
    _trackingService.addListener(_onTrackingServiceUpdated);
  }

  void _onTrackingServiceUpdated() {
    notifyListeners();
  }

  DriverLocation? get currentLocation => _trackingService.currentLocation;
  bool get isTracking => _trackingService.isTracking;
  String? get trackingError => _trackingService.trackingError;
  String? get activeTripId => _trackingService.activeTripId;

  /// Start live location tracking for an active in-progress trip.
  Future<bool> startTracking({
    required String tripId,
    required String driverId,
    required String vehicleId,
  }) async {
    return await _trackingService.startTracking(
      tripId: tripId,
      driverId: driverId,
      vehicleId: vehicleId,
    );
  }

  /// Stop live location tracking upon trip completion.
  Future<void> stopTracking() async {
    await _trackingService.stopTracking();
  }

  /// Resume tracking if app restarted with an in-progress trip.
  Future<bool> resumeTracking({
    required String tripId,
    required String driverId,
    required String vehicleId,
  }) async {
    return await _trackingService.resumeTracking(
      tripId: tripId,
      driverId: driverId,
      vehicleId: vehicleId,
    );
  }

  @override
  void dispose() {
    _trackingService.removeListener(_onTrackingServiceUpdated);
    super.dispose();
  }
}
