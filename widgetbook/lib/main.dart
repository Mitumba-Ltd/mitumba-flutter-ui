import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Tokens',
          children: [
            WidgetbookComponent(
              name: 'Colors',
              useCases: [
                WidgetbookUseCase(
                  name: 'Brand Palette',
                  builder: (context) => _ColorPalette(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Typography',
              useCases: [
                WidgetbookUseCase(
                  name: 'Type Scale',
                  builder: (context) => _TypeScale(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing',
              useCases: [
                WidgetbookUseCase(
                  name: 'Scale',
                  builder: (context) => _SpacingScale(),
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        ViewportAddon([
          IosViewports.iPhone13,
          AndroidViewports.samsungGalaxyA50,
          IosViewports.iPadAir4,
        ]),
      ],
    );
  }
}

class _ColorPalette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const swatches = <String, Color>{
      'Primary': MitumbaColors.primary,
      'Primary Light': MitumbaColors.primaryLight,
      'Primary Dark': MitumbaColors.primaryDark,
      'Text Primary': MitumbaColors.textPrimary,
      'Text Secondary': MitumbaColors.textSecondary,
      'Surface': MitumbaColors.surface,
      'Background': MitumbaColors.background,
      'Success': MitumbaColors.success,
      'Error': MitumbaColors.error,
      'Warning': MitumbaColors.warning,
      'Info': MitumbaColors.info,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: swatches.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(width: 48, height: 48, color: e.value),
              const SizedBox(width: 12),
              Text(e.key, style: MitumbaTypography.body1),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TypeScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const styles = <String, TextStyle>{
      'H1': MitumbaTypography.h1,
      'H2': MitumbaTypography.h2,
      'H3': MitumbaTypography.h3,
      'H4': MitumbaTypography.h4,
      'H5': MitumbaTypography.h5,
      'Body 1': MitumbaTypography.body1,
      'Body 2': MitumbaTypography.body2,
      'Caption': MitumbaTypography.caption,
      'Button': MitumbaTypography.button,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: styles.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('${e.key} — Mitumba', style: e.value),
        );
      }).toList(),
    );
  }
}

class _SpacingScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const values = <String, double>{
      'xs (4)': MitumbaSpacing.xs,
      'sm (8)': MitumbaSpacing.sm,
      'md (12)': MitumbaSpacing.md,
      'lg (16)': MitumbaSpacing.lg,
      'xl (24)': MitumbaSpacing.xl,
      'xxl (32)': MitumbaSpacing.xxl,
      'xxxl (48)': MitumbaSpacing.xxxl,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: values.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(width: e.value, height: 24, color: MitumbaColors.primary),
              const SizedBox(width: 12),
              Text(e.key, style: MitumbaTypography.body2),
            ],
          ),
        );
      }).toList(),
    );
  }
}
