/// Represents a GPS location update from the driver's device.
class DriverLocation {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed; // km/h
  final double heading; // degrees
  final DateTime timestamp;
  final bool isTracking;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.timestamp,
    this.isTracking = true,
  });

  Map<String, dynamic> toRealtimeDb({
    required String driverId,
    required String vehicleId,
    required String tripId,
  }) {
    return {
      'driverId': driverId,
      'vehicleId': vehicleId,
      'tripId': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'heading': heading,
      'timestamp': const {'.sv': 'timestamp'},
      'clientTimestamp': timestamp.millisecondsSinceEpoch,
      'isTracking': isTracking,
    };
  }

  @override
  String toString() =>
      'DriverLocation($latitude, $longitude, acc=$accuracy, spd=$speed km/h)';
}
