import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackgo_passenger/app/app.dart';
import 'package:trackgo_passenger/core/constants/app_constants.dart';
import 'package:trackgo_passenger/core/providers/storage_provider.dart';
import 'package:trackgo_passenger/core/services/local_storage_service.dart';

void main() {
  testWidgets('App renders splash screen and transitions to onboarding for new user', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await LocalStorageService.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(storageService),
        ],
        child: const TrackGoApp(),
      ),
    );

    // Initial Splash screen
    expect(find.text('Track'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);

    // Advance splash duration timer to navigate to Onboarding
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    // Onboarding screen should be visible with Tamil Nadu copy
    expect(find.text('Track Your Bus'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
