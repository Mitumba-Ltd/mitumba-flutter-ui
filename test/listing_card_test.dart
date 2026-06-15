import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 200, child: SingleChildScrollView(child: child))),
    ),
  );

  group('ListingCard', () {
    testWidgets('renders title and price', (tester) async {
      await tester.pumpWidget(wrap(
        ListingCard(
          id: '1',
          title: 'Vintage Jacket',
          price: 3500,
          media: const ['https://example.com/img.jpg'],
        ),
      ));

      expect(find.text('Vintage Jacket'), findsOneWidget);
      expect(find.text('KES 3,500'), findsOneWidget);
    });

    testWidgets('renders store name when provided', (tester) async {
      await tester.pumpWidget(wrap(
        ListingCard(
          id: '1',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          storeName: 'Mama Njeri',
        ),
      ));

      expect(find.text('Mama Njeri'), findsOneWidget);
    });

    testWidgets('renders condition badge', (tester) async {
      await tester.pumpWidget(wrap(
        ListingCard(
          id: '1',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          condition: ListingCondition.likeNew,
        ),
      ));

      expect(find.text('Like New'), findsOneWidget);
    });

    testWidgets('calls onSaveToggle when heart is tapped', (tester) async {
      String? savedId;
      await tester.pumpWidget(wrap(
        ListingCard(
          id: 'abc',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          onSaveToggle: (id) => savedId = id,
        ),
      ));

      await tester.tap(find.byIcon(Icons.favorite_border));
      expect(savedId, 'abc');
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      String? tappedId;
      await tester.pumpWidget(wrap(
        ListingCard(
          id: 'xyz',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          onTap: (id) => tappedId = id,
        ),
      ));

      await tester.tap(find.text('Test'));
      expect(tappedId, 'xyz');
    });

    testWidgets('calls onAddToCart and shows check icon', (tester) async {
      String? cartId;
      await tester.pumpWidget(wrap(
        ListingCard(
          id: 'c1',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          onAddToCart: (id) => cartId = id,
        ),
      ));

      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pump();
      expect(cartId, 'c1');
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Pump past the 1500ms reset timer
      await tester.pump(const Duration(milliseconds: 1500));
    });

    testWidgets('shows filled heart when isSaved is true', (tester) async {
      await tester.pumpWidget(wrap(
        ListingCard(
          id: '1',
          title: 'Test',
          price: 100,
          media: const ['https://example.com/img.jpg'],
          isSaved: true,
          onSaveToggle: (_) {},
        ),
      ));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
