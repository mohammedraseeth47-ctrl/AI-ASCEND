import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip_stop.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

class MockTripDataSource {
  static const Vehicle mockVehiclePrimary = Vehicle(
    id: 'VEH-4521',
    registrationNumber: 'TN-32-AB-4521',
    vehicleCode: 'BUS-402',
    model: 'Ashok Leyland Viking Ultra BS-VI',
    vehicleType: 'Express Passenger Bus',
    seatingCapacity: 48,
    standingCapacity: 20,
    fuelOrBatteryStatus: '92% Fuel Level',
    status: VehicleStatus.assigned,
    assignedDepot: 'Villupuram Central Depot (Division 1)',
    assignedDriverId: 'DRV-1024',
    assignedDriverName: 'Karthikeyan',
    assignedRouteNumber: 'Route VPM-101',
    assignedRouteName: 'Villupuram New Bus Stand ⇄ Cuddalore Bus Stand',
    emissionClass: 'BS-VI Heavy Duty Diesel',
    fitnessCertificateExpiry: 'Nov 2028 (Valid)',
    lastInspectionDate: 'Today, 05:45 AM (Passed)',
  );

  static const Vehicle mockVehicleSecondary = Vehicle(
    id: 'VEH-7842',
    registrationNumber: 'TN-31-CD-7842',
    vehicleCode: 'BUS-118',
    model: 'Tata LPO 1618 Starbus',
    vehicleType: 'Semi-Deluxe Transit Bus',
    seatingCapacity: 44,
    standingCapacity: 18,
    fuelOrBatteryStatus: '85% Fuel Level',
    status: VehicleStatus.available,
    assignedDepot: 'Cuddalore Regional Depot',
  );

  static const Vehicle mockVehicleTertiary = Vehicle(
    id: 'VEH-2345',
    registrationNumber: 'PY-01-AB-2345',
    vehicleCode: 'BUS-209',
    model: 'Eicher Skyline Pro Intercity',
    vehicleType: 'Inter-State Route Bus',
    seatingCapacity: 40,
    standingCapacity: 15,
    fuelOrBatteryStatus: '78% Fuel Level',
    status: VehicleStatus.available,
    assignedDepot: 'Puducherry Central Depot',
  );

  static final List<TripStop> mockRouteVpm101Stops = [
    const TripStop(
      id: 'STP-01',
      sequenceNumber: 1,
      stopName: 'Villupuram New Bus Stand (Bay 2)',
      scheduledTime: '08:15 AM',
      scheduledArrival: '08:00 AM',
      scheduledDeparture: '08:15 AM',
      isCompleted: false,
      isCurrent: true,
      isTerminal: true,
      landmarks: 'Transfer to Trichy & Salem Corridor',
    ),
    const TripStop(
      id: 'STP-02',
      sequenceNumber: 2,
      stopName: 'Koliyanur Cross Road',
      scheduledTime: '08:28 AM',
      scheduledArrival: '08:27 AM',
      scheduledDeparture: '08:28 AM',
      landmarks: 'NH-453 Link Junction',
    ),
    const TripStop(
      id: 'STP-03',
      sequenceNumber: 3,
      stopName: 'Valavanur Junction',
      scheduledTime: '08:40 AM',
      scheduledArrival: '08:38 AM',
      scheduledDeparture: '08:40 AM',
      landmarks: 'Bazaar Street & High School',
    ),
    const TripStop(
      id: 'STP-04',
      sequenceNumber: 4,
      stopName: 'Siruvandhadu Stop',
      scheduledTime: '08:52 AM',
      scheduledArrival: '08:50 AM',
      scheduledDeparture: '08:52 AM',
      landmarks: 'Rural Cooperative Bank Center',
    ),
    const TripStop(
      id: 'STP-05',
      sequenceNumber: 5,
      stopName: 'Panruti Bus Stand (Platform 1)',
      scheduledTime: '09:08 AM',
      scheduledArrival: '09:05 AM',
      scheduledDeparture: '09:08 AM',
      landmarks: 'Commercial Jackfruit Market & Rail Station',
    ),
    const TripStop(
      id: 'STP-06',
      sequenceNumber: 6,
      stopName: 'Nellikuppam Main Road',
      scheduledTime: '09:24 AM',
      scheduledArrival: '09:22 AM',
      scheduledDeparture: '09:24 AM',
      landmarks: 'Sugar Mill Gateway',
    ),
    const TripStop(
      id: 'STP-07',
      sequenceNumber: 7,
      stopName: 'Cuddalore Old Town (OT)',
      scheduledTime: '09:38 AM',
      scheduledArrival: '09:36 AM',
      scheduledDeparture: '09:38 AM',
      landmarks: 'Harbor Road Cross',
    ),
    const TripStop(
      id: 'STP-08',
      sequenceNumber: 8,
      stopName: 'Cuddalore Bus Stand (Bay 4)',
      scheduledTime: '09:48 AM',
      scheduledArrival: '09:48 AM',
      isTerminal: true,
      landmarks: 'Coastal Regional Intercity Terminal',
    ),
  ];

