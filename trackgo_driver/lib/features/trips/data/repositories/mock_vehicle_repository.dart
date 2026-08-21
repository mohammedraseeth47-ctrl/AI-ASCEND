import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';

class MockVehicleRepository implements VehicleRepository {
  final MockTripDataSource _dataSource;

  MockVehicleRepository({MockTripDataSource? dataSource})
    : _dataSource = dataSource ?? MockTripDataSource();

  @override
  Future<Vehicle?> getVehicleById(String id) {
    return _dataSource.getVehicleById(id);
  }

  @override
  Future<Vehicle?> getAssignedVehicle(String driverId) async {
    final all = await _dataSource.getAllVehicles();
    try {
      return all.firstWhere((v) => v.assignedDriverId == driverId);
    } catch (_) {
      return MockTripDataSource.mockVehiclePrimary;
    }
  }

  @override
  Future<List<Vehicle>> getAllVehicles() {
    return _dataSource.getAllVehicles();
  }
}
