import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

const _testOutfits = [
  VAZIShowcaseOutfit(
    id: 'o1',
    modelMediaUrl: 'https://example.com/model1.png',
    modelAlt: 'Model 1',
    items: [
      VAZIShowcaseItem(id: 'i1', title: 'Jacket', price: 2500, imageUrl: 'https://example.com/j.jpg'),
      VAZIShowcaseItem(id: 'i2', title: 'Jeans', price: 1500, imageUrl: 'https://example.com/p.jpg'),
    ],
    totalPrice: 4000,
  ),
  VAZIShowcaseOutfit(
    id: 'o2',
    modelMediaUrl: 'https://example.com/model2.png',
    modelAlt: 'Model 2',
    items: [
      VAZIShowcaseItem(id: 'i3', title: 'Dress', price: 3000, imageUrl: 'https://example.com/d.jpg'),
    ],
    totalPrice: 3000,
  ),
];

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: SizedBox(width: 400, height: 800, child: child)));

  group('VAZIShowcase', () {
    testWidgets('renders look counter and progress dots', (tester) async {
      await tester.pumpWidget(wrap(const VAZIShowcase(outfits: _testOutfits)));
      await tester.pump();

      expect(find.byType(VAZIBadge), findsOneWidget);
      expect(find.text('VAZI'), findsOneWidget);
    });

    testWidgets('renders outfit total price', (tester) async {
      await tester.pumpWidget(wrap(const VAZIShowcase(outfits: _testOutfits)));
      await tester.pump();

      expect(find.text('KES 4,000'), findsOneWidget);
    });

    testWidgets('renders Shop this look button', (tester) async {
      await tester.pumpWidget(wrap(VAZIShowcase(outfits: _testOutfits, onShopAll: (_) {})));
      await tester.pump();

      expect(find.text('Shop this look'), findsOneWidget);
    });

    testWidgets('calls onShopAll when button tapped', (tester) async {
      String? outfitId;
      await tester.pumpWidget(wrap(VAZIShowcase(outfits: _testOutfits, onShopAll: (id) => outfitId = id)));
      await tester.pump();

      await tester.tap(find.text('Shop this look'));
      expect(outfitId, 'o1');
    });

    testWidgets('returns empty widget when outfits is empty', (tester) async {
      await tester.pumpWidget(wrap(const VAZIShowcase(outfits: [])));

      expect(find.byType(VAZIShowcase), findsOneWidget);
      expect(find.text('VAZI'), findsNothing);
    });
  });
}
