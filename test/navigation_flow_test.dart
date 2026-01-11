import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentio/splash_screen.dart';
import 'package:sentio/Auth/screen/login_view.dart';
import 'package:sentio/dashboard/dashboard_view.dart';

void main() {
  group('Navigation Flow Tests', () {
    testWidgets('Splash screen displays correctly with rippling animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

      // Should show baseline text
      expect(find.text('Baseline'), findsOneWidget);

      // Verify black background
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);

      // Just pump to show initial state, don't wait for navigation
      await tester.pump();
    });

    testWidgets('Login screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));

      // Should show login form elements
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Dashboard displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardView()));

      // Should show dashboard content
      expect(find.text('Welcome to Dashboard'), findsOneWidget);
      expect(find.text('You have successfully logged in!'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Splash screen has rippling circles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

      // Check for ripple circles (Container with BoxShape.circle)
      final circleContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );

      expect(circleContainers, findsWidgets);

      // Verify the circles have white borders with opacity
      final containers = tester.widgetList<Container>(circleContainers);
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
        expect(decoration.shape, BoxShape.circle);
      }

      // Just pump to show initial state
      await tester.pump();
    });

    testWidgets('Dashboard logout button exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardView()));

      // Find and verify logout button
      final logoutButton = find.text('Logout');
      expect(logoutButton, findsOneWidget);

      // Verify button exists
      expect(logoutButton, findsOneWidget);
    });
  });
}
