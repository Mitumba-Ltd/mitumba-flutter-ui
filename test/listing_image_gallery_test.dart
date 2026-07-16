import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/listing/listing_image_gallery.dart';

void main() {
  testWidgets('ListingImageGallery renders empty state message when list is empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListingImageGallery(
            images: [],
            title: 'Sample Listing',
          ),
        ),
      ),
    );

    expect(find.text('No images available'), findsOneWidget);
  });

  testWidgets('ListingImageGallery renders primary images and thumbnail rows', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: ListingImageGallery(
              images: [
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
                'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
              ],
              title: 'Sample Sneakers',
            ),
          ),
        ),
      ),
    );

    // Primary images container PageView exists
    expect(find.byType(PageView), findsOneWidget);

    // Two thumbnails exist inside the thumbnail row
    final gestureFinder = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(GestureDetector),
    );
    expect(gestureFinder, findsNWidgets(2));
  });
}
