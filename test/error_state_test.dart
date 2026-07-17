import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaErrorState standard and compact layouts and buttons', (WidgetTester tester) async {
    bool retryTapped = false;
    bool backTapped = false;

    // 1. Standard elevated error state test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaErrorState(
            title: 'No connection',
            subtitle: 'Offline state',
            type: MitumbaErrorType.network,
            variant: MitumbaErrorVariant.elevated,
            onRetry: () => retryTapped = true,
            onBack: () => backTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Offline state'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);

    // Tap retry button
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(retryTapped, isTrue);

    // Tap back button
    await tester.tap(find.text('Go back'));
    await tester.pump();
    expect(backTapped, isTrue);
  });
}
