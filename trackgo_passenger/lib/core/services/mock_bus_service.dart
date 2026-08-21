import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../../data/mock/mock_routes.dart';
import '../../models/bus.dart';

/// Top-level configuration flags for Phase 2 Demo
const bool showMockBuses = true;

/// Configurable simulation speed multiplier.
/// 0.05 = very slow, 0.10 = slow, 0.15 = demonstration speed (default), 0.25 = faster, 1.0 = normal/full speed.
const double mockSpeedMultiplier = 0.15;

/// State descriptor for an active mock bus along its road path.
class _MockBusState {
  final String id;
  final String busNumber;
  final String routeId;
  final String routeNumber;
  final String routeName;
  final List<LatLng> path;
  double progressIndex; // Continuous floating point index along path [0 .. path.length - 1]
  final double speedKmh;
  final String occupancyLabel;
  final String nextStopName;

  _MockBusState({
    required this.id,
    required this.busNumber,
    required this.routeId,
    required this.routeNumber,
    required this.routeName,
    required this.path,
    required this.progressIndex,
    this.speedKmh = 38.0,
    this.occupancyLabel = 'Seats Available',
    this.nextStopName = 'Next Stop',
  });
}

/// Service managing 3 distinct mock buses moving slowly and smoothly along individual road-following routes.
class MockBusService extends ChangeNotifier {
  final List<_MockBusState> _mockBuses = [];
  Timer? _movementTimer;
  bool _isInitialized = false;

  MockBusService() {
    if (showMockBuses) {
      _initMockBuses();
      _startMovementTimer();
    }
  }

  void _initMockBuses() {
    if (_isInitialized) return;

    // 1. BUS 01: Villupuram → Trichy (Route 101) - starts at 20%
    final path1 = List<LatLng>.from(MockRoutes.routeVillupuramTrichy.polylinePoints);
    final startIndex1 = path1.length > 1 ? (path1.length * 0.20).clamp(0.0, (path1.length - 1).toDouble()) : 0.0;

    _mockBuses.add(_MockBusState(
      id: 'MOCK_BUS_01',
      busNumber: 'TN-32-M-01',
      routeId: MockRoutes.routeVillupuramTrichy.id,
      routeNumber: '101',
      routeName: 'Villupuram → Trichy',
      path: path1,
      progressIndex: startIndex1,
      speedKmh: 42.0,
      occupancyLabel: 'Seats Available',
      nextStopName: 'Ulundurpet Toll',
    ));

    // 2. BUS 02: Chennai → Vadalur (Route 102) - starts at 45%
    final path2 = List<LatLng>.from(MockRoutes.routeChennaiVadalur.polylinePoints);
    final startIndex2 = path2.length > 1 ? (path2.length * 0.45).clamp(0.0, (path2.length - 1).toDouble()) : 0.0;

    _mockBuses.add(_MockBusState(
      id: 'MOCK_BUS_02',
      busNumber: 'TN-01-M-02',
      routeId: MockRoutes.routeChennaiVadalur.id,
      routeNumber: '102',
      routeName: 'Chennai → Vadalur',
      path: path2,
      progressIndex: startIndex2,
      speedKmh: 45.0,
      occupancyLabel: 'Moderate',
      nextStopName: 'Panruti Terminal',
    ));

    // 3. BUS 03: Villupuram → Pondicherry (Route 103) - starts at 65%
    final path3 = List<LatLng>.from(MockRoutes.routeVillupuramPondicherry.polylinePoints);
    final startIndex3 = path3.length > 1 ? (path3.length * 0.65).clamp(0.0, (path3.length - 1).toDouble()) : 0.0;

    _mockBuses.add(_MockBusState(
      id: 'MOCK_BUS_03',
      busNumber: 'TN-32-M-03',
      routeId: MockRoutes.routeVillupuramPondicherry.id,
      routeNumber: '103',
      routeName: 'Villupuram → Pondicherry',
      path: path3,
      progressIndex: startIndex3,
      speedKmh: 35.0,
      occupancyLabel: 'Standing Only',
      nextStopName: 'Villianur Temple',
    ));

    _isInitialized = true;
  }

  /// Updates the single source of truth road geometry for a specific route.
  void updateRoutePath(String routeId, List<LatLng> roadGeometry) {
    if (roadGeometry.length < 2) return;

    for (final busState in _mockBuses) {
      if (busState.routeId == routeId) {
        final currentRatio = busState.path.isNotEmpty
            ? (busState.progressIndex / busState.path.length).clamp(0.0, 1.0)
            : 0.2;

        busState.path.clear();
        busState.path.addAll(roadGeometry);
        busState.progressIndex = (currentRatio * (roadGeometry.length - 1)).clamp(0.0, (roadGeometry.length - 1).toDouble());
      }
    }
    notifyListeners();
  }

  void _startMovementTimer() {
    _movementTimer?.cancel();
    // Update every 600ms for smooth and fluid visualization
    _movementTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      _tickMovement();
    });
  }

  void _tickMovement() {
    if (_mockBuses.isEmpty) return;

    for (final busState in _mockBuses) {
      if (busState.path.length < 2) continue;

      // Increment progress slowly based on mockSpeedMultiplier
      // Smaller step ensures slow, steady, road-adhering movement suitable for demonstration
      final step = 0.06 * mockSpeedMultiplier;
      busState.progressIndex += step;

      // Loop around smoothly when reaching the end of the route
      if (busState.progressIndex >= busState.path.length - 1) {
        busState.progressIndex = 0.0;
      }
    }
    notifyListeners();
  }

  /// Returns current snapshot of all 3 mock buses strictly calculated from route geometry.
  List<Bus> getMockBuses() {
    if (!showMockBuses) return [];

    final List<Bus> result = [];

    for (final busState in _mockBuses) {
      if (busState.path.length < 2) continue;

      final idx = busState.progressIndex.floor().clamp(0, busState.path.length - 2);
      final nextIdx = (idx + 1).clamp(0, busState.path.length - 1);
      final frac = (busState.progressIndex - idx).clamp(0.0, 1.0);

      final p1 = busState.path[idx];
      final p2 = busState.path[nextIdx];

      // Linear interpolation between the two adjacent road geometry points
      final lat = p1.latitude + (p2.latitude - p1.latitude) * frac;
      final lng = p1.longitude + (p2.longitude - p1.longitude) * frac;

      // Calculate bearing / heading
      final heading = _calculateBearing(p1, p2);

      result.add(Bus(
        id: busState.id,
        busNumber: busState.busNumber,
        routeId: busState.routeId,
        routeNumber: busState.routeNumber,
        routeName: busState.routeName,
        latitude: lat,
        longitude: lng,
        status: 'Running',
        heading: heading,
        speedKmh: busState.speedKmh,
        occupancyLabel: busState.occupancyLabel,
        nextStopName: busState.nextStopName,
        etaMinutes: 5,
        lastUpdated: DateTime.now(),
        driverName: 'Demo Driver (${busState.id})',
        source: 'mock',
      ));
    }

    return result;
  }

  /// Calculates geodesic bearing in degrees [0..360] between two points.
  static double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * (math.pi / 180.0);
    final lon1 = start.longitude * (math.pi / 180.0);
    final lat2 = end.latitude * (math.pi / 180.0);
    final lon2 = end.longitude * (math.pi / 180.0);

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final radians = math.atan2(y, x);
    return (radians * (180.0 / math.pi) + 360.0) % 360.0;
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }
}
