import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('MobileBottomNav', () {
    testWidgets('renders all default items', (tester) async {
      await tester.pumpWidget(wrap(
        MobileBottomNav(activeTab: 'home', onTabChange: (_) {}),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('VAZI'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('calls onTabChange with correct id', (tester) async {
      String? tapped;
      await tester.pumpWidget(wrap(
        MobileBottomNav(activeTab: 'home', onTabChange: (id) => tapped = id),
      ));

      await tester.tap(find.text('Search'));
      expect(tapped, 'search');
    });

    testWidgets('renders all 6 variants without error', (tester) async {
      for (final variant in BottomNavVariant.values) {
        await tester.pumpWidget(wrap(
          MobileBottomNav(activeTab: 'home', onTabChange: (_) {}, variant: variant),
        ));
        expect(find.text('Home'), findsOneWidget);
      }
    });

    testWidgets('supports custom items', (tester) async {
      const items = [
        MobileBottomNavItem(id: 'a', label: 'Alpha', icon: Icons.star),
        MobileBottomNavItem(id: 'b', label: 'Beta', icon: Icons.circle),
      ];
      await tester.pumpWidget(wrap(
        MobileBottomNav(activeTab: 'a', onTabChange: (_) {}, items: items),
      ));

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('indicator variant shows active icon', (tester) async {
      await tester.pumpWidget(wrap(
        MobileBottomNav(activeTab: 'home', onTabChange: (_) {}),
      ));

      // Active = filled home icon
      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });
}
