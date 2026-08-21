import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';

class MockRouteRepository implements RouteRepository {
  final MockTripDataSource _dataSource;

  MockRouteRepository({MockTripDataSource? dataSource})
    : _dataSource = dataSource ?? MockTripDataSource();

  @override
  Future<TransitRoute?> getRouteById(String id) {
    return _dataSource.getRouteById(id);
  }

  @override
  Future<TransitRoute?> getAssignedRoute(String driverId) async {
    return MockTripDataSource.mockRouteVpm101;
  }

  @override
  Future<List<TransitRoute>> getAllRoutes() {
    return _dataSource.getAllRoutes();
  }
}
