import 'package:trackgo_driver/features/authentication/data/datasources/firebase_auth_data_source.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';
import 'package:trackgo_driver/features/authentication/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  FirebaseAuthRepository({FirebaseAuthDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseAuthDataSource();

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
