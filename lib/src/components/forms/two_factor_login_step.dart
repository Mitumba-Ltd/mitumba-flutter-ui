import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

enum TwoFactorLoginMethodType { totp, sms, email, passkey }

class TwoFactorLoginMethod {
  const TwoFactorLoginMethod({
    required this.id,
    required this.type,
    this.label,
  });

  final String id;
  final TwoFactorLoginMethodType type;
  final String? label;
}

/// TwoFactorLoginStep — standalone centered view for 2FA verification during login.
/// Supports method chooser when account has multiple enabled methods.
class TwoFactorLoginStep extends StatefulWidget {
  const TwoFactorLoginStep({
    super.key,
    required this.onSubmit,
    this.loading = false,
    this.error,
    this.onUseBackupCode,
    this.methods,
    this.activeMethodId,
    this.onMethodChange,
    this.onSendCode,
    this.onUsePasskey,
  });

  final ValueChanged<String> onSubmit;
  final bool loading;
  final String? error;
  final VoidCallback? onUseBackupCode;
  final List<TwoFactorLoginMethod>? methods;
  final String? activeMethodId;
  final ValueChanged<String>? onMethodChange;
  final ValueChanged<String>? onSendCode;
  final ValueChanged<String>? onUsePasskey;

  @override
  State<TwoFactorLoginStep> createState() => _TwoFactorLoginStepState();
}

class _TwoFactorLoginStepState extends State<TwoFactorLoginStep> {
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  TwoFactorLoginMethod? get _activeMethod {
    if (widget.methods == null || widget.methods!.isEmpty) return null;
    if (widget.activeMethodId != null) {
      return widget.methods!.firstWhere(
        (m) => m.id == widget.activeMethodId,
        orElse: () => widget.methods!.first,
      );
    }
    return widget.methods!.first;
  }

  String _getSubtitle(TwoFactorLoginMethod? method) {
    if (method == null) return 'Enter the 6-digit code from your authenticator app';
    switch (method.type) {
      case TwoFactorLoginMethodType.totp:
        return 'Enter the 6-digit code from your authenticator app';
      case TwoFactorLoginMethodType.sms:
        return 'Enter the code sent to your phone${method.label != null ? ' (${method.label})' : ''}';
      case TwoFactorLoginMethodType.email:
        return 'Enter the code sent to your email${method.label != null ? ' (${method.label})' : ''}';
      case TwoFactorLoginMethodType.passkey:
        return 'Use your fingerprint, face, or security key to verify';
    }
  }

  IconData _getMethodIcon(TwoFactorLoginMethodType type) {
    switch (type) {
      case TwoFactorLoginMethodType.totp:
        return Icons.qr_code_scanner;
      case TwoFactorLoginMethodType.sms:
        return Icons.sms_outlined;
      case TwoFactorLoginMethodType.email:
        return Icons.mail_outline;
      case TwoFactorLoginMethodType.passkey:
        return Icons.fingerprint;
    }
  }

  String _getMethodLabel(TwoFactorLoginMethodType type) {
    switch (type) {
      case TwoFactorLoginMethodType.totp:
        return 'Authenticator';
      case TwoFactorLoginMethodType.sms:
        return 'SMS';
      case TwoFactorLoginMethodType.email:
        return 'Email';
      case TwoFactorLoginMethodType.passkey:
        return 'Passkey';
    }
  }

  void _handleMethodSwitch(TwoFactorLoginMethod method) {
    widget.onMethodChange?.call(method.id);
    _codeController.clear();
    setState(() {
      _codeSent = false;
    });
  }

