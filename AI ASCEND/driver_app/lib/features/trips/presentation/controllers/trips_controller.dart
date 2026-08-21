import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/trip_repository.dart';

class TripsController extends ChangeNotifier {
  final TripRepository _tripRepository;

  List<Trip> _trips = [];
  Trip? _selectedTrip;
  Trip? _upcomingTrip;
  TripStatus? _activeFilter;
  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  TripsController(this._tripRepository);

  List<Trip> get trips => _trips;
  Trip? get selectedTrip => _selectedTrip;
  Trip? get upcomingTrip => _upcomingTrip;
  TripStatus? get activeFilter => _activeFilter;
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTrips({TripStatus? filter}) async {
    _isLoading = true;
    _errorMessage = null;
    _activeFilter = filter;
    notifyListeners();

    try {
      final fetched = await _tripRepository.getTrips(statusFilter: filter);
      _trips = List<Trip>.from(fetched);
      _upcomingTrip = await _tripRepository.getUpcomingTrip();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> loadTripDetail(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedTrip = await _tripRepository.getTripById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void setFilter(TripStatus? filter) {
    if (_activeFilter != filter) {
      loadTrips(filter: filter);
    }
  }

  /// Phase 2 Trip Lifecycle Status Transitions
  Future<bool> updateStatus(String tripId, TripStatus newStatus) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _tripRepository.updateTripStatus(tripId, newStatus);
      _selectedTrip = updated;

      // Update in cached list safely using immutable list creation
      _trips = _trips.map((t) => t.id == tripId ? updated : t).toList();

      _upcomingTrip = await _tripRepository.getUpcomingTrip();
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isActionLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> markReady(String tripId) =>
      updateStatus(tripId, TripStatus.ready);

  Future<bool> startTrip(String tripId) =>
      updateStatus(tripId, TripStatus.inProgress);

  Future<bool> completeTrip(String tripId) =>
      updateStatus(tripId, TripStatus.completed);

  Future<bool> cancelTrip(String tripId) =>
      updateStatus(tripId, TripStatus.cancelled);
}
