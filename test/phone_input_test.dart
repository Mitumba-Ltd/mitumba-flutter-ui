import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaPhoneInput renders, formats and fires onChanged', (WidgetTester tester) async {
    String value = '712345678';
    String? error;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaPhoneInput(
                value: value,
                onChanged: (val) => setState(() => value = val),
                label: 'Phone',
                error: error,
              );
            },
          ),
        ),
      ),
    );

    // Initial blurred formatting: "712 345 678"
    expect(find.text('PHONE'), findsOneWidget);
    expect(find.text('712 345 678'), findsOneWidget);
    expect(find.text('+254'), findsOneWidget);

    // Focus input
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    // In focus: raw text value "712345678"
    expect(find.text('712345678'), findsOneWidget);

    // Enter new value
    await tester.enterText(find.byType(TextField), '788888888');
    await tester.pump();
    expect(value, equals('788888888'));
  });
}
