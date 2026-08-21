import 'package:flutter/material.dart';
import 'package:trackgo_driver/app/presentation/main_shell_screen.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/login_screen.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/splash_screen.dart';
import 'package:trackgo_driver/features/home/presentation/screens/assignment_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/route_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:trackgo_driver/features/trips/presentation/screens/vehicle_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String tripDetail = '/trip-detail';
  static const String vehicleDetail = '/vehicle-detail';
  static const String routeDetail = '/route-detail';
  static const String assignmentDetail = '/assignment-detail';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.home:
        final initialTab = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainShellScreen(initialTabIndex: initialTab),
        );

      case AppRoutes.tripDetail:
        final tripId = settings.arguments as String? ?? 'TRP-10482';
        return MaterialPageRoute(
          builder: (_) => TripDetailScreen(tripId: tripId),
        );

      case AppRoutes.vehicleDetail:
        final vehicleId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VehicleDetailScreen(vehicleId: vehicleId),
        );

      case AppRoutes.routeDetail:
        final routeId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => RouteDetailScreen(routeId: routeId),
        );

      case AppRoutes.assignmentDetail:
        return MaterialPageRoute(
          builder: (_) => const AssignmentDetailScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
