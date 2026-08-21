import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../models/bus_stop.dart';
import '../../models/route.dart';

/// Sample Tamil Nadu public transit routes with accurate geographic road coordinates.
class MockRoutes {
  MockRoutes._();

  /// Route 1: Villupuram → Trichy (BUS 01 / MOCK_BUS_01)
  static const Route routeVillupuramTrichy = Route(
    id: 'R-VPM-TRY',
    routeNumber: '101',
    routeName: 'Villupuram → Trichy',
    origin: 'Villupuram Central Bus Stand',
    destination: 'Trichy Central Bus Stand',
    viaSummary: 'via Ulundurpet, Veppur, Perambalur & Samayapuram (NH 38)',
    color: AppColors.primary,
    frequencyMinutes: 15,
    fareRupees: 140.0,
    operatingHours: '24 Hours Transit',
    activeBusesCount: 1,
    isFavorite: true,
    stops: [
      BusStop(id: 'STP-VPM', name: 'Villupuram Central', code: 'VPM', latitude: 11.9401, longitude: 79.4976, sequence: 1),
      BusStop(id: 'STP-ULD', name: 'Ulundurpet Toll', code: 'ULD', latitude: 11.6917, longitude: 79.2908, sequence: 2),
      BusStop(id: 'STP-VPR', name: 'Veppur Junction', code: 'VPR', latitude: 11.5303, longitude: 79.0838, sequence: 3),
      BusStop(id: 'STP-PBL', name: 'Perambalur Terminal', code: 'PBL', latitude: 11.2342, longitude: 78.8820, sequence: 4),
      BusStop(id: 'STP-SMP', name: 'Samayapuram Toll', code: 'SMP', latitude: 10.9200, longitude: 78.7400, sequence: 5),
      BusStop(id: 'STP-TRY', name: 'Trichy Central MGR', code: 'TRY', latitude: 10.7905, longitude: 78.6908, sequence: 6),
    ],
    polylinePoints: [
      LatLng(11.9401, 79.4976), // Villupuram
      LatLng(11.9120, 79.4750),
      LatLng(11.8750, 79.4480),
      LatLng(11.8350, 79.4180),
      LatLng(11.7900, 79.3800),
      LatLng(11.7450, 79.3450),
      LatLng(11.6917, 79.2908), // Ulundurpet
      LatLng(11.6500, 79.2400),
      LatLng(11.6050, 79.1850),
      LatLng(11.5650, 79.1300),
      LatLng(11.5303, 79.0838), // Veppur
      LatLng(11.4700, 79.0300),
      LatLng(11.4100, 78.9800),
      LatLng(11.3500, 78.9400),
      LatLng(11.2900, 78.9050),
      LatLng(11.2342, 78.8820), // Perambalur
      LatLng(11.1800, 78.8550),
      LatLng(11.1200, 78.8250),
      LatLng(11.0600, 78.7950),
      LatLng(11.0000, 78.7700),
      LatLng(10.9500, 78.7500),
      LatLng(10.9200, 78.7400), // Samayapuram
      LatLng(10.8800, 78.7180),
      LatLng(10.8500, 78.7000), // Srirangam / Cauvery
      LatLng(10.8200, 78.6940),
      LatLng(10.7905, 78.6908), // Trichy
    ],
  );

