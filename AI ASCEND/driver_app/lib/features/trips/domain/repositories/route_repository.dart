import 'package:trackgo_driver/features/trips/domain/entities/route.dart';

abstract class RouteRepository {
  /// Fetch route details by route ID with ordered stops
  Future<TransitRoute?> getRouteById(String id);

  /// Fetch currently assigned transit route for driver
  Future<TransitRoute?> getAssignedRoute(String driverId);

  /// Fetch all active transit routes
  Future<List<TransitRoute>> getAllRoutes();
}
