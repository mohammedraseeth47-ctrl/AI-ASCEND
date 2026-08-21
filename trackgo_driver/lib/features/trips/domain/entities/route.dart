import 'package:trackgo_driver/features/trips/domain/entities/trip_stop.dart';

enum RouteStatus { active, diverted, maintenance }

extension RouteStatusExtension on RouteStatus {
  String get displayName {
    switch (this) {
      case RouteStatus.active:
        return 'Active Corridor';
      case RouteStatus.diverted:
        return 'Diverted';
      case RouteStatus.maintenance:
        return 'Under Maintenance';
    }
  }

  String get firestoreValue {
    switch (this) {
      case RouteStatus.active:
        return 'active';
      case RouteStatus.diverted:
        return 'diverted';
      case RouteStatus.maintenance:
        return 'maintenance';
    }
  }

  static RouteStatus fromFirestore(dynamic value) {
    if (value is bool) {
      return value ? RouteStatus.active : RouteStatus.maintenance;
    }
    final str = value?.toString();
    switch (str) {
      case 'active':
        return RouteStatus.active;
      case 'diverted':
        return RouteStatus.diverted;
      case 'maintenance':
        return RouteStatus.maintenance;
      default:
        return RouteStatus.active;
    }
  }
}

class TransitRoute {
  final String id;
  final String routeId;
  final String routeNumber;
  final String routeName;
  final String origin;
  final String destination;
  final List<String> districts;
  final String state;
  final double distanceKm;
  final int totalStopsCount;
  final String colorHex;
  final List<TripStop> stops;
  final RouteStatus status;
  final int estimatedDurationMinutes;
  final String viaMajorStops;
  final String operatingRegion;

  const TransitRoute({
    required this.id,
    this.routeId = 'VPM-101',
    required this.routeNumber,
    required this.routeName,
    required this.origin,
    required this.destination,
    this.districts = const ['Villupuram', 'Cuddalore'],
    this.state = 'Tamil Nadu',
    required this.distanceKm,
    required this.totalStopsCount,
    this.colorHex = '#0284C7',
    this.stops = const [],
    this.status = RouteStatus.active,
    this.estimatedDurationMinutes = 93,
    this.viaMajorStops = 'Valavanur, Panruti, Nellikuppam',
    this.operatingRegion = 'Villupuram – Cuddalore Coastal Belt',
  });

  String get directionDescription => '$origin ⇄ $destination';

  factory TransitRoute.fromFirestore(Map<String, dynamic> data, String docId) {
    final rawStops = data['stops'] as List<dynamic>? ?? [];
    final List<TripStop> parsedStops = [];

    for (int i = 0; i < rawStops.length; i++) {
      final item = rawStops[i];
      if (item is Map<String, dynamic>) {
        parsedStops.add(TripStop.fromFirestore(item));
      } else if (item is Map) {
        parsedStops.add(
          TripStop.fromFirestore(Map<String, dynamic>.from(item)),
        );
      } else if (item is String) {
        parsedStops.add(
          TripStop(
            id: 'STP-${i + 1}',
            sequenceNumber: i + 1,
            stopName: item,
            scheduledTime: 'Stop ${i + 1}',
            isTerminal: i == 0 || i == rawStops.length - 1,
          ),
        );
      }
    }

    final rawDistricts = data['districts'] as List<dynamic>? ?? [];
    final parsedDistricts = rawDistricts.map((d) => d.toString()).toList();

    final rCode =
        data['routeCode']?.toString() ??
        data['routeNumber']?.toString() ??
        docId;
    final rName =
        data['name']?.toString() ??
        data['routeName']?.toString() ??
        'Route $rCode';
    final rOrigin = data['origin']?.toString() ?? 'Villupuram New Bus Stand';
    final rDest = data['destination']?.toString() ?? 'Cuddalore Bus Stand';
    final dist = (data['distanceKm'] as num?)?.toDouble() ?? 46.5;

    return TransitRoute(
      id: docId,
      routeId: data['routeId']?.toString() ?? docId,
      routeNumber: rCode.startsWith('Route ') ? rCode : 'Route $rCode',
      routeName: rName,
      origin: rOrigin,
      destination: rDest,
      districts: parsedDistricts.isNotEmpty
          ? parsedDistricts
          : const ['Villupuram', 'Cuddalore'],
      state: data['state']?.toString() ?? 'Tamil Nadu',
      distanceKm: dist,
      totalStopsCount:
          (data['totalStopsCount'] as num?)?.toInt() ?? parsedStops.length,
      colorHex: data['colorHex']?.toString() ?? '#0284C7',
      stops: parsedStops,
      status: RouteStatusExtension.fromFirestore(
        data['status'] ?? data['active'],
      ),
      estimatedDurationMinutes:
          (data['estimatedDurationMinutes'] as num?)?.toInt() ?? 93,
      viaMajorStops:
          data['viaMajorStops']?.toString() ??
          'Valavanur, Panruti, Nellikuppam',
      operatingRegion:
          data['operatingRegion']?.toString() ??
          'Villupuram – Cuddalore Coastal Belt',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'routeId': routeId,
      'routeCode': routeNumber.replaceAll('Route ', ''),
      'name': routeName,
      'routeName': routeName,
      'origin': origin,
      'destination': destination,
      'districts': districts,
      'state': state,
      'distanceKm': distanceKm,
      'totalStopsCount': totalStopsCount,
      'colorHex': colorHex,
      'stops': stops.map((s) => s.toFirestore()).toList(),
      'status': status.firestoreValue,
      'active': status == RouteStatus.active,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'viaMajorStops': viaMajorStops,
      'operatingRegion': operatingRegion,
    };
  }

  TransitRoute copyWith({
    String? id,
    String? routeId,
    String? routeNumber,
    String? routeName,
    String? origin,
    String? destination,
    List<String>? districts,
    String? state,
    double? distanceKm,
    int? totalStopsCount,
    String? colorHex,
    List<TripStop>? stops,
    RouteStatus? status,
    int? estimatedDurationMinutes,
    String? viaMajorStops,
    String? operatingRegion,
  }) {
    return TransitRoute(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      routeNumber: routeNumber ?? this.routeNumber,
      routeName: routeName ?? this.routeName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      districts: districts ?? this.districts,
      state: state ?? this.state,
      distanceKm: distanceKm ?? this.distanceKm,
      totalStopsCount: totalStopsCount ?? this.totalStopsCount,
      colorHex: colorHex ?? this.colorHex,
      stops: stops ?? this.stops,
      status: status ?? this.status,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      viaMajorStops: viaMajorStops ?? this.viaMajorStops,
      operatingRegion: operatingRegion ?? this.operatingRegion,
    );
  }
}
