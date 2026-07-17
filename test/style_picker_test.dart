import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('StylePicker renders header and options selection cards', (WidgetTester tester) async {
    String selectedId = 'light';

    final options = [
      const StylePickerOption(
        id: 'light',
        label: 'Light Mode',
        description: 'Clean light background.',
        preview: Text('Light Preview'),
      ),
      const StylePickerOption(
        id: 'dark',
        label: 'Dark Mode',
        description: 'Atmospheric dark surface.',
        preview: Text('Dark Preview'),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return StylePicker(
                title: 'Choose Theme',
                subtitle: 'Choose your visual preference',
                value: selectedId,
                options: options,
                onChange: (val) => setState(() => selectedId = val),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Choose Theme'), findsOneWidget);
    expect(find.text('Light Mode'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);

    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();

    expect(selectedId, 'dark');
  });
}
