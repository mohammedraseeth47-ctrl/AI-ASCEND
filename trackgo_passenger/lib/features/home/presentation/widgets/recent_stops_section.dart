import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/bus_stop.dart';

/// Horizontal scrolling nearby/major Tamil Nadu transit stops section.
class RecentStopsSection extends StatelessWidget {
  final List<BusStop> stops;
  final ValueChanged<BusStop> onStopTap;

  const RecentStopsSection({
    super.key,
    required this.stops,
    required this.onStopTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stops.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stop = stops[index];
          return SizedBox(
            width: 220,
            child: AppCard(
              onTap: () => onStopTap(stop),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(isDark ? 35 : 20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.location_city_rounded,
                          color: AppColors.primary,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          stop.code,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (stop.nextArrivalMinutes != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statusOnTimeLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${stop.nextArrivalMinutes}m',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: const Color(0xFF047857),
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    stop.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        'Lines: ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 11,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          stop.passingRouteNumbers.join(', '),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