  void _handleSendCode() {
    final method = _activeMethod;
    if (method != null && widget.onSendCode != null) {
      widget.onSendCode!(method.id);
      setState(() {
        _codeSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final method = _activeMethod;
    final hasMultipleMethods = widget.methods != null && widget.methods!.length > 1;
    final needsSend = method != null &&
        (method.type == TwoFactorLoginMethodType.sms || method.type == TwoFactorLoginMethodType.email);
    final isPasskey = method?.type == TwoFactorLoginMethodType.passkey;

    return Scaffold(
      backgroundColor: MitumbaColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MitumbaSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(MitumbaSpacing.xl),
            decoration: BoxDecoration(
              color: MitumbaColors.surface,
              borderRadius: BorderRadius.circular(MitumbaRadius.xl),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: MitumbaColors.greenLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.lock_open_outlined,
                    size: 36,
                    color: MitumbaColors.green,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xl),

                // Title
                const Text(
                  'Two-Factor Authentication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeXl,
                    fontWeight: FontWeight.w800,
                    color: MitumbaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.sm),

                // Subtitle
                Text(
                  _getSubtitle(method),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeBase,
                    color: MitumbaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xxl),

                // Multiple methods selection chips
                if (hasMultipleMethods) ...[
                  Wrap(
                    spacing: MitumbaSpacing.xs,
                    runSpacing: MitumbaSpacing.xs,
                    alignment: WrapAlignment.center,
                    children: widget.methods!.map((m) {
                      final isActive = m.id == (method?.id ?? '');
                      return ChoiceChip(
                        label: Text(
                          m.label ?? _getMethodLabel(m.type),
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeSm,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? MitumbaColors.green : MitumbaColors.textSecondary,
                          ),
                        ),
                        avatar: Icon(
                          _getMethodIcon(m.type),
                          size: 16,
                          color: isActive ? MitumbaColors.green : MitumbaColors.textSecondary,
                        ),
                        selected: isActive,
                        selectedColor: MitumbaColors.greenLight,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MitumbaRadius.full),
                          side: BorderSide(
                            color: isActive ? MitumbaColors.green : MitumbaColors.divider,
                            width: 1.5,
                          ),
                        ),
                        showCheckmark: false,
                        onSelected: (_) => _handleMethodSwitch(m),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: MitumbaSpacing.xl),
                ],

                // Trigger Send code button for SMS/Email
                if (method != null && !isPasskey && needsSend && !_codeSent && widget.onSendCode != null) ...[
                  MitumbaPrimaryButton(
                    label: 'Send code via ${_getMethodLabel(method.type)}',
                    onPressed: _handleSendCode,
                  ),
                ] else if (isPasskey && widget.onUsePasskey != null && method != null) ...[
                  // Passkey verification button
                  MitumbaPrimaryButton(
                    label: 'Use a passkey',
                    loading: widget.loading,
                    onPressed: () => widget.onUsePasskey!(method.id),
                  ),
                  if (widget.error != null) ...[
                    const SizedBox(height: MitumbaSpacing.sm),
                    Text(
                      widget.error!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeXs,
                        color: MitumbaColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ] else ...[
                  // Standard OTP monospaced input field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification code',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          fontWeight: FontWeight.w600,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: MitumbaColors.surface,
                          borderRadius: BorderRadius.circular(MitumbaRadius.md),
                          border: Border.all(
                            color: widget.error != null ? MitumbaColors.error : MitumbaColors.divider,
                            width: widget.error != null ? 2.0 : 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          onChanged: (val) {
                            final digits = val.replaceAll(RegExp(r'\D'), '');
                            if (digits != val) {
                              _codeController.text = digits;
                              _codeController.selection = TextSelection.fromPosition(
                                TextPosition(offset: digits.length),
                              );
                            }
                            setState(() {});
                          },
                          style: const TextStyle(
                            fontSize: 28.0,
                            letterSpacing: 10.0,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: MitumbaColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            hintText: '000000',
                            hintStyle: TextStyle(
                              letterSpacing: 10.0,
                              color: MitumbaColors.textDisabled,
                            ),
                          ),
                        ),
                      ),
                      if (widget.error != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.error!,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeXs,
                            color: MitumbaColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: MitumbaSpacing.xl),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: MitumbaPrimaryButton(
                      label: widget.loading ? 'Verifying...' : 'Verify',
                      disabled: _codeController.text.length != 6 || widget.loading,
                      onPressed: () => widget.onSubmit(_codeController.text),
                    ),
                  ),
                ],

                // Backup code option
                if (widget.onUseBackupCode != null) ...[
                  const SizedBox(height: MitumbaSpacing.xl),
                  GestureDetector(
                    onTap: widget.onUseBackupCode,
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Use a backup code instead',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          fontWeight: FontWeight.bold,
                          color: MitumbaColors.green,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
