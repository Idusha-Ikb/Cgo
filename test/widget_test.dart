import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:securetrack_sl/main.dart';

void main() {
  testWidgets('App loads splash screen and navigates to role selection', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const SecureTrackApp());

    // Verify SecureTrack SL title appears on splash screen
    expect(find.text('SecureTrack SL'), findsWidgets);

    // Fast-forward past splash timer to role selection screen
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Verify role selection screen loaded with both Container Owner and Driver options
    expect(find.text('Select your role to continue'), findsOneWidget);
    expect(find.text('Container Owner'), findsOneWidget);
    expect(find.text('Driver'), findsOneWidget);
  });

  testWidgets('Login screen email validation test', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureTrackApp());
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Tap Container Owner card
    await tester.tap(find.text('Container Owner'));
    await tester.pumpAndSettle();

    // Verify Login Screen loaded
    expect(find.text('Sign in to your account'), findsOneWidget);
    expect(find.text('Container Owner Portal'), findsOneWidget);

    // Clear email input and enter invalid email
    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, 'invalid-email');
    await tester.pump();

    // Tap Login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify validation error is displayed
    expect(find.text('Please enter a valid email address (e.g. name@domain.com)'), findsOneWidget);

    // Enter valid email and valid password
    await tester.enterText(emailField, 'valid.owner@cargooverseas.lk');
    await tester.pump();

    // Tap Login button again
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify Dashboard screen is loaded
    expect(find.text('Tharindu Perera'), findsOneWidget);
    expect(find.text('Recent Containers'), findsOneWidget);
    // Verify Arrived metric card
    expect(find.text('Arrived'), findsWidgets);
  });
}
