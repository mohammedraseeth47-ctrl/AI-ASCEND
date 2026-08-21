import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

abstract class VehicleRepository {
  /// Fetch vehicle details by vehicle ID
  Future<Vehicle?> getVehicleById(String id);

  /// Fetch currently assigned vehicle for driver
  Future<Vehicle?> getAssignedVehicle(String driverId);

  /// Fetch list of all operational vehicles in fleet
  Future<List<Vehicle>> getAllVehicles();
}
