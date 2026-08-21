import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/authentication/domain/repositories/auth_repository.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/home/data/datasources/mock_driver_data_source.dart';
import 'package:trackgo_driver/features/home/data/repositories/mock_driver_repository.dart';
import 'package:trackgo_driver/features/home/domain/repositories/driver_repository.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/home/presentation/screens/home_screen.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_route_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_trip_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/trip_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';

class _FakeAuthRepository implements AuthRepository {
  final DriverUser user;
  _FakeAuthRepository(this.user);

  @override
  Future<DriverUser?> getCurrentUser() async => user;

  @override
  Future<DriverUser> login({required String email, required String password}) async => user;

  @override
  Future<void> logout() async {}

  @override
  Future<bool> resetPassword({required String email}) async => true;

  @override
  Future<bool> isAuthenticated() async => true;
}

void main() {
  const mockUser = DriverUser(
    id: 'DRV-1024',
    name: 'Karthikeyan',
    email: 'driver@trackgo.com',
    phone: '+91 98421 78940',
    assignedDepot: 'Villupuram Central Depot',
    region: 'Villupuram Region',
    licenseNumber: 'TN-32-2015-0048291',
    licenseExpiry: 'Dec 2028',
  );

  Widget createHomeScreenWrapper() {
    final tripDataSource = MockTripDataSource();
    final driverRepo = MockDriverRepository(dataSource: MockDriverDataSource(tripDataSource: tripDataSource));
    final homeController = HomeController(driverRepo);
    final tripRepo = MockTripRepository(dataSource: tripDataSource);
    final vehicleRepo = MockVehicleRepository(dataSource: tripDataSource);
    final routeRepo = MockRouteRepository(dataSource: tripDataSource);
    final tripsController = TripsController(tripRepo);
    final authController = AuthController(_FakeAuthRepository(mockUser));

    return MultiProvider(
      providers: [
        Provider<DriverRepository>.value(value: driverRepo),
        Provider<TripRepository>.value(value: tripRepo),
        Provider<VehicleRepository>.value(value: vehicleRepo),
        Provider<RouteRepository>.value(value: routeRepo),
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider<HomeController>.value(value: homeController),
        ChangeNotifierProvider<TripsController>.value(value: tripsController),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen Responsiveness & Zero Overflow Tests', () {
    const screenSizes = [
      Size(360, 640), // Small Android Phone
      Size(390, 844), // Medium Android Phone
      Size(412, 915), // Large Android Phone
    ];

    for (final size in screenSizes) {
      testWidgets('Renders HomeScreen with 0 overflow on size ${size.width}x${size.height}', (WidgetTester tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(createHomeScreenWrapper());
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        // Verify dashboard key Tamil Nadu elements are rendered
        expect(find.textContaining('Good '), findsOneWidget);
        expect(find.text('Trips Today'), findsOneWidget);
        expect(find.text("Today's Assignment"), findsOneWidget);
        expect(find.text('Route VPM-101'), findsWidgets);
        expect(find.text('Next Scheduled Trip'), findsOneWidget);
        expect(find.text('Villupuram New Bus Stand'), findsWidgets);
        expect(find.text('Quick Operational Actions'), findsOneWidget);

        // Verify no exceptions were thrown during render
        expect(tester.takeException(), isNull);
      });
    }
  });
}
