import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/profile_nav_list.dart';

void main() {
  testWidgets('ProfileNavList renders items, icons, and chevrons', (WidgetTester tester) async {
    bool itemClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileNavList(
            items: [
              ProfileNavItem(
                label: 'My Orders',
                icon: const Icon(Icons.shopping_bag_outlined),
                onClick: () {
                  itemClicked = true;
                },
              ),
              const ProfileNavItem(
                label: 'Static Item',
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('My Orders'), findsOneWidget);
    expect(find.text('Static Item'), findsOneWidget);

    // Chevron should be present only on clickable items
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    // Click trigger check
    await tester.tap(find.text('My Orders'));
    await tester.pumpAndSettle();

    expect(itemClicked, isTrue);
  });

  testWidgets('ProfileNavList renders item badges when count > 0', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileNavList(
            items: [
              ProfileNavItem(
                label: 'Inbox Messages',
                icon: Icon(Icons.mail_outline),
                badge: 4,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('4'), findsOneWidget);
  });
}
