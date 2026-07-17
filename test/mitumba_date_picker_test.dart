import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaDatePicker renders selected date and triggers onChange on grid selection', (WidgetTester tester) async {
    DateTime selectedDate = DateTime(2026, 7, 16);
    DateTime? callbackDate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaDatePicker(
                value: selectedDate,
                label: 'Shipping Date',
                onChange: (date) {
                  setState(() {
                    selectedDate = date;
                    callbackDate = date;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify read-only field text formatted as DD/MM/YYYY
    expect(find.text('16/07/2026'), findsOneWidget);
    expect(find.text('SHIPPING DATE'), findsOneWidget);

    // Tap to open custom calendar dialog
    await tester.tap(find.byType(MitumbaDatePicker));
    await tester.pumpAndSettle();

    // Verify dialog header is visible
    expect(find.text('July 2026'), findsOneWidget);

    // Tap day 20 in the calendar grid (which is day 20 of July 2026)
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();

    // Dialog should close, and value should update to 20/07/2026
    expect(find.text('July 2026'), findsNothing);
    expect(find.text('20/07/2026'), findsOneWidget);
    expect(callbackDate, DateTime(2026, 7, 20));
  });
}
