import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Service for fetching and caching road-following route polylines using public OSRM API with resilient fallback geometry.
class RoadRoutingService {
  static const String _osrmBaseUrl = 'https://router.project-osrm.org/route/v1/driving';
  static const Duration _timeout = Duration(seconds: 6);

  // In-memory cache to ensure each route is requested at most ONCE from OSRM
  static final Map<String, List<LatLng>> _routeCache = {};

  /// Get cached road route points or fetch from OSRM.
  static Future<List<LatLng>> getCachedOrFetchRoute(
    String routeId,
    List<LatLng> waypoints, {
    List<LatLng>? fallbackPoints,
  }) async {
    if (_routeCache.containsKey(routeId) && _routeCache[routeId]!.isNotEmpty) {
      return _routeCache[routeId]!;
    }

    final points = await getMultiPointRoadRoute(waypoints, fallbackPoints: fallbackPoints);
    _routeCache[routeId] = points;
    return points;
  }

  /// Fetch road geometry passing through multiple waypoints.
  /// Converts GeoJSON [longitude, latitude] coordinate pairs into [LatLng(latitude, longitude)].
  static Future<List<LatLng>> getMultiPointRoadRoute(
    List<LatLng> waypoints, {
    List<LatLng>? fallbackPoints,
  }) async {
    if (waypoints.length < 2) {
      return waypoints;
    }

    try {
      // OSRM expects "longitude,latitude;longitude,latitude;..."
      final coordString = waypoints
          .map((pt) => '${pt.longitude.toStringAsFixed(6)},${pt.latitude.toStringAsFixed(6)}')
          .join(';');

      final url = Uri.parse('$_osrmBaseUrl/$coordString?overview=full&geometries=geojson');

      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['code'] == 'Ok' && data['routes'] is List && (data['routes'] as List).isNotEmpty) {
          final firstRoute = data['routes'][0];
          final geometry = firstRoute['geometry'];
          if (geometry is Map && geometry['coordinates'] is List) {
            final coords = geometry['coordinates'] as List;
            final List<LatLng> roadPoints = [];

            for (final point in coords) {
              if (point is List && point.length >= 2) {
                // GeoJSON format is [longitude, latitude]
                final lng = (point[0] as num).toDouble();
                final lat = (point[1] as num).toDouble();
                roadPoints.add(LatLng(lat, lng));
              }
            }

            if (roadPoints.length >= 2) {
              debugPrint('RoadRoutingService: Successfully fetched ${roadPoints.length} OSRM road coordinates.');
              return roadPoints;
            }
          }
        }
      }
      debugPrint('RoadRoutingService: OSRM returned non-200 status (${response.statusCode}). Using fallback route.');
    } catch (e) {
      debugPrint('RoadRoutingService: OSRM route fetch error ($e). Using fallback geometry.');
    }

    // Fallback: Use high-density fallback points if available
    if (fallbackPoints != null && fallbackPoints.isNotEmpty) {
      return fallbackPoints;
    }

    return _generateCurvedFallback(waypoints);
  }

  /// Generates a smooth multi-point fallback path between waypoints so a straight 2-point line is never shown.
  static List<LatLng> _generateCurvedFallback(List<LatLng> waypoints) {
    if (waypoints.length < 2) return waypoints;
    final List<LatLng> points = [];

    for (int i = 0; i < waypoints.length - 1; i++) {
      final p1 = waypoints[i];
      final p2 = waypoints[i + 1];
      const int segments = 12;

      for (int s = 0; s < segments; s++) {
        final t = s / segments;
        // Subtle highway bend offset
        final offset = (s % 2 == 0 ? 0.0003 : -0.0003) * (1 - (2 * t - 1).abs());
        final lat = p1.latitude + (p2.latitude - p1.latitude) * t + offset;
        final lng = p1.longitude + (p2.longitude - p1.longitude) * t + (offset * 0.5);
        points.add(LatLng(lat, lng));
      }
    }
    points.add(waypoints.last);
    return points;
  }
}
