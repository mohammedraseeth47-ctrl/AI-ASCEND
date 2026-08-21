import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

enum AssignmentStatus { active, completed, pending }

extension AssignmentStatusExtension on AssignmentStatus {
  String get displayName {
    switch (this) {
      case AssignmentStatus.active:
        return 'Active Shift';
      case AssignmentStatus.completed:
        return 'Shift Completed';
      case AssignmentStatus.pending:
        return 'Pending Check-In';
    }
  }

  String get firestoreValue {
    switch (this) {
      case AssignmentStatus.active:
        return 'active';
      case AssignmentStatus.completed:
        return 'completed';
      case AssignmentStatus.pending:
        return 'pending';
    }
  }

  static AssignmentStatus fromFirestore(dynamic value) {
    final str = value?.toString();
    switch (str) {
      case 'active':
        return AssignmentStatus.active;
      case 'completed':
        return AssignmentStatus.completed;
      case 'pending':
        return AssignmentStatus.pending;
      default:
        return AssignmentStatus.active;
    }
  }
}

class DriverAssignment {
  final String id;
  final String date;
  final String shiftStartTime;
  final String shiftEndTime;
  final String driverId;
  final String driverName;
  final Vehicle vehicle;
  final TransitRoute route;
  final List<Trip> trips;
  final AssignmentStatus status;
  final String notes;

  const DriverAssignment({
    required this.id,
    required this.date,
    required this.shiftStartTime,
    required this.shiftEndTime,
    this.driverId = 'DRV-1024',
    this.driverName = 'Karthikeyan',
    required this.vehicle,
    required this.route,
    this.trips = const [],
    this.status = AssignmentStatus.active,
    this.notes =
        'Pre-trip diagnostics passed at Villupuram Central Depot. Fuel level at 92%. Bay assignment: Bay 2.',
  });

  factory DriverAssignment.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    required Vehicle vehicle,
    required TransitRoute route,
    required List<Trip> trips,
    String driverName = 'Karthikeyan',
  }) {
    return DriverAssignment(
      id: docId,
      date: data['date']?.toString() ?? 'Today',
      shiftStartTime:
          data['shiftStartTime']?.toString() ??
          data['shiftStart']?.toString() ??
          '06:30 AM',
      shiftEndTime:
          data['shiftEndTime']?.toString() ??
          data['shiftEnd']?.toString() ??
          '02:30 PM',
      driverId: data['driverId']?.toString() ?? '',
      driverName: driverName,
      vehicle: vehicle,
      route: route,
      trips: trips,
      status: AssignmentStatusExtension.fromFirestore(data['status']),
      notes: data['notes']?.toString() ?? 'Pre-trip diagnostics passed.',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'driverId': driverId,
      'vehicleId': vehicle.id,
      'routeId': route.id,
      'tripIds': trips.map((t) => t.id).toList(),
      'shiftStartTime': shiftStartTime,
      'shiftEndTime': shiftEndTime,
      'date': date,
      'status': status.firestoreValue,
      'notes': notes,
    };
  }

  DriverAssignment copyWith({
    String? id,
    String? date,
    String? shiftStartTime,
    String? shiftEndTime,
    String? driverId,
    String? driverName,
    Vehicle? vehicle,
    TransitRoute? route,
    List<Trip>? trips,
    AssignmentStatus? status,
    String? notes,
  }) {
    return DriverAssignment(
      id: id ?? this.id,
      date: date ?? this.date,
      shiftStartTime: shiftStartTime ?? this.shiftStartTime,
      shiftEndTime: shiftEndTime ?? this.shiftEndTime,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      vehicle: vehicle ?? this.vehicle,
      route: route ?? this.route,
      trips: trips ?? this.trips,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
