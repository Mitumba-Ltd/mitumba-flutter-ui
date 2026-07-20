import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('FloatingChatDock renders correctly on desktop and responds to actions', (WidgetTester tester) async {
    // Desktop layout
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool minimizeToggled = false;
    bool closeTapped = false;
    bool backTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingChatDock(
                open: true,
                title: 'Nairobi Thrift',
                subtitle: 'Active now',
                minimized: false,
                onToggleMinimize: () => minimizeToggled = true,
                onClose: () => closeTapped = true,
                onBack: () => backTapped = true,
                unreadCount: 3,
                children: const SizedBox(
                  height: 200,
                  child: Text('Chat messages'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Verify presence of title, subtitle, and children
    expect(find.text('Nairobi Thrift'), findsOneWidget);
    expect(find.text('Active now'), findsOneWidget);
    expect(find.text('Chat messages'), findsOneWidget);

    // Tap minimize button
    final minimizeFinder = find.byIcon(Icons.remove);
    expect(minimizeFinder, findsOneWidget);
    await tester.tap(minimizeFinder);
    await tester.pumpAndSettle();
    expect(minimizeToggled, isTrue);

    // Tap close button
    final closeFinder = find.byIcon(Icons.close);
    expect(closeFinder, findsOneWidget);
    await tester.tap(closeFinder);
    await tester.pumpAndSettle();
    expect(closeTapped, isTrue);

    // Tap back button
    final backFinder = find.byIcon(Icons.chevron_left);
    expect(backFinder, findsOneWidget);
    await tester.tap(backFinder);
    await tester.pumpAndSettle();
    expect(backTapped, isTrue);
  });

  testWidgets('FloatingChatDock does not render on mobile viewports', (WidgetTester tester) async {
    // Mobile layout
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingChatDock(
                open: true,
                title: 'Nairobi Thrift',
                minimized: false,
                onToggleMinimize: () {},
                onClose: () {},
                children: const Text('Chat messages'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Nairobi Thrift'), findsNothing);
  });

  testWidgets('FloatingChatDock shows unread count badge when minimized', (WidgetTester tester) async {
    // Desktop layout
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingChatDock(
                open: true,
                title: 'Nairobi Thrift',
                minimized: true,
                unreadCount: 5,
                onToggleMinimize: () {},
                onClose: () {},
                children: const Text('Chat messages'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Nairobi Thrift'), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // Badge unread count
  });
}
