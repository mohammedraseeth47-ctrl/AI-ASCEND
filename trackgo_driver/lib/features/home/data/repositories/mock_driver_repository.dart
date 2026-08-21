import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/home/data/datasources/mock_driver_data_source.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_metrics.dart';
import 'package:trackgo_driver/features/home/domain/repositories/driver_repository.dart';

class MockDriverRepository implements DriverRepository {
  final MockDriverDataSource _dataSource;

  MockDriverRepository({MockDriverDataSource? dataSource})
    : _dataSource = dataSource ?? MockDriverDataSource();

  @override
  Future<DriverAssignment?> getTodayAssignment() {
    return _dataSource.getTodayAssignment();
  }

  @override
  Future<DriverMetrics> getDriverMetrics() {
    return _dataSource.getDriverMetrics();
  }

  @override
  Future<DriverStatus> updateDriverStatus(DriverStatus newStatus) {
    return _dataSource.updateDriverStatus(newStatus);
  }
}
