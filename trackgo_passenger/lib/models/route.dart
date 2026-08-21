import 'package:flutter/material.dart' hide Route;
import 'package:latlong2/latlong.dart';
import 'bus_stop.dart';

/// Bus Route model representing a Tamil Nadu transit corridor.
class Route {
  final String id;
  final String routeNumber;
  final String routeName;
  final String origin;
  final String destination;
  final String viaSummary;
  final List<BusStop> stops;
  final List<LatLng> polylinePoints;
  final Color color;
  final int frequencyMinutes;
  final double fareRupees;
  final String operatingHours;
  final int activeBusesCount;
  final bool isFavorite;

  const Route({
    required this.id,
    required this.routeNumber,
    required this.routeName,
    required this.origin,
    required this.destination,
    this.viaSummary = '',
    required this.stops,
    required this.polylinePoints,
    required this.color,
    this.frequencyMinutes = 15,
    this.fareRupees = 35.0,
    this.operatingHours = '05:00 AM - 11:00 PM',
    this.activeBusesCount = 3,
    this.isFavorite = false,
  });

  Route copyWith({
    String? id,
    String? routeNumber,
    String? routeName,
    String? origin,
    String? destination,
    String? viaSummary,
    List<BusStop>? stops,
    List<LatLng>? polylinePoints,
    Color? color,
    int? frequencyMinutes,
    double? fareRupees,
    String? operatingHours,
    int? activeBusesCount,
    bool? isFavorite,
  }) {
    return Route(
      id: id ?? this.id,
      routeNumber: routeNumber ?? this.routeNumber,
      routeName: routeName ?? this.routeName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      viaSummary: viaSummary ?? this.viaSummary,
      stops: stops ?? this.stops,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      color: color ?? this.color,
      frequencyMinutes: frequencyMinutes ?? this.frequencyMinutes,
      fareRupees: fareRupees ?? this.fareRupees,
      operatingHours: operatingHours ?? this.operatingHours,
      activeBusesCount: activeBusesCount ?? this.activeBusesCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
