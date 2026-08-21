import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/tracking/domain/entities/driver_location.dart';

void main() {
  group('DriverLocation Domain Entity Tests', () {
    test('Converts to Realtime Database JSON payload with server timestamp placeholder', () {
      final now = DateTime(2026, 8, 20, 10, 30, 0);
      final location = DriverLocation(
        latitude: 11.9401,
        longitude: 79.4861,
        accuracy: 8.5,
        speed: 31.4,
        heading: 92.0,
        timestamp: now,
        isTracking: true,
      );

      final rtdbMap = location.toRealtimeDb(
        driverId: 'DRV-1024',
        vehicleId: 'BUS-402',
        tripId: 'TRP-10482',
      );

      expect(rtdbMap['driverId'], 'DRV-1024');
      expect(rtdbMap['vehicleId'], 'BUS-402');
      expect(rtdbMap['tripId'], 'TRP-10482');
      expect(rtdbMap['latitude'], 11.9401);
      expect(rtdbMap['longitude'], 79.4861);
      expect(rtdbMap['accuracy'], 8.5);
      expect(rtdbMap['speed'], 31.4);
      expect(rtdbMap['heading'], 92.0);
      expect(rtdbMap['isTracking'], isTrue);
      expect(rtdbMap['clientTimestamp'], now.millisecondsSinceEpoch);
      expect(rtdbMap['timestamp'], equals({'.sv': 'timestamp'}));
    });

    test('toString formats cleanly for logging', () {
      final location = DriverLocation(
        latitude: 11.9401,
        longitude: 79.4861,
        accuracy: 5.0,
        speed: 40.0,
        heading: 180.0,
        timestamp: DateTime.now(),
      );

      expect(
        location.toString(),
        contains('11.9401, 79.4861'),
      );
      expect(location.toString(), contains('spd=40.0 km/h'));
    });
  });
}
