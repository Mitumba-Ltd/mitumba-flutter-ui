import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('TwoFactorMethodList renders rows and popup menu', (WidgetTester tester) async {
    final methods = [
      const TwoFactorMethodView(
        id: '1',
        type: TwoFactorMethodType.totp,
        enabled: true,
        isPrimary: true,
        pending: false,
        lastUsedAt: '2 mins ago',
      ),
      const TwoFactorMethodView(
        id: '2',
        type: TwoFactorMethodType.sms,
        enabled: false,
        isPrimary: false,
        pending: true,
      ),
    ];

    bool addTapped = false;
    String? setPrimaryId;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TwoFactorMethodList(
            methods: methods,
            onAdd: () => addTapped = true,
            onEnable: (_) {},
            onDisable: (_) {},
            onDelete: (_) {},
            onSetPrimary: (id) => setPrimaryId = id,
          ),
        ),
      ),
    );

    // Verify header and items
    expect(find.text('Two-Factor Methods'), findsOneWidget);
    expect(find.text('Authenticator App'), findsOneWidget);
    expect(find.text('SMS'), findsOneWidget);

    // Chips
    expect(find.text('PRIMARY'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);

    // Tap Add method
    await tester.tap(find.text('Add method'));
    await tester.pump();
    expect(addTapped, isTrue);

    // Open options popup menu for the second method (sms)
    final menuButtons = find.byIcon(Icons.more_vert);
    expect(menuButtons, findsNWidgets(2));
    await tester.tap(menuButtons.at(1));
    await tester.pumpAndSettle();

    // Verify popup options
    expect(find.text('Enable'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
  });
}
