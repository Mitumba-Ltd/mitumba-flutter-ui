import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('TwoFactorSetupModal step-by-step setup simulation', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    bool closed = false;
    String verifiedCode = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TwoFactorSetupModal(
            open: true,
            onClose: () => closed = true,
            otpauthUri: 'otpauth://totp/Mitumba:buyer?secret=ABCD',
            secret: 'ABCD',
            backupCodes: const ['1111-2222', '3333-4444'],
            onVerify: (code) async {
              verifiedCode = code;
            },
          ),
        ),
      ),
    );

    expect(find.text('Set Up Two-Factor Authentication'), findsOneWidget);
    expect(find.text('Scan QR Code'), findsOneWidget);

    // Tap manual key button
    await tester.tap(find.text("Can't scan? Enter key manually"));
    await tester.pumpAndSettle();
    expect(find.text('ABCD'), findsOneWidget);

    // Tap Next to go to Step 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Verify Code'), findsOneWidget);

    // Enter verification code
    await tester.enterText(find.byType(TextField), '999888');
    await tester.pump();

    // Verify & Enable
    await tester.tap(find.text('Verify & Enable'));
    await tester.pumpAndSettle();

    expect(verifiedCode, equals('999888'));
    expect(find.text('Backup Codes'), findsOneWidget);
    expect(find.text('1111-2222'), findsOneWidget);

    // Done
    await tester.tap(find.text('Done'));
    await tester.pump();
    expect(closed, isTrue);
  });
}
