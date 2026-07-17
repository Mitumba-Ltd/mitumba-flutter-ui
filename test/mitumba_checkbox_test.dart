import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaCheckbox toggles and renders labels', (WidgetTester tester) async {
    bool checked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaCheckbox(
                checked: checked,
                label: 'Agree to terms',
                onChange: (val) {
                  setState(() => checked = val);
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Agree to terms'), findsOneWidget);
    expect(checked, isFalse);

    await tester.tap(find.text('Agree to terms'));
    await tester.pumpAndSettle();

    expect(checked, isTrue);
  });
}
