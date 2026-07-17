import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'http_mock_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('CartItem renders product image, details, price and handles selectors', (WidgetTester tester) async {
    int newQty = 1;
    String newSize = 'M';
    bool removed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItem(
            imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100',
            title: 'Vintage Denim Jacket',
            subtitle: 'Blue / Stonewash',
            status: 'IN STOCK',
            priceKes: 3200,
            size: 'M',
            availableSizes: const ['S', 'M', 'L'],
            quantity: 1,
            onRemove: () => removed = true,
            onQuantityChange: (q) => newQty = q,
            onSizeChange: (s) => newSize = s,
          ),
        ),
      ),
    );

    expect(find.text('Vintage Denim Jacket'), findsOneWidget);
    expect(find.text('Blue / Stonewash'), findsOneWidget);
    expect(find.text('IN STOCK'), findsOneWidget);
    expect(find.text('KES 3,200'), findsOneWidget);

    // Verify select widgets are rendered (M and 1)
    expect(find.text('M'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Call onChange on MitumbaSelect to verify callback triggers
    final sizeSelect = tester.widget<MitumbaSelect>(find.byType(MitumbaSelect).first);
    sizeSelect.onChange('L');
    expect(newSize, 'L');

    final qtySelect = tester.widget<MitumbaSelect>(find.byType(MitumbaSelect).at(1));
    qtySelect.onChange(3);
    expect(newQty, 3);

    // Tap remove close button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(removed, true);
  });
}
