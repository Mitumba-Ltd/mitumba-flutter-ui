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
            WidgetbookComponent(
              name: 'SellerCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Center(
                    child: SizedBox(
                      width: 350,
                      child: SellerCard(
                        sellerId: 's1',
                        name: context.knobs.string(label: 'Name', initialValue: 'Mama Njeri'),
                        city: context.knobs.string(label: 'City', initialValue: 'Nairobi'),
                        stiScore: context.knobs.int.input(label: 'STI Score', initialValue: 85),
                        totalListings: context.knobs.int.input(label: 'Listings', initialValue: 42),
                        isVaziFeatured: context.knobs.boolean(label: 'VAZI Featured', initialValue: false),
                        actionLabel: context.knobs.stringOrNull(label: 'Action Label', initialValue: 'Visit Store'),
                        onTap: () {},
                        onAction: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'EmptyState',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final variant = context.knobs.object.dropdown(
                      label: 'Variant',
                      options: EmptyStateVariant.values,
                      labelBuilder: (v) => v.name,
                      initialOption: EmptyStateVariant.standard,
                    );
                    return Center(
                      child: EmptyState(
                        title: context.knobs.string(label: 'Title', initialValue: 'No listings yet'),
                        subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'Start selling to see your items here.'),
                        icon: Icons.storefront_outlined,
                        variant: variant,
                        actionLabel: context.knobs.stringOrNull(label: 'Action', initialValue: 'Create listing'),
                        onAction: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AuthPage',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final view = context.knobs.object.dropdown(
                      label: 'View',
                      options: AuthView.values,
                      labelBuilder: (v) => v.name,
                      initialOption: AuthView.signin,
                    );
                    return AuthPage(
                      view: view,
                      error: context.knobs.stringOrNull(label: 'Error'),
                      onLogin: (_, __, ___) {},
                      onSignUp: (_, __) {},
                      onForgotPassword: (_) {},
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MitumbaPrimaryButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Variants',
                  builder: (context) {
                    final variant = context.knobs.object.dropdown(
                      label: 'Variant',
                      options: ButtonVariant.values,
                      labelBuilder: (v) => v.name,
                      initialOption: ButtonVariant.primary,
                    );
                    final size = context.knobs.object.dropdown(
                      label: 'Size',
                      options: ButtonSize.values,
                      labelBuilder: (s) => s.name,
                      initialOption: ButtonSize.medium,
                    );
                    return Center(
                      child: MitumbaPrimaryButton(
                        label: context.knobs.string(label: 'Label', initialValue: 'Click me'),
                        variant: variant,
                        size: size,
                        loading: context.knobs.boolean(label: 'Loading', initialValue: false),
                        disabled: context.knobs.boolean(label: 'Disabled', initialValue: false),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MitumbaAvatar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    final size = context.knobs.object.dropdown(
                      label: 'Size',
                      options: MitumbaAvatarSize.values,
                      labelBuilder: (s) => s.name,
                      initialOption: MitumbaAvatarSize.md,
                    );
                    final status = context.knobs.objectOrNull.dropdown(
                      label: 'Status',
                      options: MitumbaAvatarStatus.values,
                      labelBuilder: (s) => s.name,
                    );
                    final align = context.knobs.objectOrNull.dropdown(
                      label: 'Text Alignment',
                      options: MitumbaAvatarTextAlignment.values,
                      labelBuilder: (a) => a.name,
                    );
                    final progress = context.knobs.double.slider(
                      label: 'Progress Percentage',
                      initialValue: 0.0,
                      min: 0.0,
                      max: 100.0,
                    );
                    return Center(
                      child: MitumbaAvatar(
                        name: context.knobs.string(label: 'Name', initialValue: 'Isaac Stanley'),
                        imageUrl: context.knobs.stringOrNull(label: 'Image URL', initialValue: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                        size: size,
                        status: status,
                        textAlignment: align,
                        subtitle: context.knobs.stringOrNull(label: 'Subtitle', initialValue: 'Verified Seller'),
                        notificationCount: context.knobs.stringOrNull(label: 'Notification Badge', initialValue: '3'),
                        progress: progress > 0 ? progress : null,
                        hasNewEvent: context.knobs.boolean(label: 'New Event Ring', initialValue: false),
                        selected: context.knobs.boolean(label: 'Selected Check', initialValue: false),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MitumbaAvatarGroup',
              useCases: [
                WidgetbookUseCase(
                  name: 'Stacked List',
                  builder: (context) {
                    final size = context.knobs.object.dropdown(
                      label: 'Avatar Size',
                      options: MitumbaAvatarSize.values,
                      labelBuilder: (s) => s.name,
                      initialOption: MitumbaAvatarSize.md,
                    );
                    final overlap = context.knobs.object.dropdown(
                      label: 'Overlap Amount',
                      options: MitumbaAvatarOverlap.values,
                      labelBuilder: (o) => o.name,
                      initialOption: MitumbaAvatarOverlap.relaxed,
                    );
                    return Center(
                      child: MitumbaAvatarGroup(
                        size: size,
                        overlap: overlap,
                        max: context.knobs.int.slider(label: 'Max Displayed', initialValue: 4, min: 1, max: 10),
                        onAdd: context.knobs.boolean(label: 'Show Add Button', initialValue: true) ? () {} : null,
                        children: const [
                          MitumbaAvatar(name: 'Alice Cooper', imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                          MitumbaAvatar(name: 'Bob Dylan', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
                          MitumbaAvatar(name: 'Charlie Chaplin'),
                          MitumbaAvatar(name: 'Diana Prince', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100'),
                          MitumbaAvatar(name: 'Edward Stark'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MitumbaChip',
              useCases: [
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    final variant = context.knobs.object.dropdown(
                      label: 'Variant',
                      options: MitumbaChipVariant.values,
                      labelBuilder: (v) => v.name,
                      initialOption: MitumbaChipVariant.outline,
                    );
                    final status = context.knobs.object.dropdown(
                      label: 'Status Category',
                      options: MitumbaChipStatus.values,
                      labelBuilder: (s) => s.name,
                      initialOption: MitumbaChipStatus.defaultStatus,
                    );
                    final rounding = context.knobs.object.dropdown(
                      label: 'Rounding',
                      options: MitumbaChipRounding.values,
                      labelBuilder: (r) => r.name,
                      initialOption: MitumbaChipRounding.rounded,
                    );
                    final size = context.knobs.object.dropdown(
                      label: 'Size',
                      options: const ['small', 'medium'],
                      initialOption: 'medium',
                    );
                    final showIcon = context.knobs.boolean(label: 'Show Leading Icon', initialValue: false);
                    final showAvatar = context.knobs.boolean(label: 'Show Avatar', initialValue: false);
                    final showBadge = context.knobs.boolean(label: 'Show Badge', initialValue: false);
                    final showDelete = context.knobs.boolean(label: 'Show Delete Button', initialValue: false);

                    return Center(
                      child: MitumbaChip(
                        label: context.knobs.string(label: 'Label', initialValue: 'Vintage'),
                        variant: variant,
                        status: status,
                        rounding: rounding,
                        size: size,
                        selected: context.knobs.boolean(label: 'Selected', initialValue: false),
                        disabled: context.knobs.boolean(label: 'Disabled', initialValue: false),
                        icon: showIcon ? const Icon(Icons.star) : null,
                        avatar: showAvatar
                            ? const MitumbaAvatar(
                                size: MitumbaAvatarSize.xs,
                                name: 'Alice',
                              )
                            : null,
                        badge: showBadge ? 42 : null,
                        onClick: () {},
                        onDelete: showDelete ? () {} : null,
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MitumbaTextField',
              useCases: [
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    final size = context.knobs.object.dropdown(
                      label: 'Size',
                      options: MitumbaTextFieldSize.values,
                      labelBuilder: (s) => s.name,
                      initialOption: MitumbaTextFieldSize.medium,
                    );
                    final rounding = context.knobs.object.dropdown(
                      label: 'Rounding',
                      options: MitumbaTextFieldRounding.values,
                      labelBuilder: (r) => r.name,
                      initialOption: MitumbaTextFieldRounding.rounded,
                    );
                    final status = context.knobs.objectOrNull.dropdown(
                      label: 'Validation Status',
                      options: MitumbaTextFieldStatus.values,
                      labelBuilder: (s) => s.name,
                    );

                    final showPrefix = context.knobs.boolean(label: 'Show Prefix Icon', initialValue: false);
                    final showSuffix = context.knobs.boolean(label: 'Show Suffix Icon', initialValue: false);
                    final isPassword = context.knobs.boolean(label: 'Obscure (Password)', initialValue: false);
                    final showEndButton = context.knobs.boolean(label: 'Show Integrated End Button', initialValue: false);

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MitumbaTextField(
                          label: context.knobs.stringOrNull(label: 'Label', initialValue: 'Search Items'),
                          hint: context.knobs.string(label: 'Placeholder Hint', initialValue: 'Type vintage jacket...'),
                          value: '',
                          onChange: (_) {},
                          size: size,
                          rounding: rounding,
                          status: status,
                          disabled: context.knobs.boolean(label: 'Disabled', initialValue: false),
                          readOnly: context.knobs.boolean(label: 'Read Only', initialValue: false),
                          multiline: context.knobs.boolean(label: 'Multiline', initialValue: false),
                          obscureText: isPassword,
                          prefix: showPrefix ? const Icon(Icons.search) : null,
                          suffix: showSuffix ? const Icon(Icons.info_outline) : null,
                          helperText: context.knobs.stringOrNull(label: 'Helper Text', initialValue: 'Type something to search'),
                          error: context.knobs.stringOrNull(label: 'Error Text'),
                          endButton: showEndButton
                              ? MitumbaPrimaryButton(
                                  label: 'SEARCH',
                                  size: size == MitumbaTextFieldSize.small
                                      ? ButtonSize.small
                                      : (size == MitumbaTextFieldSize.large
                                          ? ButtonSize.large
                                          : ButtonSize.medium),
                                  onPressed: () {},
                                )
                              : null,
                        ),
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
