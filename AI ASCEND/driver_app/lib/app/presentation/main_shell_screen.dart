import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/features/home/presentation/screens/home_screen.dart';
import 'package:trackgo_driver/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:trackgo_driver/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:trackgo_driver/features/profile/presentation/screens/profile_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trips_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialTabIndex;

  const MainShellScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsController = context.watch<NotificationsController>();
    final unreadCount = notificationsController.unreadCount;

    final screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const TripsScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMutedLight,
          selectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.alt_route_outlined),
              activeIcon: Icon(Icons.alt_route_rounded),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.notifications_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.notifications_rounded),
              ),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
