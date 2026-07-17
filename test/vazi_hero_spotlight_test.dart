import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'http_mock_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('VAZIHeroSpotlight renders title and outfits list, tapping model opens popover', (WidgetTester tester) async {
    final outfits = [
      const VAZIHeroOutfit(
        id: 'outfit-1',
        modelMediaUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
        modelMediaType: 'image',
        modelAlt: 'Summer look',
        name: 'Summer Breeze Look',
        totalPrice: 4500,
        items: [
          VAZIShowcaseItem(id: 'item-1', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100', price: 2000, title: 'Shirt'),
          VAZIShowcaseItem(id: 'item-2', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100', price: 2500, title: 'Pants'),
        ],
      ),
    ];

    String? shopClickedId;
    String? itemClickedId;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VAZIHeroSpotlight(
            outfits: outfits,
            title: 'Featured AI Outfits',
            onShopLook: (id) => shopClickedId = id,
            onItemClick: (id) => itemClickedId = id,
          ),
        ),
      ),
    );

    // Verify title is rendered
    expect(find.text('Featured AI Outfits'), findsOneWidget);

    // Verify model image is loaded via Image.network
    expect(find.byType(Image), findsOneWidget);

    // Tap on the model card to open popover
    await tester.tap(find.byType(Image));
    await tester.pumpAndSettle();

    // Popover content should be visible
    expect(find.text('Summer Breeze Look'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('KES 4500'), findsOneWidget);

    // Tap on the first item thumbnail (Image within popover)
    // There are 3 images total: the model image and 2 item thumbnails
    await tester.tap(find.byType(Image).at(1));
    await tester.pumpAndSettle();

    expect(itemClickedId, 'item-1');

    // Tap on the model card again to reopen popover
    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();

    // Tap "Shop" button inside popover
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();

    expect(shopClickedId, 'outfit-1');
  });
}
