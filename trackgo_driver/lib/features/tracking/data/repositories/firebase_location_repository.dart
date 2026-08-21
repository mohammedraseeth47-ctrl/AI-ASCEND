import 'package:firebase_database/firebase_database.dart';
import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';
import 'package:trackgo_driver/features/tracking/domain/repositories/location_repository.dart';

/// Writes live driver location data to Firebase Realtime Database
/// under `liveLocations/{tripId}`.
class FirebaseLocationRepository implements LocationRepository {
  final FirebaseDatabase _database;

  FirebaseLocationRepository({FirebaseDatabase? database})
    : _database = database ?? FirebaseDatabase.instance;

  @override
  Future<void> publishLocation({
    required String tripId,
    required String driverId,
    required String vehicleId,
    required DriverLocation location,
  }) async {
    final ref = _database.ref('liveLocations/$tripId');
    await ref.set(
      location.toRealtimeDb(
        driverId: driverId,
        vehicleId: vehicleId,
        tripId: tripId,
      ),
    );
  }

  @override
  Future<void> stopTracking(String tripId) async {
    final ref = _database.ref('liveLocations/$tripId');
    await ref.update({'isTracking': false, 'timestamp': ServerValue.timestamp});
  }
}