  static final List<TripStop> mockRouteCudPdyStops = [
    const TripStop(
      id: 'STP-CP1',
      sequenceNumber: 1,
      stopName: 'Cuddalore Bus Stand (Bay 2)',
      scheduledTime: '10:15 AM',
      scheduledDeparture: '10:15 AM',
      isTerminal: true,
      landmarks: 'Origin Intercity Terminal',
    ),
    const TripStop(
      id: 'STP-CP2',
      sequenceNumber: 2,
      stopName: 'Manjakuppam Clock Tower',
      scheduledTime: '10:25 AM',
      landmarks: 'District Court Complex',
    ),
    const TripStop(
      id: 'STP-CP3',
      sequenceNumber: 3,
      stopName: 'Kanniakoil Toll Border',
      scheduledTime: '10:40 AM',
      landmarks: 'Puducherry State Entry Gateway',
    ),
    const TripStop(
      id: 'STP-CP4',
      sequenceNumber: 4,
      stopName: 'Kirumampakkam Junction',
      scheduledTime: '10:52 AM',
      landmarks: 'Industrial Estate Entry',
    ),
    const TripStop(
      id: 'STP-CP5',
      sequenceNumber: 5,
      stopName: 'Thavalakuppam Signal',
      scheduledTime: '11:02 AM',
      landmarks: 'Paradise Beach Highway Cross',
    ),
    const TripStop(
      id: 'STP-CP6',
      sequenceNumber: 6,
      stopName: 'Puducherry Bus Stand (Marai Malai Adigal Salai)',
      scheduledTime: '11:10 AM',
      scheduledArrival: '11:10 AM',
      isTerminal: true,
      landmarks: 'Puducherry Main Terminal Bay 1',
    ),
  ];

  static final List<TripStop> mockCompletedStops = [
    const TripStop(
      id: 'STP-C1',
      sequenceNumber: 1,
      stopName: 'Villupuram Central Depot',
      scheduledTime: '06:30 AM',
      actualTime: '06:30 AM',
      isCompleted: true,
      isTerminal: true,
      landmarks: 'Vehicle Maintenance Yard',
    ),
    const TripStop(
      id: 'STP-C2',
      sequenceNumber: 2,
      stopName: 'District Collectorate Office',
      scheduledTime: '06:45 AM',
      actualTime: '06:44 AM',
      isCompleted: true,
      landmarks: 'Collectorate Master Complex',
    ),
    const TripStop(
      id: 'STP-C3',
      sequenceNumber: 3,
      stopName: 'Villupuram New Bus Stand',
      scheduledTime: '07:00 AM',
      actualTime: '06:58 AM',
      isCompleted: true,
      isTerminal: true,
      landmarks: 'Bay 2 Departure Platform',
    ),
  ];

  static final TransitRoute mockRouteVpm101 = TransitRoute(
    id: 'RTE-VPM-101',
    routeNumber: 'Route VPM-101',
    routeName: 'Villupuram New Bus Stand ⇄ Cuddalore Bus Stand',
    origin: 'Villupuram New Bus Stand',
    destination: 'Cuddalore Bus Stand',
    distanceKm: 46.5,
    totalStopsCount: 8,
    colorHex: '#0284C7',
    stops: mockRouteVpm101Stops,
    viaMajorStops: 'Valavanur, Panruti, Nellikuppam',
    operatingRegion: 'Villupuram – Cuddalore Coastal Belt',
  );

