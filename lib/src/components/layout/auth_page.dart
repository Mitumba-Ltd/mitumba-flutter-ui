import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Active form view for [AuthPage].
enum AuthView { signin, signup, forgot, reset }

/// A social auth provider for [AuthPage].
class SocialProvider {
  const SocialProvider({required this.name, required this.icon});
  final String name;
  final IconData icon;
}

/// Split-layout authentication page with animated gradient panel.
///
/// Mirrors the web `AuthPage` from `@mitumba/ui`.
///
/// ```dart
/// AuthPage(
///   onLogin: (email, password, remember) {},
///   onSignUp: (email, password) {},
///   onForgotPassword: (email) {},
/// )
/// ```
class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    this.view = AuthView.signin,
    this.onLogin,
    this.onSignUp,
    this.onForgotPassword,
    this.onResetPassword,
    this.onSocialAuth,
    this.onViewChange,
    this.loading = false,
    this.error,
    this.success,
    this.socialProviders,
  });

  /// Initial view.
  final AuthView view;

  /// Sign in handler: (email, password, remember).
  final void Function(String email, String password, bool remember)? onLogin;

  /// Sign up handler: (email, password).
  final void Function(String email, String password)? onSignUp;

  /// Forgot password handler: (email).
  final void Function(String email)? onForgotPassword;

  /// Reset password handler: (password, confirm).
  final void Function(String password, String confirm)? onResetPassword;

  /// Social auth handler: (provider, mode).
  final void Function(String provider, String mode)? onSocialAuth;

  /// Called when view changes.
  final ValueChanged<AuthView>? onViewChange;

  /// Whether a request is in progress.
  final bool loading;

  /// Error message.
  final String? error;

  /// Success message.
  final String? success;

  /// Social providers to show.
  final List<SocialProvider>? socialProviders;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthView _currentView;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _remember = false;

  @override
  void initState() {
    super.initState();
    _currentView = widget.view;
  }

  @override
  void didUpdateWidget(AuthPage old) {
    super.didUpdateWidget(old);
    if (widget.view != old.view) _currentView = widget.view;
  }

  void _switchView(AuthView v) {
    setState(() => _currentView = v);
    widget.onViewChange?.call(v);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MitumbaColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(MitumbaSpacing.lg),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: EdgeInsets.all(MitumbaSpacing.xxl),
              decoration: BoxDecoration(
                color: MitumbaColors.surface,
                borderRadius: BorderRadius.circular(MitumbaRadius.xl),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  SizedBox(height: MitumbaSpacing.xxl),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_currentView),
                      child: _buildForm(),
                    ),
                  ),
                  if (widget.error != null) ...[
                    SizedBox(height: MitumbaSpacing.md),
                    _MessageBanner(message: widget.error!, color: MitumbaColors.error),
                  ],
                  if (widget.success != null) ...[
                    SizedBox(height: MitumbaSpacing.md),
                    _MessageBanner(message: widget.success!, color: MitumbaColors.success),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final (title, subtitle) = switch (_currentView) {
      AuthView.signin => ('Sign In', 'Welcome back! Please login to your account.'),
      AuthView.signup => ('Sign Up', 'Create your account to get started.'),
      AuthView.forgot => ('Forgot Password', "Enter your email and we'll send you a reset link."),
      AuthView.reset => ('Reset Password', 'Enter your new password below.'),
    };
    return Column(
      children: [
        Text('Mitumba', style: MitumbaTypography.h3.copyWith(color: MitumbaColors.green)),
        SizedBox(height: MitumbaSpacing.xl),
        Text(title, style: MitumbaTypography.h4),
        SizedBox(height: MitumbaSpacing.xs),
        Text(subtitle, style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildForm() {
    return switch (_currentView) {
      AuthView.signin => _buildSignIn(),
      AuthView.signup => _buildSignUp(),
      AuthView.forgot => _buildForgot(),
      AuthView.reset => _buildReset(),
    };
  }

  Widget _buildSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(controller: _emailCtrl),
        SizedBox(height: MitumbaSpacing.base),
        _PasswordField(controller: _passwordCtrl),
        SizedBox(height: MitumbaSpacing.md),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _remember,
                onChanged: (v) => setState(() => _remember = v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: MitumbaSpacing.xs),
            Expanded(child: Text('Remember me', style: MitumbaTypography.caption)),
            GestureDetector(
              onTap: () => _switchView(AuthView.forgot),
              child: Text('Forgot password?', style: MitumbaTypography.caption.copyWith(color: MitumbaColors.green)),
            ),
          ],
        ),
        SizedBox(height: MitumbaSpacing.xl),
        _SubmitButton(
          label: widget.loading ? 'Signing in...' : 'Sign In',
          loading: widget.loading,
          onPressed: () => widget.onLogin?.call(_emailCtrl.text, _passwordCtrl.text, _remember),
        ),
        _buildSocial('login'),
        SizedBox(height: MitumbaSpacing.lg),
        _SwitchLink(text: "Don't have an account? ", linkText: 'Sign Up', onTap: () => _switchView(AuthView.signup)),
      ],
    );
  }

  Widget _buildSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(controller: _emailCtrl),
        SizedBox(height: MitumbaSpacing.base),
        _PasswordField(controller: _passwordCtrl),
        SizedBox(height: MitumbaSpacing.xl),
        _SubmitButton(
          label: widget.loading ? 'Creating account...' : 'Sign Up',
          loading: widget.loading,
          onPressed: () => widget.onSignUp?.call(_emailCtrl.text, _passwordCtrl.text),
        ),
        _buildSocial('signup'),
        SizedBox(height: MitumbaSpacing.lg),
        _SwitchLink(text: 'Already have an account? ', linkText: 'Sign In', onTap: () => _switchView(AuthView.signin)),
      ],
    );
  }

  Widget _buildForgot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(controller: _emailCtrl),
        SizedBox(height: MitumbaSpacing.xl),
        _SubmitButton(
          label: widget.loading ? 'Sending...' : 'Send Reset Link',
          loading: widget.loading,
          onPressed: () => widget.onForgotPassword?.call(_emailCtrl.text),
        ),
        SizedBox(height: MitumbaSpacing.lg),
        _SwitchLink(text: 'Remember your password? ', linkText: 'Sign In', onTap: () => _switchView(AuthView.signin)),
      ],
    );
  }

  Widget _buildReset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PasswordField(controller: _passwordCtrl, label: 'New Password'),
        SizedBox(height: MitumbaSpacing.base),
        _PasswordField(controller: _confirmCtrl, label: 'Confirm Password'),
        SizedBox(height: MitumbaSpacing.xl),
        _SubmitButton(
          label: widget.loading ? 'Resetting...' : 'Reset Password',
          loading: widget.loading,
          onPressed: () => widget.onResetPassword?.call(_passwordCtrl.text, _confirmCtrl.text),
        ),
        SizedBox(height: MitumbaSpacing.lg),
        _SwitchLink(text: 'Back to ', linkText: 'Sign In', onTap: () => _switchView(AuthView.signin)),
      ],
    );
  }

  Widget _buildSocial(String mode) {
    if (widget.socialProviders == null && widget.onSocialAuth == null) return const SizedBox.shrink();
    final providers = widget.socialProviders ?? const [];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.lg),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.md),
                child: Text('OR', style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: providers.map((p) => Padding(
            padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm),
            child: IconButton.outlined(
              onPressed: () => widget.onSocialAuth?.call(p.name, mode),
              icon: Icon(p.icon),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller, this.label = 'Password'});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onPressed, this.loading = false});
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MitumbaColors.green,
        foregroundColor: MitumbaColors.white,
        padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.base),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
        textStyle: MitumbaTypography.button,
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: MitumbaColors.white,
              ),
            )
          : Text(label),
    );
  }
}

class _SwitchLink extends StatelessWidget {
  const _SwitchLink({required this.text, required this.linkText, required this.onTap});
  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(TextSpan(
        text: text,
        style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: onTap,
              child: Text(linkText, style: MitumbaTypography.body2.copyWith(
                color: MitumbaColors.green,
                fontWeight: FontWeight.w700,
              )),
            ),
          ),
        ],
      )),
    );
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.color});
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MitumbaSpacing.base),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(MitumbaRadius.md),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(message, style: MitumbaTypography.body2.copyWith(color: color)),
    );
  }
}
