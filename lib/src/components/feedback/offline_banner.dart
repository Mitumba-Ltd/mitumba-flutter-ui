import 'package:flutter/material.dart';
import '../../tokens/radius.dart';
import 'mitumba_banner.dart';
import '../foundation/mitumba_primary_button.dart';

/// Premium Offline Status Banner.
/// Automatically detects and responds to connection changes when managed,
/// and displays as a passive alert warning banner with a custom retry callback.
class MitumbaOfflineBanner extends StatelessWidget {
  const MitumbaOfflineBanner({
    super.key,
    required this.isOffline,
    this.onRetry,
  });

  /// Whether the device is currently offline.
  final bool isOffline;

  /// Called when the retry button is clicked.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return MitumbaBanner(
      severity: MitumbaBannerSeverity.warning,
      title: 'You are currently offline',
      icon: const Icon(Icons.wifi_off, color: Colors.orange),
      message: 'Please check your internet connection to continue browsing the marketplace.',
      action: onRetry != null
          ? MitumbaPrimaryButton(
              label: 'Retry',
              size: ButtonSize.small,
              variant: ButtonVariant.outline,
              onPressed: onRetry!,
            )
          : null,
    );
  }
}
