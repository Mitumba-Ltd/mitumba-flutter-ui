import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  group('BuyerOnboardingPage', () {
    testWidgets('renders heading and all fields', (tester) async {
      await tester.pumpWidget(wrap(BuyerOnboardingPage(onComplete: (_) {})));

      expect(find.text('Welcome to Mitumba'), findsOneWidget);
      expect(find.text('Display name'), findsOneWidget);
      expect(find.text('County'), findsOneWidget);
      expect(find.text('Phone number'), findsOneWidget);
    });

    testWidgets('continue button disabled when fields empty', (tester) async {
      await tester.pumpWidget(wrap(BuyerOnboardingPage(onComplete: (_) {})));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('calls onComplete with data when valid', (tester) async {
      BuyerOnboardingData? result;
      await tester.pumpWidget(wrap(BuyerOnboardingPage(
        onComplete: (d) => result = d,
        counties: const ['Nairobi', 'Mombasa'],
      )));

      await tester.enterText(find.widgetWithText(TextField, 'Display name'), 'Amina K.');
      await tester.enterText(find.widgetWithText(TextField, 'Phone number'), '712345678');

      // Select county from dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nairobi').last);
      await tester.pumpAndSettle();

      // Now submit
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.displayName, 'Amina K.');
      expect(result!.county, 'Nairobi');
      expect(result!.phone, '712345678');
    });

    testWidgets('shows error message when provided', (tester) async {
      await tester.pumpWidget(wrap(BuyerOnboardingPage(
        onComplete: (_) {},
        error: 'Something went wrong',
      )));

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows loading text on button', (tester) async {
      await tester.pumpWidget(wrap(BuyerOnboardingPage(
        onComplete: (_) {},
        loading: true,
      )));

      expect(find.text('Setting up...'), findsOneWidget);
    });
  });
}
