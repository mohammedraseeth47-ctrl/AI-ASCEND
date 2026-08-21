import 'package:trackgo_driver/features/trips/data/datasources/firebase_route_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';

class FirebaseRouteRepository implements RouteRepository {
  final FirebaseRouteDataSource _dataSource;

  FirebaseRouteRepository({FirebaseRouteDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseRouteDataSource();

  @override
  Future<TransitRoute?> getRouteById(String id) {
    return _dataSource.getRouteById(id);
  }

  @override
  Future<TransitRoute?> getAssignedRoute(String driverId) {
    return _dataSource.getAssignedRoute(driverId);
  }

  @override
  Future<List<TransitRoute>> getAllRoutes() {
    return _dataSource.getAllRoutes();
  }
}
