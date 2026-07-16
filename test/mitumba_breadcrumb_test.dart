import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/navigation/mitumba_breadcrumb.dart';

void main() {
  testWidgets('MitumbaBreadcrumb renders items, separators, and supports clicks', (WidgetTester tester) async {
    bool linkClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaBreadcrumb(
            items: [
              MitumbaBreadcrumbItem(
                label: 'Home',
                onTap: () {
                  linkClicked = true;
                },
              ),
              const MitumbaBreadcrumbItem(
                label: 'Shop',
              ),
              const MitumbaBreadcrumbItem(
                label: 'Vintage Jackets',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Vintage Jackets'), findsOneWidget);

    // Separators (two / dividers)
    expect(find.text('/'), findsNWidgets(2));

    // Tap link
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(linkClicked, isTrue);
  });
}
