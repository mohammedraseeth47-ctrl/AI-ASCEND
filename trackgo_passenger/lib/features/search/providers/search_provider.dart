import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_routes.dart';
import '../../../data/mock/mock_stops.dart';
import '../../../models/bus_stop.dart';
import '../../../models/route.dart' as app_models;

enum SearchCategory { all, busLines, stops, places }

/// State container for Tamil Nadu transit search.
class SearchState {
  final String query;
  final SearchCategory selectedCategory;
  final List<app_models.Route> allRoutes;
  final List<BusStop> allStops;
  final List<app_models.Route> filteredRoutes;
  final List<BusStop> filteredStops;
  final bool isLoading;

  const SearchState({
    this.query = '',
    this.selectedCategory = SearchCategory.all,
    required this.allRoutes,
    required this.allStops,
    required this.filteredRoutes,
    required this.filteredStops,
    this.isLoading = false,
  });

  SearchState copyWith({
    String? query,
    SearchCategory? selectedCategory,
    List<app_models.Route>? allRoutes,
    List<BusStop>? allStops,
    List<app_models.Route>? filteredRoutes,
    List<BusStop>? filteredStops,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allRoutes: allRoutes ?? this.allRoutes,
      allStops: allStops ?? this.allStops,
      filteredRoutes: filteredRoutes ?? this.filteredRoutes,
      filteredStops: filteredStops ?? this.filteredStops,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider managing search queries, category filters, and Tamil Nadu routes.
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier()
      : super(SearchState(
          allRoutes: MockRoutes.allRoutes,
          allStops: MockStops.allStops,
          filteredRoutes: MockRoutes.allRoutes,
          filteredStops: MockStops.allStops,
        ));

  void setQuery(String query) {
    state = state.copyWith(query: query);
    _applyFilter();
  }

  void setCategory(SearchCategory category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilter();
  }

  void clearQuery() {
    setQuery('');
  }

  void _applyFilter() {
    final q = state.query.toLowerCase().trim();

    List<app_models.Route> routes = state.allRoutes;
    List<BusStop> stops = state.allStops;

    if (q.isNotEmpty) {
      routes = routes.where((r) {
        return r.routeNumber.toLowerCase().contains(q) ||
            r.routeName.toLowerCase().contains(q) ||
            r.origin.toLowerCase().contains(q) ||
            r.destination.toLowerCase().contains(q) ||
            r.viaSummary.toLowerCase().contains(q);
      }).toList();

      stops = stops.where((s) {
        return s.name.toLowerCase().contains(q) ||
            s.code.toLowerCase().contains(q) ||
            s.passingRouteNumbers.any((c) => c.toLowerCase().contains(q));
      }).toList();
    }

    state = state.copyWith(
      filteredRoutes: routes,
      filteredStops: stops,
    );
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
