import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../feedback/mitumba_modal.dart';
import '../foundation/mitumba_primary_button.dart';
import '../foundation/mitumba_text_field.dart';

/// Destructive action confirmation dialog.
class DestructiveConfirmDialog extends StatefulWidget {
  const DestructiveConfirmDialog({
    super.key,
    required this.open,
    required this.onClose,
    required this.title,
    required this.description,
    this.blockers = const [],
    this.confirmPhrase,
    this.requireTotp = false,
    required this.onConfirm,
    this.submitting = false,
    this.confirmLabel = 'Delete',
  });

  /// Whether the dialog is open.
  final bool open;

  /// Close handler.
  final VoidCallback onClose;

  /// Dialog title (e.g. "Delete this store").
  final String title;

  /// Irreversible warning description.
  final String description;

  /// Blocker reasons. If non-empty, confirmation is blocked.
  final List<String> blockers;

  /// Required exact phrase user must type to confirm.
  final String? confirmPhrase;

  /// Whether a 6-digit TOTP code is required.
  final bool requireTotp;

  /// Called when user confirms.
  final Future<void> Function({String? code}) onConfirm;

  /// Whether action is currently submitting.
  final bool submitting;

  /// Label for confirm button.
  final String confirmLabel;

  @override
  State<DestructiveConfirmDialog> createState() => _DestructiveConfirmDialogState();
}

class _DestructiveConfirmDialogState extends State<DestructiveConfirmDialog> {
  String _phrase = '';
  String _code = '';

  @override
  void didUpdateWidget(covariant DestructiveConfirmDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.open && oldWidget.open) {
      // Reset inputs when closed
      setState(() {
        _phrase = '';
        _code = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final hasBlockers = widget.blockers.isNotEmpty;
    final phraseMatch = widget.confirmPhrase == null || _phrase == widget.confirmPhrase;
    final codeValid = !widget.requireTotp || _code.replaceAll(RegExp(r'\s'), '').length == 6;
    final canConfirm = !hasBlockers && phraseMatch && codeValid && !widget.submitting;

    final actions = Row(
      children: [
        Expanded(
          child: MitumbaPrimaryButton(
            label: 'Cancel',
            variant: ButtonVariant.outline,
            disabled: widget.submitting,
            onPressed: widget.onClose,
            fullWidth: true,
          ),
        ),
        const SizedBox(width: MitumbaSpacing.base),
        Expanded(
          child: MitumbaPrimaryButton(
            label: widget.confirmLabel,
            variant: ButtonVariant.danger,
            disabled: !canConfirm,
            loading: widget.submitting,
            onPressed: () {
              if (canConfirm) {
                widget.onConfirm(
                  code: widget.requireTotp ? _code.replaceAll(RegExp(r'\s'), '') : null,
                );
              }
            },
            fullWidth: true,
          ),
        ),
      ],
    );

    return MitumbaModal(
      title: widget.title,
      onClose: widget.onClose,
      actions: actions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Warning description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                color: MitumbaColors.error,
                size: 24,
              ),
              const SizedBox(width: MitumbaSpacing.base),
              Expanded(
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeSm,
                    color: MitumbaColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          // Blockers
          if (hasBlockers) ...[
            const SizedBox(height: MitumbaSpacing.lg),
            Container(
              padding: const EdgeInsets.all(MitumbaSpacing.base),
              decoration: BoxDecoration(
                color: MitumbaColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
                border: Border.all(color: MitumbaColors.error.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You must resolve these first:',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeSm,
                      fontWeight: FontWeight.w700,
                      color: MitumbaColors.error,
                    ),
                  ),
                  const SizedBox(height: MitumbaSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.blockers.map((b) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: MitumbaColors.textPrimary)),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: MitumbaTypography.fontSizeSm,
                                  color: MitumbaColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          // Confirm phrase input
          if (widget.confirmPhrase != null && !hasBlockers) ...[
            const SizedBox(height: MitumbaSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeSm,
                      color: MitumbaColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Type '),
                      TextSpan(
                        text: widget.confirmPhrase!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' to confirm:'),
                    ],
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xs),
                MitumbaTextField(
                  hint: widget.confirmPhrase!,
                  value: _phrase,
                  onChange: (val) {
                    setState(() {
                      _phrase = val;
                    });
                  },
                ),
              ],
            ),
          ],

          // TOTP input
          if (widget.requireTotp && !hasBlockers) ...[
            const SizedBox(height: MitumbaSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your 6-digit authentication code:',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeSm,
                    color: MitumbaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xs),
                TextField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      _code = val.replaceAll(RegExp(r'\D'), '');
                    });
                  },
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: MitumbaTypography.fontSizeMd,
                    letterSpacing: 8.0,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '000000',
                    hintStyle: const TextStyle(
                      fontFamily: 'monospace',
                      letterSpacing: 8.0,
                      color: MitumbaColors.textDisabled,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                      borderSide: const BorderSide(color: MitumbaColors.green),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
