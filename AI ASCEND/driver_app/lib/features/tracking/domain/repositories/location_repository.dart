import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';

/// Interface for publishing live driver location data.
abstract class LocationRepository {
  /// Publish a location update for the given active trip.
  Future<void> publishLocation({
    required String tripId,
    required String driverId,
    required String vehicleId,
    required DriverLocation location,
  });

  /// Mark tracking as stopped for the given trip.
  Future<void> stopTracking(String tripId);
}
