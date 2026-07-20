import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('EmailVerificationPage renders elements, enters OTP code, and triggers verify', (WidgetTester tester) async {
    String verifiedCode = '';
    bool resendTapped = false;
    bool backTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmailVerificationPage(
            email: 'buyer@mitumba.com',
            onVerify: (code) => verifiedCode = code,
            onResend: () => resendTapped = true,
            onGoBack: () => backTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.textContaining('buyer@mitumba.com'), findsOneWidget);
    expect(find.text("Didn't receive it? Resend"), findsOneWidget);
    expect(find.text('Wrong email? Go back'), findsOneWidget);

    // Enter verification code
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    // Verify button should be clickable
    await tester.tap(find.text('Verify'));
    await tester.pump();

    expect(verifiedCode, equals('123456'));

    // Resend link tap
    await tester.tap(find.text("Didn't receive it? Resend"));
    await tester.pump();
    expect(resendTapped, isTrue);

    // Go back tap
    await tester.tap(find.text('Wrong email? Go back'));
    await tester.pump();
    expect(backTapped, isTrue);
  });
}
