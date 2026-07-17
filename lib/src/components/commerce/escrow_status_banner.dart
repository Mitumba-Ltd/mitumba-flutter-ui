import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../feedback/mitumba_banner.dart';

enum EscrowStatus { funded, shipped, timeoutWarning, released, refunded }

/// Premium Escrow Status Banner displaying transaction states securely.
class EscrowStatusBanner extends StatelessWidget {
  const EscrowStatusBanner({
    super.key,
    required this.status,
    this.amountKes = 0,
    this.hoursRemaining,
  });

  final EscrowStatus status;
  final double amountKes;
  final int? hoursRemaining;

  @override
  Widget build(BuildContext context) {
    final formattedAmount = amountKes.toStringAsFixed(0);

    String title;
    String message;
    MitumbaBannerSeverity severity;
    Widget icon;

    switch (status) {
      case EscrowStatus.funded:
        severity = MitumbaBannerSeverity.info;
        icon = const Icon(Icons.security, color: MitumbaColors.info);
        title = 'Payment in Escrow';
        message = "KES $formattedAmount is securely held. We'll release it once you confirm delivery.";
        break;
      case EscrowStatus.shipped:
        severity = MitumbaBannerSeverity.info;
        icon = const Icon(Icons.local_shipping, color: MitumbaColors.info);
        title = 'Item Shipped';
        message = 'The seller has dispatched your item. Track your package and confirm receipt to release funds.';
        break;
      case EscrowStatus.timeoutWarning:
        severity = MitumbaBannerSeverity.warning;
        icon = const Icon(Icons.history, color: MitumbaColors.warning);
        title = 'Action Required';
        message = 'Only ${hoursRemaining ?? 24} hours left to confirm delivery before funds are automatically released.';
        break;
      case EscrowStatus.released:
        severity = MitumbaBannerSeverity.success;
        icon = const Icon(Icons.account_balance_wallet, color: MitumbaColors.green);
        title = 'Payment Released';
        message = 'Funds have been successfully transferred to the seller\'s wallet. Thank you for shopping!';
        break;
      case EscrowStatus.refunded:
        severity = MitumbaBannerSeverity.error;
        icon = const Icon(Icons.error_outline, color: MitumbaColors.error);
        title = 'Payment Refunded';
        message = 'The escrow has been cancelled and KES $formattedAmount has been returned to your wallet.';
        break;
    }

    return MitumbaBanner(
      title: title,
      message: message,
      severity: severity,
      icon: icon,
    );
  }
}
