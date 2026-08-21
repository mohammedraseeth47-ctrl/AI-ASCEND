import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/authentication/data/datasources/mock_auth_data_source.dart';
import 'package:trackgo_driver/features/authentication/data/repositories/mock_auth_repository.dart';

void main() {
  group('MockAuthRepository Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository(dataSource: MockAuthDataSource());
    });

    test('login succeeds with correct test credentials', () async {
      final user = await repository.login(
        email: 'driver@trackgo.com',
        password: 'password123',
      );

      expect(user.id, 'DRV-1024');
      expect(user.name, 'Karthikeyan');
      expect(await repository.isAuthenticated(), isTrue);
    });

    test('login succeeds with driver username', () async {
      final user = await repository.login(
        email: 'driver123',
        password: 'password123',
      );

      expect(user.id, 'DRV-1024');
      expect(await repository.isAuthenticated(), isTrue);
    });

    test('login fails with invalid password', () async {
      expect(
        () => repository.login(
          email: 'driver@trackgo.com',
          password: 'wrong_password',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('login fails with unregistered email', () async {
      expect(
        () => repository.login(
          email: 'unknown@trackgo.com',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('logout clears session correctly', () async {
      await repository.login(
        email: 'driver@trackgo.com',
        password: 'password123',
      );
      expect(await repository.isAuthenticated(), isTrue);

      await repository.logout();
      expect(await repository.isAuthenticated(), isFalse);
      expect(await repository.getCurrentUser(), isNull);
    });

    test('resetPassword returns true for valid email', () async {
      final result = await repository.resetPassword(email: 'driver@trackgo.com');
      expect(result, isTrue);
    });

    test('resetPassword throws error for invalid email', () async {
      expect(
        () => repository.resetPassword(email: 'invalid-email'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
