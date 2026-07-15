import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  group('MitumbaGlass', () {
    testWidgets('renders child content correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaGlass(
        child: Text('Glass Content', key: Key('child_text')),
      )));
      await tester.pump();

      expect(find.byKey(const Key('child_text')), findsOneWidget);
      expect(find.text('Glass Content'), findsOneWidget);
    });

    testWidgets('renders with custom rounding styles', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaGlass(
        rounding: MitumbaGlassRounding.huge,
        child: SizedBox(width: 50, height: 50),
      )));
      await tester.pump();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16.0)); // huge = xl = 16px
    });

    testWidgets('respects border flag', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaGlass(
        border: false,
        child: SizedBox(width: 50, height: 50),
      )));
      await tester.pump();

      final innerContainerFinder = find.byType(Container).at(2); // inside BackdropFilter
      final container = tester.widget<Container>(innerContainerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });
  });
}
