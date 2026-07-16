import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/page_container.dart';
import 'package:mitumba_ui/src/tokens/spacing.dart';

void main() {
  testWidgets('PageContainer renders child and respects max width constraints', (WidgetTester tester) async {
    // Set screen size to 1920x1080 (very wide)
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageContainer(
            maxWidth: PageContainerMaxWidth.sm, // 640.0
            child: SizedBox(
              height: 100,
              child: Text('Content'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Content'), findsOneWidget);

    final containerFinder = find.byType(Container);
    final RenderBox renderBox = tester.renderObject(containerFinder);
    
    // Width should be constrained to 640.0
    expect(renderBox.size.width, equals(640.0));

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('PageContainer applies correct responsive padding', (WidgetTester tester) async {
    // Small viewport (xs) - < 600 width
    tester.view.physicalSize = const Size(480, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageContainer(
            child: SizedBox(height: 100),
          ),
        ),
      ),
    );

    final Container container = tester.widget(find.byType(Container));
    final EdgeInsets padding = container.padding as EdgeInsets;
    expect(padding.left, equals(MitumbaSpacing.base)); // 12.0

    // Medium viewport (md) - 800 width (>= 600, < 1200)
    tester.view.physicalSize = const Size(800, 1000);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageContainer(
            child: SizedBox(height: 100),
          ),
        ),
      ),
    );

    final Container containerMd = tester.widget(find.byType(Container));
    final EdgeInsets paddingMd = containerMd.padding as EdgeInsets;
    expect(paddingMd.left, equals(MitumbaSpacing.lg)); // 16.0

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('PageContainer removes padding when noPadding is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageContainer(
            noPadding: true,
            child: SizedBox(height: 100),
          ),
        ),
      ),
    );

    final Container container = tester.widget(find.byType(Container));
    final EdgeInsets padding = container.padding as EdgeInsets;
    expect(padding.left, equals(0.0));
  });
}
