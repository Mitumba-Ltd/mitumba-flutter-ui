import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/src/components/layout/mitumba_grid.dart';

void main() {
  testWidgets('MitumbaGrid renders children and computes item widths based on columns', (WidgetTester tester) async {
    // Set viewport width to 1000 (md breakpoint, columns.md = 8, gap = 16)
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 1000,
              child: MitumbaGrid(
                children: List.generate(8, (index) => SizedBox(height: 50, child: Text('Item $index'))),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 7'), findsOneWidget);

    final itemFinder = find.text('Item 0');
    final RenderBox renderBox = tester.renderObject(itemFinder);
    
    // Available width = 1000.
    // md columns = 8.
    // md gap = 16.
    // Total gap width = 7 * 16 = 112.
    // Item width = (1000 - 112) / 8 = 888 / 8 = 111.0.
    expect(renderBox.size.width, equals(111.0));

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
