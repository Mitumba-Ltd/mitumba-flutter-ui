import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Universal modal base primitive displaying detailed content windows.
/// On desktop, centers as a standard dialog; on mobile, acts as a bottom sheet.
class MitumbaModal extends StatelessWidget {
  const MitumbaModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions,
    this.showClose = true,
    this.loading = false,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? actions;
  final bool showClose;
  final bool loading;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MitumbaRadius.xl),
            topRight: Radius.circular(MitumbaRadius.xl),
          ),
        ),
        padding: const EdgeInsets.only(top: MitumbaSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle - mobile only
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: MitumbaColors.divider,
                  borderRadius: BorderRadius.circular(MitumbaRadius.full),
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.md),
            _buildHeader(context),
            const Divider(color: MitumbaColors.divider, height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(MitumbaSpacing.lg),
                child: Stack(
                  children: [
                    child,
                    if (loading) _buildLoadingOverlay(),
                  ],
                ),
              ),
            ),
            if (actions != null) ...[
              const Divider(color: MitumbaColors.divider, height: 1),
              Padding(
                padding: const EdgeInsets.all(MitumbaSpacing.lg),
                child: actions!,
              ),
            ],
          ],
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: MitumbaSpacing.lg,
        vertical: MitumbaSpacing.xxl,
      ),
      child: Center(
        child: Container(
          width: 500,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const Divider(color: MitumbaColors.divider, height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(MitumbaSpacing.lg),
                  child: Stack(
                    children: [
                      child,
                      if (loading) _buildLoadingOverlay(),
                    ],
                  ),
                ),
              ),
              if (actions != null) ...[
                const Divider(color: MitumbaColors.divider, height: 1),
                Padding(
                  padding: const EdgeInsets.all(MitumbaSpacing.lg),
                  child: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MitumbaSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeLg,
                    fontWeight: FontWeight.w700,
                    color: MitumbaColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeSm,
                      color: MitumbaColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showClose)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: MitumbaColors.textDisabled,
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 18,
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.white70,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: MitumbaColors.green,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
