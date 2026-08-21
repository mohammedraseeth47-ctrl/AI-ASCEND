import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/app/router/app_router.dart';
import 'package:trackgo_driver/core/theme/app_theme.dart';
import 'package:trackgo_driver/features/authentication/data/datasources/mock_auth_data_source.dart';
import 'package:trackgo_driver/features/authentication/data/repositories/firebase_auth_repository.dart';
import 'package:trackgo_driver/features/authentication/data/repositories/mock_auth_repository.dart';
import 'package:trackgo_driver/features/authentication/domain/repositories/auth_repository.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/home/data/datasources/mock_driver_data_source.dart';
import 'package:trackgo_driver/features/home/data/repositories/firebase_driver_repository.dart';
import 'package:trackgo_driver/features/home/data/repositories/mock_driver_repository.dart';
import 'package:trackgo_driver/features/home/domain/repositories/driver_repository.dart';
import 'package:trackgo_driver/features/home/presentation/controllers/home_controller.dart';
import 'package:trackgo_driver/features/notifications/data/datasources/mock_notification_data_source.dart';
import 'package:trackgo_driver/features/notifications/data/repositories/firebase_notification_repository.dart';
import 'package:trackgo_driver/features/notifications/data/repositories/mock_notification_repository.dart';
import 'package:trackgo_driver/features/notifications/domain/repositories/notification_repository.dart';
import 'package:trackgo_driver/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:trackgo_driver/features/tracking/data/repositories/firebase_location_repository.dart';
import 'package:trackgo_driver/features/tracking/data/repositories/mock_location_repository.dart';
import 'package:trackgo_driver/features/tracking/domain/repositories/location_repository.dart';
import 'package:trackgo_driver/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:trackgo_driver/features/tracking/services/location_tracking_service.dart';
import 'package:trackgo_driver/features/trips/data/datasources/mock_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/repositories/firebase_route_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/firebase_trip_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/firebase_vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_route_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_trip_repository.dart';
import 'package:trackgo_driver/features/trips/data/repositories/mock_vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/trip_repository.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/vehicle_repository.dart';
import 'package:trackgo_driver/features/trips/presentation/controllers/trips_controller.dart';

class TrackGoDriverApp extends StatelessWidget {
  final AuthRepository? authRepository;
  final TripRepository? tripRepository;
  final VehicleRepository? vehicleRepository;
  final RouteRepository? routeRepository;
  final DriverRepository? driverRepository;
  final LocationRepository? locationRepository;
  final NotificationRepository? notificationRepository;

  const TrackGoDriverApp({
    super.key,
    this.authRepository,
    this.tripRepository,
    this.vehicleRepository,
    this.routeRepository,
    this.driverRepository,
    this.locationRepository,
    this.notificationRepository,
  });

  @override
  Widget build(BuildContext context) {
    final hasFirebase = Firebase.apps.isNotEmpty;

    // Shared mock data source fallback for test environments or offline
    final mockTripDataSource = MockTripDataSource();
    final mockDriverDataSource = MockDriverDataSource(
      tripDataSource: mockTripDataSource,
    );

    // Repositories (Firebase backed when initialized, with clean fallback for testing/offline)
    final effectiveAuthRepo =
        authRepository ??
        (hasFirebase
            ? FirebaseAuthRepository()
            : MockAuthRepository(dataSource: MockAuthDataSource()));

    final effectiveTripRepo =
        tripRepository ??
        (hasFirebase
            ? FirebaseTripRepository()
            : MockTripRepository(dataSource: mockTripDataSource));

    final effectiveVehicleRepo =
        vehicleRepository ??
        (hasFirebase
            ? FirebaseVehicleRepository()
            : MockVehicleRepository(dataSource: mockTripDataSource));

    final effectiveRouteRepo =
        routeRepository ??
        (hasFirebase
            ? FirebaseRouteRepository()
            : MockRouteRepository(dataSource: mockTripDataSource));

    final effectiveDriverRepo =
        driverRepository ??
        (hasFirebase
            ? FirebaseDriverRepository()
            : MockDriverRepository(dataSource: mockDriverDataSource));

    final effectiveLocationRepo =
        locationRepository ??
        (hasFirebase ? FirebaseLocationRepository() : MockLocationRepository());

    final effectiveNotificationRepo =
        notificationRepository ??
        (hasFirebase
            ? FirebaseNotificationRepository()
            : MockNotificationRepository(
                dataSource: MockNotificationDataSource(),
              ));

    // Services
    final trackingService = LocationTrackingService(effectiveLocationRepo);

    return MultiProvider(
      providers: [
        // Repository Providers
        Provider<AuthRepository>.value(value: effectiveAuthRepo),
        Provider<TripRepository>.value(value: effectiveTripRepo),
        Provider<VehicleRepository>.value(value: effectiveVehicleRepo),
        Provider<RouteRepository>.value(value: effectiveRouteRepo),
        Provider<NotificationRepository>.value(
          value: effectiveNotificationRepo,
        ),
        Provider<DriverRepository>.value(value: effectiveDriverRepo),
        Provider<LocationRepository>.value(value: effectiveLocationRepo),

        // Tracking Service Provider
        ChangeNotifierProvider<LocationTrackingService>.value(
          value: trackingService,
        ),

        // Controller / State Management Providers
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(effectiveAuthRepo),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(effectiveDriverRepo),
        ),
        ChangeNotifierProvider<TripsController>(
          create: (_) => TripsController(effectiveTripRepo),
        ),
        ChangeNotifierProvider<NotificationsController>(
          create: (_) => NotificationsController(effectiveNotificationRepo),
        ),
        ChangeNotifierProvider<TrackingController>(
          create: (_) => TrackingController(trackingService),
        ),
      ],
      child: MaterialApp(
        title: 'TrackGo Driver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
