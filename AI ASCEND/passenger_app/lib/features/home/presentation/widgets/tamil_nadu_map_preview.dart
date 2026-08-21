import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../core/services/map_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/mock/mock_routes.dart';

/// Mini OpenStreetMap interactive preview widget for the Home screen with responsive bounds.
class TamilNaduMapPreview extends StatelessWidget {
  final VoidCallback onTap;

  const TamilNaduMapPreview({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRoute = MockRoutes.routeVillupuramTrichy;

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // FlutterMap OpenStreetMap
          FlutterMap(
            options: const MapOptions(
              initialCenter: MapService.tamilNaduCenter,
              initialZoom: 10.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.none, // Non-interactive preview to prevent scroll hijacking
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: MapService.openStreetMapTileUrl,
                userAgentPackageName: MapService.userAgentPackageName,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: primaryRoute.polylinePoints,
                    strokeWidth: 4.0,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),

          // Tap Overlay with Route Tag
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withAlpha(230),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.map_rounded, color: AppColors.primary, size: 12),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'TN Map',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Open Map →',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(170),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Villupuram • Cuddalore • Puducherry',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
