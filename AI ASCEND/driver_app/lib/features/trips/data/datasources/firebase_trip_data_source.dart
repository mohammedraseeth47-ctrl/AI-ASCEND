import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/trips/data/datasources/firebase_route_data_source.dart';
import 'package:trackgo_driver/features/trips/data/datasources/firebase_vehicle_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

class FirebaseTripDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseRouteDataSource _routeDataSource;
  final FirebaseVehicleDataSource _vehicleDataSource;

  final Map<String, TransitRoute> _routeCache = {};
  final Map<String, Vehicle> _vehicleCache = {};

  FirebaseTripDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseRouteDataSource? routeDataSource,
    FirebaseVehicleDataSource? vehicleDataSource,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _routeDataSource =
           routeDataSource ?? FirebaseRouteDataSource(firestore: firestore),
       _vehicleDataSource =
           vehicleDataSource ?? FirebaseVehicleDataSource(firestore: firestore);

  String? get _currentUid => _auth.currentUser?.uid;

  static List<Trip> getDemoTrips(String uid) {
    const demoVehicle = Vehicle(
      id: 'BUS001',
      vehicleId: 'BUS001',
      registrationNumber: 'TN 32 AB 1234',
      vehicleCode: 'BUS001',
      model: 'Ashok Leyland Viking Ultra BS-VI',
      vehicleType: 'PSV Heavy Passenger Transit',
      seatingCapacity: 48,
      standingCapacity: 20,
      fuelOrBatteryStatus: '92% Fuel Level',
    );

    const demoRoute = TransitRoute(
      id: 'VPM-CUD-01',
      routeId: 'VPM-CUD-01',
      routeNumber: 'Route VPM-CUD-01',
      routeName: 'Villupuram → Cuddalore',
      origin: 'Villupuram',
      destination: 'Cuddalore',
      distanceKm: 46.5,
      totalStopsCount: 8,
    );

    return [
      Trip(
        id: 'TRIP-001',
        tripId: 'TRIP-001',
        tripCode: 'TRIP-VPM-01',
        route: demoRoute,
        vehicle: demoVehicle,
        driverId: uid,
        date: 'Today',
        scheduledDeparture: '08:15 AM',
        scheduledArrival: '09:48 AM',
        status: TripStatus.ready,
        stops: demoRoute.stops,
        origin: 'Villupuram',
        destination: 'Cuddalore',
      ),
      Trip(
        id: 'TRIP-002',
        tripId: 'TRIP-002',
        tripCode: 'TRIP-VPM-02',
        route: demoRoute,
        vehicle: demoVehicle,
        driverId: uid,
        date: 'Today',
        scheduledDeparture: '10:30 AM',
        scheduledArrival: '12:05 PM',
        status: TripStatus.scheduled,
        stops: demoRoute.stops,
        origin: 'Cuddalore',
        destination: 'Villupuram',
      ),
      Trip(
        id: 'TRIP-003',
        tripId: 'TRIP-003',
        tripCode: 'TRIP-VPM-03',
        route: demoRoute,
        vehicle: demoVehicle,
        driverId: uid,
        date: 'Today',
        scheduledDeparture: '02:00 PM',
        scheduledArrival: '03:35 PM',
        status: TripStatus.completed,
        stops: demoRoute.stops,
        origin: 'Villupuram',
        destination: 'Cuddalore',
      ),
    ];
  }

  Future<List<Trip>> getTrips({
    TripStatus? statusFilter,
    String? driverId,
  }) async {
    final targetDriverId = driverId ?? _currentUid ?? 'DRV001';

    try {
      Query<Map<String, dynamic>> query = _firestore.collection('trips');

      if (targetDriverId.isNotEmpty) {
        query = query.where('driverId', isEqualTo: targetDriverId);
      }

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.firestoreValue);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final trips = <Trip>[];
        for (final doc in querySnapshot.docs) {
          final trip = await _populateTrip(doc.data(), doc.id);
          if (trip != null) {
            trips.add(trip);
          }
        }
        return trips;
      }
    } catch (e) {
      debugPrint('Firestore read error in getTrips ($e) - using demo fallback');
    }

    final demoList = getDemoTrips(targetDriverId);
    if (statusFilter != null) {
      return demoList.where((t) => t.status == statusFilter).toList();
    }
    return demoList;
  }

  Future<Trip?> getTripById(String id) async {
    try {
      final doc = await _firestore.collection('trips').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return await _populateTrip(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Error in getTripById: $e');
    }

    final demo = getDemoTrips(_currentUid ?? 'DRV001');
    return demo.firstWhere((t) => t.id == id, orElse: () => demo.first);
  }

  Future<Trip?> getUpcomingTrip({String? driverId}) async {
    final trips = await getTrips(driverId: driverId);
    if (trips.isEmpty) return null;

    try {
      return trips.firstWhere((t) => t.status == TripStatus.inProgress);
    } catch (_) {}

    try {
      return trips.firstWhere((t) => t.status == TripStatus.ready);
    } catch (_) {}

    try {
      return trips.firstWhere((t) => t.status == TripStatus.scheduled);
    } catch (_) {}

    return trips.first;
  }

  Future<Trip> updateTripStatus(String id, TripStatus newStatus) async {
    try {
      final docRef = _firestore.collection('trips').doc(id);
      final doc = await docRef.get();

      if (doc.exists && doc.data() != null) {
        final currentData = doc.data()!;
        final updates = <String, dynamic>{
          'status': newStatus.firestoreValue,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (newStatus == TripStatus.inProgress) {
          updates['startedAt'] = FieldValue.serverTimestamp();
          updates['actualDeparture'] =
              currentData['actualDeparture'] ?? 'Today, Live Active';
        } else if (newStatus == TripStatus.completed) {
          updates['completedAt'] = FieldValue.serverTimestamp();
          updates['actualArrival'] =
              currentData['actualArrival'] ?? 'Today, Completed';
        }

        await docRef.update(updates);
        final updatedDoc = await docRef.get();
        final updatedTrip = await _populateTrip(
          updatedDoc.data()!,
          updatedDoc.id,
        );
        if (updatedTrip != null) return updatedTrip;
      }
    } catch (e) {
      debugPrint('Trip status updated in-memory fallback ($e)');
    }

    final demoTrips = getDemoTrips(_currentUid ?? 'DRV001');
    final match = demoTrips.firstWhere(
      (t) => t.id == id,
      orElse: () => demoTrips.first,
    );
    return match.copyWith(status: newStatus);
  }

  Future<Trip?> _populateTrip(Map<String, dynamic> data, String docId) async {
    final routeId = data['routeId']?.toString() ?? 'VPM-CUD-01';
    final vehicleId = data['vehicleId']?.toString() ?? 'BUS001';

    TransitRoute? route = _routeCache[routeId];
    if (route == null) {
      route = await _routeDataSource.getRouteById(routeId);
      if (route != null) _routeCache[routeId] = route;
    }

    Vehicle? vehicle = _vehicleCache[vehicleId];
    if (vehicle == null) {
      vehicle = await _vehicleDataSource.getVehicleById(vehicleId);
      if (vehicle != null) _vehicleCache[vehicleId] = vehicle;
    }

    route ??= const TransitRoute(
      id: 'VPM-CUD-01',
      routeId: 'VPM-CUD-01',
      routeNumber: 'Route VPM-CUD-01',
      routeName: 'Villupuram → Cuddalore',
      origin: 'Villupuram',
      destination: 'Cuddalore',
      distanceKm: 46.5,
      totalStopsCount: 8,
    );

    vehicle ??= const Vehicle(
      id: 'BUS001',
      vehicleId: 'BUS001',
      registrationNumber: 'TN 32 AB 1234',
      vehicleCode: 'BUS001',
      model: 'Ashok Leyland Viking Ultra BS-VI',
      vehicleType: 'PSV Heavy Passenger Transit',
      seatingCapacity: 48,
      standingCapacity: 20,
      fuelOrBatteryStatus: '92% Fuel Level',
    );

    return Trip.fromFirestore(data, docId, route: route, vehicle: vehicle);
  }
}
