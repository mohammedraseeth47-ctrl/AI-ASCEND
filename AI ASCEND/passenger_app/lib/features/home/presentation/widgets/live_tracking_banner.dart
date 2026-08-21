import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/bus.dart';

/// Responsive hero demo bus preview banner card on Home dashboard.
class LiveTrackingBanner extends StatelessWidget {
  final Bus bus;
  final VoidCallback onTrackPressed;

  const LiveTrackingBanner({
    super.key,
    required this.bus,
    required this.onTrackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.gradient(
      onTap: onTrackPressed,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Demo preview status and Occupancy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'DEMO LIVE PREVIEW',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withAlpha(230),
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline_rounded, color: Colors.white, size: 10),
                    const SizedBox(width: 3),
                    Text(
                      bus.occupancyLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Route info and ETA
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RouteCodeBadge(
                      routeCode: bus.busNumber,
                      color: Colors.white.withAlpha(40),
                      isLarge: false,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      bus.routeName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bus.etaMinutes}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'MINS ETA',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withAlpha(200),
                      fontWeight: FontWeight.w700,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Next Stop and Speed metadata row
          Wrap(
            spacing: 8,
            runSpacing: 2,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pin_drop_outlined, color: Colors.white70, size: 11),
                  const SizedBox(width: 3),
                  Text(
                    'Next: ${bus.nextStopName}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withAlpha(220),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed_rounded, color: Colors.white70, size: 11),
                  const SizedBox(width: 3),
                  Text(
                    '${bus.speedKmh.toInt()} km/h',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withAlpha(220),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bottom Track Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(35),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Open Tamil Nadu Live Map',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
