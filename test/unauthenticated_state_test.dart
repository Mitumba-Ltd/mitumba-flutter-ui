import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('UnauthenticatedState renders heading, subtitle, and responds to CTAs', (WidgetTester tester) async {
    bool signInTapped = false;
    bool secondaryTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UnauthenticatedState(
            title: 'Please sign in to access chat',
            subtitle: 'You need an account to message buyers and sellers directly.',
            signInLabel: 'Go to Sign In',
            onSignIn: () => signInTapped = true,
            secondaryAction: MitumbaSecondaryAction(
              label: 'Browse catalog',
              onClick: () => secondaryTapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Please sign in to access chat'), findsOneWidget);
    expect(find.text('You need an account to message buyers and sellers directly.'), findsOneWidget);
    expect(find.text('Go to Sign In'), findsOneWidget);
    expect(find.text('Browse catalog'), findsOneWidget);

    await tester.tap(find.text('Go to Sign In'));
    await tester.pump();
    expect(signInTapped, isTrue);

    await tester.tap(find.text('Browse catalog'));
    await tester.pump();
    expect(secondaryTapped, isTrue);
  });
}
