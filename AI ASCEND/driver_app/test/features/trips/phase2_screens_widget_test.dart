import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/features/home/data/datasources/mock_driver_data_source.dart';
import 'package:trackgo_driver/features/home/data/repositories/mock_driver_repository.dart';
import 'package:trackgo_driver/features/home/domain/repositories/driver_repository.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/home/presentation/screens/assignment_detail_screen.dart';
import 'package:trackgo_driver/features/tracking/data/repositories/mock_location_repository.dart';
import 'package:trackgo_driver/features/tracking/domain/repositories/location_repository.dart';
import 'package:trackgo_driver/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:trackgo_driver/features/tracking/services/location_tracking_service.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_route_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_trip_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/trip_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

void main() {
  late MockTripDataSource tripDataSource;
  late MockVehicleRepository vehicleRepo;
  late MockRouteRepository routeRepo;
  late MockTripRepository tripRepo;
  late MockDriverRepository driverRepo;
  late MockLocationRepository locationRepo;
  late LocationTrackingService trackingService;

  setUp(() {
    tripDataSource = MockTripDataSource();
    vehicleRepo = MockVehicleRepository(dataSource: tripDataSource);
    routeRepo = MockRouteRepository(dataSource: tripDataSource);
    tripRepo = MockTripRepository(dataSource: tripDataSource);
    driverRepo = MockDriverRepository(
      dataSource: MockDriverDataSource(tripDataSource: tripDataSource),
    );
    locationRepo = MockLocationRepository();
    trackingService = LocationTrackingService(locationRepo);
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        Provider<VehicleRepository>.value(value: vehicleRepo),
        Provider<RouteRepository>.value(value: routeRepo),
        Provider<TripRepository>.value(value: tripRepo),
        Provider<DriverRepository>.value(value: driverRepo),
        Provider<LocationRepository>.value(value: locationRepo),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(driverRepo),
        ),
        ChangeNotifierProvider<TripsController>(
          create: (_) => TripsController(tripRepo),
        ),
        ChangeNotifierProvider<TrackingController>(
          create: (_) => TrackingController(trackingService),
        ),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('VehicleDetailScreen renders vehicle registration and specs', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const VehicleDetailScreen(vehicleId: 'VEH-4521')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('TN-32-AB-4521'), findsOneWidget);
    expect(find.text('BUS-402'), findsOneWidget);
    expect(find.text('48'), findsOneWidget); // Seated
    expect(find.text('20'), findsOneWidget); // Standing
    expect(find.text('68'), findsOneWidget); // Total
    expect(find.text('Diesel Fuel Tank Level'), findsOneWidget);
  });

  testWidgets('RouteDetailScreen renders ordered stops timeline', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const RouteDetailScreen(routeId: 'RTE-VPM-101')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Route VPM-101'), findsOneWidget);
    expect(find.text('46.5 km'), findsOneWidget);
    expect(find.text('Panruti Bus Stand (Platform 1)'), findsOneWidget);
    expect(find.text('Cuddalore Bus Stand (Bay 4)'), findsOneWidget);
  });

  testWidgets('AssignmentDetailScreen renders driver, vehicle, route relationship', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const AssignmentDetailScreen()));
    // Allow initState postFrameCallback to fire
    await tester.pump(const Duration(milliseconds: 100));
    // Allow async data loading (150ms delay in MockDriverDataSource + 50ms in trips)
    await tester.pump(const Duration(milliseconds: 500));
    // Settle remaining micro-frames from notifyListeners
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Today's Shift Assignment"), findsOneWidget);
    expect(find.text('BUS-402 (TN-32-AB-4521)'), findsOneWidget);
    expect(find.text('Route VPM-101'), findsOneWidget);
  });

  testWidgets('TripDetailScreen renders lifecycle action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const TripDetailScreen(tripId: 'TRP-10482')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Mark Ready for Departure'), findsOneWidget);
    expect(find.text('Cancel Trip Assignment'), findsOneWidget);
  });
}
