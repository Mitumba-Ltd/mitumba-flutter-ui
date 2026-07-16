import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/profile_card.dart';
import 'package:mitumba_ui/src/components/foundation/mitumba_chip.dart';

void main() {
  testWidgets('ProfileCard renders initials when no avatar URL is provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileCard(
            name: 'Isaac Stanley',
            subtitle: 'Member since 2026',
          ),
        ),
      ),
    );

    expect(find.text('IS'), findsOneWidget);
    expect(find.text('Isaac Stanley'), findsOneWidget);
    expect(find.text('Member since 2026'), findsOneWidget);
  });

  testWidgets('ProfileCard renders roles as solid pill chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileCard(
            name: 'Jane Doe',
            roles: [
              ProfileCardRole(label: 'Seller', color: 'primary'),
              ProfileCardRole(label: 'Vazi Certified', color: 'secondary'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('SELLER'), findsOneWidget);
    expect(find.text('VAZI CERTIFIED'), findsOneWidget);

    final chipFinder = find.byType(MitumbaChip);
    expect(chipFinder, findsNWidgets(2));
  });

  testWidgets('ProfileCard renders action button and calls callback', (WidgetTester tester) async {
    bool actionFired = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileCard(
            name: 'Jane Doe',
            actionLabel: 'Edit Profile',
            onAction: () {
              actionFired = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Edit Profile'), findsOneWidget);
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    expect(actionFired, isTrue);
  });
}
