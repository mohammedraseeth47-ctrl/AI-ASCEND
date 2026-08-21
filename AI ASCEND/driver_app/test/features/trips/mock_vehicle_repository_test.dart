import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

void main() {
  group('MockVehicleRepository Tests', () {
    late MockVehicleRepository repository;
    late MockTripDataSource dataSource;

    setUp(() {
      dataSource = MockTripDataSource();
      repository = MockVehicleRepository(dataSource: dataSource);
    });

    test('getAssignedVehicle returns assigned bus TN-32-AB-4521 for driver', () async {
      final vehicle = await repository.getAssignedVehicle('DRV-1024');
      expect(vehicle, isNotNull);
      expect(vehicle!.registrationNumber, 'TN-32-AB-4521');
      expect(vehicle.vehicleCode, 'BUS-402');
      expect(vehicle.status, VehicleStatus.assigned);
      expect(vehicle.totalCapacity, 68);
    });

    test('getVehicleById returns correct vehicle specification', () async {
      final vehicle = await repository.getVehicleById('VEH-4521');
      expect(vehicle, isNotNull);
      expect(vehicle!.id, 'VEH-4521');
      expect(vehicle.model, contains('Ashok Leyland'));
      expect(vehicle.assignedDepot, contains('Villupuram'));
    });

    test('getAllVehicles returns all fleet buses', () async {
      final fleet = await repository.getAllVehicles();
      expect(fleet.length, greaterThanOrEqualTo(3));
      expect(fleet.any((v) => v.registrationNumber.startsWith('TN-')), isTrue);
      expect(fleet.any((v) => v.registrationNumber.startsWith('PY-')), isTrue);
    });
  });
}
