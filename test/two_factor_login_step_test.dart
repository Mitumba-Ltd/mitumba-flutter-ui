import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('TwoFactorLoginStep renders with single and multiple methods', (WidgetTester tester) async {
    final methods = [
      const TwoFactorLoginMethod(id: '1', type: TwoFactorLoginMethodType.totp),
      const TwoFactorLoginMethod(id: '2', type: TwoFactorLoginMethodType.sms, label: '0712***678'),
    ];

    String submittedCode = '';
    String? activeMethodId = '1';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TwoFactorLoginStep(
            methods: methods,
            activeMethodId: activeMethodId,
            onSubmit: (code) => submittedCode = code,
            onMethodChange: (id) => activeMethodId = id,
          ),
        ),
      ),
    );

    expect(find.text('Two-Factor Authentication'), findsOneWidget);
    expect(find.text('Authenticator'), findsOneWidget);
    expect(find.text('0712***678'), findsOneWidget);

    // Enter verification code
    await tester.enterText(find.byType(TextField), '654321');
    await tester.pump();

    await tester.tap(find.text('Verify'));
    await tester.pump();

    expect(submittedCode, equals('654321'));
  });
}
