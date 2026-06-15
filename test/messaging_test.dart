import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

const _conversations = [
  Conversation(id: 'c1', partnerId: 'p1', partnerName: 'Mama Njeri', lastMessage: 'Is it still available?', lastMessageAt: '2m', unread: true),
  Conversation(id: 'c2', partnerId: 'p2', partnerName: 'John', lastMessage: 'Thanks!', lastMessageAt: '1h'),
];

const _messages = [
  ChatMessage(body: 'Hello!', timestamp: '10:00', isMine: false, senderName: 'Mama Njeri'),
  ChatMessage(body: 'Hi, is the jacket available?', timestamp: '10:01', isMine: true),
];

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('ConversationList', () {
    testWidgets('renders conversations', (tester) async {
      await tester.pumpWidget(wrap(
        ConversationList(conversations: _conversations, onSelect: (_) {}),
      ));

      expect(find.text('Mama Njeri'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Is it still available?'), findsOneWidget);
    });

    testWidgets('calls onSelect when tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(wrap(
        ConversationList(conversations: _conversations, onSelect: (id) => selected = id),
      ));

      await tester.tap(find.text('Mama Njeri'));
      expect(selected, 'c1');
    });
  });

  group('ChatThread', () {
    testWidgets('renders messages and partner name', (tester) async {
      await tester.pumpWidget(wrap(
        ChatThread(messages: _messages, partnerName: 'Mama Njeri', onSend: (_) {}),
      ));

      expect(find.text('Mama Njeri'), findsOneWidget);
      expect(find.text('Hello!'), findsOneWidget);
      expect(find.text('Hi, is the jacket available?'), findsOneWidget);
    });

    testWidgets('calls onSend when send button tapped', (tester) async {
      String? sent;
      await tester.pumpWidget(wrap(
        ChatThread(messages: _messages, partnerName: 'Test', onSend: (msg) => sent = msg),
      ));

      await tester.enterText(find.byType(TextField), 'Hey');
      await tester.tap(find.byIcon(Icons.send));
      expect(sent, 'Hey');
    });
  });

  group('InboxLayout', () {
    testWidgets('shows conversation list on narrow viewport', (tester) async {
      await tester.pumpWidget(wrap(
        SizedBox(
          width: 400,
          child: InboxLayout(
            conversationList: const Text('LIST'),
            chatThread: const Text('THREAD'),
          ),
        ),
      ));

      expect(find.text('LIST'), findsOneWidget);
    });
  });
}
