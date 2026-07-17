import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('AddTwoFactorMethodModal renders available options and clicks', (WidgetTester tester) async {
    bool open = true;
    TwoFactorMethodType? selectedType;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return AddTwoFactorMethodModal(
                open: open,
                onClose: () => setState(() => open = false),
                availableTypes: const [TwoFactorMethodType.totp, TwoFactorMethodType.passkey],
                onSelectType: (t) => setState(() => selectedType = t),
              );
            },
          ),
        ),
      ),
    );

    // Verify dialog header
    expect(find.text('Add 2FA Method'), findsOneWidget);
    expect(find.text('Choose how you want to verify your identity'), findsOneWidget);

    // Verify option titles
    expect(find.text('Authenticator App'), findsOneWidget);
    expect(find.text('Passkey'), findsOneWidget);
    expect(find.text('SMS'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    // Chips
    expect(find.text('RECOMMENDED'), findsOneWidget);
    expect(find.text('STRONGEST'), findsOneWidget);

    // Tap TOTP (available)
    await tester.tap(find.text('Authenticator App'));
    await tester.pump();
    expect(selectedType, equals(TwoFactorMethodType.totp));

    // Tap SMS (not available)
    selectedType = null;
    await tester.tap(find.text('SMS'));
    await tester.pump();
    expect(selectedType, isNull); // Selection remains null because disabled
  });
}
