import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('DeliveryBadge renders icon and custom days', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeliveryBadge(
            type: 'same-city',
            estimatedDays: '1-2 days',
          ),
        ),
      ),
    );

    expect(find.text('1-2 DAYS'), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping), findsOneWidget);
  });
}
