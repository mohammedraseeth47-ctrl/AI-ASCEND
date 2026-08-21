import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_buses.dart';
import '../../../data/mock/mock_routes.dart';
import '../../../data/mock/mock_stops.dart';
import '../../../models/bus.dart';
import '../../../models/bus_stop.dart';
import '../../../models/route.dart' as app_models;

/// State for Home dashboard screen focusing on Tamil Nadu transport.
class HomeState {
  final Bus? nearbyLiveBus;
  final List<app_models.Route> nearbyRoutes;
  final List<BusStop> recentStops;
  final bool isLoading;
  final String? errorMessage;
  final String locationName;

  const HomeState({
    this.nearbyLiveBus,
    required this.nearbyRoutes,
    required this.recentStops,
    this.isLoading = false,
    this.errorMessage,
    this.locationName = 'Villupuram Central, Tamil Nadu',
  });

  HomeState copyWith({
    Bus? nearbyLiveBus,
    List<app_models.Route>? nearbyRoutes,
    List<BusStop>? recentStops,
    bool? isLoading,
    String? errorMessage,
    String? locationName,
  }) {
    return HomeState(
      nearbyLiveBus: nearbyLiveBus ?? this.nearbyLiveBus,
      nearbyRoutes: nearbyRoutes ?? this.nearbyRoutes,
      recentStops: recentStops ?? this.recentStops,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      locationName: locationName ?? this.locationName,
    );
  }
}

/// Provider supplying data for the Home screen dashboard.
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
      : super(const HomeState(
          nearbyRoutes: [],
          recentStops: [],
          isLoading: true,
        )) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 250));

    state = state.copyWith(
      nearbyLiveBus: MockBuses.bus1, // TN-32-AB-1234
      nearbyRoutes: MockRoutes.allRoutes,
      recentStops: [
        MockStops.villupuramBusStand,
        MockStops.cuddaloreBusStand,
        MockStops.puducherryBusStand,
        MockStops.panrutiBusStand,
      ],
      locationName: 'Villupuram Central, Tamil Nadu',
      isLoading: false,
    );
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
