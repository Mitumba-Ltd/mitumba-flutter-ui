import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/vazi/vazi_badge.dart';

void main() {
  testWidgets('VAZIBadge renders with correct texts and icons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: VAZIBadge(size: VAZIBadgeSize.medium),
          ),
        ),
      ),
    );

    expect(find.text('VAZI'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
  });
}
