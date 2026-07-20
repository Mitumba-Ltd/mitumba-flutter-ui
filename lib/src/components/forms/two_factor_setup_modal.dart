import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

/// TwoFactorSetupModal — dialog for enabling 2FA from settings.
/// 3-step flow: scan QR → verify code → save backup codes.
class TwoFactorSetupModal extends StatefulWidget {
  const TwoFactorSetupModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.otpauthUri,
    required this.secret,
    required this.onVerify,
    this.backupCodes,
    this.verifying = false,
    this.error,
  });

  final bool open;
  final VoidCallback onClose;
  final String otpauthUri;
  final String secret;
  final Future<void> Function(String code) onVerify;
  final List<String>? backupCodes;
  final bool verifying;
  final String? error;

  @override
  State<TwoFactorSetupModal> createState() => _TwoFactorSetupModalState();
}

class _TwoFactorSetupModalState extends State<TwoFactorSetupModal> {
  int _activeStep = 0;
  bool _showSecret = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    try {
      await widget.onVerify(_codeController.text);
      if (widget.backupCodes != null && widget.backupCodes!.isNotEmpty) {
        setState(() {
          _activeStep = 2;
        });
      }
    } catch (_) {
      // Errors are handled externally by passing the error property
    }
  }

  void _handleCopyAll() {
    if (widget.backupCodes != null) {
      Clipboard.setData(ClipboardData(text: widget.backupCodes!.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recovery codes copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final stepLabels = ['Scan QR Code', 'Verify Code', 'Backup Codes'];
    final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(widget.otpauthUri)}';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(MitumbaSpacing.xl),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Set Up Two-Factor Authentication',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeLg,
                  fontWeight: FontWeight.w800,
                  color: MitumbaColors.textPrimary,
                ),
              ),
              const SizedBox(height: MitumbaSpacing.xxl),

              // Step indicators row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(stepLabels.length, (i) {
                  final label = stepLabels[i];
                  final isDone = _activeStep > i;
                  final isActive = _activeStep == i;

                  Color circleBg = MitumbaColors.background;
                  Color circleText = MitumbaColors.textDisabled;
                  Border? circleBorder;

                  if (isDone) {
                    circleBg = MitumbaColors.green;
                    circleText = Colors.white;
                  } else if (isActive) {
                    circleBg = MitumbaColors.greenLight;
                    circleText = MitumbaColors.green;
                    circleBorder = Border.all(color: MitumbaColors.green, width: 2);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: circleBg,
                            shape: BoxShape.circle,
                            border: circleBorder,
                          ),
                          alignment: Alignment.center,
                          child: isDone
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: circleText,
                                  ),
                                ),
                        ),
                        const SizedBox(height: MitumbaSpacing.xs),
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: (_activeStep >= i)
                                ? MitumbaColors.textPrimary
                                : MitumbaColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: MitumbaSpacing.xxxl),

              // Step content view
              if (_activeStep == 0) ...[
                // Step 1: Scan QR
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MitumbaColors.background,
                        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                      ),
                      padding: const EdgeInsets.all(MitumbaSpacing.xl),
                      margin: const EdgeInsets.only(bottom: MitumbaSpacing.xl),
                      child: Image.network(
                        qrUrl,
                        width: 180,
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 180,
                            height: 180,
                            child: Icon(
                              Icons.qr_code,
                              size: 96,
                              color: MitumbaColors.textDisabled,
                            ),
                          );
                        },
                      ),
                    ),
                    const Text(
                      'Scan this QR code with your authenticator app (Google Authenticator, Authy, etc.)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeSm,
                        color: MitumbaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: MitumbaSpacing.md),
                    TextButton(
                      onPressed: () => setState(() => _showSecret = !_showSecret),
                      child: Text(
                        _showSecret
                            ? 'Hide manual key'
                            : "Can't scan? Enter key manually",
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: MitumbaColors.green,
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _showSecret
                          ? Container(
                              margin: const EdgeInsets.only(top: MitumbaSpacing.sm),
                              padding: const EdgeInsets.all(MitumbaSpacing.md),
                              decoration: BoxDecoration(
                                color: MitumbaColors.background,
                                borderRadius: BorderRadius.circular(MitumbaRadius.md),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.secret,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 14,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: MitumbaColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 16),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: widget.secret));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Secret key copied!')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: MitumbaSpacing.xxl),
                    MitumbaPrimaryButton(
                      label: 'Next',
                      onPressed: () => setState(() => _activeStep = 1),
                    ),
                  ],
                ),
              ] else if (_activeStep == 1) ...[
                // Step 2: Verify Code
                Column(
                  children: [
                    const Text(
                      'Enter the 6-digit code from your authenticator app to confirm setup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeBase,
                        color: MitumbaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: MitumbaSpacing.xxl),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: Column(
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
                    ),
                    const SizedBox(height: MitumbaSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: MitumbaPrimaryButton(
                        label: widget.verifying ? 'Verifying...' : 'Verify & Enable',
                        disabled: _codeController.text.length != 6 || widget.verifying,
                        onPressed: _handleVerify,
                      ),
                    ),
                  ],
                ),
              ] else if (_activeStep == 2 && widget.backupCodes != null) ...[
                // Step 3: Backup codes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(MitumbaSpacing.md),
                      decoration: BoxDecoration(
                        color: MitumbaColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        border: Border.all(color: MitumbaColors.warning.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_outlined, color: MitumbaColors.warning),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Save these recovery codes in a safe place. Each code can only be used once if you lose access to your authenticator app.',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: MitumbaTypography.fontSizeSm,
                                color: MitumbaColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: MitumbaSpacing.xl),

                    // 2-column grid of backup codes
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: MitumbaSpacing.sm,
                        mainAxisSpacing: MitumbaSpacing.sm,
                      ),
                      itemCount: widget.backupCodes!.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          decoration: BoxDecoration(
                            color: MitumbaColors.background,
                            borderRadius: BorderRadius.circular(MitumbaRadius.md),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.backupCodes![idx],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: MitumbaColors.textPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: MitumbaSpacing.xl),

                    // Copy All button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _handleCopyAll,
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy All'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: MitumbaColors.green,
                            side: const BorderSide(color: MitumbaColors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(MitumbaRadius.md),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MitumbaSpacing.xxl),

                    MitumbaPrimaryButton(
                      label: 'Done',
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
