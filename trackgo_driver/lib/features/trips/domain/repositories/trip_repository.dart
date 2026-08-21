import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';

abstract class TripRepository {
  /// Fetch all trips with optional status filter
  Future<List<Trip>> getTrips({TripStatus? statusFilter});

  /// Fetch single trip detail by ID
  Future<Trip?> getTripById(String id);

  /// Fetch next upcoming trip for dashboard
  Future<Trip?> getUpcomingTrip();

  /// Update the status of a specific trip (Phase 2 local lifecycle workflow)
  Future<Trip> updateTripStatus(String id, TripStatus newStatus);
}
