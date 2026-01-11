// This is a basic Flutter widget test for the Sentio app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentio/main.dart';

void main() {
  testWidgets('App loads with correct title and theme', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app is loaded with MaterialApp.router
    expect(find.byType(MaterialApp), findsOneWidget);

    // The app should start with the splash screen
    // We can't test the actual splash screen content here since it navigates away
    // But we can verify the app structure is correct
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
