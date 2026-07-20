import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('SellerOnboardingPage wizard flow simulation', (WidgetTester tester) async {
    // Configure mobile screen size
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SellerOnboardingData? completedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SellerOnboardingPage(
            currentStep: 0,
            onComplete: (data) => completedData = data,
          ),
        ),
      ),
    );

    // Step 0: Welcome
    expect(find.text('Start selling on Mitumba'), findsWidgets);
    expect(find.text("Let's get started"), findsOneWidget);

    await tester.tap(find.text("Let's get started"));
    await tester.pumpAndSettle();

    // Step 1: Identity
    expect(find.text('Your identity'), findsOneWidget);

    // Enter values into TextFields
    final textFieldsStep1 = find.byType(TextField);
    await tester.enterText(textFieldsStep1.at(0), 'Nairobi Seller');
    await tester.enterText(textFieldsStep1.at(1), '0711223344');
    await tester.enterText(textFieldsStep1.at(2), '12345678');
    await tester.pumpAndSettle();

    // Choose County
    final dropdownFinder = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Baringo').last);
    await tester.pumpAndSettle();

    // Tap Continue
    final continueFinder = find.text('Continue');
    await tester.ensureVisible(continueFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    // Step 2: Business
    expect(find.text('Your business'), findsOneWidget);
    await tester.ensureVisible(continueFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    // Step 3: What you sell
    expect(find.text('What you sell'), findsOneWidget);
    // Select categories & grades
    final categoryFinder = find.text("Women's Wear");
    await tester.ensureVisible(categoryFinder);
    await tester.pumpAndSettle();
    await tester.tap(categoryFinder);

    final gradeFinder = find.text('Grade A — Like new');
    await tester.ensureVisible(gradeFinder);
    await tester.pumpAndSettle();
    await tester.tap(gradeFinder);

    await tester.ensureVisible(continueFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    // Step 4: Store
    expect(find.text('Your store'), findsOneWidget);
    final textFieldsStep4 = find.byType(TextField);
    await tester.enterText(textFieldsStep4.at(0), 'Nairobi Kicks');
    await tester.pumpAndSettle();

    final finishFinder = find.text('Finish setup');
    await tester.ensureVisible(finishFinder);
    await tester.pumpAndSettle();
    await tester.tap(finishFinder);
    await tester.pumpAndSettle();

    // Step 5: Confirmation
    expect(find.text("You're all set!"), findsOneWidget);
    final startListingFinder = find.text('Start listing my items →');
    await tester.ensureVisible(startListingFinder);
    await tester.pumpAndSettle();
    await tester.tap(startListingFinder);
    await tester.pumpAndSettle();

    expect(completedData, isNotNull);
    expect(completedData!.storeName, equals('Nairobi Kicks'));
    expect(completedData!.fullName, equals('Nairobi Seller'));
  });
}
