import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaOfflineBanner shows banner only when isOffline is true', (WidgetTester tester) async {
    bool retryTapped = false;

    // Test offline = false
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaOfflineBanner(
            isOffline: false,
            onRetry: () => retryTapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(MitumbaBanner), findsNothing);

    // Test offline = true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaOfflineBanner(
            isOffline: true,
            onRetry: () => retryTapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(MitumbaBanner), findsOneWidget);
    expect(find.text('You are currently offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(retryTapped, isTrue);
  });
}
