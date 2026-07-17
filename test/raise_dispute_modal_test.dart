import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('RaiseDisputeModal renders fields and submits data when valid', (WidgetTester tester) async {
    DisputeData? submittedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RaiseDisputeModal(
            orderShortId: '29384',
            onSubmit: (data) => submittedData = data,
          ),
        ),
      ),
    );

    expect(find.text('Raise a Dispute'), findsOneWidget);
    expect(find.text('Order #29384'), findsOneWidget);

    // Verify submit button is disabled initially
    final buttonFinder = find.byType(MitumbaPrimaryButton);
    expect(tester.widget<MitumbaPrimaryButton>(buttonFinder).disabled, true);

    // Enter a valid description (min 10 characters)
    await tester.enterText(find.byType(MitumbaTextField).first, 'Item arrived damaged and torn at the seams.');
    await tester.pump();

    // Select reason
    final reasonSelect = tester.widget<MitumbaSelect>(find.byType(MitumbaSelect).first);
    reasonSelect.onChange('damaged');
    await tester.pump();

    // Select desired resolution
    final resolutionSelect = tester.widget<MitumbaSelect>(find.byType(MitumbaSelect).at(1));
    resolutionSelect.onChange('refund');
    await tester.pump();

    // Now submit button should be enabled, tap it!
    expect(tester.widget<MitumbaPrimaryButton>(buttonFinder).disabled, false);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(submittedData, isNotNull);
    expect(submittedData!.reason, 'damaged');
    expect(submittedData!.desiredResolution, 'refund');
    expect(submittedData!.description, 'Item arrived damaged and torn at the seams.');
  });
}
