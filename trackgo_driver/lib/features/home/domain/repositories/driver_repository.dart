import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_metrics.dart';

abstract class DriverRepository {
  Future<DriverAssignment?> getTodayAssignment();
  Future<DriverMetrics> getDriverMetrics();
  Future<DriverStatus> updateDriverStatus(DriverStatus newStatus);
}
