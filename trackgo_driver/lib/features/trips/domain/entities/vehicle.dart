enum VehicleStatus { assigned, inService, maintenance, available }

extension VehicleStatusExtension on VehicleStatus {
  String get displayName {
    switch (this) {
      case VehicleStatus.assigned:
        return 'Assigned';
      case VehicleStatus.inService:
        return 'In Service';
      case VehicleStatus.maintenance:
        return 'Under Maintenance';
      case VehicleStatus.available:
        return 'Available';
    }
  }

  String get firestoreValue {
    switch (this) {
      case VehicleStatus.assigned:
        return 'assigned';
      case VehicleStatus.inService:
        return 'in_service';
      case VehicleStatus.maintenance:
        return 'maintenance';
      case VehicleStatus.available:
        return 'available';
    }
  }

  static VehicleStatus fromFirestore(String? value) {
    switch (value) {
      case 'assigned':
        return VehicleStatus.assigned;
      case 'in_service':
      case 'active':
        return VehicleStatus.inService;
      case 'maintenance':
        return VehicleStatus.maintenance;
      case 'available':
        return VehicleStatus.available;
      default:
        return VehicleStatus.available;
    }
  }
}

class Vehicle {
  final String id;
  final String vehicleId;
  final String registrationNumber;
  final String vehicleCode;
  final String model;
  final String vehicleType;
  final int capacity;
  final int seatingCapacity;
  final int standingCapacity;
  final int fuelPercent;
  final int? batteryPercent;
  final String fuelOrBatteryStatus;
  final VehicleStatus status;
  final String depotId;
  final String assignedDepot;
  final String? assignedDriverId;
  final String? assignedDriverName;
  final String? assignedRouteNumber;
  final String? assignedRouteName;
  final String emissionClass;
  final String fitnessCertificateExpiry;
  final String lastInspectionDate;

  const Vehicle({
    required this.id,
    this.vehicleId = 'BUS-402',
    required this.registrationNumber,
    required this.vehicleCode,
    this.model = 'Ashok Leyland Viking Ultra BS-VI',
    this.vehicleType = 'PSV Heavy Passenger Transit',
    this.capacity = 68,
    required this.seatingCapacity,
    required this.standingCapacity,
    this.fuelPercent = 92,
    this.batteryPercent,
    required this.fuelOrBatteryStatus,
    this.status = VehicleStatus.assigned,
    this.depotId = 'DEPOT-VPM-01',
    this.assignedDepot = 'Villupuram Central Depot (Division 1)',
    this.assignedDriverId,
    this.assignedDriverName,
    this.assignedRouteNumber,
    this.assignedRouteName,
    this.emissionClass = 'BS-VI Heavy Duty Diesel',
    this.fitnessCertificateExpiry = 'Nov 2028 (Valid)',
    this.lastInspectionDate = 'Today, 05:45 AM (Passed)',
  });

  int get totalCapacity =>
      capacity > 0 ? capacity : (seatingCapacity + standingCapacity);

