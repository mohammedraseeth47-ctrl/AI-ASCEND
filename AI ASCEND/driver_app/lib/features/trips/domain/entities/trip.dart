import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip_stop.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

enum TripStatus { scheduled, ready, inProgress, completed, cancelled }

extension TripStatusExtension on TripStatus {
  String get displayName {
    switch (this) {
      case TripStatus.scheduled:
        return 'Scheduled';
      case TripStatus.ready:
        return 'Ready';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get firestoreValue {
    switch (this) {
      case TripStatus.scheduled:
        return 'scheduled';
      case TripStatus.ready:
        return 'ready';
      case TripStatus.inProgress:
        return 'in_progress';
      case TripStatus.completed:
        return 'completed';
      case TripStatus.cancelled:
        return 'cancelled';
    }
  }

  static TripStatus fromFirestore(String? value) {
    switch (value) {
      case 'scheduled':
        return TripStatus.scheduled;
      case 'ready':
        return TripStatus.ready;
      case 'in_progress':
      case 'active':
        return TripStatus.inProgress;
      case 'completed':
        return TripStatus.completed;
      case 'cancelled':
        return TripStatus.cancelled;
      default:
        return TripStatus.scheduled;
    }
  }
}

class Trip {
  final String id;
  final String tripId;
  final String tripCode;
  final TransitRoute route;
  final Vehicle vehicle;
  final String driverId;
  final String date;
  final String scheduledDeparture;
  final String scheduledArrival;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final String? actualDeparture;
  final String? actualArrival;
  final TripStatus status;
  final List<TripStop> stops;
  final int passengerCountEstimate;
  final String? notes;
  final String? routeId;
  final String? vehicleId;
  final String origin;
  final String destination;
  final int stopCount;
  final double distanceKm;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const Trip({
    required this.id,
    this.tripId = 'TRIP-VPM101-001',
    required this.tripCode,
    required this.route,
    required this.vehicle,
    required this.driverId,
    required this.date,
    required this.scheduledDeparture,
    required this.scheduledArrival,
    this.scheduledStart,
    this.scheduledEnd,
    this.actualDeparture,
    this.actualArrival,
    required this.status,
    required this.stops,
    this.passengerCountEstimate = 0,
    this.notes,
    this.routeId,
    this.vehicleId,
    this.origin = 'Villupuram New Bus Stand',
    this.destination = 'Cuddalore Bus Stand',
    this.stopCount = 8,
    this.distanceKm = 46.5,
    this.startedAt,
    this.completedAt,
  });

  bool get isToday => true;

  factory Trip.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    required TransitRoute route,
    required Vehicle vehicle,
  }) {
    final startDt = _parseTimestamp(data['scheduledStart']);
    final endDt = _parseTimestamp(data['scheduledEnd']);

    String schedDep = data['scheduledDeparture']?.toString() ?? '';
    if (schedDep.isEmpty && startDt != null) {
      schedDep = DateFormat('hh:mm a').format(startDt);
    }
    if (schedDep.isEmpty) schedDep = '08:15 AM';

    String schedArr = data['scheduledArrival']?.toString() ?? '';
    if (schedArr.isEmpty && endDt != null) {
      schedArr = DateFormat('hh:mm a').format(endDt);
    }
    if (schedArr.isEmpty) schedArr = '09:48 AM';

    final tId = data['tripId']?.toString() ?? docId;
    final tCode = data['tripCode']?.toString() ?? tId;
    final orig = data['origin']?.toString() ?? route.origin;
    final dest = data['destination']?.toString() ?? route.destination;
    final sCount = (data['stopCount'] as num?)?.toInt() ?? route.stops.length;
    final dist = (data['distanceKm'] as num?)?.toDouble() ?? route.distanceKm;

    return Trip(
      id: docId,
      tripId: tId,
      tripCode: tCode,
      route: route,
      vehicle: vehicle,
      driverId: data['driverId']?.toString() ?? '',
      date: data['date']?.toString() ?? 'Today',
      scheduledDeparture: schedDep,
      scheduledArrival: schedArr,
      scheduledStart: startDt,
      scheduledEnd: endDt,
      actualDeparture: data['actualDeparture']?.toString(),
      actualArrival: data['actualArrival']?.toString(),
      status: TripStatusExtension.fromFirestore(data['status']?.toString()),
      stops: route.stops,
      passengerCountEstimate:
          (data['passengerCountEstimate'] as num?)?.toInt() ?? 0,
      notes: data['notes']?.toString(),
      routeId: data['routeId']?.toString() ?? route.id,
      vehicleId: data['vehicleId']?.toString() ?? vehicle.id,
      origin: orig,
      destination: dest,
      stopCount: sCount,
      distanceKm: dist,
      startedAt: _parseTimestamp(data['startedAt']),
      completedAt: _parseTimestamp(data['completedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tripId': tripId,
      'tripCode': tripCode,
      'routeId': routeId ?? route.id,
      'vehicleId': vehicleId ?? vehicle.id,
      'driverId': driverId,
      'date': date,
      'scheduledDeparture': scheduledDeparture,
      'scheduledArrival': scheduledArrival,
      if (scheduledStart != null)
        'scheduledStart': Timestamp.fromDate(scheduledStart!),
      if (scheduledEnd != null)
        'scheduledEnd': Timestamp.fromDate(scheduledEnd!),
      if (actualDeparture != null) 'actualDeparture': actualDeparture,
      if (actualArrival != null) 'actualArrival': actualArrival,
      'status': status.firestoreValue,
      'origin': origin,
      'destination': destination,
      'stopCount': stopCount,
      'distanceKm': distanceKm,
      'passengerCountEstimate': passengerCountEstimate,
      if (notes != null) 'notes': notes,
      if (startedAt != null) 'startedAt': Timestamp.fromDate(startedAt!),
      if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Trip copyWith({
    String? id,
    String? tripId,
    String? tripCode,
    TransitRoute? route,
    Vehicle? vehicle,
    String? driverId,
    String? date,
    String? scheduledDeparture,
    String? scheduledArrival,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    String? actualDeparture,
    String? actualArrival,
    TripStatus? status,
    List<TripStop>? stops,
    int? passengerCountEstimate,
    String? notes,
    String? routeId,
    String? vehicleId,
    String? origin,
    String? destination,
    int? stopCount,
    double? distanceKm,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      tripCode: tripCode ?? this.tripCode,
      route: route ?? this.route,
      vehicle: vehicle ?? this.vehicle,
      driverId: driverId ?? this.driverId,
      date: date ?? this.date,
      scheduledDeparture: scheduledDeparture ?? this.scheduledDeparture,
      scheduledArrival: scheduledArrival ?? this.scheduledArrival,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      actualDeparture: actualDeparture ?? this.actualDeparture,
      actualArrival: actualArrival ?? this.actualArrival,
      status: status ?? this.status,
      stops: stops ?? this.stops,
      passengerCountEstimate:
          passengerCountEstimate ?? this.passengerCountEstimate,
      notes: notes ?? this.notes,
      routeId: routeId ?? this.routeId,
      vehicleId: vehicleId ?? this.vehicleId,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      stopCount: stopCount ?? this.stopCount,
      distanceKm: distanceKm ?? this.distanceKm,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
