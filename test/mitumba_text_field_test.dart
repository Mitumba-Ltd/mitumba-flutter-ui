import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  group('MitumbaTextField', () {
    testWidgets('renders label and placeholder hint correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaTextField(
        label: 'Username',
        hint: 'Enter your username',
        value: '',
        onChange: (_) {},
      )));
      await tester.pump();

      expect(find.text('USERNAME'), findsOneWidget);
      expect(find.text('Enter your username'), findsOneWidget);
    });

    testWidgets('calls onChange when user types text', (WidgetTester tester) async {
      String typedText = '';
      await tester.pumpWidget(wrap(MitumbaTextField(
        hint: 'Type here',
        value: '',
        onChange: (val) => typedText = val,
      )));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'hello');
      expect(typedText, 'hello');
    });

    testWidgets('renders helper and error text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaTextField(
        hint: 'Hint',
        value: '',
        onChange: (_) {},
        helperText: 'Supporting text',
        error: 'Error message',
      )));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
      expect(find.text('Supporting text'), findsNothing); // error overrides helper
    });

    testWidgets('renders prefix and suffix widgets when provided', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaTextField(
        hint: 'Hint',
        value: '',
        onChange: (_) {},
        prefix: const Icon(Icons.search, key: Key('prefix_icon')),
        suffix: const Icon(Icons.clear, key: Key('suffix_icon')),
      )));
      await tester.pump();

      expect(find.byKey(const Key('prefix_icon')), findsOneWidget);
      expect(find.byKey(const Key('suffix_icon')), findsOneWidget);
    });

    testWidgets('obscures text and toggles visibility in password mode', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MitumbaTextField(
        hint: 'Password',
        value: 'secret123',
        onChange: (_) {},
        obscureText: true,
      )));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);

      // Tap password toggle eye icon
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      final textFieldUpdated = tester.widget<TextField>(find.byType(TextField));
      expect(textFieldUpdated.obscureText, false);
    });

    testWidgets('renders integrated endButton correctly', (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(wrap(MitumbaTextField(
        hint: 'Search',
        value: '',
        onChange: (_) {},
        endButton: TextButton(
          onPressed: () => clicked = true,
          child: const Text('GO'),
        ),
      )));
      await tester.pump();

      expect(find.text('GO'), findsOneWidget);
      await tester.tap(find.text('GO'));
      expect(clicked, true);
    });
  });
}
