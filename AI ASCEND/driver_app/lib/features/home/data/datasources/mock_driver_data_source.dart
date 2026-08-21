import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_metrics.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';

class MockDriverDataSource {
  DriverStatus _currentStatus = DriverStatus.available;
  final MockTripDataSource _tripDataSource;

  MockDriverDataSource({MockTripDataSource? tripDataSource})
    : _tripDataSource = tripDataSource ?? MockTripDataSource();

  Future<DriverAssignment?> getTodayAssignment() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final trips = await _tripDataSource.getTrips();
    return DriverAssignment(
      id: 'ASN-2026-4521',
      date: 'Today, Oct 24',
      shiftStartTime: '06:30 AM',
      shiftEndTime: '02:30 PM',
      driverId: 'DRV-1024',
      driverName: 'Karthikeyan',
      vehicle: MockTripDataSource.mockVehiclePrimary,
      route: MockTripDataSource.mockRouteVpm101,
      trips: trips,
      status: AssignmentStatus.active,
      notes:
          'Pre-trip diagnostics passed at Villupuram Central Depot. Fuel level at 92%. Bay assignment: Bay 2.',
    );
  }

  Future<DriverMetrics> getDriverMetrics() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final trips = await _tripDataSource.getTrips();
    final completed = trips.where((t) => t.status.name == 'completed').length;
    final total = trips.length;

    return DriverMetrics(
      completedTripsToday: completed,
      totalScheduledTripsToday: total,
      onTimePercentage: 98.5,
      drivingHoursToday: 2.2 + (completed * 1.5),
      totalDistanceKmToday: 46.5 * completed,
    );
  }

  Future<DriverStatus> updateDriverStatus(DriverStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentStatus = newStatus;
    return _currentStatus;
  }
}
