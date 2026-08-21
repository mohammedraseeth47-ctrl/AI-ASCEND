import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_empty_state.dart';

/// My Trips Screen with clean Phase 1 placeholder empty-state.
class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Trips'),
        centerTitle: false,
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: AppEmptyState(
              title: 'No Trips Yet',
              message: 'Your saved and recent journeys will appear here.',
              icon: Icons.confirmation_number_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
