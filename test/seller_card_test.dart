import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: SizedBox(width: 350, child: child))));

  group('SellerCard', () {
    testWidgets('renders name, city, and listings count', (tester) async {
      await tester.pumpWidget(wrap(
        SellerCard(sellerId: 's1', name: 'Mama Njeri', city: 'Nairobi', stiScore: 85, totalListings: 42),
      ));

      expect(find.text('Mama Njeri'), findsOneWidget);
      expect(find.text('Nairobi · 42 listings'), findsOneWidget);
    });

    testWidgets('renders STI score chip', (tester) async {
      await tester.pumpWidget(wrap(
        SellerCard(sellerId: 's1', name: 'Test', city: 'Mombasa', stiScore: 72, totalListings: 10),
      ));

      expect(find.text('72'), findsOneWidget);
    });

    testWidgets('renders VAZI badge when featured', (tester) async {
      await tester.pumpWidget(wrap(
        SellerCard(sellerId: 's1', name: 'Test', city: 'Kisumu', stiScore: 90, totalListings: 5, isVaziFeatured: true),
      ));

      expect(find.text('VAZI'), findsOneWidget);
    });

    testWidgets('renders action button and calls onAction', (tester) async {
      var actionCalled = false;
      await tester.pumpWidget(wrap(
        SellerCard(
          sellerId: 's1', name: 'Test', city: 'Nakuru', stiScore: 50,
          totalListings: 3, actionLabel: 'Visit Store',
          onAction: () => actionCalled = true,
        ),
      ));

      expect(find.text('Visit Store'), findsOneWidget);
      await tester.tap(find.text('Visit Store'));
      expect(actionCalled, true);
    });

    testWidgets('calls onTap when card tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        SellerCard(
          sellerId: 's1', name: 'Test', city: 'Eldoret', stiScore: 60,
          totalListings: 1, onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('Test'));
      expect(tapped, true);
    });

    testWidgets('shows singular "listing" for count of 1', (tester) async {
      await tester.pumpWidget(wrap(
        SellerCard(sellerId: 's1', name: 'Test', city: 'Thika', stiScore: 30, totalListings: 1),
      ));

      expect(find.text('Thika · 1 listing'), findsOneWidget);
    });
  });
}
