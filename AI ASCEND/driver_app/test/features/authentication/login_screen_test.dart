import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/features/authentication/data/datasources/mock_auth_data_source.dart';
import 'package:trackgo_driver/features/authentication/data/repositories/mock_auth_repository.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders production fields and hides developer test tools', (WidgetTester tester) async {
    final authRepo = MockAuthRepository(dataSource: MockAuthDataSource());
    final authController = AuthController(authRepo);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>.value(
        value: authController,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify Title & Inputs
    expect(find.text('TrackGo Driver'), findsOneWidget);
    expect(find.text('Driver ID or Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In to Driver Portal'), findsOneWidget);

    // Verify developer seed & autofill buttons are NOT present in production UI
    expect(find.text('Auto-fill Test Account'), findsNothing);
    expect(find.text('Seed Firestore'), findsNothing);
    expect(find.text('Developer Sandbox & Seed'), findsNothing);

    // Enter credentials
    await tester.enterText(find.byType(TextFormField).first, 'driver1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'driver1@gmail.com'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'password123'), findsOneWidget);
  });
}
