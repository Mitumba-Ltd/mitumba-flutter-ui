import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_outfit_card.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_outfit_card_skeleton.dart';
import 'package:mitumba_ui/src/components/feedback/mitumba_skeleton.dart';

void main() {
  const List<VAZIOutfitItem> sampleItems = [
    VAZIOutfitItem(
      listingId: '1',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      garmentType: 'shoes',
      priceKes: 3200,
      sellerName: 'Boutique Store',
    ),
    VAZIOutfitItem(
      listingId: '2',
      imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
      garmentType: 'top',
      priceKes: 1800,
      sellerName: 'Vibe Store',
    ),
  ];

  testWidgets('VAZIOutfitCard renders title, sellers count, price, and responds to click events', (WidgetTester tester) async {
    bool cardTapped = false;
    bool buyAllTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VAZIOutfitCard(
            outfitName: 'Chilled Weekend Vibe',
            items: sampleItems,
            totalPriceKes: 5000,
            sellersCount: 2,
            isMultiCity: true,
            onTap: () {
              cardTapped = true;
            },
            onBuyAll: () {
              buyAllTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Chilled Weekend Vibe'), findsOneWidget);
    expect(find.text('2 SELLERS'), findsOneWidget);
    expect(find.text('MULTI-CITY'), findsOneWidget);
    expect(find.text('KES 5,000'), findsOneWidget);

    // Tap main card body
    await tester.tap(find.text('Chilled Weekend Vibe'));
    await tester.pumpAndSettle();
    expect(cardTapped, isTrue);

    // Tap Buy Look button
    await tester.tap(find.text('Buy entire look'));
    await tester.pumpAndSettle();
    expect(buyAllTapped, isTrue);
  });

  testWidgets('VAZIOutfitCardSkeleton renders multiple loading skeleton elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VAZIOutfitCardSkeleton(),
        ),
      ),
    );

    expect(find.byType(VAZIOutfitCardSkeleton), findsOneWidget);
    expect(find.byType(MitumbaSkeleton), findsNWidgets(7)); // 2 in collage, 5 in details = 7
  });
}
