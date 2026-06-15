import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

  group('EmptyState', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(wrap(
        const EmptyState(title: 'No results', subtitle: 'Try a different search.'),
      ));

      expect(find.text('No results'), findsOneWidget);
      expect(find.text('Try a different search.'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(wrap(
        const EmptyState(title: 'Empty', subtitle: 'Nothing here.', icon: Icons.inbox_outlined),
      ));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('renders action button and calls onAction', (tester) async {
      var called = false;
      await tester.pumpWidget(wrap(
        EmptyState(
          title: 'Empty',
          subtitle: 'Nothing.',
          actionLabel: 'Browse',
          onAction: () => called = true,
        ),
      ));

      expect(find.text('Browse'), findsOneWidget);
      await tester.tap(find.text('Browse'));
      expect(called, true);
    });

    testWidgets('compact variant uses row layout', (tester) async {
      await tester.pumpWidget(wrap(
        const EmptyState(
          title: 'No items',
          subtitle: 'Add something.',
          icon: Icons.add,
          variant: EmptyStateVariant.compact,
        ),
      ));

      // Both icon and text should be present
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('elevated variant renders without border', (tester) async {
      await tester.pumpWidget(wrap(
        const EmptyState(
          title: 'Empty',
          subtitle: 'Sub',
          variant: EmptyStateVariant.elevated,
        ),
      ));

      expect(find.text('Empty'), findsOneWidget);
    });
  });
}
