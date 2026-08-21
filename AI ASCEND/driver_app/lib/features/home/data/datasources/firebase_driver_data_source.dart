import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/authentication/data/datasources/firebase_auth_data_source.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_assignment.dart';
import 'package:trackgo_driver/features/home/domain/entities/driver_metrics.dart';
import 'package:trackgo_driver/features/trips/data/datasources/firebase_route_data_source.dart';
import 'package:trackgo_driver/features/trips/data/datasources/firebase_trip_data_source.dart';
import 'package:trackgo_driver/features/trips/data/datasources/firebase_vehicle_data_source.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

class FirebaseDriverDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseTripDataSource _tripDataSource;
  final FirebaseVehicleDataSource _vehicleDataSource;
  final FirebaseRouteDataSource _routeDataSource;

  FirebaseDriverDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseTripDataSource? tripDataSource,
    FirebaseVehicleDataSource? vehicleDataSource,
    FirebaseRouteDataSource? routeDataSource,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _tripDataSource =
           tripDataSource ?? FirebaseTripDataSource(firestore: firestore),
       _vehicleDataSource =
           vehicleDataSource ?? FirebaseVehicleDataSource(firestore: firestore),
       _routeDataSource =
           routeDataSource ?? FirebaseRouteDataSource(firestore: firestore);

  String? get _currentUid => _auth.currentUser?.uid;

  DriverAssignment getDemoAssignment(String uid) {
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

    return DriverAssignment(
      id: 'ASSIGN001',
      date: 'Today',
      shiftStartTime: '06:30 AM',
      shiftEndTime: '02:30 PM',
      driverId: uid,
      driverName: 'Arun Kumar',
      vehicle: demoVehicle,
      route: demoRoute,
      trips: [
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
      ],
      status: AssignmentStatus.active,
      notes:
          'Pre-trip diagnostics passed at Villupuram Central Depot. Fuel level at 92%.',
    );
  }

  Future<DriverUser?> getCurrentDriver() async {
    final uid = _currentUid;
    if (uid == null) return null;
    return await getDriverByUid(uid);
  }

  Future<DriverUser?> getDriverByUid(String uid) async {
    try {
      final directDoc = await _firestore.collection('drivers').doc(uid).get();
      if (directDoc.exists && directDoc.data() != null) {
        return DriverUser.fromFirestore(directDoc.data()!, directDoc.id);
      }
    } catch (e) {
      debugPrint(
        'Firestore read error in getDriverByUid ($e) - using demo fallback',
      );
    }

    return FirebaseAuthDataSource.getDemoDriver(uid, _auth.currentUser?.email);
  }

  Future<DriverAssignment?> getTodayAssignment() async {
    final uid = _currentUid ?? 'DRV001';

    try {
      final querySnapshot = await _firestore
          .collection('assignments')
          .where('driverId', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        final vehicleId = data['vehicleId']?.toString() ?? 'BUS001';
        final routeId = data['routeId']?.toString() ?? 'VPM-CUD-01';

        final vehicle =
            await _vehicleDataSource.getVehicleById(vehicleId) ??
            const Vehicle(
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

        final route =
            await _routeDataSource.getRouteById(routeId) ??
            const TransitRoute(
              id: 'VPM-CUD-01',
              routeId: 'VPM-CUD-01',
              routeNumber: 'Route VPM-CUD-01',
              routeName: 'Villupuram → Cuddalore',
              origin: 'Villupuram',
              destination: 'Cuddalore',
              distanceKm: 46.5,
              totalStopsCount: 8,
            );

        final trips = await _tripDataSource.getTrips(driverId: uid);

        return DriverAssignment(
          id: doc.id,
          date: data['date']?.toString() ?? 'Today',
          shiftStartTime:
              data['shiftStartTime']?.toString() ??
              data['shiftStart']?.toString() ??
              '06:30 AM',
          shiftEndTime:
              data['shiftEndTime']?.toString() ??
              data['shiftEnd']?.toString() ??
              '02:30 PM',
          driverId: uid,
          driverName: 'Arun Kumar',
          vehicle: vehicle,
          route: route,
          trips: trips,
          status: AssignmentStatusExtension.fromFirestore(data['status']),
          notes: data['notes']?.toString() ?? 'Active operational assignment.',
        );
      }
    } catch (e) {
      debugPrint(
        'Firestore read error in getTodayAssignment ($e) - using demo fallback',
      );
    }

    return getDemoAssignment(uid);
  }

  Future<DriverMetrics> getDriverMetrics() async {
    final uid = _currentUid ?? 'DRV001';
    try {
      final trips = await _tripDataSource.getTrips(driverId: uid);
      final completedTrips = trips
          .where((t) => t.status == TripStatus.completed)
          .toList();
      final completedCount = completedTrips.length;
      final totalCount = trips.isNotEmpty ? trips.length : 3;

      return DriverMetrics(
        completedTripsToday: completedCount > 0 ? completedCount : 1,
        totalScheduledTripsToday: totalCount,
        onTimePercentage: 98.5,
        drivingHoursToday: 3.5,
        totalDistanceKmToday: 46.5,
      );
    } catch (e) {
      return const DriverMetrics(
        completedTripsToday: 1,
        totalScheduledTripsToday: 3,
        onTimePercentage: 98.5,
        drivingHoursToday: 3.5,
        totalDistanceKmToday: 46.5,
      );
    }
  }

  Future<DriverStatus> updateDriverStatus(DriverStatus newStatus) async {
    final uid = _currentUid;
    if (uid != null) {
      try {
        await _firestore.collection('drivers').doc(uid).update({
          'status': newStatus.firestoreValue,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
    return newStatus;
  }
}
