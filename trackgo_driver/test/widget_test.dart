import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/app/app.dart';

void main() {
  testWidgets('TrackGoDriverApp boots into SplashScreen and transitions to Login', (WidgetTester tester) async {
    await tester.pumpWidget(const TrackGoDriverApp());

    // Initially on Splash
    expect(find.text('Track'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
    expect(find.text('DRIVER PLATFORM'), findsOneWidget);

    // Settle splash timer & animation
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Now on Login Screen
    expect(find.text('TrackGo Driver'), findsOneWidget);
    expect(find.text('Sign In to Driver Portal'), findsOneWidget);
  });
}
