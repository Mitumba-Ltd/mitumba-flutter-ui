import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('AuthSubmitButton renders and responds to taps', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthSubmitButton(
            label: 'Submit Code',
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    expect(find.text('Submit Code'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text('Submit Code'));
    await tester.pump();

    expect(clicked, isTrue);
  });

  testWidgets('AuthSubmitButton handles disabled state', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthSubmitButton(
            label: 'Submit Code',
            disabled: true,
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Submit Code'));
    await tester.pump();

    expect(clicked, isFalse);
  });

  testWidgets('AuthSubmitButton handles loading state', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthSubmitButton(
            label: 'Submit Code',
            loading: true,
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    expect(find.text('Submit Code'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump();

    expect(clicked, isFalse);
  });
}
