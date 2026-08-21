import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bus.dart';

/// Service responsible for reading live driver GPS locations from Firebase Realtime Database
/// under the `liveLocations` path.
class FirebasePassengerDataSource {
  final FirebaseDatabase _database;

  FirebasePassengerDataSource({FirebaseDatabase? database})
      : _database = database ?? FirebaseDatabase.instance;

  /// Returns a real-time stream of active buses streaming GPS from the Driver App.
  Stream<List<Bus>> getLiveBusesStream() {
    final ref = _database.ref('liveLocations');

    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) {
        return <Bus>[];
      }

      final rawData = snapshot.value;
      final List<Bus> buses = [];

      if (rawData is Map) {
        rawData.forEach((key, value) {
          if (value is Map) {
            try {
              final bus = Bus.fromRealtimeDb(key.toString(), value);
              // Only include live tracking buses with valid coordinates
              if (bus != null && bus.status == 'Live') {
                buses.add(bus);
              }
            } catch (e) {
              debugPrint('Error parsing live bus entry for $key: $e');
            }
          }
        });
      } else if (rawData is List) {
        for (int i = 0; i < rawData.length; i++) {
          final item = rawData[i];
          if (item is Map) {
            try {
              final bus = Bus.fromRealtimeDb(i.toString(), item);
              if (bus != null && bus.status == 'Live') {
                buses.add(bus);
              }
            } catch (e) {
              debugPrint('Error parsing live bus entry at index $i: $e');
            }
          }
        }
      }

      return buses;
    }).handleError((error) {
      debugPrint('Firebase liveLocations stream error: $error');
      return <Bus>[];
    });
  }
}

/// Provider for FirebasePassengerDataSource
final firebasePassengerDataSourceProvider = Provider<FirebasePassengerDataSource>((ref) {
  return FirebasePassengerDataSource();
});

/// StreamProvider exposing the live bus list from Firebase
final liveBusesStreamProvider = StreamProvider<List<Bus>>((ref) {
  final dataSource = ref.watch(firebasePassengerDataSourceProvider);
  return dataSource.getLiveBusesStream();
});
