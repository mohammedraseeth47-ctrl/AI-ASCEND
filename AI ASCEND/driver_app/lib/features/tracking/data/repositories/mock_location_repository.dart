import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';
import 'package:trackgo_driver/features/tracking/domain/repositories/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  final List<DriverLocation> publishedLocations = [];
  bool isTrackingStopped = false;

  @override
  Future<void> publishLocation({
    required String tripId,
    required String driverId,
    required String vehicleId,
    required DriverLocation location,
  }) async {
    publishedLocations.add(location);
  }

  @override
  Future<void> stopTracking(String tripId) async {
    isTrackingStopped = true;
  }
}
