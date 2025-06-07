// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/main.dart';

void main() {
  testWidgets('Analyse Réseau smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial UI is displayed correctly.
    expect(find.text('Plage d\'adresse IP'), findsOneWidget);
    expect(find.text('127.0.0.1'), findsOneWidget);
    expect(find.text('Analyser'), findsOneWidget);

    // Tap the 'Analyser' button and trigger a frame.
    await tester.tap(find.text('Analyser'));
    await tester.pump();

    // Verify that the SnackBar is displayed.
    expect(find.byType(SnackBar), findsOneWidget);

    // Additional expectations after the SnackBar appears.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
