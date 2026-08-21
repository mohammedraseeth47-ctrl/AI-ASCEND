class DriverMetrics {
  final int completedTripsToday;
  final int totalScheduledTripsToday;
  final double onTimePercentage;
  final double drivingHoursToday;
  final double totalDistanceKmToday;

  const DriverMetrics({
    required this.completedTripsToday,
    required this.totalScheduledTripsToday,
    required this.onTimePercentage,
    required this.drivingHoursToday,
    required this.totalDistanceKmToday,
  });
}
