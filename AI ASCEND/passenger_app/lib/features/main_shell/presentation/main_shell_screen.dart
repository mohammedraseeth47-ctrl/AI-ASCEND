import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../tracking/presentation/tracking_screen.dart';
import '../../trips/presentation/trips_screen.dart';
import '../providers/navigation_provider.dart';

/// Main Application Shell hosting the persistent Bottom Navigation Bar and 5 core feature screens.
class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = const [
      HomeScreen(),
      SearchScreen(),
      TrackingScreen(),
      TripsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 50 : 15),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => ref.read(navigationProvider.notifier).setTab(index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 22),
                activeIcon: Icon(Icons.home_rounded, size: 22),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined, size: 22),
                activeIcon: Icon(Icons.search_rounded, size: 22),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined, size: 22),
                activeIcon: Icon(Icons.map_rounded, size: 22),
                label: 'Live Track',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined, size: 22),
                activeIcon: Icon(Icons.confirmation_number_rounded, size: 22),
                label: 'Trips',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded, size: 22),
                activeIcon: Icon(Icons.person_rounded, size: 22),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