  static final TransitRoute mockRouteCudPdy115 = TransitRoute(
    id: 'RTE-CUD-PDY-115',
    routeNumber: 'Route CUD-PDY-115',
    routeName: 'Cuddalore Bus Stand ⇄ Puducherry Bus Stand',
    origin: 'Cuddalore Bus Stand',
    destination: 'Puducherry Bus Stand',
    distanceKm: 23.8,
    totalStopsCount: 6,
    colorHex: '#10B981',
    stops: mockRouteCudPdyStops,
    viaMajorStops: 'Manjakuppam, Kanniakoil, Thavalakuppam',
    operatingRegion: 'Cuddalore – Puducherry Inter-State Highway',
  );

  static final TransitRoute mockRouteVpmPdy301 = TransitRoute(
    id: 'RTE-VPM-PDY-301',
    routeNumber: 'Route VPM-PDY-301',
    routeName: 'Villupuram New Bus Stand ⇄ Puducherry Bus Stand',
    origin: 'Villupuram New Bus Stand',
    destination: 'Puducherry Bus Stand',
    distanceKm: 39.2,
    totalStopsCount: 7,
    colorHex: '#F59E0B',
    stops: mockRouteVpm101Stops,
    viaMajorStops: 'Valavanur, Kandamangalam, Villianur',
    operatingRegion: 'NH-332 Express Transit Corridor',
  );

  static final TransitRoute mockRouteVpmTnd202 = TransitRoute(
    id: 'RTE-VPM-TND-202',
    routeNumber: 'Route VPM-TND-202',
    routeName: 'Villupuram New Bus Stand ⇄ Tindivanam Bus Stand',
    origin: 'Villupuram New Bus Stand',
    destination: 'Tindivanam Bus Stand',
    distanceKm: 38.0,
    totalStopsCount: 6,
    colorHex: '#8B5CF6',
    stops: mockRouteVpm101Stops,
    viaMajorStops: 'Vikravandi, Mailam Cross',
    operatingRegion: 'NH-45 Grand Southern Trunk Route',
  );

  static final TransitRoute mockRouteCudChi210 = TransitRoute(
    id: 'RTE-CUD-CHI-210',
    routeNumber: 'Route CUD-CHI-210',
    routeName: 'Cuddalore Bus Stand ⇄ Chidambaram Bus Stand',
    origin: 'Cuddalore Bus Stand',
    destination: 'Chidambaram Bus Stand',
    distanceKm: 44.0,
    totalStopsCount: 7,
    colorHex: '#EC4899',
    stops: mockRouteVpm101Stops,
    viaMajorStops: 'Alapakkam, Bhuvanagiri',
    operatingRegion: 'Cuddalore – Chidambaram Heritage Corridor',
  );

