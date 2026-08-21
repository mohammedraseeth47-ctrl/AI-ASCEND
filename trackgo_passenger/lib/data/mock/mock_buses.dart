import '../../models/bus.dart';

/// Mock Tamil Nadu public transport buses with realistic registration plates.
class MockBuses {
  MockBuses._();

  static final Bus bus1 = Bus(
    id: 'MOCK_BUS_01',
    busNumber: 'TN-32-M-01',
    routeId: 'R-VPM-TRY',
    routeNumber: '101',
    routeName: 'Villupuram → Trichy',
    latitude: 11.6917, // Near Ulundurpet
    longitude: 79.2908,
    heading: 215.0,
    speedKmh: 42.0,
    status: 'Running',
    occupancyLabel: 'Seats Available',
    nextStopName: 'Ulundurpet Toll',
    etaMinutes: 4,
    lastUpdated: DateTime.now(),
    driverName: 'Demo Driver (BUS 01)',
    source: 'mock',
  );

  static final Bus bus2 = Bus(
    id: 'MOCK_BUS_02',
    busNumber: 'TN-01-M-02',
    routeId: 'R-CHN-VDL',
    routeNumber: '102',
    routeName: 'Chennai → Vadalur',
    latitude: 12.2285, // Near Tindivanam
    longitude: 79.6500,
    heading: 200.0,
    speedKmh: 45.0,
    status: 'Running',
    occupancyLabel: 'Moderate',
    nextStopName: 'Panruti Terminal',
    etaMinutes: 8,
    lastUpdated: DateTime.now(),
    driverName: 'Demo Driver (BUS 02)',
    source: 'mock',
  );

  static final Bus bus3 = Bus(
    id: 'MOCK_BUS_03',
    busNumber: 'TN-32-M-03',
    routeId: 'R-VPM-PDY',
    routeNumber: '103',
    routeName: 'Villupuram → Pondicherry',
    latitude: 11.9167, // Near Valavanur
    longitude: 79.5833,
    heading: 90.0,
    speedKmh: 35.0,
    status: 'Running',
    occupancyLabel: 'Standing Only',
    nextStopName: 'Villianur Temple',
    etaMinutes: 5,
    lastUpdated: DateTime.now(),
    driverName: 'Demo Driver (BUS 03)',
    source: 'mock',
  );

  static final List<Bus> allBuses = [bus1, bus2, bus3];
}
