import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Loading indicator component with animated transit pulsing effect.
class AppLoading extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;

  const AppLoading({
    super.key,
    this.message,
    this.size = 48.0,
    this.color,
  });

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: effectiveColor.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: effectiveColor.withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.directions_bus_rounded,
                      color: effectiveColor,
                      size: widget.size * 0.55,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer placeholder skeleton for list items and cards during loading.
class AppSkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppSkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12.0,
  });

  @override
  State<AppSkeletonLoader> createState() => _AppSkeletonLoaderState();
}

class _AppSkeletonLoaderState extends State<AppSkeletonLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurfaceVariant : AppColors.lightBorder;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