  final List<Trip> _trips = [
    Trip(
      id: 'TRP-10482',
      tripCode: 'TRIP-VPM-101-01',
      route: mockRouteVpm101,
      vehicle: mockVehiclePrimary,
      driverId: 'DRV-1024',
      date: 'Today, Oct 24',
      scheduledDeparture: '08:15 AM',
      scheduledArrival: '09:48 AM',
      status: TripStatus.scheduled,
      stops: mockRouteVpm101Stops,
      passengerCountEstimate: 42,
      notes:
          'Morning express service via Panruti. Peak boarding expected at Valavanur and Panruti.',
    ),
    Trip(
      id: 'TRP-10483',
      tripCode: 'TRIP-CUD-PDY-02',
      route: mockRouteCudPdy115,
      vehicle: mockVehiclePrimary,
      driverId: 'DRV-1024',
      date: 'Today, Oct 24',
      scheduledDeparture: '10:15 AM',
      scheduledArrival: '11:10 AM',
      status: TripStatus.scheduled,
      stops: mockRouteCudPdyStops,
      passengerCountEstimate: 36,
      notes: 'Coastal corridor regular service.',
    ),
    Trip(
      id: 'TRP-10480',
      tripCode: 'TRIP-DEPOT-01',
      route: const TransitRoute(
        id: 'RTE-DEPOT',
        routeNumber: 'Route DEPOT-01',
        routeName: 'Villupuram Central Depot ⇄ New Bus Stand',
        origin: 'Villupuram Central Depot',
        destination: 'Villupuram New Bus Stand',
        distanceKm: 6.2,
        totalStopsCount: 3,
        viaMajorStops: 'Collectorate Office',
        operatingRegion: 'Villupuram City Route',
      ),
      vehicle: mockVehiclePrimary,
      driverId: 'DRV-1024',
      date: 'Today, Oct 24',
      scheduledDeparture: '06:30 AM',
      scheduledArrival: '07:00 AM',
      actualDeparture: '06:30 AM',
      actualArrival: '06:58 AM',
      status: TripStatus.completed,
      stops: mockCompletedStops,
      passengerCountEstimate: 18,
      notes: 'Vehicle inspected and in service on schedule.',
    ),
    Trip(
      id: 'TRP-10484',
      tripCode: 'TRIP-VPM-PDY-01',
      route: mockRouteVpmPdy301,
      vehicle: mockVehiclePrimary,
      driverId: 'DRV-1024',
      date: 'Today, Oct 24',
      scheduledDeparture: '02:45 PM',
      scheduledArrival: '04:00 PM',
      status: TripStatus.scheduled,
      stops: mockRouteVpm101Stops,
      passengerCountEstimate: 45,
      notes: 'Afternoon return connector trip.',
    ),
    Trip(
      id: 'TRP-10478',
      tripCode: 'TRIP-VPM-TND-C',
      route: mockRouteVpmTnd202,
      vehicle: mockVehicleSecondary,
      driverId: 'DRV-1024',
      date: 'Yesterday, Oct 23',
      scheduledDeparture: '05:30 PM',
      scheduledArrival: '06:45 PM',
      status: TripStatus.cancelled,
      stops: mockRouteVpm101Stops,
      notes: 'Trip cancelled due to NH-45 culvert maintenance near Vikravandi.',
    ),
  ];

  Future<List<Trip>> getTrips({TripStatus? statusFilter}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (statusFilter == null) {
      return List<Trip>.of(_trips);
    }
    return _trips.where((t) => t.status == statusFilter).toList();
  }

  Future<Trip?> getTripById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _trips.indexWhere((t) => t.id == id);
    if (index != -1) {
      return _trips[index];
    }
    return null;
  }

  Future<Trip?> getUpcomingTrip() async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _trips.firstWhere(
        (t) =>
            t.status == TripStatus.inProgress ||
            t.status == TripStatus.ready ||
            t.status == TripStatus.scheduled,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Trip> updateTripStatus(String id, TripStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _trips.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Trip with ID "$id" not found.');
    }

    final currentTrip = _trips[index];

    // Status transition rules
    if (currentTrip.status == TripStatus.cancelled) {
      throw Exception('Cancelled trips cannot be restarted or modified.');
    }

    String? actualDeparture = currentTrip.actualDeparture;
    String? actualArrival = currentTrip.actualArrival;

    if (newStatus == TripStatus.inProgress && actualDeparture == null) {
      actualDeparture = 'Today, Live Active';
    } else if (newStatus == TripStatus.completed && actualArrival == null) {
      actualArrival = 'Today, Completed';
    }

    final updatedTrip = currentTrip.copyWith(
      status: newStatus,
      actualDeparture: actualDeparture,
      actualArrival: actualArrival,
    );

    _trips[index] = updatedTrip;
    return updatedTrip;
  }

  Future<List<TransitRoute>> getAllRoutes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      mockRouteVpm101,
      mockRouteCudPdy115,
      mockRouteVpmPdy301,
      mockRouteVpmTnd202,
      mockRouteCudChi210,
    ];
  }

  Future<TransitRoute?> getRouteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final all = await getAllRoutes();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return mockRouteVpm101;
    }
  }

  Future<List<Vehicle>> getAllVehicles() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [mockVehiclePrimary, mockVehicleSecondary, mockVehicleTertiary];
  }

  Future<Vehicle?> getVehicleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final all = await getAllVehicles();
    try {
      return all.firstWhere((v) => v.id == id);
    } catch (_) {
      return mockVehiclePrimary;
    }
  }
}