  factory Vehicle.fromFirestore(Map<String, dynamic> data, String docId) {
    final cap = (data['capacity'] as num?)?.toInt() ?? 52;
    final seated =
        (data['seatingCapacity'] as num?)?.toInt() ??
        (cap > 20 ? cap - 12 : cap);
    final standing =
        (data['standingCapacity'] as num?)?.toInt() ??
        (cap - seated).clamp(0, 50);
    final fuel =
        (data['fuelPercent'] as num?)?.toInt() ??
        (data['fuelLevel'] as num?)?.toInt() ??
        92;

    return Vehicle(
      id: docId,
      vehicleId: data['vehicleId']?.toString() ?? docId,
      registrationNumber:
          data['registrationNumber']?.toString() ?? 'TN-32-AB-4521',
      vehicleCode: data['vehicleCode']?.toString() ?? docId,
      model: data['model']?.toString() ?? 'Ashok Leyland Viking Ultra BS-VI',
      vehicleType:
          data['vehicleType']?.toString() ?? 'PSV Heavy Passenger Transit',
      capacity: cap,
      seatingCapacity: seated,
      standingCapacity: standing,
      fuelPercent: fuel,
      batteryPercent: (data['batteryPercent'] as num?)?.toInt(),
      fuelOrBatteryStatus:
          data['fuelOrBatteryStatus']?.toString() ?? '$fuel% Fuel Level',
      status: VehicleStatusExtension.fromFirestore(data['status']?.toString()),
      depotId: data['depotId']?.toString() ?? 'DEPOT-VPM-01',
      assignedDepot:
          data['assignedDepot']?.toString() ??
          'Villupuram Central Depot (Division 1)',
      assignedDriverId: data['assignedDriverId']?.toString(),
      assignedDriverName: data['assignedDriverName']?.toString(),
      assignedRouteNumber: data['assignedRouteNumber']?.toString(),
      assignedRouteName: data['assignedRouteName']?.toString(),
      emissionClass:
          data['emissionClass']?.toString() ?? 'BS-VI Heavy Duty Diesel',
      fitnessCertificateExpiry:
          data['fitnessCertificateExpiry']?.toString() ?? 'Nov 2028 (Valid)',
      lastInspectionDate:
          data['lastInspectionDate']?.toString() ?? 'Today, 05:45 AM (Passed)',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vehicleId': vehicleId,
      'registrationNumber': registrationNumber,
      'vehicleCode': vehicleCode,
      'model': model,
      'vehicleType': vehicleType,
      'capacity': totalCapacity,
      'seatingCapacity': seatingCapacity,
      'standingCapacity': standingCapacity,
      'fuelPercent': fuelPercent,
      if (batteryPercent != null) 'batteryPercent': batteryPercent,
      'fuelOrBatteryStatus': fuelOrBatteryStatus,
      'status': status.firestoreValue,
      'depotId': depotId,
      'assignedDepot': assignedDepot,
      if (assignedDriverId != null) 'assignedDriverId': assignedDriverId,
      if (assignedDriverName != null) 'assignedDriverName': assignedDriverName,
      if (assignedRouteNumber != null)
        'assignedRouteNumber': assignedRouteNumber,
      if (assignedRouteName != null) 'assignedRouteName': assignedRouteName,
      'emissionClass': emissionClass,
      'fitnessCertificateExpiry': fitnessCertificateExpiry,
      'lastInspectionDate': lastInspectionDate,
    };
  }

  Vehicle copyWith({
    String? id,
    String? vehicleId,
    String? registrationNumber,
    String? vehicleCode,
    String? model,
    String? vehicleType,
    int? capacity,
    int? seatingCapacity,
    int? standingCapacity,
    int? fuelPercent,
    int? batteryPercent,
    String? fuelOrBatteryStatus,
    VehicleStatus? status,
    String? depotId,
    String? assignedDepot,
    String? assignedDriverId,
    String? assignedDriverName,
    String? assignedRouteNumber,
    String? assignedRouteName,
    String? emissionClass,
    String? fitnessCertificateExpiry,
    String? lastInspectionDate,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vehicleCode: vehicleCode ?? this.vehicleCode,
      model: model ?? this.model,
      vehicleType: vehicleType ?? this.vehicleType,
      capacity: capacity ?? this.capacity,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      standingCapacity: standingCapacity ?? this.standingCapacity,
      fuelPercent: fuelPercent ?? this.fuelPercent,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      fuelOrBatteryStatus: fuelOrBatteryStatus ?? this.fuelOrBatteryStatus,
      status: status ?? this.status,
      depotId: depotId ?? this.depotId,
      assignedDepot: assignedDepot ?? this.assignedDepot,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      assignedDriverName: assignedDriverName ?? this.assignedDriverName,
      assignedRouteNumber: assignedRouteNumber ?? this.assignedRouteNumber,
      assignedRouteName: assignedRouteName ?? this.assignedRouteName,
      emissionClass: emissionClass ?? this.emissionClass,
      fitnessCertificateExpiry:
          fitnessCertificateExpiry ?? this.fitnessCertificateExpiry,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
    );
  }
}
