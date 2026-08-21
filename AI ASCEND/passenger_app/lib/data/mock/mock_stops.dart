import '../../models/bus_stop.dart';

/// Accurate Tamil Nadu public transport bus stands and intermediate stops.
class MockStops {
  MockStops._();

  // Major Hubs
  static const BusStop villupuramBusStand = BusStop(
    id: 'BS-VPM-01',
    name: 'Villupuram Central Bus Stand',
    latitude: 11.9401,
    longitude: 79.4976,
    code: 'VPM-01',
    sequence: 1,
    passingRouteNumbers: ['101', '102', '103', '105'],
    isMajorHub: true,
    nextArrivalMinutes: 3,
  );

  static const BusStop panrutiBusStand = BusStop(
    id: 'BS-PRT-01',
    name: 'Panruti Bus Stand',
    latitude: 11.7749,
    longitude: 79.5537,
    code: 'PRT-01',
    sequence: 2,
    passingRouteNumbers: ['101', '103'],
    isMajorHub: false,
    nextArrivalMinutes: 12,
  );

  static const BusStop cuddaloreBusStand = BusStop(
    id: 'BS-CDL-01',
    name: 'Cuddalore Old Bus Stand',
    latitude: 11.7480,
    longitude: 79.7714,
    code: 'CDL-01',
    sequence: 3,
    passingRouteNumbers: ['101', '102', '103', '104'],
    isMajorHub: true,
    nextArrivalMinutes: 6,
  );

  static const BusStop puducherryBusStand = BusStop(
    id: 'BS-PDY-01',
    name: 'Puducherry New Bus Stand',
    latitude: 11.9338,
    longitude: 79.8145,
    code: 'PDY-01',
    sequence: 4,
    passingRouteNumbers: ['101', '102', '104', '105'],
    isMajorHub: true,
    nextArrivalMinutes: 8,
  );

  // Additional Tamil Nadu Regional Hubs
  static const BusStop tindivanamBusStand = BusStop(
    id: 'BS-TMV-01',
    name: 'Tindivanam Bus Stand',
    latitude: 12.2286,
    longitude: 79.6508,
    code: 'TMV-01',
    passingRouteNumbers: ['201', '105'],
    isMajorHub: true,
    nextArrivalMinutes: 15,
  );

  static const BusStop neyveliBusStand = BusStop(
    id: 'BS-NVL-01',
    name: 'Neyveli T.S Bus Stand',
    latitude: 11.5996,
    longitude: 79.4862,
    code: 'NVL-01',
    passingRouteNumbers: ['301', '103'],
    isMajorHub: true,
    nextArrivalMinutes: 22,
  );

  static const BusStop chidambaramBusStand = BusStop(
    id: 'BS-CDM-01',
    name: 'Chidambaram Bus Stand',
    latitude: 11.3992,
    longitude: 79.6934,
    code: 'CDM-01',
    passingRouteNumbers: ['401', '104'],
    isMajorHub: true,
    nextArrivalMinutes: 28,
  );

  static const BusStop ulundurpetBusStand = BusStop(
    id: 'BS-ULP-01',
    name: 'Ulundurpet Bus Stand',
    latitude: 11.6917,
    longitude: 79.2906,
    code: 'ULP-01',
    passingRouteNumbers: ['501'],
    isMajorHub: false,
    nextArrivalMinutes: 35,
  );

  // All Stops List
  static const List<BusStop> allStops = [
    villupuramBusStand,
    cuddaloreBusStand,
    puducherryBusStand,
    panrutiBusStand,
    tindivanamBusStand,
    neyveliBusStand,
    chidambaramBusStand,
    ulundurpetBusStand,
  ];
}
