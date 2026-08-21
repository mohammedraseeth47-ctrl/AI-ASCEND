import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:trackgo_passenger/data/mock/mock_buses.dart';
import 'package:trackgo_passenger/data/mock/mock_routes.dart';
import 'package:trackgo_passenger/data/mock/mock_stops.dart';
import 'package:trackgo_passenger/models/bus.dart';
import 'package:trackgo_passenger/models/bus_stop.dart';
import 'package:trackgo_passenger/models/route.dart' as app_models;
import 'package:trackgo_passenger/models/route_point.dart';

void main() {
  group('Tamil Nadu Model Unit Tests', () {
    test('Bus model properties and copyWith', () {
      final bus = Bus(
        id: 'BUS-TN32-1234',
        busNumber: 'TN-32-AB-1234',
        routeId: 'R-VPM-CDL-PDY',
        routeNumber: '101',
        routeName: 'Villupuram → Cuddalore → Puducherry',
        latitude: 11.7749,
        longitude: 79.5537,
        heading: 90,
        speedKmh: 40.0,
        occupancyLabel: 'Seats Available',
        nextStopName: 'Panruti Bus Stand',
        etaMinutes: 4,
        status: 'On Route',
        lastUpdated: DateTime.now(),
      );

      expect(bus.busNumber, 'TN-32-AB-1234');
      expect(bus.status, 'On Route');
      expect(bus.occupancyLabel, 'Seats Available');

      final updatedBus = bus.copyWith(etaMinutes: 2, speedKmh: 45.0);
      expect(updatedBus.etaMinutes, 2);
      expect(updatedBus.speedKmh, 45.0);
      expect(updatedBus.id, 'BUS-TN32-1234');
    });

    test('BusStop model properties', () {
      const stop = BusStop(
        id: 'BS-VPM-01',
        name: 'Villupuram Central Bus Stand',
        latitude: 11.9401,
        longitude: 79.4976,
        code: 'VPM-01',
        sequence: 1,
        passingRouteNumbers: ['101', '102'],
        isMajorHub: true,
        nextArrivalMinutes: 3,
      );

      expect(stop.name, 'Villupuram Central Bus Stand');
      expect(stop.code, 'VPM-01');
      expect(stop.isMajorHub, isTrue);
      expect(stop.nextArrivalMinutes, 3);
    });

    test('Route model properties and copyWith', () {
      const route = app_models.Route(
        id: 'R-VPM-CDL-PDY',
        routeNumber: '101 Express',
        routeName: 'Villupuram → Cuddalore → Puducherry',
        origin: 'Villupuram Central Bus Stand',
        destination: 'Puducherry New Bus Stand',
        color: Colors.teal,
        frequencyMinutes: 10,
        fareRupees: 45.0,
        stops: [MockStops.villupuramBusStand, MockStops.cuddaloreBusStand],
        polylinePoints: [LatLng(11.9401, 79.4976), LatLng(11.7480, 79.7714)],
      );

      expect(route.routeNumber, '101 Express');
      expect(route.fareRupees, 45.0);
      expect(route.isFavorite, isFalse);

      final favoriteRoute = route.copyWith(isFavorite: true);
      expect(favoriteRoute.isFavorite, isTrue);
    });

    test('RoutePoint model properties', () {
      const point = RoutePoint(
        latitude: 11.9401,
        longitude: 79.4976,
        name: 'Villupuram Junction',
      );

      expect(point.latitude, 11.9401);
      expect(point.longitude, 79.4976);
      expect(point.name, 'Villupuram Junction');
    });

    test('Mock data lists contain Tamil Nadu hubs', () {
      expect(MockStops.allStops.isNotEmpty, isTrue);
      expect(MockRoutes.allRoutes.isNotEmpty, isTrue);
      expect(MockBuses.allBuses.isNotEmpty, isTrue);

      expect(MockStops.allStops.any((s) => s.name.contains('Villupuram')), isTrue);
      expect(MockStops.allStops.any((s) => s.name.contains('Cuddalore')), isTrue);
      expect(MockStops.allStops.any((s) => s.name.contains('Puducherry')), isTrue);
    });
  });
}
