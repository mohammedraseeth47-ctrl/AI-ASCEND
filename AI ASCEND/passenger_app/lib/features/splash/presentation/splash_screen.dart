import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Splash Screen with animated logo, pulse ring, and routing based on onboarding status.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseRingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.9, curve: Curves.easeIn)),
    );

    _pulseRingAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(AppConstants.splashDuration, () {
      if (!mounted) return;

      final storageService = ref.read(localStorageServiceProvider);
      final isCompleted = storageService.isOnboardingCompleted;

      final nextRoute = isCompleted ? AppRoutes.main : AppRoutes.onboarding;

      Navigator.of(context).pushReplacementNamed(nextRoute);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Background Gradient Accent
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(isDark ? 25 : 40),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withAlpha(isDark ? 20 : 35),
              ),
            ),
          ),

          // Main Center Content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Logo with Pulse Ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse Ring
                        Transform.scale(
                          scale: _pulseRingAnimation.value,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withAlpha((80 * (1 - _pulseRingAnimation.value + 1)).toInt().clamp(0, 255)),
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                        // Logo Container
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(100),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_bus_filled_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // App Title & Tagline
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Track',
                                style: AppTextStyles.displayMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Go',
                                style: AppTextStyles.displayMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppConstants.appTagline,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Tamil Nadu Transit Edition',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Bottom Version & Loading Indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.8,
              child: Column(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppConstants.appVersion,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
