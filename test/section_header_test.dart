import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/section_header.dart';

void main() {
  testWidgets('SectionHeader renders title, subtitle, and overline', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Featured Listings',
            subtitle: 'Handpicked curation of premium vintage pieces.',
            overline: 'Curated Deals',
          ),
        ),
      ),
    );

    expect(find.text('Featured Listings'), findsOneWidget);
    expect(find.text('Handpicked curation of premium vintage pieces.'), findsOneWidget);
    expect(find.text('CURATED DEALS'), findsOneWidget); // uppercase check
  });

  testWidgets('SectionHeader renders action button and fires callback', (WidgetTester tester) async {
    bool actionFired = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Featured Listings',
            actionLabel: 'See All',
            onAction: () {
              actionFired = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('See All'), findsOneWidget);
    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();

    expect(actionFired, isTrue);
  });

  testWidgets('SectionHeader supports custom action widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Featured Listings',
            action: Badge(label: Text('NEW')),
          ),
        ),
      ),
    );

    expect(find.byType(Badge), findsOneWidget);
  });

  testWidgets('SectionHeader renders column in centered alignment', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Featured Listings',
            align: SectionHeaderAlign.center,
            actionLabel: 'See All',
          ),
        ),
      ),
    );

    // Centered layout should be a Column
    expect(find.byType(Column), findsAtLeastNWidgets(2));
    expect(find.byType(Row), findsNothing);
  });
}
