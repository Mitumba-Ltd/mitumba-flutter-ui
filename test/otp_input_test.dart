import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaOTPInput renders 6 text fields and triggers events', (WidgetTester tester) async {
    String value = '';
    String completedOtp = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaOTPInput(
                value: value,
                onChanged: (val) => setState(() => value = val),
                onComplete: (otp) => setState(() => completedOtp = otp),
              );
            },
          ),
        ),
      ),
    );

    // Verify 6 TextFields are rendered
    expect(find.byType(TextField), findsNWidgets(6));

    // Tap first textfield and enter '1'
    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.pump();

    expect(value, equals('1'));

    // Fill all remaining slots
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.enterText(find.byType(TextField).at(2), '3');
    await tester.enterText(find.byType(TextField).at(3), '4');
    await tester.enterText(find.byType(TextField).at(4), '5');
    await tester.enterText(find.byType(TextField).at(5), '6');
    await tester.pump();

    expect(value, equals('123456'));
    expect(completedOtp, equals('123456'));
  });
}
