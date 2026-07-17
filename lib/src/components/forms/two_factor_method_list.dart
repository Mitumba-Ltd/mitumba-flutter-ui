import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../feedback/mitumba_skeleton.dart';
import '../foundation/mitumba_chip.dart';

enum TwoFactorMethodType { totp, sms, email, passkey }

class TwoFactorMethodView {
  const TwoFactorMethodView({
    required this.id,
    required this.type,
    this.label,
    required this.enabled,
    required this.isPrimary,
    required this.pending,
    this.lastUsedAt,
  });

  /// Method ID.
  final String id;

  /// Method type.
  final TwoFactorMethodType type;

  /// Custom label (falls back to type name if null).
  final String? label;

  /// Whether this method is enabled.
  final bool enabled;

  /// Whether this is the primary method.
  final bool isPrimary;

  /// Whether verification is still pending.
  final bool pending;

  /// Last used timestamp description.
  final String? lastUsedAt;
}

/// TwoFactorMethodList — displays and manages 2FA methods.
class TwoFactorMethodList extends StatelessWidget {
  const TwoFactorMethodList({
    super.key,
    required this.methods,
    this.loading = false,
    required this.onAdd,
    required this.onEnable,
    required this.onDisable,
    required this.onDelete,
    required this.onSetPrimary,
    this.onVerifyPending,
  });

  /// List of 2FA methods.
  final List<TwoFactorMethodView> methods;

  /// Loading state.
  final bool loading;

  /// Called to add a new method.
  final VoidCallback onAdd;

  /// Called to enable a method.
  final ValueChanged<String> onEnable;

  /// Called to disable a method.
  final ValueChanged<String> onDisable;

  /// Called to delete a method.
  final ValueChanged<String> onDelete;

  /// Called to set a method as primary.
  final ValueChanged<String> onSetPrimary;

  /// Called to resume verifying a pending method.
  final ValueChanged<String>? onVerifyPending;

  IconData _getTypeIcon(TwoFactorMethodType type) {
    switch (type) {
      case TwoFactorMethodType.totp:
        return Icons.qr_code_2;
      case TwoFactorMethodType.sms:
        return Icons.sms_outlined;
      case TwoFactorMethodType.email:
        return Icons.email_outlined;
      case TwoFactorMethodType.passkey:
        return Icons.fingerprint;
    }
  }

  String _getTypeLabel(TwoFactorMethodType type) {
    switch (type) {
      case TwoFactorMethodType.totp:
        return 'Authenticator App';
      case TwoFactorMethodType.sms:
        return 'SMS';
      case TwoFactorMethodType.email:
        return 'Email';
      case TwoFactorMethodType.passkey:
        return 'Passkey';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(2, (_) {
          return const Padding(
            padding: EdgeInsets.only(bottom: MitumbaSpacing.base),
            child: MitumbaSkeleton(
              height: 64,
              variant: MitumbaSkeletonVariant.rectangular,
            ),
          );
        }),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Two-Factor Methods',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeMd,
                fontWeight: FontWeight.w700,
                color: MitumbaColors.textPrimary,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 14),
              label: const Text(
                'Add method',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MitumbaColors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: MitumbaSpacing.lg),

        // Empty state
        if (methods.isEmpty)
          Container(
            padding: const EdgeInsets.all(MitumbaSpacing.xxl),
            decoration: BoxDecoration(
              color: MitumbaColors.background,
              borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            ),
            child: const Text(
              'No 2FA methods yet. Add one to protect your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                color: MitumbaColors.textSecondary,
              ),
            ),
          )
        else
          // Method rows
          Column(
            children: methods.map((method) => _buildMethodRow(context, method)).toList(),
          ),
      ],
    );
  }

  Widget _buildMethodRow(BuildContext context, TwoFactorMethodView method) {
    return Container(
      margin: const EdgeInsets.only(bottom: MitumbaSpacing.sm),
      padding: const EdgeInsets.all(MitumbaSpacing.base),
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        border: Border.all(color: MitumbaColors.divider),
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            _getTypeIcon(method.type),
            color: method.enabled ? MitumbaColors.green : MitumbaColors.textDisabled,
            size: 24,
          ),
          const SizedBox(width: 16),

          // Info text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.label ?? _getTypeLabel(method.type),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeSm,
                    fontWeight: FontWeight.w700,
                    color: MitumbaColors.textPrimary,
                  ),
                ),
                if (method.lastUsedAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Last used ${method.lastUsedAt}',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeXs,
                      color: MitumbaColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Status chips
          if (method.isPrimary)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: MitumbaChip(
                label: 'Primary',
                status: MitumbaChipStatus.active,
                size: 'small',
                variant: MitumbaChipVariant.solid,
                rounding: MitumbaChipRounding.pill,
              ),
            ),

          if (method.pending)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: MitumbaChip(
                label: 'Pending',
                status: MitumbaChipStatus.incomplete,
                size: 'small',
                variant: MitumbaChipVariant.solid,
                rounding: MitumbaChipRounding.pill,
                onClick: onVerifyPending != null ? () => onVerifyPending!(method.id) : null,
              ),
            ),

          if (!method.enabled && !method.pending)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: MitumbaChip(
                label: 'Off',
                status: MitumbaChipStatus.common,
                size: 'small',
                variant: MitumbaChipVariant.solid,
                rounding: MitumbaChipRounding.pill,
              ),
            ),

          // Overflow menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: MitumbaColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onSelected: (action) {
              if (action == 'setPrimary') onSetPrimary(method.id);
              if (action == 'enable') onEnable(method.id);
              if (action == 'disable') onDisable(method.id);
              if (action == 'delete') onDelete(method.id);
            },
            itemBuilder: (context) {
              return [
                if (!method.isPrimary && method.enabled)
                  PopupMenuItem(
                    value: 'setPrimary',
                    child: Row(
                      children: const [
                        Icon(Icons.star_outline, size: 16, color: MitumbaColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Set as primary', style: TextStyle(fontFamily: 'Nunito', fontSize: 13)),
                      ],
                    ),
                  ),
                if (method.enabled)
                  PopupMenuItem(
                    value: 'disable',
                    child: Row(
                      children: const [
                        Icon(Icons.toggle_off_outlined, size: 16, color: MitumbaColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Disable', style: TextStyle(fontFamily: 'Nunito', fontSize: 13)),
                      ],
                    ),
                  )
                else
                  PopupMenuItem(
                    value: 'enable',
                    child: Row(
                      children: const [
                        Icon(Icons.toggle_on_outlined, size: 16, color: MitumbaColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Enable', style: TextStyle(fontFamily: 'Nunito', fontSize: 13)),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, size: 16, color: MitumbaColors.error),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: MitumbaColors.error)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
