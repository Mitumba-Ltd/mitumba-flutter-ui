import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  testWidgets('EscrowStatusBanner renders status messages correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              EscrowStatusBanner(
                status: EscrowStatus.funded,
                amountKes: 5200,
              ),
              EscrowStatusBanner(
                status: EscrowStatus.timeoutWarning,
                hoursRemaining: 18,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Payment in Escrow'), findsOneWidget);
    expect(find.text("KES 5200 is securely held. We'll release it once you confirm delivery."), findsOneWidget);
    expect(find.byIcon(Icons.security), findsOneWidget);

    expect(find.text('Action Required'), findsOneWidget);
    expect(find.text('Only 18 hours left to confirm delivery before funds are automatically released.'), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
