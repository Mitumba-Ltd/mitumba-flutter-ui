import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaBanner renders title and message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MitumbaBanner(
            title: 'Info Update',
            message: 'Your profile has been updated.',
            severity: MitumbaBannerSeverity.info,
          ),
        ),
      ),
    );

    expect(find.text('Info Update'), findsOneWidget);
    expect(find.text('Your profile has been updated.'), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);
  });

  testWidgets('MitumbaBanner triggers action and close callbacks', (WidgetTester tester) async {
    bool closeTapped = false;
    bool actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaBanner(
            title: 'Critical Error',
            severity: MitumbaBannerSeverity.error,
            onClose: () => closeTapped = true,
            action: ElevatedButton(
              onPressed: () => actionTapped = true,
              child: const Text('RETRY'),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.error), findsOneWidget);

    await tester.tap(find.text('RETRY'));
    await tester.pumpAndSettle();
    expect(actionTapped, true);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(closeTapped, true);
  });
}
