import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_4/signup_page.dart'; // ✅ make sure this import matches your app folder name

void main() {
  testWidgets('Signup Page UI Test', (WidgetTester tester) async {
    // Load the SignupPage widget inside a MaterialApp
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    // ✅ Check if "Sign Up" title appears
    expect(find.text('Sign Up'), findsOneWidget);

    // ✅ Check if text fields are visible
    expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'Date of Birth (MM/DD/YYYY)'),
      findsOneWidget,
    );

    // ✅ Check if gender dropdown exists
    expect(
      find.widgetWithText(DropdownButtonFormField<String>, 'Gender'),
      findsOneWidget,
    );

    // ✅ Check if Sign Up button exists
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });
}
