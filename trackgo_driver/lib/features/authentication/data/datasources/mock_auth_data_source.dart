import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';

/// Centralized Mock Authentication Data Source
/// Test credentials and mock session store for Phase 1 (Tamil Nadu Region).
class MockAuthDataSource {
  // Predefined Phase 1 Test Account
  static const String validEmail = 'driver@trackgo.com';
  static const String validDriverEmail = 'karthikeyan.driver@trackgo.example';
  static const String validUsername = 'driver123';
  static const String validDriverUsername = 'karthik123';
  static const String validPassword = 'password123';

  static const DriverUser mockDriver = DriverUser(
    id: 'DRV-1024',
    name: 'Karthikeyan',
    email: 'karthikeyan.driver@trackgo.example',
    phone: '+91 98765 43210',
    licenseNumber: 'TN-32-2018-0049281',
    licenseExpiry: 'Dec 2028',
    avatarUrl: null, // Initial fallback avatar
    status: DriverStatus.available,
    assignedDepot: 'Villupuram Central Depot (Division 1)',
    region: 'Villupuram Region',
    vehicleClass: 'PSV Badge - Heavy Passenger Transit',
    experienceYears: 7,
    rating: 4.94,
  );

  DriverUser? _currentUser;

  Future<DriverUser> login(String emailOrUsername, String password) async {
    // Simulate brief network latency for realistic feel
    await Future.delayed(const Duration(milliseconds: 650));

    final normalizedInput = emailOrUsername.trim().toLowerCase();
    final isEmailMatch =
        normalizedInput == validEmail || normalizedInput == validDriverEmail;
    final isUsernameMatch =
        normalizedInput == validUsername ||
        normalizedInput == validDriverUsername;

    if ((isEmailMatch || isUsernameMatch) && password == validPassword) {
      _currentUser = mockDriver;
      return _currentUser!;
    } else if (normalizedInput.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty.');
    } else if (!isEmailMatch && !isUsernameMatch) {
      throw Exception('Driver account not found for "$emailOrUsername".');
    } else {
      throw Exception('Invalid password. Please verify your credentials.');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 250));
    _currentUser = null;
  }

  Future<DriverUser?> getCurrentUser() async {
    return _currentUser;
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception('Please provide a valid email address.');
    }
    return true;
  }
}
