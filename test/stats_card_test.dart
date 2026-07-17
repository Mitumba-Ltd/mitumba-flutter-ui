import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('StatsCard renders label, value, and units correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatsCard(
            label: 'Total Revenue',
            value: '45,800',
            unit: 'KES',
            unitPosition: StatsCardUnitPosition.prefix,
          ),
        ),
      ),
    );

    expect(find.text('TOTAL REVENUE'), findsOneWidget);
    expect(find.text('45,800'), findsOneWidget);
    expect(find.text('KES'), findsOneWidget);
  });

  testWidgets('StatsCard renders trend status and handles click events', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatsCard(
            label: 'Visits',
            value: '1,200',
            trend: const StatsCardTrend(
              direction: 'up',
              percent: 12.0,
              label: 'vs yesterday',
            ),
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('12%'), findsOneWidget);
    expect(find.text('vs yesterday'), findsOneWidget);

    await tester.tap(find.text('VISITS'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
