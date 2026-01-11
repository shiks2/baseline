import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentio/Auth/screen/login_view.dart';

void main() {
  group('LoginView Tests', () {
    testWidgets('Login view renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Verify main elements are present
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Don\'t have an account? '), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Email field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Tap the login button without entering anything
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Invalid email validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Enter invalid email
      await tester.enterText(find.byType(TextField).first, 'invalid-email');

      // Tap the login button
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Find password field (second TextField)
      final passwordField = find.byType(TextField).last;

      // Initially should be obscure
      final initialTextField = tester.widget<TextField>(passwordField);
      expect(initialTextField.obscureText, isTrue);

      // Tap the visibility icon (look for any IconButton)
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should no longer be obscure
      final updatedTextField = tester.widget<TextField>(passwordField);
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('Form submission with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Enter valid email and password
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap the login button
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should not show validation errors
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Please enter a valid email address'), findsNothing);

      // Wait for the login simulation to complete
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