  /// Route 2: Chennai → Vadalur (BUS 02 / MOCK_BUS_02)
  static const Route routeChennaiVadalur = Route(
    id: 'R-CHN-VDL',
    routeNumber: '102',
    routeName: 'Chennai → Vadalur',
    origin: 'Chennai CMBT / Tambaram',
    destination: 'Vadalur Bus Stand',
    viaSummary: 'via Chengalpattu, Tindivanam & Panruti (GST / NH 32)',
    color: AppColors.routeBlue,
    frequencyMinutes: 20,
    fareRupees: 165.0,
    operatingHours: '04:00 AM - 11:30 PM',
    activeBusesCount: 1,
    isFavorite: false,
    stops: [
      BusStop(id: 'STP-CHN', name: 'Chennai Tambaram', code: 'TBM', latitude: 12.9249, longitude: 80.1000, sequence: 1),
      BusStop(id: 'STP-CGL', name: 'Chengalpattu Junction', code: 'CGL', latitude: 12.6819, longitude: 79.9888, sequence: 2),
      BusStop(id: 'STP-TMV', name: 'Tindivanam Bypass', code: 'TMV', latitude: 12.2285, longitude: 79.6500, sequence: 3),
      BusStop(id: 'STP-PRT', name: 'Panruti Terminal', code: 'PRT', latitude: 11.7749, longitude: 79.5537, sequence: 4),
      BusStop(id: 'STP-VDL', name: 'Vadalur Vallalar', code: 'VDL', latitude: 11.5540, longitude: 79.5500, sequence: 5),
    ],
    polylinePoints: [
      LatLng(12.9249, 80.1000), // Chennai Tambaram
      LatLng(12.8800, 80.0750),
      LatLng(12.8350, 80.0500),
      LatLng(12.7850, 80.0250),
      LatLng(12.7350, 80.0050),
      LatLng(12.6819, 79.9888), // Chengalpattu
      LatLng(12.6200, 79.9500),
      LatLng(12.5500, 79.9050),
      LatLng(12.4800, 79.8550),
      LatLng(12.4100, 79.8050),
      LatLng(12.3400, 79.7450),
      LatLng(12.2800, 79.6950),
      LatLng(12.2285, 79.6500), // Tindivanam
      LatLng(12.1600, 79.6200),
      LatLng(12.0900, 79.5850),
      LatLng(12.0300, 79.5500), // Vikravandi
      LatLng(11.9600, 79.5500),
      LatLng(11.8900, 79.5520),
      LatLng(11.8300, 79.5530),
      LatLng(11.7749, 79.5537), // Panruti
      LatLng(11.7200, 79.5520),
      LatLng(11.6600, 79.5510),
      LatLng(11.6050, 79.5505),
      LatLng(11.5540, 79.5500), // Vadalur
    ],
  );

  /// Route 3: Villupuram → Pondicherry (BUS 03 / MOCK_BUS_03)
  static const Route routeVillupuramPondicherry = Route(
    id: 'R-VPM-PDY',
    routeNumber: '103',
    routeName: 'Villupuram → Pondicherry',
    origin: 'Villupuram Central Bus Stand',
    destination: 'Pondicherry New Bus Stand',
    viaSummary: 'via Valavanur, Madagadipet & Villianur (NH 332)',
    color: AppColors.routePurple,
    frequencyMinutes: 10,
    fareRupees: 35.0,
    operatingHours: '05:00 AM - 11:30 PM',
    activeBusesCount: 1,
    isFavorite: true,
    stops: [
      BusStop(id: 'STP-VPM3', name: 'Villupuram Central', code: 'VPM', latitude: 11.9401, longitude: 79.4976, sequence: 1),
      BusStop(id: 'STP-VLV', name: 'Valavanur Stop', code: 'VLV', latitude: 11.9167, longitude: 79.5833, sequence: 2),
      BusStop(id: 'STP-MGD', name: 'Madagadipet', code: 'MGD', latitude: 11.9180, longitude: 79.6700, sequence: 3),
      BusStop(id: 'STP-VLN', name: 'Villianur Temple', code: 'VLN', latitude: 11.9150, longitude: 79.7600, sequence: 4),
      BusStop(id: 'STP-PDY', name: 'Pondicherry Terminal', code: 'PDY', latitude: 11.9338, longitude: 79.8145, sequence: 5),
    ],
    polylinePoints: [
      LatLng(11.9401, 79.4976), // Villupuram
      LatLng(11.9330, 79.5180),
      LatLng(11.9270, 79.5420),
      LatLng(11.9210, 79.5630),
      LatLng(11.9167, 79.5833), // Valavanur
      LatLng(11.9172, 79.6100),
      LatLng(11.9178, 79.6400),
      LatLng(11.9180, 79.6700), // Madagadipet
      LatLng(11.9170, 79.7000),
      LatLng(11.9160, 79.7300),
      LatLng(11.9150, 79.7600), // Villianur
      LatLng(11.9200, 79.7800),
      LatLng(11.9260, 79.7980),
      LatLng(11.9338, 79.8145), // Pondicherry
    ],
  );

  /// Primary Demo Routes for Phase 2
  static const List<Route> allRoutes = [
    routeVillupuramTrichy,
    routeChennaiVadalur,
    routeVillupuramPondicherry,
  ];
}
