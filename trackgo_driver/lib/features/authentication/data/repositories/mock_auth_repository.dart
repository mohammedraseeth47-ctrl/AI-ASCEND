import '../../domain/entities/driver_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_data_source.dart';

class MockAuthRepository implements AuthRepository {
  final MockAuthDataSource _dataSource;

  MockAuthRepository({MockAuthDataSource? dataSource})
    : _dataSource = dataSource ?? MockAuthDataSource();

  @override
  Future<DriverUser?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<DriverUser> login({required String email, required String password}) {
    return _dataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return _dataSource.logout();
  }

  @override
  Future<bool> resetPassword({required String email}) {
    return _dataSource.resetPassword(email);
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await _dataSource.getCurrentUser();
    return user != null;
  }
}
