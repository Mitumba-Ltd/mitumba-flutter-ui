import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_feed_section.dart';
import 'package:mitumba_ui/src/components/vazi/complete_this_look_panel.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_outfit_card.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_outfit_card_skeleton.dart';

void main() {
  const List<VAZIOutfitItem> sampleItems = [
    VAZIOutfitItem(
      listingId: '1',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      garmentType: 'shoes',
      priceKes: 3200,
      sellerName: 'Boutique Store',
    ),
  ];

  testWidgets('VAZIFeedSection renders header and card items correctly', (WidgetTester tester) async {
    bool seeAllPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: VAZIFeedSection(
              outfits: [
                VAZIOutfitCard(
                  outfitName: 'Weekend Casual',
                  items: sampleItems,
                  totalPriceKes: 3200,
                  sellersCount: 1,
                  onTap: () {},
                ),
              ],
              onSeeAll: () {
                seeAllPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('VAZI Picks for You'), findsOneWidget);
    expect(find.text('EXPLORE ALL'), findsOneWidget);
    expect(find.text('Weekend Casual'), findsOneWidget);

    await tester.tap(find.text('EXPLORE ALL'));
    await tester.pumpAndSettle();
    expect(seeAllPressed, isTrue);
  });

  testWidgets('CompleteThisLookPanel hides when empty and displays skeletons when loading', (WidgetTester tester) async {
    // 1. Empty non-loading panel -> finds nothing
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CompleteThisLookPanel(
            outfits: [],
            loading: false,
          ),
        ),
      ),
    );

    expect(find.text('Complete this look'), findsNothing);

    // 2. Loading state -> renders skeletons
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CompleteThisLookPanel(
              outfits: [],
              loading: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Complete this look'), findsOneWidget);
    expect(find.byType(VAZIOutfitCardSkeleton), findsNWidgets(3));
  });
}
