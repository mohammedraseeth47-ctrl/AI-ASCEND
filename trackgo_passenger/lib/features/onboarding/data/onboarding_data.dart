import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/onboarding_item_model.dart';

/// 3-Screen Onboarding copy tailored specifically for Tamil Nadu public transport.
class OnboardingData {
  OnboardingData._();

  static const List<OnboardingItemModel> items = [
    OnboardingItemModel(
      title: 'Track Your Bus',
      description: 'See buses across Tamil Nadu and know where your bus is.',
      icon: Icons.directions_bus_filled_rounded,
      primaryColor: AppColors.primary,
      secondaryColor: AppColors.primaryLight,
      badgeText: 'Tamil Nadu Live Transit',
    ),
    OnboardingItemModel(
      title: 'Find Nearby Routes',
      description:
          'Discover buses, stops and routes around Villupuram, Cuddalore and Puducherry.',
      icon: Icons.alt_route_rounded,
      primaryColor: AppColors.accent,
      secondaryColor: Color(0xFF0077B6),
      badgeText: 'Regional Commute Planning',
    ),
    OnboardingItemModel(
      title: 'Travel With Confidence',
      description: 'Plan your journey better with TrackGo.',
      icon: Icons.verified_user_rounded,
      primaryColor: AppColors.accentAmber,
      secondaryColor: Color(0xFFD97706),
      badgeText: 'Smart Passenger Experience',
    ),
  ];
}
