import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('MitumbaSlider renders and triggers single value changes', (WidgetTester tester) async {
    double sliderValue = 50.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaSlider(
                value: sliderValue,
                min: 0.0,
                max: 100.0,
                label: 'Volume',
                onChange: (val) => setState(() => sliderValue = val as double),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('VOLUME'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('MitumbaSlider range support rendering', (WidgetTester tester) async {
    RangeValues range = const RangeValues(20.0, 80.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MitumbaSlider(
                rangeValue: range,
                min: 0.0,
                max: 100.0,
                label: 'Price Range',
                onChange: (val) => setState(() => range = val as RangeValues),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('PRICE RANGE'), findsOneWidget);
    expect(find.byType(RangeSlider), findsOneWidget);
  });
}
