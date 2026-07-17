import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'http_mock_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('StoreCard renders name, initials avatar, and subtitle', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StoreCard(
            name: 'Gikomba Luxury',
            subtitle: '12 active listings',
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    // Verify text info is rendered
    expect(find.text('Gikomba Luxury'), findsOneWidget);
    expect(find.text('12 active listings'), findsOneWidget);

    // Verify avatar contains initials
    expect(find.text('GL'), findsOneWidget);

    // Verify trailing chevron
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    // Tap card
    await tester.tap(find.text('Gikomba Luxury'));
    await tester.pumpAndSettle();

    expect(clicked, true);
  });
}
