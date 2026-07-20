import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('OrderMessageAttachment renders details and formats amount correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OrderMessageAttachment(
            orderShortId: 'a9331769',
            listingTitle: 'Vintage Denim Jacket',
            amount: 3200,
            status: 'shipped',
          ),
        ),
      ),
    );

    // Verify correct texts
    expect(find.text('Order #a9331769'), findsOneWidget);
    expect(find.text('Vintage Denim Jacket'), findsOneWidget);
    expect(find.text('KES 3,200 · shipped'), findsOneWidget);
  });
}
