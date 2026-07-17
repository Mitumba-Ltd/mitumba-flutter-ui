import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaModal renders title, subtitle, content, actions, and responds to close click', (WidgetTester tester) async {
    bool closeTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaModal(
            title: 'Test Modal',
            subtitle: 'Supporting details',
            onClose: () => closeTapped = true,
            actions: const Text('Footer Actions'),
            child: const Text('Body Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Modal'), findsOneWidget);
    expect(find.text('Supporting details'), findsOneWidget);
    expect(find.text('Body Content'), findsOneWidget);
    expect(find.text('Footer Actions'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(closeTapped, true);
  });
}
