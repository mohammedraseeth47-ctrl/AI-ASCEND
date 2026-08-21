import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';
import 'package:trackgo_driver/features/tracking/domain/repositories/location_repository.dart';

/// GPS tracking service that manages location streaming and publishing.
///
/// Responsibilities:
/// - Request/check location permissions
/// - Check location services availability
/// - Start/stop GPS position stream
/// - Convert Position to DriverLocation domain model
/// - Publish location updates via LocationRepository
/// - Handle errors and offline queuing
class LocationTrackingService extends ChangeNotifier {
  final LocationRepository _locationRepository;

  StreamSubscription<Position>? _positionSubscription;
  DriverLocation? _currentLocation;
  bool _isTracking = false;
  String? _trackingError;
  String? _activeTripId;
  String? _activeDriverId;
  String? _activeVehicleId;

  // Lightweight offline queue
  final List<_QueuedUpdate> _offlineQueue = [];
  static const int _maxQueueSize = 50;

  LocationTrackingService(this._locationRepository);

  DriverLocation? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;
  String? get trackingError => _trackingError;
  String? get activeTripId => _activeTripId;

  /// Check if location services are enabled on the device.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permission.
  /// Returns true if permission is granted.
  Future<bool> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _trackingError =
          'Location permission denied. Please grant location access to start tracking.';
      notifyListeners();
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      _trackingError =
          'Location permission permanently denied. Please enable it in device Settings.';
      notifyListeners();
      return false;
    }

    _trackingError = null;
    return true;
  }

  /// Start GPS location tracking for the given trip.
  Future<bool> startTracking({
    required String tripId,
    required String driverId,
    required String vehicleId,
  }) async {
    // 1. Check location services
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      _trackingError = 'Location services are disabled. Please enable GPS.';
      notifyListeners();
      return false;
    }

    // 2. Check/request permission
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) {
      return false;
    }

    // 3. Store active trip info
    _activeTripId = tripId;
    _activeDriverId = driverId;
    _activeVehicleId = vehicleId;
    _trackingError = null;
    _isTracking = true;
    notifyListeners();

    // 4. Get initial position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      await _processPosition(position);
    } catch (e) {
      debugPrint('Initial position error: $e');
    }

    // 5. Start position stream
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 15, // Update every 15 meters
          ),
        ).listen(
          _processPosition,
          onError: (error) {
            debugPrint('Location stream error: $error');
            _trackingError = 'GPS signal lost. Retrying...';
            notifyListeners();
          },
        );

    return true;
  }

  /// Stop GPS tracking and clean up.
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;

    // Publish tracking stopped to RTDB
    if (_activeTripId != null) {
      try {
        await _locationRepository.stopTracking(_activeTripId!);
      } catch (e) {
        debugPrint('Error stopping tracking in RTDB: $e');
      }
    }

    // Flush any remaining queued updates
    await _flushOfflineQueue();

    _isTracking = false;
    _activeTripId = null;
    _activeDriverId = null;
    _activeVehicleId = null;
    _trackingError = null;
    notifyListeners();
  }

  /// Resume tracking for an active trip (e.g., after app restart).
  Future<bool> resumeTracking({
    required String tripId,
    required String driverId,
    required String vehicleId,
  }) async {
    return startTracking(
      tripId: tripId,
      driverId: driverId,
      vehicleId: vehicleId,
    );
  }

  Future<void> _processPosition(Position position) async {
    final location = DriverLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      speed: (position.speed * 3.6).clamp(0, 200), // m/s → km/h
      heading: position.heading,
      timestamp: position.timestamp,
      isTracking: true,
    );

    _currentLocation = location;
    _trackingError = null;
    notifyListeners();

    // Publish to Firebase
    if (_activeTripId != null &&
        _activeDriverId != null &&
        _activeVehicleId != null) {
      try {
        await _locationRepository.publishLocation(
          tripId: _activeTripId!,
          driverId: _activeDriverId!,
          vehicleId: _activeVehicleId!,
          location: location,
        );

        // If publish succeeded, try flushing any queued updates
        if (_offlineQueue.isNotEmpty) {
          await _flushOfflineQueue();
        }
      } catch (e) {
        // Network failure — queue the update
        debugPrint('Location publish failed (queuing): $e');
        _queueUpdate(location);
      }
    }
  }

  void _queueUpdate(DriverLocation location) {
    if (_offlineQueue.length >= _maxQueueSize) {
      _offlineQueue.removeAt(0); // Drop oldest
    }
    _offlineQueue.add(
      _QueuedUpdate(
        tripId: _activeTripId!,
        driverId: _activeDriverId!,
        vehicleId: _activeVehicleId!,
        location: location,
      ),
    );
  }

  Future<void> _flushOfflineQueue() async {
    if (_offlineQueue.isEmpty) return;

    // Only publish the most recent queued location (to avoid burst writes)
    final latest = _offlineQueue.last;
    _offlineQueue.clear();

    try {
      await _locationRepository.publishLocation(
        tripId: latest.tripId,
        driverId: latest.driverId,
        vehicleId: latest.vehicleId,
        location: latest.location,
      );
    } catch (e) {
      debugPrint('Queue flush failed: $e');
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

class _QueuedUpdate {
  final String tripId;
  final String driverId;
  final String vehicleId;
  final DriverLocation location;

  _QueuedUpdate({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.location,
  });
}
