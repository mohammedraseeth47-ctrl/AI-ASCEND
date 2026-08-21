enum DriverStatus { available, onDuty, onTrip, onBreak, offline }

extension DriverStatusExtension on DriverStatus {
  String get displayName {
    switch (this) {
      case DriverStatus.available:
        return 'Available';
      case DriverStatus.onDuty:
        return 'On Duty';
      case DriverStatus.onTrip:
        return 'On Trip';
      case DriverStatus.onBreak:
        return 'On Break';
      case DriverStatus.offline:
        return 'Offline';
    }
  }

  String get firestoreValue {
    switch (this) {
      case DriverStatus.available:
        return 'available';
      case DriverStatus.onDuty:
        return 'on_duty';
      case DriverStatus.onTrip:
        return 'on_trip';
      case DriverStatus.onBreak:
        return 'on_break';
      case DriverStatus.offline:
        return 'offline';
    }
  }

  static DriverStatus fromFirestore(String? value) {
    switch (value) {
      case 'available':
        return DriverStatus.available;
      case 'on_duty':
        return DriverStatus.onDuty;
      case 'on_trip':
        return DriverStatus.onTrip;
      case 'on_break':
        return DriverStatus.onBreak;
      case 'offline':
        return DriverStatus.offline;
      default:
        return DriverStatus.available;
    }
  }
}

class DriverUser {
  final String id; // Document ID (Firebase Auth UID)
  final String driverId; // e.g. "DRV-1024"
  final String? authUid;
  final String name;
  final String email;
  final String phone;
  final String region;
  final double rating;
  final int experienceYears;
  final DriverStatus status;
  final String depotId;
  final String assignedDepot;
  final String? assignedBusId;
  final String? assignedRouteId;
  final String licenseNumber;
  final String licenseCategory;
  final String licenseExpiry;
  final String medicalCertificate;
  final String vehicleClass;
  final String? avatarUrl;

  const DriverUser({
    required this.id,
    this.driverId = 'DRV-1024',
    this.authUid,
    required this.name,
    required this.email,
    required this.phone,
    this.region = 'Villupuram',
    this.rating = 4.94,
    this.experienceYears = 7,
    this.status = DriverStatus.available,
    this.depotId = 'DEPOT-VPM-01',
    this.assignedDepot = 'Villupuram Central Depot',
    this.assignedBusId = 'BUS-402',
    this.assignedRouteId = 'VPM-101',
    required this.licenseNumber,
    this.licenseCategory = 'Commercial HMV',
    required this.licenseExpiry,
    this.medicalCertificate = 'Class 1 (Valid)',
    this.vehicleClass = 'PSV Heavy Passenger Transit',
    this.avatarUrl,
  });

  factory DriverUser.fromFirestore(Map<String, dynamic> data, String docId) {
    final driverIdVal = data['driverId']?.toString() ?? 'DRV-1024';
    final licenseExp =
        data['licenseValidUntil']?.toString() ??
        data['licenseExpiry']?.toString() ??
        'Valid';
    final vehicleClassVal =
        data['authorizedVehicleClass']?.toString() ??
        data['vehicleClass']?.toString() ??
        'PSV Heavy Passenger Transit';

    return DriverUser(
      id: docId,
      driverId: driverIdVal,
      authUid: data['authUid']?.toString() ?? docId,
      name: data['name']?.toString() ?? 'Driver',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      region: data['region']?.toString() ?? 'Villupuram',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.94,
      experienceYears: (data['experienceYears'] as num?)?.toInt() ?? 7,
      status: DriverStatusExtension.fromFirestore(data['status']?.toString()),
      depotId: data['depotId']?.toString() ?? 'DEPOT-VPM-01',
      assignedDepot:
          data['assignedDepot']?.toString() ?? 'Villupuram Central Depot',
      assignedBusId:
          data['assignedBusId']?.toString() ?? data['vehicleId']?.toString(),
      assignedRouteId:
          data['assignedRouteId']?.toString() ?? data['routeId']?.toString(),
      licenseNumber: data['licenseNumber']?.toString() ?? '',
      licenseCategory: data['licenseCategory']?.toString() ?? 'Commercial HMV',
      licenseExpiry: licenseExp,
      medicalCertificate:
          data['medicalCertificate']?.toString() ?? 'Class 1 (Valid)',
      vehicleClass: vehicleClassVal,
      avatarUrl: data['avatarUrl']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'driverId': driverId,
      'authUid': authUid ?? id,
      'name': name,
      'email': email,
      'phone': phone,
      'region': region,
      'rating': rating,
      'experienceYears': experienceYears,
      'status': status.firestoreValue,
      'depotId': depotId,
      'assignedDepot': assignedDepot,
      'assignedBusId': assignedBusId,
      'assignedRouteId': assignedRouteId,
      'licenseNumber': licenseNumber,
      'licenseCategory': licenseCategory,
      'licenseValidUntil': licenseExpiry,
      'medicalCertificate': medicalCertificate,
      'authorizedVehicleClass': vehicleClass,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }

  DriverUser copyWith({
    String? id,
    String? driverId,
    String? authUid,
    String? name,
    String? email,
    String? phone,
    String? region,
    double? rating,
    int? experienceYears,
    DriverStatus? status,
    String? depotId,
    String? assignedDepot,
    String? assignedBusId,
    String? assignedRouteId,
    String? licenseNumber,
    String? licenseCategory,
    String? licenseExpiry,
    String? medicalCertificate,
    String? vehicleClass,
    String? avatarUrl,
  }) {
    return DriverUser(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      authUid: authUid ?? this.authUid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      rating: rating ?? this.rating,
      experienceYears: experienceYears ?? this.experienceYears,
      status: status ?? this.status,
      depotId: depotId ?? this.depotId,
      assignedDepot: assignedDepot ?? this.assignedDepot,
      assignedBusId: assignedBusId ?? this.assignedBusId,
      assignedRouteId: assignedRouteId ?? this.assignedRouteId,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseCategory: licenseCategory ?? this.licenseCategory,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      medicalCertificate: medicalCertificate ?? this.medicalCertificate,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
