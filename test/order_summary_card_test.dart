import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('OrderSummaryCard renders title, lines, total and responds to click', (WidgetTester tester) async {
    bool checkoutClicked = false;
    final items = [
      const OrderSummaryItem(label: 'Subtotal', amountKes: 6400),
      const OrderSummaryItem(label: 'Delivery', amountKes: 300),
      const OrderSummaryItem(label: 'Promo Code', amountKes: 500, isDiscount: true),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderSummaryCard(
            items: items,
            totalKes: 6200,
            onAction: () => checkoutClicked = true,
            trustLine: 'Escrow Protected Payment',
          ),
        ),
      ),
    );

    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.text('KES 6,400'), findsOneWidget);
    expect(find.text('Promo Code'), findsOneWidget);
    expect(find.text('−KES 500'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('KES 6,200'), findsOneWidget);
    expect(find.text('Escrow Protected Payment'), findsOneWidget);

    await tester.tap(find.byType(MitumbaPrimaryButton));
    await tester.pumpAndSettle();
    expect(checkoutClicked, true);
  });
}
