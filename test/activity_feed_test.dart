import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('ActivityFeed renders list events and timestamps', (WidgetTester tester) async {
    final events = [
      const ActivityEvent(
        id: '1',
        type: ActivityType.order,
        title: 'New Order Received',
        subtitle: 'Order #3829 contains 3 items.',
        timestamp: '5 min ago',
      ),
      const ActivityEvent(
        id: '2',
        type: ActivityType.payout,
        title: 'Payout Processed',
        timestamp: '1 hour ago',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityFeed(
            events: events,
          ),
        ),
      ),
    );

    expect(find.text('New Order Received'), findsOneWidget);
    expect(find.text('Order #3829 contains 3 items.'), findsOneWidget);
    expect(find.text('5 MIN AGO'), findsOneWidget);
    expect(find.text('Payout Processed'), findsOneWidget);
    expect(find.text('1 HOUR AGO'), findsOneWidget);
  });

  testWidgets('ActivityFeed renders empty message when events are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityFeed(
            events: [],
            emptyMessage: 'No updates right now',
          ),
        ),
      ),
    );

    expect(find.text('No updates right now'), findsOneWidget);
  });
}
