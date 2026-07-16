import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/navigation/mitumba_tabs.dart';

void main() {
  testWidgets('MitumbaTabs primary (solid) variant renders correctly and fires onChange', (WidgetTester tester) async {
    String selectedValue = 'all';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaTabs(
            value: selectedValue,
            onChange: (v) {
              selectedValue = v as String;
            },
            tabs: const [
              MitumbaTabOption(label: 'All Items', value: 'all'),
              MitumbaTabOption(label: 'Jackets', value: 'jackets'),
              MitumbaTabOption(label: 'Pants', value: 'pants', disabled: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('All Items'), findsOneWidget);
    expect(find.text('Jackets'), findsOneWidget);

    // Tap jackets
    await tester.tap(find.text('Jackets'));
    await tester.pumpAndSettle();

    expect(selectedValue, equals('jackets'));

    // Tap disabled tab (pants)
    await tester.tap(find.text('Pants'));
    await tester.pumpAndSettle();

    // Value should NOT change because it is disabled
    expect(selectedValue, equals('jackets'));
  });

  testWidgets('MitumbaTabs secondary (underline) variant renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaTabs(
            value: 'all',
            onChange: (_) {},
            variant: MitumbaTabsVariant.secondary,
            tabs: const [
              MitumbaTabOption(label: 'All Items', value: 'all'),
              MitumbaTabOption(label: 'Jackets', value: 'jackets'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('All Items'), findsOneWidget);
  });
}
