import 'package:trackgo_driver/features/trips/data/datasources/firebase_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/trip_repository.dart';

class FirebaseTripRepository implements TripRepository {
  final FirebaseTripDataSource _dataSource;

  FirebaseTripRepository({FirebaseTripDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseTripDataSource();

  @override
  Future<List<Trip>> getTrips({TripStatus? statusFilter}) {
    return _dataSource.getTrips(statusFilter: statusFilter);
  }

  @override
  Future<Trip?> getTripById(String id) {
    return _dataSource.getTripById(id);
  }

  @override
  Future<Trip?> getUpcomingTrip() {
    return _dataSource.getUpcomingTrip();
  }

  @override
  Future<Trip> updateTripStatus(String id, TripStatus newStatus) {
    return _dataSource.updateTripStatus(id, newStatus);
  }
}
