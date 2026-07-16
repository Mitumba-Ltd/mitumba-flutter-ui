import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/mitumba_divider.dart';
import 'package:mitumba_ui/src/tokens/colors.dart';

void main() {
  testWidgets('MitumbaDivider renders horizontal divider by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MitumbaDivider(),
        ),
      ),
    );

    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);

    final Divider divider = tester.widget(find.byType(Divider));
    expect(divider.color, equals(MitumbaColors.divider));
    expect(divider.thickness, equals(1.0));
  });

  testWidgets('MitumbaDivider renders vertical divider with custom styling', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MitumbaDivider(
            orientation: MitumbaDividerOrientation.vertical,
            thickness: 2.0,
            color: Colors.red,
          ),
        ),
      ),
    );

    expect(find.byType(VerticalDivider), findsOneWidget);
    expect(find.byType(Divider), findsNothing);

    final VerticalDivider divider = tester.widget(find.byType(VerticalDivider));
    expect(divider.color, equals(Colors.red));
    expect(divider.thickness, equals(2.0));
  });
}
