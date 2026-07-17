import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('STIBreakdownPanel renders score, indicators, and list of activities', (WidgetTester tester) async {
    const events = [
      STIEvent(
        type: 'positive',
        reason: 'Fast shipping on #2984',
        timestamp: '3 hours ago',
        pointsChange: 2,
      ),
      STIEvent(
        type: 'negative',
        reason: 'Late response on thread',
        timestamp: '1 day ago',
        pointsChange: 1,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: STIBreakdownPanel(
              score: 85,
              fulfillmentRate: 0.96,
              accuracyRate: 0.98,
              avgResponseHours: 1.5,
              daysActive: 140,
              recentEvents: events,
            ),
          ),
        ),
      ),
    );

    // Verify main components are present
    expect(find.text('Seller Trust Index'), findsOneWidget);
    expect(find.text('85'), findsOneWidget);
    expect(find.text('Trusted'), findsOneWidget);

    // Verify factors values
    expect(find.text('Order fulfillment'), findsOneWidget);
    expect(find.text('96%'), findsOneWidget);
    expect(find.text('Listing accuracy'), findsOneWidget);
    expect(find.text('98%'), findsOneWidget);
    expect(find.text('1.5h'), findsOneWidget);
    expect(find.text('140'), findsOneWidget);

    // Verify recent activity list
    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Fast shipping on #2984'), findsOneWidget);
    expect(find.text('+2'), findsOneWidget);
    expect(find.text('Late response on thread'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
