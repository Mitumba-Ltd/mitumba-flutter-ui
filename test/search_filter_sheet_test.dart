import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('SearchFilterSheet', () {
    testWidgets('renders all sections', (tester) async {
      await tester.pumpWidget(wrap(
        SearchFilterSheet(
          filters: const FilterState(),
          onFiltersChange: (_) {},
          onApply: () {},
          onClear: () {},
        ),
      ));

      expect(find.text('Sort By'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);

      // Scroll to see more sections
      await tester.scrollUntilVisible(find.text('VAZI Eligible Only'), 200);
      expect(find.text('Condition'), findsOneWidget);
      expect(find.text('Price Range'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('VAZI Eligible Only'), findsOneWidget);
    });

    testWidgets('calls onApply when button tapped', (tester) async {
      var applied = false;
      await tester.pumpWidget(wrap(
        SearchFilterSheet(
          filters: const FilterState(),
          onFiltersChange: (_) {},
          onApply: () => applied = true,
          onClear: () {},
        ),
      ));

      await tester.tap(find.text('Show Results'));
      expect(applied, true);
    });

    testWidgets('shows result count in button', (tester) async {
      await tester.pumpWidget(wrap(
        SearchFilterSheet(
          filters: const FilterState(),
          onFiltersChange: (_) {},
          onApply: () {},
          onClear: () {},
          resultCount: 42,
        ),
      ));

      expect(find.text('Show 42 Results'), findsOneWidget);
    });

    testWidgets('toggling category chip calls onFiltersChange', (tester) async {
      FilterState? newFilters;
      await tester.pumpWidget(wrap(
        SearchFilterSheet(
          filters: const FilterState(),
          onFiltersChange: (f) => newFilters = f,
          onApply: () {},
          onClear: () {},
        ),
      ));

      await tester.tap(find.text('Tops'));
      expect(newFilters, isNotNull);
      expect(newFilters!.categories, contains('Tops'));
    });

    testWidgets('calls onClear when clear button tapped', (tester) async {
      var cleared = false;
      await tester.pumpWidget(wrap(
        SearchFilterSheet(
          filters: const FilterState(),
          onFiltersChange: (_) {},
          onApply: () {},
          onClear: () => cleared = true,
        ),
      ));

      await tester.tap(find.text('Clear All'));
      expect(cleared, true);
    });
  });
}
