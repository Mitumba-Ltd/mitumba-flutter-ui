import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/navigation/mitumba_pagination.dart';

void main() {
  testWidgets('MitumbaPagination renders page numbers, ellipses, and fires clicks', (WidgetTester tester) async {
    int selectedPage = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaPagination(
            count: 10,
            page: 4,
            onChange: (p) {
              selectedPage = p;
            },
          ),
        ),
      ),
    );

    // Active page 4 should render
    expect(find.text('1'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('...'), findsOneWidget);

    // Tap page 5 (since page <= 4 generates 1, 2, 3, 4, 5, ..., 10)
    expect(find.text('5'), findsOneWidget);
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(selectedPage, equals(5));
  });

  testWidgets('MitumbaPagination arrows trigger callbacks', (WidgetTester tester) async {
    int selectedPage = 4;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaPagination(
            count: 10,
            page: 4,
            onChange: (p) {
              selectedPage = p;
            },
          ),
        ),
      ),
    );

    // Tap previous (should yield 3)
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(selectedPage, equals(3));

    // Tap next (should yield 5)
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(selectedPage, equals(5));
  });
}
