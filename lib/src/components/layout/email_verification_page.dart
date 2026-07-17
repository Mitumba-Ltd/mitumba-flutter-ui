import 'dart:async';
import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

/// EmailVerificationPage — standalone page for email verification after signup.
/// Split layout on desktop (hero left, form right), form-only on mobile.
/// Same visual language as AuthPage and TwoFactorLoginStep.
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.onVerify,
    required this.onResend,
    this.loading = false,
    this.error,
    this.resendSuccess = false,
    this.heroImageUrl,
    this.onGoBack,
  });

  final String email;
  final ValueChanged<String> onVerify;
  final VoidCallback onResend;
  final bool loading;
  final String? error;
  final bool resendSuccess;
  final String? heroImageUrl;
  final VoidCallback? onGoBack;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _handleResend() {
    widget.onResend();
    _startCountdown();
  }

  void _handleVerify() {
    if (_codeController.text.length == 6) {
      widget.onVerify(_codeController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    Widget buildFormPanel() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.xl, vertical: MitumbaSpacing.xxxl),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Envelope Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: MitumbaColors.greenLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 36,
                    color: MitumbaColors.green,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xl),

                // Title
                const Text(
                  'Verify your email',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeXl,
                    fontWeight: FontWeight.w800,
                    color: MitumbaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.sm),

                // Subtitle
                Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Text(
                    'We sent a 6-digit code to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeBase,
                      color: MitumbaColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: MitumbaSpacing.xxl),

                // Monospace code input field
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

                // Resend Success Banner
                if (widget.resendSuccess) ...[
                  Container(
                    constraints: const BoxConstraints(maxWidth: 240),
                    margin: const EdgeInsets.only(bottom: MitumbaSpacing.lg),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: MitumbaColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                      border: Border.all(color: MitumbaColors.success.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: MitumbaColors.success, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Code resent!',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeSm,
                            color: MitumbaColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Verify Button
                Container(
                  constraints: const BoxConstraints(maxWidth: 240),
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: MitumbaSpacing.xl),
                  child: MitumbaPrimaryButton(
                    label: widget.loading ? 'Verifying...' : 'Verify',
                    disabled: _codeController.text.length != 6 || widget.loading,
                    onPressed: _handleVerify,
                  ),
                ),

                // Resend switch
                GestureDetector(
                  onTap: _countdown > 0 ? null : _handleResend,
                  child: MouseRegion(
                    cursor: _countdown > 0 ? SystemMouseCursors.basic : SystemMouseCursors.click,
                    child: Text(
                      _countdown > 0
                          ? 'Resend available in ${_countdown}s'
                          : "Didn't receive it? Resend",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: _countdown > 0 ? MitumbaColors.textDisabled : MitumbaColors.green,
                        decoration: _countdown > 0 ? TextDecoration.none : TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                // Go Back Switch
                if (widget.onGoBack != null) ...[
                  const SizedBox(height: MitumbaSpacing.lg),
                  GestureDetector(
                    onTap: widget.onGoBack,
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Wrong email? Go back',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (isMobile) {
      return Scaffold(
        backgroundColor: MitumbaColors.surface,
        body: SafeArea(child: buildFormPanel()),
      );
    }

    // Split desktop/tablet layout
    final panelBg = widget.heroImageUrl != null
        ? DecorationImage(
            image: NetworkImage(widget.heroImageUrl!),
            fit: BoxFit.cover,
          )
        : null;

    return Scaffold(
      backgroundColor: MitumbaColors.background,
      body: Center(
        child: Container(
          width: 900,
          height: 540,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.xl),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Hero panel (42% width)
              Container(
                width: 900 * 0.42,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: panelBg,
                  gradient: widget.heroImageUrl == null
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [MitumbaColors.green, MitumbaColors.earth],
                        )
                      : null,
                ),
                child: Container(
                  color: widget.heroImageUrl != null ? Colors.black.withOpacity(0.4) : Colors.transparent,
                  padding: const EdgeInsets.all(MitumbaSpacing.giant),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Almost there!',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: MitumbaSpacing.lg),
                      Text(
                        'Verify your email to unlock the full Mitumba experience — buy, sell, and connect with trusted sellers across Kenya.',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeBase,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Form panel
              Expanded(
                child: buildFormPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
