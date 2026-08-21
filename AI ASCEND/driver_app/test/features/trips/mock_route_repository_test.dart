import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_route_repository.dart';

void main() {
  group('MockRouteRepository Tests', () {
    late MockRouteRepository repository;
    late MockTripDataSource dataSource;

    setUp(() {
      dataSource = MockTripDataSource();
      repository = MockRouteRepository(dataSource: dataSource);
    });

    test('getAssignedRoute returns Route VPM-101 for driver', () async {
      final route = await repository.getAssignedRoute('DRV-1024');
      expect(route, isNotNull);
      expect(route!.routeNumber, 'Route VPM-101');
      expect(route.origin, 'Villupuram New Bus Stand');
      expect(route.destination, 'Cuddalore Bus Stand');
      expect(route.distanceKm, 46.5);
    });

    test('getRouteById returns ordered stops with sequence numbers', () async {
      final route = await repository.getRouteById('RTE-VPM-101');
      expect(route, isNotNull);
      expect(route!.stops.isNotEmpty, isTrue);

      // Verify sequence order
      for (int i = 0; i < route.stops.length; i++) {
        expect(route.stops[i].sequenceNumber, i + 1);
      }

      // Verify first and last terminals
      expect(route.stops.first.isTerminal, isTrue);
      expect(route.stops.first.stopName, contains('Villupuram'));
      expect(route.stops.last.isTerminal, isTrue);
      expect(route.stops.last.stopName, contains('Cuddalore'));
    });

    test('getAllRoutes returns multiple Tamil Nadu routes', () async {
      final routes = await repository.getAllRoutes();
      expect(routes.length, greaterThanOrEqualTo(4));
      expect(routes.any((r) => r.routeNumber.contains('VPM')), isTrue);
      expect(routes.any((r) => r.routeNumber.contains('CUD')), isTrue);
    });
  });
}
