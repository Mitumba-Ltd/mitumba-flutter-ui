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
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'ListingCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Center(
                    child: SizedBox(
                      width: 200,
                      child: ListingCard(
                        id: '1',
                        title: context.knobs.string(label: 'Title', initialValue: 'Vintage Leather Jacket — Size M'),
                        price: context.knobs.int.input(label: 'Price (KES)', initialValue: 3500),
                        media: const [
                          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
                          'https://images.unsplash.com/photo-1559551409-dadc959f76b8?w=400',
                        ],
                        storeName: context.knobs.stringOrNull(label: 'Store Name', initialValue: 'Mama Njeri Styles'),
                        condition: context.knobs.objectOrNull.dropdown(
                          label: 'Condition',
                          options: ListingCondition.values,
                          labelBuilder: (c) => c.name,
                          initialOption: ListingCondition.likeNew,
                        ),
                        isSaved: context.knobs.boolean(label: 'Saved', initialValue: false),
                        onSaveToggle: (_) {},
                        onTap: (_) {},
                        onAddToCart: (_) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MobileBottomNav',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Variants',
                  builder: (context) {
                    final variant = context.knobs.object.dropdown(
                      label: 'Variant',
                      options: BottomNavVariant.values,
                      labelBuilder: (v) => v.name,
                      initialOption: BottomNavVariant.indicator,
                    );
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: MobileBottomNav(
                        activeTab: 'home',
                        onTabChange: (_) {},
                        variant: variant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Tokens',
          children: [
            WidgetbookComponent(
              name: 'Colors',
              useCases: [
                WidgetbookUseCase(name: 'Brand Palette', builder: (_) => _ColorPalette()),
              ],
            ),
            WidgetbookComponent(
              name: 'Typography',
              useCases: [
                WidgetbookUseCase(name: 'Type Scale', builder: (_) => _TypeScale()),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing',
              useCases: [
                WidgetbookUseCase(name: 'Scale', builder: (_) => _SpacingScale()),
              ],
            ),
            WidgetbookComponent(
              name: 'Radius',
              useCases: [
                WidgetbookUseCase(name: 'Scale', builder: (_) => _RadiusScale()),
              ],
            ),
            WidgetbookComponent(
              name: 'Shadows',
              useCases: [
                WidgetbookUseCase(name: 'Elevations', builder: (_) => _ShadowScale()),
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
      'Green (Primary)': MitumbaColors.green,
      'Green Light': MitumbaColors.greenLight,
      'Green Dark': MitumbaColors.greenDark,
      'Earth': MitumbaColors.earth,
      'Earth Light': MitumbaColors.earthLight,
      'Earth Dark': MitumbaColors.earthDark,
      'Background': MitumbaColors.background,
      'Surface': MitumbaColors.surface,
      'Border': MitumbaColors.border,
      'Text Primary': MitumbaColors.textPrimary,
      'Text Secondary': MitumbaColors.textSecondary,
      'Success': MitumbaColors.success,
      'Error': MitumbaColors.error,
      'Warning': MitumbaColors.warning,
      'Info': MitumbaColors.info,
      'STI Trusted': MitumbaColors.stiTrusted,
      'STI At Risk': MitumbaColors.stiAtRisk,
      'STI Flagged': MitumbaColors.stiFlagged,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: swatches.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(
            color: e.value,
            borderRadius: BorderRadius.circular(MitumbaRadius.sm),
            border: Border.all(color: MitumbaColors.border),
          )),
          const SizedBox(width: 12),
          Text(e.key, style: MitumbaTypography.body2),
        ]),
      )).toList(),
    );
  }
}

class _TypeScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const styles = <String, TextStyle>{
      'H1 (32px extrabold)': MitumbaTypography.h1,
      'H2 (26px bold)': MitumbaTypography.h2,
      'H3 (22px bold)': MitumbaTypography.h3,
      'H4 (20px bold)': MitumbaTypography.h4,
      'H5 (18px semibold)': MitumbaTypography.h5,
      'Body 1 (16px)': MitumbaTypography.body1,
      'Body 2 (14px)': MitumbaTypography.body2,
      'Caption (12px)': MitumbaTypography.caption,
      'Button (14px semibold)': MitumbaTypography.button,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: styles.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('${e.key} — Mitumba', style: e.value),
      )).toList(),
    );
  }
}

class _SpacingScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const values = <String, double>{
      'xxs (2)': MitumbaSpacing.xxs,
      'xs (4)': MitumbaSpacing.xs,
      'sm (6)': MitumbaSpacing.sm,
      'md (8)': MitumbaSpacing.md,
      'base (12)': MitumbaSpacing.base,
      'lg (16)': MitumbaSpacing.lg,
      'xl (20)': MitumbaSpacing.xl,
      'xxl (24)': MitumbaSpacing.xxl,
      'xxxl (32)': MitumbaSpacing.xxxl,
      'huge (48)': MitumbaSpacing.huge,
      'giant (64)': MitumbaSpacing.giant,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: values.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Container(width: e.value, height: 24, color: MitumbaColors.green),
          const SizedBox(width: 12),
          Text(e.key, style: MitumbaTypography.body2),
        ]),
      )).toList(),
    );
  }
}

class _RadiusScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const values = <String, double>{
      'xxs (2)': MitumbaRadius.xxs,
      'xs (4)': MitumbaRadius.xs,
      'sm (6)': MitumbaRadius.sm,
      'md (8)': MitumbaRadius.md,
      'lg (12)': MitumbaRadius.lg,
      'xl (16)': MitumbaRadius.xl,
      'xxl (24)': MitumbaRadius.xxl,
      'xxxl (32)': MitumbaRadius.xxxl,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: values.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: MitumbaColors.greenLight,
              border: Border.all(color: MitumbaColors.green),
              borderRadius: BorderRadius.circular(e.value),
            ),
          ),
          const SizedBox(width: 12),
          Text(e.key, style: MitumbaTypography.body2),
        ]),
      )).toList(),
    );
  }
}

class _ShadowScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shadows = <String, List<BoxShadow>>{
      'Card': MitumbaShadows.card,
      'Elevated': MitumbaShadows.elevated,
      'Deep': MitumbaShadows.deep,
      'Bottom Sheet': MitumbaShadows.bottomSheet,
      'Green': MitumbaShadows.green,
      'Earth': MitumbaShadows.earth,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: shadows.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            boxShadow: e.value,
          ),
          alignment: Alignment.center,
          child: Text(e.key, style: MitumbaTypography.body2),
        ),
      )).toList(),
    );
  }
}
