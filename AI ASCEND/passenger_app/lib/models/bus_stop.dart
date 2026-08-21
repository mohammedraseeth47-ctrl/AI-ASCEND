/// Bus Stop model for Tamil Nadu public transportation stations.
class BusStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String code;
  final int sequence;
  final List<String> passingRouteNumbers;
  final bool isMajorHub;
  final int? nextArrivalMinutes;

  const BusStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.code,
    this.sequence = 1,
    this.passingRouteNumbers = const [],
    this.isMajorHub = false,
    this.nextArrivalMinutes,
  });
}
