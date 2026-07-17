import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'http_mock_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('DisputeEvidenceGallery renders images and statements correctly grouped', (WidgetTester tester) async {
    final evidence = [
      const DisputeEvidenceItem(
        type: 'image',
        content: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100',
        uploaderRole: UploaderRole.buyer,
        createdAt: '3 hours ago',
      ),
      const DisputeEvidenceItem(
        type: 'text',
        content: 'The package arrived completely open at the bottom.',
        uploaderRole: UploaderRole.buyer,
        createdAt: '3 hours ago',
      ),
      const DisputeEvidenceItem(
        type: 'text',
        content: 'I shipped this item in a double-sealed plastic bag.',
        uploaderRole: UploaderRole.seller,
        createdAt: '1 hour ago',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DisputeEvidenceGallery(evidence: evidence),
          ),
        ),
      ),
    );

    expect(find.text('Buyer Evidence'), findsOneWidget);
    expect(find.text('Seller Evidence'), findsOneWidget);

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('The package arrived completely open at the bottom.'), findsOneWidget);
    expect(find.text('I shipped this item in a double-sealed plastic bag.'), findsOneWidget);
  });
}
