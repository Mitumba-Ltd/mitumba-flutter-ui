import 'package:flutter/material.dart';
import '../foundation/mitumba_chip.dart';

/// Premium Delivery Status Badge matching Chip benchmark rules.
class DeliveryBadge extends StatelessWidget {
  const DeliveryBadge({
    super.key,
    required this.type,
    this.estimatedDays,
  });

  /// Delivery route category: 'same-city' | 'intercity'
  final String type;

  /// Custom label, e.g., "2-3 days"
  final String? estimatedDays;

  @override
  Widget build(BuildContext context) {
    final status = type == 'same-city'
        ? MitumbaChipStatus.active
        : MitumbaChipStatus.common;

    return MitumbaChip(
      label: estimatedDays ?? type,
      status: status,
      variant: MitumbaChipVariant.soft,
      size: 'small',
      icon: const Icon(Icons.local_shipping, size: 14),
    );
  }
}
