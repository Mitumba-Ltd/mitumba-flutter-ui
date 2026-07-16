import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/listing/listing_card_skeleton.dart';
import 'package:mitumba_ui/src/components/feedback/mitumba_skeleton.dart';

void main() {
  testWidgets('ListingCardSkeleton renders multiple skeleton sub-blocks', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 250,
            child: ListingCardSkeleton(),
          ),
        ),
      ),
    );

    expect(find.byType(ListingCardSkeleton), findsOneWidget);
    expect(find.byType(MitumbaSkeleton), findsNWidgets(5));
  });
}
