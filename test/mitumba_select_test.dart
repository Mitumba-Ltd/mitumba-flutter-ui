import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  final testOptions = [
    const MitumbaSelectOption(value: 'nbo', label: 'Nairobi', subtitle: 'Capital', group: 'Kenya'),
    const MitumbaSelectOption(value: 'msa', label: 'Mombasa', subtitle: 'Coastal', group: 'Kenya'),
    const MitumbaSelectOption(value: 'kla', label: 'Kampala', subtitle: 'Capital', group: 'Uganda'),
  ];

  group('MitumbaSelect', () {
    testWidgets('renders label and placeholder correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaSelect(
        label: 'Location',
        placeholder: 'Select a city',
        value: '',
        options: testOptions,
        onChange: (_) {},
      )));
      await tester.pump();

      expect(find.text('LOCATION'), findsOneWidget);
      expect(find.text('Select a city'), findsOneWidget);
    });

    testWidgets('renders selected option label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaSelect(
        value: 'nbo',
        options: testOptions,
        onChange: (_) {},
      )));
      await tester.pump();

      expect(find.text('Nairobi'), findsOneWidget);
    });

    testWidgets('opens bottom sheet on tap and displays options', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaSelect(
        value: '',
        placeholder: 'Select location',
        options: testOptions,
        onChange: (_) {},
      )));
      await tester.pump();

      // Tap select container to open picker sheet
      await tester.tap(find.text('Select location'));
      await tester.pumpAndSettle();

      // Verify options are displayed inside bottom sheet
      expect(find.text('Nairobi'), findsOneWidget);
      expect(find.text('Mombasa'), findsOneWidget);
      expect(find.text('Kampala'), findsOneWidget);

      // Verify group subheaders
      expect(find.text('KENYA'), findsOneWidget);
      expect(find.text('UGANDA'), findsOneWidget);
    });

    testWidgets('triggers onChange when option is tapped in single selection mode', (WidgetTester tester) async {
      dynamic selectedVal;
      await tester.pumpWidget(wrap(MitumbaSelect(
        value: '',
        placeholder: 'Select location',
        options: testOptions,
        onChange: (val) => selectedVal = val,
      )));
      await tester.pump();

      await tester.tap(find.text('Select location'));
      await tester.pumpAndSettle();

      // Tap Mombasa option
      await tester.tap(find.text('Mombasa'));
      await tester.pumpAndSettle(); // should close the picker sheet

      expect(selectedVal, 'msa');
      expect(find.text('Mombasa'), findsNothing); // modal closed
    });

    testWidgets('filters options when search term is entered', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaSelect(
        value: '',
        placeholder: 'Select location',
        options: testOptions,
        showSearch: true,
        onChange: (_) {},
      )));
      await tester.pump();

      await tester.tap(find.text('Select location'));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Mombasa');
      await tester.pump();

      expect(find.widgetWithText(InkWell, 'Mombasa'), findsOneWidget);
      expect(find.text('Nairobi'), findsNothing); // filtered out
      expect(find.text('Kampala'), findsNothing); // filtered out
    });

    testWidgets('supports multiple selection and done button callback', (WidgetTester tester) async {
      dynamic selectedVals;
      await tester.pumpWidget(wrap(MitumbaSelect(
        value: const ['nbo'],
        options: testOptions,
        multiple: true,
        onChange: (val) => selectedVals = val,
      )));
      await tester.pump();

      expect(find.text('Selected 1 items'), findsOneWidget);

      await tester.tap(find.text('Selected 1 items'));
      await tester.pumpAndSettle();

      // Tap Mombasa checkbox
      await tester.tap(find.text('Mombasa'));
      await tester.pump();

      // Tap done button
      await tester.tap(find.text('DONE'));
      await tester.pumpAndSettle();

      expect(selectedVals, isA<List>());
      expect(selectedVals, contains('nbo'));
      expect(selectedVals, contains('msa'));
    });
  });
}
