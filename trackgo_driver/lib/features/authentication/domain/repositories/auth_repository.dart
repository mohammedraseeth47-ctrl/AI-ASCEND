import '../entities/driver_user.dart';

abstract class AuthRepository {
  /// Returns current authenticated user or null if not authenticated
  Future<DriverUser?> getCurrentUser();

  /// Logs in with email/username and password
  Future<DriverUser> login({required String email, required String password});

  /// Logs out current user and clears session state
  Future<void> logout();

  /// Initiates password reset for given email
  Future<bool> resetPassword({required String email});

  /// Check if user has active session
  Future<bool> isAuthenticated();
}
