import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaSearchBar input, submit, clear and suggestions', (WidgetTester tester) async {
    String value = '';
    String clickedSuggestion = '';

    final suggestions = ['Vintage jacket', 'Nike shoes', 'Levis 501'];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaSearchBar(
                value: value,
                onChanged: (val) => setState(() => value = val),
                onSubmit: (_) {},
                suggestions: suggestions,
                onSuggestionClick: (s) => setState(() => clickedSuggestion = s),
              );
            },
          ),
        ),
      ),
    );

    // Initial check
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search...'), findsOneWidget);

    // Focus input to open suggestions overlay
    await tester.tap(find.byType(TextField));
    await tester.pump();

    // Verify suggestions are visible in overlay
    expect(find.text('Vintage jacket'), findsOneWidget);
    expect(find.text('Nike shoes'), findsOneWidget);

    // Click on suggestion
    await tester.tap(find.text('Nike shoes'));
    await tester.pumpAndSettle();

    expect(clickedSuggestion, equals('Nike shoes'));
    expect(value, equals('Nike shoes'));

    // Clear search
    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(value, isEmpty);
  });
}
