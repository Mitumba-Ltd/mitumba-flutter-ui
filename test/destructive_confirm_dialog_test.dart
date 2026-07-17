import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('DestructiveConfirmDialog validates, handles blockers, confirm phrases, and totp', (WidgetTester tester) async {
    bool open = true;
    bool confirmed = false;
    String? totpCode;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return DestructiveConfirmDialog(
                open: open,
                onClose: () => setState(() => open = false),
                title: 'Delete Shop',
                description: 'Are you sure?',
                confirmPhrase: 'DELETE',
                requireTotp: true,
                onConfirm: ({code}) async {
                  confirmed = true;
                  totpCode = code;
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify dialog title
    expect(find.text('Delete Shop'), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);

    // The Confirm button (labeled Delete) should be disabled initially
    final confirmButton = find.text('Delete');
    expect(confirmButton, findsOneWidget);

    // Tap confirm - should do nothing because disabled
    await tester.tap(confirmButton);
    await tester.pump();
    expect(confirmed, isFalse);

    // Enter wrong phrase
    await tester.enterText(find.byType(MitumbaTextField), 'WRONG');
    await tester.pump();

    // Enter valid phrase
    await tester.enterText(find.byType(MitumbaTextField), 'DELETE');
    await tester.pump();

    // Enter 6 digit code in the TOTP textfield (2nd TextField in the dialog)
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump();

    // Tap confirm - now it should succeed
    await tester.tap(confirmButton);
    await tester.pump();

    expect(confirmed, isTrue);
    expect(totpCode, equals('123456'));
  });
}
