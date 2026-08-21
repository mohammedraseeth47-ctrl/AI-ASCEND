import 'package:latlong2/latlong.dart';
import '../constants/app_constants.dart';

/// Service managing OpenStreetMap tile layers, endpoints, headers, and Tamil Nadu regional coordinates.
class MapService {
  MapService._();

  /// Standard OpenStreetMap Tile URL template
  static const String openStreetMapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// OpenStreetMap requires a custom User-Agent header according to tile usage policy
  static const String userAgentPackageName = 'com.trackgo.passenger_app.tamilnadu';

  /// Map attribution string
  static const String attribution = '© OpenStreetMap contributors • Tamil Nadu Transit';

  /// Default Tamil Nadu camera center (Villupuram - Cuddalore - Puducherry corridor)
  static const LatLng tamilNaduCenter = LatLng(
    AppConstants.tamilNaduCenterLat,
    AppConstants.tamilNaduCenterLng,
  );

  /// Key Tamil Nadu Transport Hub Locations
  static const LatLng villupuramBusStand = LatLng(AppConstants.villupuramLat, AppConstants.villupuramLng);
  static const LatLng cuddaloreBusStand = LatLng(AppConstants.cuddaloreLat, AppConstants.cuddaloreLng);
  static const LatLng puducherryBusStand = LatLng(AppConstants.puducherryLat, AppConstants.puducherryLng);

  /// Max zoom level supported by OSM
  static const double maxZoom = 18.0;

  /// Min zoom level
  static const double minZoom = 7.0;

  /// Regional default zoom
  static const double defaultZoom = 10.5;
}
