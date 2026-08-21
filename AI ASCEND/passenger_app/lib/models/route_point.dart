/// Model representing a geographic point on a Tamil Nadu bus route.
class RoutePoint {
  final double latitude;
  final double longitude;
  final String? name;

  const RoutePoint({
    required this.latitude,
    required this.longitude,
    this.name,
  });
}
