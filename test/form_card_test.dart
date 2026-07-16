import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/form_card.dart';

void main() {
  testWidgets('FormCard renders header details and child content', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FormCard(
            title: 'Verify Phone',
            subtitle: 'Enter the code sent to you via SMS.',
            icon: Icon(Icons.sms_outlined),
            child: Text('SMS Input Field'),
          ),
        ),
      ),
    );

    expect(find.text('Verify Phone'), findsOneWidget);
    expect(find.text('Enter the code sent to you via SMS.'), findsOneWidget);
    expect(find.byIcon(Icons.sms_outlined), findsOneWidget);
    expect(find.text('SMS Input Field'), findsOneWidget);
    expect(find.text('Verification Error'), findsNothing); // No error rendered
  });

  testWidgets('FormCard renders error message box when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FormCard(
            title: 'Verify Phone',
            error: 'Verification Code Expired',
            child: Text('Form Form'),
          ),
        ),
      ),
    );

    expect(find.text('Verification Code Expired'), findsOneWidget);
  });
}
