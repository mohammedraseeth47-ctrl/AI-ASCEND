import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_passenger/core/widgets/app_badge.dart';
import 'package:trackgo_passenger/core/widgets/app_button.dart';
import 'package:trackgo_passenger/core/widgets/app_card.dart';
import 'package:trackgo_passenger/core/widgets/app_empty_state.dart';
import 'package:trackgo_passenger/core/widgets/app_error.dart';

void main() {
  group('Core Widgets Tests', () {
    testWidgets('AppButton renders text and triggers callback', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Confirm Ride',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Confirm Ride'), findsOneWidget);

      await tester.tap(find.text('Confirm Ride'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('AppBadge displays correct label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBadge.onTime(text: 'On Time'),
          ),
        ),
      );

      expect(find.text('On Time'), findsOneWidget);
    });

    testWidgets('AppCard renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('AppEmptyState displays title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'No Stops Found',
              message: 'Check back later',
            ),
          ),
        ),
      );

      expect(find.text('No Stops Found'), findsOneWidget);
      expect(find.text('Check back later'), findsOneWidget);
    });

    testWidgets('AppError displays error message and retries', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppError(
              message: 'Failed to fetch GPS coordinates',
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Failed to fetch GPS coordinates'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retried, isTrue);
    });
  });
}
