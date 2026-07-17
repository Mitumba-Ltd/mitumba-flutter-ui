import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('AddAddressModal validates, county selects, and saves', (WidgetTester tester) async {
    bool open = true;
    AddressFormData? savedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return AddAddressModal(
                open: open,
                onClose: () => setState(() => open = false),
                onSave: (data) => setState(() => savedData = data),
              );
            },
          ),
        ),
      ),
    );

    // Verify modal is open and shows fields
    expect(find.text('Add Delivery Address'), findsOneWidget);
    expect(find.text('LABEL'), findsOneWidget);
    expect(find.text('FULL NAME'), findsOneWidget);

    // Tap Save to trigger validations
    await tester.tap(find.text('Save Address'));
    await tester.pumpAndSettle();

    // Verify validation errors are displayed
    expect(find.text('Label is required'), findsOneWidget);
    expect(find.text('Full name is required'), findsOneWidget);

    // Fill form
    await tester.enterText(find.byType(TextField).at(0), 'Home');
    await tester.enterText(find.byType(TextField).at(1), 'Stan Blik');
    await tester.enterText(find.byType(TextField).at(2), '712345678');
    await tester.enterText(find.byType(TextField).at(3), 'Ngong Road');
    await tester.enterText(find.byType(TextField).at(4), 'Apt 4B');
    await tester.enterText(find.byType(TextField).at(5), 'Nairobi');
    await tester.pump();

    // Select county (MitumbaSelect opens a modal/sheet or drop list. Let's tap the Select field)
    await tester.ensureVisible(find.byType(MitumbaSelect));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(MitumbaSelect));
    await tester.pumpAndSettle();

    // Tap Bungoma in the dropdown options (visible at top of list)
    await tester.tap(find.text('Bungoma'));
    await tester.pumpAndSettle();

    // Save again
    await tester.tap(find.text('Save Address'));
    await tester.pumpAndSettle();

    expect(savedData, isNotNull);
    expect(savedData!.label, equals('Home'));
    expect(savedData!.fullName, equals('Stan Blik'));
    expect(savedData!.phone, equals('712345678'));
    expect(savedData!.county, equals('Bungoma'));
  });
}
