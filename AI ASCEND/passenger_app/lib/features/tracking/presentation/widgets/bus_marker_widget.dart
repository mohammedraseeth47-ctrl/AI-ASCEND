import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/bus.dart';

/// Interactive live bus vehicle marker with animated pulse and Tamil Nadu bus number bubble.
class BusMarkerWidget extends StatefulWidget {
  final Bus bus;
  final bool isSelected;
  final VoidCallback onTap;

  const BusMarkerWidget({
    super.key,
    required this.bus,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<BusMarkerWidget> createState() => _BusMarkerWidgetState();
}

class _BusMarkerWidgetState extends State<BusMarkerWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDriver = widget.bus.isDriver;
    final primaryColor = widget.isSelected
        ? AppColors.accentAmber
        : (isDriver ? AppColors.primary : const Color(0xFF6366F1)); // Emerald for LIVE driver, Indigo for DEMO

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Registration Number & Mode Pill (LIVE vs DEMO)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(70),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.bus.busNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: isDriver
                        ? AppColors.statusOnTimeLight
                        : const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isDriver ? 'LIVE' : 'DEMO',
                    style: TextStyle(
                      color: isDriver ? const Color(0xFF047857) : const Color(0xFF6D28D9),
                      fontWeight: FontWeight.w800,
                      fontSize: 8.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),

          // Animated Bus Pin with Pulse
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse Circle (always for live driver, or when selected)
                  if (widget.isSelected || isDriver)
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withAlpha(isDriver ? 70 : 45),
                        ),
                      ),
                    ),
                  // Inner Bus Icon with heading rotation
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: widget.bus.heading * (math.pi / 180.0),
                        child: Icon(
                          isDriver ? Icons.navigation_rounded : Icons.navigation_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
