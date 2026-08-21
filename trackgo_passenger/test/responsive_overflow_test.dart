import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackgo_passenger/core/providers/storage_provider.dart';
import 'package:trackgo_passenger/core/services/local_storage_service.dart';
import 'package:trackgo_passenger/data/mock/mock_buses.dart';
import 'package:trackgo_passenger/data/mock/mock_routes.dart';
import 'package:trackgo_passenger/data/mock/mock_stops.dart';
import 'package:trackgo_passenger/features/home/presentation/home_screen.dart';
import 'package:trackgo_passenger/features/home/presentation/widgets/live_tracking_banner.dart';
import 'package:trackgo_passenger/features/home/presentation/widgets/nearby_routes_list.dart';
import 'package:trackgo_passenger/features/home/presentation/widgets/quick_actions_grid.dart';
import 'package:trackgo_passenger/features/home/presentation/widgets/recent_stops_section.dart';
import 'package:trackgo_passenger/features/onboarding/presentation/onboarding_screen.dart';
import 'package:trackgo_passenger/features/profile/presentation/profile_screen.dart';
import 'package:trackgo_passenger/features/search/presentation/search_screen.dart';
import 'package:trackgo_passenger/features/search/presentation/widgets/route_detail_sheet.dart';
import 'package:trackgo_passenger/features/tracking/presentation/tracking_screen.dart';
import 'package:trackgo_passenger/features/tracking/presentation/widgets/tracking_bottom_sheet.dart';
import 'package:trackgo_passenger/features/trips/presentation/trips_screen.dart';

void main() {
  const testPhoneSizes = [
    Size(320, 568), // Small iPhone SE / Android Go
    Size(360, 640), // Standard Small Android
    Size(375, 667), // iPhone 8 / SE2
    Size(390, 844), // iPhone 12/13/14
    Size(412, 915), // Pixel / Galaxy large
    Size(600, 960), // Foldable / Small Tablet
  ];

  late LocalStorageService storageService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = await LocalStorageService.create();
  });

  Widget buildTestApp(Widget child, Size size) {
    return ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(storageService),
      ],
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
        ),
      ),
    );
  }

  group('Responsive Zero-Overflow Screen Tests', () {
    for (final size in testPhoneSizes) {
      testWidgets('HomeScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const HomeScreen(), size));
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('SearchScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const SearchScreen(), size));
        await tester.pumpAndSettle();

        expect(find.byType(SearchScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('TrackingScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const TrackingScreen(), size));
        await tester.pump();

        expect(find.byType(TrackingScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('TripsScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const TripsScreen(), size));
        await tester.pumpAndSettle();

        expect(find.byType(TripsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('ProfileScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const ProfileScreen(), size));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('OnboardingScreen renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const OnboardingScreen(), size));
        await tester.pumpAndSettle();

        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('RouteDetailSheet renders with zero overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: RouteDetailSheet(route: MockRoutes.routeVillupuramCuddalorePuducherry),
            ),
            size,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RouteDetailSheet), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Component-level Zero-Overflow Tests on Narrow 320px Width', () {
    const narrowSize = Size(320, 568);

    testWidgets('LiveTrackingBanner renders without overflow', (tester) async {
      tester.view.physicalSize = narrowSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: LiveTrackingBanner(
              bus: MockBuses.bus1,
              onTrackPressed: () {},
            ),
          ),
          narrowSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('NearbyRoutesList renders without overflow', (tester) async {
      tester.view.physicalSize = narrowSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: NearbyRoutesList(
                routes: MockRoutes.allRoutes,
                onRouteTap: (_) {},
              ),
            ),
          ),
          narrowSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('QuickActionsGrid renders 2x2 without overflow', (tester) async {
      tester.view.physicalSize = narrowSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: QuickActionsGrid(
              actions: [
                QuickActionItem(title: 'Live Map', icon: Icons.map, color: Colors.teal, onTap: () {}),
                QuickActionItem(title: 'TN Routes', icon: Icons.route, color: Colors.blue, onTap: () {}),
                QuickActionItem(title: 'Bus Stands', icon: Icons.pin, color: Colors.purple, onTap: () {}),
                QuickActionItem(title: 'My Trips', icon: Icons.card_travel, color: Colors.amber, onTap: () {}),
              ],
            ),
          ),
          narrowSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('RecentStopsSection renders without overflow', (tester) async {
      tester.view.physicalSize = narrowSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: RecentStopsSection(
              stops: MockStops.allStops,
              onStopTap: (_) {},
            ),
          ),
          narrowSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('TrackingBottomSheet renders without overflow', (tester) async {
      tester.view.physicalSize = narrowSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: TrackingBottomSheet(
              bus: MockBuses.bus1,
              route: MockRoutes.routeVillupuramCuddalorePuducherry,
              onRecenter: () {},
              onNotify: () {},
            ),
          ),
          narrowSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
