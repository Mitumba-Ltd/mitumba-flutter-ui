import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaRadio updates selected choice on tap', (WidgetTester tester) async {
    String selectedValue = 'first';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  MitumbaRadio(
                    selected: selectedValue == 'first',
                    value: 'first',
                    label: 'First Option',
                    onChange: (val) => setState(() => selectedValue = val),
                  ),
                  MitumbaRadio(
                    selected: selectedValue == 'second',
                    value: 'second',
                    label: 'Second Option',
                    onChange: (val) => setState(() => selectedValue = val),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('First Option'), findsOneWidget);
    expect(find.text('Second Option'), findsOneWidget);
    expect(selectedValue, 'first');

    await tester.tap(find.text('Second Option'));
    await tester.pumpAndSettle();

    expect(selectedValue, 'second');
  });
}
