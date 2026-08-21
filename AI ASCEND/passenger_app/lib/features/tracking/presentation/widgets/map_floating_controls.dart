import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Floating map control buttons (Zoom In, Zoom Out, Recenter on Bus, Reset to Tamil Nadu view).
class MapFloatingControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRecenterBus;
  final VoidCallback onViewTamilNaduRoutes;

  const MapFloatingControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRecenterBus,
    required this.onViewTamilNaduRoutes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final iconColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // View Tamil Nadu Routes Action Pill Button
        InkWell(
          onTap: onViewTamilNaduRoutes,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_rounded, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                Text(
                  'TN Routes',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Recenter on Mock Bus Button
        _controlButton(
          icon: Icons.directions_bus_rounded,
          tooltip: 'Center on Bus',
          onPressed: onRecenterBus,
          bgColor: bgColor,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: 6),

        // Zoom In
        _controlButton(
          icon: Icons.add_rounded,
          tooltip: 'Zoom In',
          onPressed: onZoomIn,
          bgColor: bgColor,
          iconColor: iconColor,
        ),
        const SizedBox(height: 6),

        // Zoom Out
        _controlButton(
          icon: Icons.remove_rounded,
          tooltip: 'Zoom Out',
          onPressed: onZoomOut,
          bgColor: bgColor,
          iconColor: iconColor,
        ),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: iconColor, size: 18),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
