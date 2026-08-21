import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/authentication/domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  DriverUser? _currentUser;
  String? _errorMessage;

  AuthController(this._authRepository);

  AuthStatus get status => _status;
  DriverUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _currentUser != null;
  bool get isLoading => _status == AuthStatus.authenticating;

  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
      } else {
        _currentUser = null;
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      return await _authRepository.resetPassword(email: email);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void updateDriverStatus(DriverStatus newStatus) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
