import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_metrics.dart';
import 'package:trackgo_driver/features/home/domain/repositories/driver_repository.dart';

class HomeController extends ChangeNotifier {
  final DriverRepository _driverRepository;

  DriverAssignment? _assignment;
  DriverMetrics? _metrics;
  bool _isLoading = false;
  String? _errorMessage;

  HomeController(this._driverRepository);

  DriverAssignment? get assignment => _assignment;
  DriverMetrics? get metrics => _metrics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _driverRepository.getTodayAssignment(),
        _driverRepository.getDriverMetrics(),
      ]);

      _assignment = results[0] as DriverAssignment?;
      _metrics = results[1] as DriverMetrics;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> updateDriverStatus(DriverStatus newStatus) async {
    try {
      await _driverRepository.updateDriverStatus(newStatus);
      notifyListeners();
    } catch (_) {}
  }
}
