import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/navigation/top_nav.dart';
import 'package:mitumba_ui/src/components/foundation/mitumba_avatar.dart';

void main() {
  testWidgets('TopNav renders announcement, logo, navigation links, and search bar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    String searchSubmitted = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: TopNav(
            announcement: const Text('Free delivery on orders above KES 5,000!'),
            links: const [
              TopNavLink(label: 'Home', href: '/', active: true),
              TopNavLink(label: 'Shop', href: '/shop'),
            ],
            onSearchSubmit: (q) {
              searchSubmitted = q;
            },
          ),
        ),
      ),
    );

    expect(find.text('Free delivery on orders above KES 5,000!'), findsOneWidget);
    expect(find.text('MITUMBA'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);

    // Enter search text and submit
    await tester.enterText(find.byType(TextField), 'vintage jacket');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(searchSubmitted, equals('vintage jacket'));

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('TopNav responsive hiding at mobile viewport width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(
          appBar: TopNav(
            links: [
              TopNavLink(label: 'Home', href: '/'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsNothing); // Hidden on mobile
    expect(find.byType(TextField), findsNothing); // Hidden on mobile

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('TopNav cart count and auth click trigger handlers', (WidgetTester tester) async {
    bool authClicked = false;
    bool cartClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: TopNav(
            cartCount: 3,
            onCartClick: () {
              cartClicked = true;
            },
            onAuthClick: () {
              authClicked = true;
            },
          ),
        ),
      ),
    );

    // Cart badge count
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();
    expect(cartClicked, isTrue);

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(authClicked, isTrue);
  });

  testWidgets('TopNav renders profile avatar when authenticated', (WidgetTester tester) async {
    bool profileClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: TopNav(
            isAuthenticated: true,
            user: const TopNavUser(name: 'Isaac Stanley'),
            onProfileClick: () {
              profileClicked = true;
            },
          ),
        ),
      ),
    );

    expect(find.byType(MitumbaAvatar), findsOneWidget);

    await tester.tap(find.byType(MitumbaAvatar));
    await tester.pumpAndSettle();
    expect(profileClicked, isTrue);
  });
}
