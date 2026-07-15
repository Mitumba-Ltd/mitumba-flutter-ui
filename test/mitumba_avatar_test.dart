import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  group('MitumbaAvatar', () {
    testWidgets('renders initials correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(name: 'Isaac Stanley')));
      await tester.pump();

      expect(find.text('IS'), findsOneWidget);
    });

    testWidgets('renders fallback question mark when name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(name: '')));
      await tester.pump();

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders status dot when status is online', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(status: MitumbaAvatarStatus.online)));
      await tester.pump();

      // online status indicator is rendered in a container with success green color
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsNWidgets(2)); // avatar circle + status dot
    });

    testWidgets('renders selected checkmark tick overlay', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(selected: true)));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('renders notification badge count', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(notificationCount: 5)));
      await tester.pump();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('renders name and subtitle side-aligned', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const MitumbaAvatar(
        name: 'Isaac Stanley',
        subtitle: 'Seller',
        textAlignment: MitumbaAvatarTextAlignment.side,
      )));
      await tester.pump();

      expect(find.text('Isaac Stanley'), findsOneWidget);
      expect(find.text('Seller'), findsOneWidget);
    });

    testWidgets('calls onClick when clicked', (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(wrap(MitumbaAvatar(
        name: 'Isaac Stanley',
        onClick: () => clicked = true,
      )));
      await tester.pump();

      await tester.tap(find.text('IS'));
      expect(clicked, true);
    });
  });

  group('MitumbaAvatarGroup', () {
    final testChildren = [
      const MitumbaAvatar(name: 'Alice'),
      const MitumbaAvatar(name: 'Bob'),
      const MitumbaAvatar(name: 'Charlie'),
    ];

    testWidgets('renders stacked avatars up to max', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaAvatarGroup(
        max: 2,
        children: testChildren,
      )));
      await tester.pump();

      // Render 2 children + 1 overflow (+1)
      expect(find.text('AL'), findsOneWidget);
      expect(find.text('BO'), findsOneWidget);
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('CH'), findsNothing); // Charlie hidden in overflow
    });

    testWidgets('renders CTA add button if onAdd is provided', (WidgetTester tester) async {
      bool addClicked = false;
      await tester.pumpWidget(wrap(MitumbaAvatarGroup(
        children: testChildren,
        onAdd: () => addClicked = true,
      )));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      expect(addClicked, true);
    });
  });
}
