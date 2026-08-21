import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/bus_stop.dart';

/// Interactive Tamil Nadu bus stand pin on OpenStreetMap.
class StopMarkerWidget extends StatelessWidget {
  final BusStop stop;
  final VoidCallback onTap;

  const StopMarkerWidget({
    super.key,
    required this.stop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: stop.isMajorHub ? 26 : 22,
            height: stop.isMajorHub ? 26 : 22,
            decoration: BoxDecoration(
              color: stop.isMajorHub ? AppColors.secondary : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: stop.isMajorHub ? AppColors.primary : AppColors.secondary,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: stop.isMajorHub
                  ? const Icon(Icons.location_city_rounded, color: Colors.white, size: 14)
                  : Text(
                      '${stop.sequence}',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
