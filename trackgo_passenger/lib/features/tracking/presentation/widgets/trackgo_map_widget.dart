import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/map_service.dart';
import '../../../../models/bus.dart';
import '../../../../models/bus_stop.dart';
import '../../../../models/route.dart' as app_models;
import 'bus_marker_widget.dart';
import 'stop_marker_widget.dart';

/// Reusable OpenStreetMap canvas widget configured with flutter_map for Tamil Nadu.
class TrackGoMapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;
  final double initialZoom;
  final app_models.Route? activeRoute;
  final List<app_models.Route> routes;
  final List<Bus> buses;
  final Bus? selectedBus;
  final ValueChanged<Bus> onBusTap;
  final ValueChanged<BusStop> onStopTap;

  const TrackGoMapWidget({
    super.key,
    required this.mapController,
    required this.initialCenter,
    this.initialZoom = 10.5,
    this.activeRoute,
    this.routes = const [],
    required this.buses,
    this.selectedBus,
    required this.onBusTap,
    required this.onStopTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate Bus Markers with generous responsive bounding box
    final busMarkers = buses.map((bus) {
      return Marker(
        point: LatLng(bus.latitude, bus.longitude),
        width: 140,
        height: 75,
        alignment: Alignment.center,
        child: BusMarkerWidget(
          bus: bus,
          isSelected: selectedBus?.id == bus.id,
          onTap: () => onBusTap(bus),
        ),
      );
    }).toList();

    // Generate Stop Markers for active route
    final stopMarkers = (activeRoute?.stops ?? []).map((stop) {
      return Marker(
        point: LatLng(stop.latitude, stop.longitude),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: StopMarkerWidget(
          stop: stop,
          onTap: () => onStopTap(stop),
        ),
      );
    }).toList();

    // Build polylines for all routes (highlighting activeRoute)
    final List<Polyline> allPolylines = [];
    final routeList = routes.isNotEmpty ? routes : (activeRoute != null ? [activeRoute!] : <app_models.Route>[]);

    for (final r in routeList) {
      if (r.polylinePoints.isEmpty) continue;
      final isActive = activeRoute?.id == r.id;

      if (isActive) {
        // Outer glow
        allPolylines.add(
          Polyline(
            points: r.polylinePoints,
            strokeWidth: 9.0,
            color: r.color.withAlpha(70),
          ),
        );
        // Vibrant main line
        allPolylines.add(
          Polyline(
            points: r.polylinePoints,
            strokeWidth: 5.0,
            color: r.color,
          ),
        );
      } else {
        // Distinct road line for non-selected route
        allPolylines.add(
          Polyline(
            points: r.polylinePoints,
            strokeWidth: 4.0,
            color: r.color.withAlpha(210),
          ),
        );
      }
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        minZoom: MapService.minZoom,
        maxZoom: MapService.maxZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        // OpenStreetMap Standard Tile Layer
        TileLayer(
          urlTemplate: MapService.openStreetMapTileUrl,
          userAgentPackageName: MapService.userAgentPackageName,
        ),

        // All Routes Polylines Layer
        if (allPolylines.isNotEmpty)
          PolylineLayer(polylines: allPolylines),

        // Stop Markers Layer
        MarkerLayer(markers: stopMarkers),

        // Live and Mock Bus Markers Layer
        MarkerLayer(markers: busMarkers),
      ],
    );
  }
}
