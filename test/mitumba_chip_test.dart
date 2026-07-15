import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  group('MitumbaChip', () {
    testWidgets('renders label uppercase correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaChip(label: 'Vintage')));
      await tester.pump();

      expect(find.text('VINTAGE'), findsOneWidget);
    });

    testWidgets('renders badge text when badge is provided', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaChip(label: 'Items', badge: 12)));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('renders custom avatar if provided', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaChip(
        label: 'User',
        avatar: Icon(Icons.person, key: Key('avatar_icon')),
      )));
      await tester.pump();

      expect(find.byKey(const Key('avatar_icon')), findsOneWidget);
    });

    testWidgets('calls onClick when tapped', (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(wrap(MitumbaChip(
        label: 'Tappable',
        onClick: () => clicked = true,
      )));
      await tester.pump();

      await tester.tap(find.text('TAPPABLE'));
      expect(clicked, true);
    });

    testWidgets('renders delete close icon and calls onDelete when tapped', (WidgetTester tester) async {
      bool deleted = false;
      await tester.pumpWidget(wrap(MitumbaChip(
        label: 'Delete Me',
        onDelete: () => deleted = true,
      )));
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, true);
    });

    testWidgets('does not trigger onClick or onDelete when disabled is true', (WidgetTester tester) async {
      bool clicked = false;
      bool deleted = false;
      await tester.pumpWidget(wrap(MitumbaChip(
        label: 'Disabled',
        disabled: true,
        onClick: () => clicked = true,
        onDelete: () => deleted = true,
      )));
      await tester.pump();

      await tester.tap(find.text('DISABLED'));
      expect(clicked, false);

      if (find.byIcon(Icons.close).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.close));
      }
      expect(deleted, false);
    });
  });
}
