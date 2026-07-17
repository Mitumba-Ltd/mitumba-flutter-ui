import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaSwitch toggles on and off', (WidgetTester tester) async {
    bool on = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaSwitch(
                on: on,
                label: 'Enable Notifications',
                onChange: (val) => setState(() => on = val),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Enable Notifications'), findsOneWidget);
    expect(on, isFalse);

    await tester.tap(find.text('Enable Notifications'));
    await tester.pumpAndSettle();

    expect(on, isTrue);
  });
}
