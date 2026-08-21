import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_trip_repository.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';

void main() {
  group('MockTripRepository Tests', () {
    late MockTripRepository repository;

    setUp(() {
      repository = MockTripRepository(dataSource: MockTripDataSource());
    });

    test('getTrips returns all mock trips when no filter applied', () async {
      final trips = await repository.getTrips();
      expect(trips.isNotEmpty, isTrue);
      expect(trips.length, greaterThanOrEqualTo(4));
    });

    test('getTrips filters scheduled trips correctly', () async {
      final scheduledTrips = await repository.getTrips(statusFilter: TripStatus.scheduled);
      expect(scheduledTrips.isNotEmpty, isTrue);
      for (final trip in scheduledTrips) {
        expect(trip.status, TripStatus.scheduled);
      }
    });

    test('getTrips filters completed trips correctly', () async {
      final completedTrips = await repository.getTrips(statusFilter: TripStatus.completed);
      expect(completedTrips.isNotEmpty, isTrue);
      for (final trip in completedTrips) {
        expect(trip.status, TripStatus.completed);
      }
    });

    test('getTripById returns corresponding trip', () async {
      final trip = await repository.getTripById('TRP-10482');
      expect(trip, isNotNull);
      expect(trip!.id, 'TRP-10482');
      expect(trip.route.routeNumber, 'Route VPM-101');
      expect(trip.stops.isNotEmpty, isTrue);
    });

    test('getUpcomingTrip returns next scheduled trip', () async {
      final upcoming = await repository.getUpcomingTrip();
      expect(upcoming, isNotNull);
      expect(upcoming!.status, TripStatus.scheduled);
    });
  });
}
