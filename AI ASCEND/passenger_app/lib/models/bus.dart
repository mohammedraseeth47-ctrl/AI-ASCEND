/// Real-time / Mock bus telemetry model for Tamil Nadu public transport.
class Bus {
  final String id;
  final String busNumber; // e.g. TN-32-AB-1234
  final String routeId;
  final String routeNumber;
  final String routeName;
  final double latitude;
  final double longitude;
  final String status; // 'On Route', 'Approaching', 'On Time', 'Delayed'
  final double heading;
  final double speedKmh;
  final String occupancyLabel;
  final String nextStopName;
  final int etaMinutes;
  final DateTime lastUpdated;
  final String? driverName;
  final String source; // 'driver' for Firebase real driver, 'mock' for local simulated demo bus

  const Bus({
    required this.id,
    required this.busNumber,
    required this.routeId,
    required this.routeNumber,
    required this.routeName,
    required this.latitude,
    required this.longitude,
    this.status = 'On Route',
    this.heading = 0.0,
    this.speedKmh = 35.0,
    this.occupancyLabel = 'Seats Available',
    this.nextStopName = 'Approaching Stop',
    this.etaMinutes = 5,
    required this.lastUpdated,
    this.driverName,
    this.source = 'mock',
  });

  bool get isDriver => source == 'driver';
  bool get isMock => source == 'mock';

  Bus copyWith({
    String? id,
    String? busNumber,
    String? routeId,
    String? routeNumber,
    String? routeName,
    double? latitude,
    double? longitude,
    String? status,
    double? heading,
    double? speedKmh,
    String? occupancyLabel,
    String? nextStopName,
    int? etaMinutes,
    DateTime? lastUpdated,
    String? driverName,
    String? source,
  }) {
    return Bus(
      id: id ?? this.id,
      busNumber: busNumber ?? this.busNumber,
      routeId: routeId ?? this.routeId,
      routeNumber: routeNumber ?? this.routeNumber,
      routeName: routeName ?? this.routeName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      heading: heading ?? this.heading,
      speedKmh: speedKmh ?? this.speedKmh,
      occupancyLabel: occupancyLabel ?? this.occupancyLabel,
      nextStopName: nextStopName ?? this.nextStopName,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      driverName: driverName ?? this.driverName,
      source: source ?? this.source,
    );
  }

  /// Safely create a Bus instance from Firebase Realtime Database data.
  /// Returns null if required coordinates (latitude, longitude) are missing or invalid.
  static Bus? fromRealtimeDb(String key, Map<dynamic, dynamic> data) {
    final lat = _parseDouble(data['latitude']);
    final lng = _parseDouble(data['longitude']);

    if (lat == null || lng == null) {
      return null;
    }

    final isTracking = data['isTracking'];
    final bool active = isTracking == null ? true : (isTracking == true || isTracking.toString() == 'true');
    final String tripId = data['tripId']?.toString() ?? key;
    final String vehicleId = data['vehicleId']?.toString() ?? 'BUS-${key.hashCode.abs() % 900 + 100}';
    final String? driverId = data['driverId']?.toString() ?? data['driverName']?.toString();

    // Timestamp parsing
    DateTime updatedAt = DateTime.now();
    final rawTimestamp = data['timestamp'] ?? data['clientTimestamp'];
    if (rawTimestamp is int) {
      updatedAt = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    } else if (rawTimestamp is num) {
      updatedAt = DateTime.fromMillisecondsSinceEpoch(rawTimestamp.toInt());
    } else if (rawTimestamp != null) {
      final parsedTs = int.tryParse(rawTimestamp.toString());
      if (parsedTs != null) {
        updatedAt = DateTime.fromMillisecondsSinceEpoch(parsedTs);
      }
    }

    final speed = _parseDouble(data['speed']) ?? 0.0;
    final heading = _parseDouble(data['heading']) ?? 0.0;
    final routeNumber = data['routeNumber']?.toString() ?? data['routeId']?.toString() ?? 'LIVE';
    final routeName = data['routeName']?.toString() ?? 'Live Driver Corridor';

    return Bus(
      id: tripId,
      busNumber: vehicleId,
      routeId: data['routeId']?.toString() ?? tripId,
      routeNumber: routeNumber,
      routeName: routeName,
      latitude: lat,
      longitude: lng,
      status: active ? 'Live' : 'Offline',
      heading: heading,
      speedKmh: speed,
      occupancyLabel: active ? 'Live Driver' : 'Standby',
      nextStopName: 'Live Route',
      etaMinutes: 1,
      lastUpdated: updatedAt,
      driverName: driverId != null ? 'Driver ($driverId)' : null,
      source: 'driver',
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
