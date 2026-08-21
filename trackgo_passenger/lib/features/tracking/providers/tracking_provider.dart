import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/map_service.dart';
import '../../../core/services/mock_bus_service.dart';
import '../../../core/services/road_routing_service.dart';
import '../../../data/datasources/firebase_passenger_data_source.dart';
import '../../../data/mock/mock_routes.dart';
import '../../../models/bus.dart';
import '../../../models/route.dart' as app_models;

/// State for the Tamil Nadu Live Map & Bus Tracking feature.
class TrackingState {
  final app_models.Route selectedRoute;
  final List<app_models.Route> routes;
  final List<Bus> activeBuses;
  final List<Bus> firebaseBuses;
  final List<Bus> mockBuses;
  final Bus? selectedBus;
  final LatLng mapCenter;
  final double zoom;
  final bool isTrackingBus;
  final bool isLoading;
  final String? errorMessage;

  const TrackingState({
    required this.selectedRoute,
    this.routes = const [],
    required this.activeBuses,
    this.firebaseBuses = const [],
    this.mockBuses = const [],
    this.selectedBus,
    required this.mapCenter,
    this.zoom = AppConstants.defaultZoom,
    this.isTrackingBus = false,
    this.isLoading = false,
    this.errorMessage,
  });

  TrackingState copyWith({
    app_models.Route? selectedRoute,
    List<app_models.Route>? routes,
    List<Bus>? activeBuses,
    List<Bus>? firebaseBuses,
    List<Bus>? mockBuses,
    Bus? selectedBus,
    bool clearSelectedBus = false,
    LatLng? mapCenter,
    double? zoom,
    bool? isTrackingBus,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TrackingState(
      selectedRoute: selectedRoute ?? this.selectedRoute,
      routes: routes ?? this.routes,
      activeBuses: activeBuses ?? this.activeBuses,
      firebaseBuses: firebaseBuses ?? this.firebaseBuses,
      mockBuses: mockBuses ?? this.mockBuses,
      selectedBus: clearSelectedBus ? null : (selectedBus ?? this.selectedBus),
      mapCenter: mapCenter ?? this.mapCenter,
      zoom: zoom ?? this.zoom,
      isTrackingBus: isTrackingBus ?? this.isTrackingBus,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier handling live bus GPS updates from Firebase Realtime Database
/// combined with smooth local mock bus road-following simulations.
class TrackingNotifier extends StateNotifier<TrackingState> {
  final FirebasePassengerDataSource _dataSource;
  final MockBusService _mockBusService;
  StreamSubscription<List<Bus>>? _busSubscription;
  List<Bus> _latestFirebaseBuses = [];
  List<Bus> _latestMockBuses = [];

  TrackingNotifier(this._dataSource, this._mockBusService)
      : super(TrackingState(
          selectedRoute: MockRoutes.routeVillupuramTrichy,
          routes: MockRoutes.allRoutes,
          activeBuses: const [],
          firebaseBuses: const [],
          mockBuses: const [],
          selectedBus: null,
          mapCenter: MapService.tamilNaduCenter,
          zoom: MapService.defaultZoom,
          isLoading: true,
        )) {
    _initServices();
  }

  void _initServices() {
    _startFirebaseListener();
    _startMockBusListener();
    _loadAllRoutesRoadGeometry();
  }

  /// Fetches and caches OSRM road geometry for all 3 demo routes.
  Future<void> _loadAllRoutesRoadGeometry() async {
    final List<app_models.Route> updatedRoutes = [];

    for (final route in MockRoutes.allRoutes) {
      if (route.stops.length >= 2) {
        final waypoints = route.stops.map((s) => LatLng(s.latitude, s.longitude)).toList();
        final roadPoints = await RoadRoutingService.getCachedOrFetchRoute(
          route.id,
          waypoints,
          fallbackPoints: route.polylinePoints,
        );

        final updatedRoute = route.copyWith(polylinePoints: roadPoints);
        updatedRoutes.add(updatedRoute);
        _mockBusService.updateRoutePath(route.id, roadPoints);
      } else {
        updatedRoutes.add(route);
      }
    }

    if (mounted && updatedRoutes.isNotEmpty) {
      final newSelectedRoute = updatedRoutes.firstWhere(
        (r) => r.id == state.selectedRoute.id,
        orElse: () => updatedRoutes.first,
      );

      state = state.copyWith(
        routes: updatedRoutes,
        selectedRoute: newSelectedRoute,
      );
    }
  }

  void _startFirebaseListener() {
    _busSubscription?.cancel();
    _busSubscription = _dataSource.getLiveBusesStream().listen(
      (firebaseBuses) {
        _latestFirebaseBuses = firebaseBuses;
        _recomputeBuses();
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to connect to live tracking stream',
        );
      },
    );
  }

  void _startMockBusListener() {
    _latestMockBuses = _mockBusService.getMockBuses();
    _mockBusService.addListener(_onMockBusTick);
    _recomputeBuses();
  }

  void _onMockBusTick() {
    if (!mounted) return;
    _latestMockBuses = _mockBusService.getMockBuses();
    _recomputeBuses();
  }

  void _recomputeBuses() {
    final List<Bus> allBuses = [
      ..._latestFirebaseBuses,
      if (showMockBuses) ..._latestMockBuses,
    ];

    Bus? newSelectedBus;
    if (allBuses.isNotEmpty) {
      if (state.selectedBus != null) {
        newSelectedBus = allBuses.firstWhere(
          (b) => b.id == state.selectedBus!.id,
          orElse: () => allBuses.first,
        );
      } else {
        // Prioritize real driver bus if available, else first mock bus
        newSelectedBus = allBuses.firstWhere(
          (b) => b.isDriver,
          orElse: () => allBuses.first,
        );
      }
    }

    LatLng newMapCenter = state.mapCenter;
    // If tracking is active, follow selected bus
    if (newSelectedBus != null && state.isTrackingBus) {
      newMapCenter = LatLng(newSelectedBus.latitude, newSelectedBus.longitude);
    }

    state = state.copyWith(
      activeBuses: allBuses,
      firebaseBuses: _latestFirebaseBuses,
      mockBuses: _latestMockBuses,
      selectedBus: newSelectedBus,
      clearSelectedBus: allBuses.isEmpty,
      mapCenter: newMapCenter,
      isLoading: false,
      errorMessage: null,
    );
  }

  void selectRoute(app_models.Route route) {
    state = state.copyWith(
      selectedRoute: route,
      mapCenter: route.polylinePoints.isNotEmpty
          ? route.polylinePoints.first
          : MapService.tamilNaduCenter,
      isTrackingBus: false,
    );
  }

  void selectBus(Bus bus) {
    // Find matching route for this bus
    final matchedRoute = state.routes.firstWhere(
      (r) => r.id == bus.routeId,
      orElse: () => state.selectedRoute,
    );

    state = state.copyWith(
      selectedBus: bus,
      selectedRoute: matchedRoute,
      mapCenter: LatLng(bus.latitude, bus.longitude),
      isTrackingBus: true,
    );
  }

  void centerOnBus() {
    if (state.selectedBus != null) {
      state = state.copyWith(
        mapCenter: LatLng(state.selectedBus!.latitude, state.selectedBus!.longitude),
        isTrackingBus: true,
      );
    }
  }

  void resetToTamilNaduView() {
    state = state.copyWith(
      mapCenter: MapService.tamilNaduCenter,
      zoom: MapService.defaultZoom,
      isTrackingBus: false,
    );
  }

  void setZoom(double newZoom) {
    state = state.copyWith(
      zoom: newZoom.clamp(MapService.minZoom, MapService.maxZoom),
    );
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    _mockBusService.removeListener(_onMockBusTick);
    _mockBusService.dispose();
    super.dispose();
  }
}

final mockBusServiceProvider = Provider<MockBusService>((ref) {
  final service = MockBusService();
  ref.onDispose(() => service.dispose());
  return service;
});

final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  final dataSource = ref.watch(firebasePassengerDataSourceProvider);
  final mockService = ref.watch(mockBusServiceProvider);
  return TrackingNotifier(dataSource, mockService);
});
