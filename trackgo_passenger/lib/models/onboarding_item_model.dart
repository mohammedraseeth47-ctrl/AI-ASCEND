import 'package:flutter/material.dart';

/// Data model representing a single onboarding walkthrough slide.
class OnboardingItemModel {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String badgeText;

  const OnboardingItemModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.badgeText,
  });
}
