import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaImageUploader renders grids, covers, and triggers clicks', (WidgetTester tester) async {
    final images = [
      const UploadedImage(
        id: '1',
        url: 'https://example.com/img1.jpg',
        status: UploadedImageStatus.done,
        isPrimary: true,
      ),
      const UploadedImage(
        id: '2',
        url: 'https://example.com/img2.jpg',
        status: UploadedImageStatus.uploading,
        isPrimary: false,
      ),
    ];

    String? removedId;
    bool addTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MitumbaImageUploader(
            images: images,
            onAddTap: () => addTapped = true,
            onRemove: (id) => removedId = id,
          ),
        ),
      ),
    );

    // Verify empty slots are rendered (4 empty slots when max is 6 and images length is 2)
    expect(find.byIcon(Icons.add_a_photo_outlined), findsNWidgets(4));

    // Verify COVER badge on first item
    expect(find.text('COVER'), findsOneWidget);

    // Tap delete on the second image (id '2')
    // The close icon button is rendered inside the slot
    final closeButtons = find.byIcon(Icons.close);
    expect(closeButtons, findsNWidgets(2)); // image 1 and 2 both have close icons
    await tester.tap(closeButtons.at(1));
    await tester.pump();

    expect(removedId, equals('2'));

    // Tap on an empty slot to add
    // The 3rd slot is index 2, which is an InkWell containing Icons.add_a_photo_outlined
    await tester.tap(find.byIcon(Icons.add_a_photo_outlined).first);
    await tester.pump();
    expect(addTapped, isTrue);
  });
}
