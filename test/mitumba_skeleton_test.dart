import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/feedback/mitumba_skeleton.dart';

void main() {
  testWidgets('MitumbaSkeleton renders with correct dimensions and semantics', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: MitumbaSkeleton(
              width: 200,
              height: 40,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MitumbaSkeleton), findsOneWidget);

    final RenderBox renderBox = tester.renderObject(find.byType(MitumbaSkeleton));
    expect(renderBox.size.width, equals(200.0));
    expect(renderBox.size.height, equals(40.0));
  });
}
