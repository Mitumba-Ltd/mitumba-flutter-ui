import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'http_mock_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('OrderCard renders details and status badge', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderCard(
            orderShortId: 'tr894',
            title: 'Vintage Denim Set + Boots',
            imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100',
            totalKes: 7400,
            deliveryFeeKes: 350,
            status: OrderCardStatus.shipped,
            createdAt: '2 days ago',
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    expect(find.text('ORDER #TR894'), findsOneWidget);
    expect(find.text('Vintage Denim Set + Boots'), findsOneWidget);
    expect(find.text('2 days ago'), findsOneWidget);
    expect(find.text('KES 7,400'), findsOneWidget);
    expect(find.text('+KES 350 delivery'), findsOneWidget);

    // Verify status chip
    expect(find.text('SHIPPED'), findsOneWidget);

    // Tap track package button
    await tester.tap(find.text('Track Package'));
    await tester.pumpAndSettle();

    // Tap card
    await tester.tap(find.text('Vintage Denim Set + Boots'));
    await tester.pumpAndSettle();
    expect(clicked, true);
  });
}
