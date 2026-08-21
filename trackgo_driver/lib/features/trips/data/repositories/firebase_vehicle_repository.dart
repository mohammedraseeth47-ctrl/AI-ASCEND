import 'package:trackgo_driver/features/trips/data/datasources/firebase_vehicle_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';

class FirebaseVehicleRepository implements VehicleRepository {
  final FirebaseVehicleDataSource _dataSource;

  FirebaseVehicleRepository({FirebaseVehicleDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseVehicleDataSource();

  @override
  Future<Vehicle?> getVehicleById(String id) {
    return _dataSource.getVehicleById(id);
  }

  @override
  Future<Vehicle?> getAssignedVehicle(String driverId) {
    return _dataSource.getAssignedVehicle(driverId);
  }

  @override
  Future<List<Vehicle>> getAllVehicles() {
    return _dataSource.getAllVehicles();
  }
}
