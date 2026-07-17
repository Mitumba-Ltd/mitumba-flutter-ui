import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('PriceTag renders formatted currency price', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              PriceTag(
                priceKes: 1250,
                size: 'small',
              ),
              PriceTag(
                priceKes: 10450,
                size: 'large',
                strikethrough: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('KES 1,250'), findsOneWidget);
    expect(find.text('KES 10,450'), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text('KES 10,450'));
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);
  });
}
