import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('SellerDisputeResponseCard accept and contest interactions', (WidgetTester tester) async {
    bool accepted = false;
    String contestMsg = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SellerDisputeResponseCard(
            reason: 'Item arrived damaged',
            description: 'The buyer claims the jacket is ripped.',
            onAccept: () => accepted = true,
            onContest: (msg, files) => contestMsg = msg,
          ),
        ),
      ),
    );

    expect(find.text('Item arrived damaged'), findsOneWidget);
    expect(find.text('The buyer claims the jacket is ripped.'), findsOneWidget);

    // Tap Accept & Refund
    await tester.tap(find.text('Accept & Refund'));
    await tester.pumpAndSettle();
    expect(accepted, true);

    // Tap Respond with Evidence
    await tester.tap(find.text('Respond with Evidence'));
    await tester.pumpAndSettle();

    // Verify contest form is visible
    expect(find.byType(MitumbaTextField), findsOneWidget);

    // Enter contest response
    await tester.enterText(find.byType(MitumbaTextField), 'This item was inspect-cleared before packaging.');
    await tester.pump();

    // Tap Submit Response
    await tester.tap(find.text('Submit Response'));
    await tester.pumpAndSettle();

    expect(contestMsg, 'This item was inspect-cleared before packaging.');
  });
}
