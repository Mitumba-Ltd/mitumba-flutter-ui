import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../feedback/mitumba_modal.dart';
import '../foundation/mitumba_chip.dart';
import 'two_factor_method_list.dart'; // Reuse TwoFactorMethodType

class AddTwoFactorMethodModal extends StatelessWidget {
  const AddTwoFactorMethodModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.availableTypes,
    required this.onSelectType,
  });

  /// Whether the modal is open.
  final bool open;

  /// Close callback.
  final VoidCallback onClose;

  /// List of types currently available to add.
  final List<TwoFactorMethodType> availableTypes;

  /// Callback fired when the user selects an option.
  final ValueChanged<TwoFactorMethodType> onSelectType;

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

  String _getTypeTitle(TwoFactorMethodType type) {
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

  String _getTypeDescription(TwoFactorMethodType type) {
    switch (type) {
      case TwoFactorMethodType.totp:
        return 'Use Google Authenticator, Authy, 1Password, or similar';
      case TwoFactorMethodType.sms:
        return 'Get a code by text message';
      case TwoFactorMethodType.email:
        return 'Get a code by email';
      case TwoFactorMethodType.passkey:
        return 'Face ID, Touch ID, or a security key';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!open) return const SizedBox.shrink();

    return MitumbaModal(
      title: 'Add 2FA Method',
      subtitle: 'Choose how you want to verify your identity',
      onClose: onClose,
      child: Column(
        children: TwoFactorMethodType.values.map((type) {
          final isAvailable = availableTypes.contains(type);
          final title = _getTypeTitle(type);
          final desc = _getTypeDescription(type);
          final icon = _getTypeIcon(type);

          return Padding(
            padding: const EdgeInsets.only(bottom: MitumbaSpacing.md),
            child: InkWell(
              onTap: isAvailable ? () => onSelectType(type) : null,
              borderRadius: BorderRadius.circular(MitumbaRadius.lg),
              child: Opacity(
                opacity: isAvailable ? 1.0 : 0.5,
                child: Container(
                  padding: const EdgeInsets.all(MitumbaSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                    border: Border.all(color: MitumbaColors.divider),
                    color: MitumbaColors.surface,
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Icon(
                        icon,
                        color: isAvailable ? MitumbaColors.green : MitumbaColors.textDisabled,
                        size: 28,
                      ),
                      const SizedBox(width: 16),

                      // Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: MitumbaTypography.fontSizeBase,
                                    fontWeight: FontWeight.w700,
                                    color: MitumbaColors.textPrimary,
                                  ),
                                ),
                                 if (type == TwoFactorMethodType.totp) ...[
                                  const SizedBox(width: 8),
                                  const MitumbaChip(
                                    label: 'Recommended',
                                    status: MitumbaChipStatus.success,
                                    size: 'small',
                                    variant: MitumbaChipVariant.solid,
                                    rounding: MitumbaChipRounding.pill,
                                  ),
                                ],
                                if (type == TwoFactorMethodType.passkey) ...[
                                  const SizedBox(width: 8),
                                  const MitumbaChip(
                                    label: 'Strongest',
                                    status: MitumbaChipStatus.special,
                                    size: 'small',
                                    variant: MitumbaChipVariant.solid,
                                    rounding: MitumbaChipRounding.pill,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: MitumbaTypography.fontSizeXs,
                                color: MitumbaColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
