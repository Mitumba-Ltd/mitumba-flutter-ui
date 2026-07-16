import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/navigation/mitumba_stepper.dart';

void main() {
  testWidgets('MitumbaStepper renders steps, checkmarks, and subtitles', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MitumbaStepper(
            activeStep: 1,
            steps: [
              MitumbaStepOption(label: 'Verification', subtitle: 'Completed'),
              MitumbaStepOption(label: 'Address', subtitle: 'Active'),
              MitumbaStepOption(label: 'Payment'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Verification'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);

    // Completed step should render checkmark icon instead of index number
    expect(find.byIcon(Icons.check), findsOneWidget);

    // Active step should render index 2
    expect(find.text('2'), findsOneWidget);

    // Pending step should render index 3
    expect(find.text('3'), findsOneWidget);
  });
}
