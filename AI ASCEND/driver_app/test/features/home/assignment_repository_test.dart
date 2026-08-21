import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/home/data/datasources/mock_driver_data_source.dart';
import 'package:trackgo_driver/features/home/data/repositories/mock_driver_repository.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';

void main() {
  group('Driver Assignment & Metrics Tests', () {
    late MockTripDataSource tripDataSource;
    late MockDriverDataSource driverDataSource;
    late MockDriverRepository repository;

    setUp(() {
      tripDataSource = MockTripDataSource();
      driverDataSource = MockDriverDataSource(tripDataSource: tripDataSource);
      repository = MockDriverRepository(dataSource: driverDataSource);
    });

    test('getTodayAssignment returns driver, vehicle, route, and shift trips', () async {
      final assignment = await repository.getTodayAssignment();
      expect(assignment, isNotNull);
      expect(assignment!.driverId, 'DRV-1024');
      expect(assignment.driverName, 'Karthikeyan');
      expect(assignment.vehicle.registrationNumber, 'TN-32-AB-4521');
      expect(assignment.route.routeNumber, 'Route VPM-101');
      expect(assignment.trips.isNotEmpty, isTrue);
    });

    test('getDriverMetrics reflects driving performance', () async {
      final metrics = await repository.getDriverMetrics();
      expect(metrics.totalScheduledTripsToday, greaterThan(0));
      expect(metrics.onTimePercentage, 98.5);
    });
  });
}
