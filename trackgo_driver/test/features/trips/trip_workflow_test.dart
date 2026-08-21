import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_trip_repository.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';

void main() {
  group('Trip Status Lifecycle Workflow Tests', () {
    late MockTripDataSource dataSource;
    late MockTripRepository repository;
    late TripsController controller;

    setUp(() {
      dataSource = MockTripDataSource();
      repository = MockTripRepository(dataSource: dataSource);
      controller = TripsController(repository);
    });

    test('Trip progresses through scheduled -> ready -> inProgress -> completed', () async {
      await controller.loadTrips();
      final tripId = 'TRP-10482';

      // 1. Initial State: Scheduled
      await controller.loadTripDetail(tripId);
      expect(controller.selectedTrip!.status, TripStatus.scheduled);

      // 2. Mark Ready
      final readySuccess = await controller.markReady(tripId);
      if (!readySuccess) {
        // ignore: avoid_print
        print('DEBUG ERROR: ${controller.errorMessage}');
      }
      expect(controller.errorMessage, isNull);
      expect(readySuccess, isTrue);
      expect(controller.selectedTrip!.status, TripStatus.ready);

      // 3. Start Trip -> In Progress
      final startSuccess = await controller.startTrip(tripId);
      expect(startSuccess, isTrue);
      expect(controller.selectedTrip!.status, TripStatus.inProgress);
      expect(controller.selectedTrip!.actualDeparture, isNotNull);

      // 4. Complete Trip -> Completed
      final completeSuccess = await controller.completeTrip(tripId);
      expect(completeSuccess, isTrue);
      expect(controller.selectedTrip!.status, TripStatus.completed);
      expect(controller.selectedTrip!.actualArrival, isNotNull);
    });

    test('Cancelled trips throw error if attempting to restart', () async {
      final tripId = 'TRP-10478'; // Cancelled trip in mock data
      await controller.loadTripDetail(tripId);
      expect(controller.selectedTrip!.status, TripStatus.cancelled);

      final startAttempt = await controller.startTrip(tripId);
      expect(startAttempt, isFalse);
      expect(controller.errorMessage, contains('Cancelled trips cannot be restarted'));
    });

    test('Trip cancellation transitions status to cancelled', () async {
      final tripId = 'TRP-10483';
      await controller.loadTripDetail(tripId);

      final cancelSuccess = await controller.cancelTrip(tripId);
      expect(cancelSuccess, isTrue);
      expect(controller.selectedTrip!.status, TripStatus.cancelled);
    });
  });
}
