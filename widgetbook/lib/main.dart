import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:mitumba_ui/mitumba_ui.dart';
import 'responsive_device_preview.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapping Widgetbook in a Theme widget with brand styling (Nunito font and brand primary colors)
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MitumbaColors.green,
          primary: MitumbaColors.green,
          secondary: MitumbaColors.earth,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Nunito',
      ),
      child: Widgetbook.material(
        directories: [
          WidgetbookCategory(
            name: 'Components',
            children: [
              WidgetbookCategory(
                name: 'Foundation',
                children: [
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
                  WidgetbookComponent(
                    name: 'MitumbaSelect',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          final size = context.knobs.object.dropdown(
                            label: 'Size',
                            options: MitumbaSelectSize.values,
                            labelBuilder: (s) => s.name,
                            initialOption: MitumbaSelectSize.medium,
                          );
                          final rounding = context.knobs.object.dropdown(
                            label: 'Rounding',
                            options: MitumbaSelectRounding.values,
                            labelBuilder: (r) => r.name,
                            initialOption: MitumbaSelectRounding.rounded,
                          );
                          final multiple = context.knobs.boolean(label: 'Multiple Selection', initialValue: false);
                          final showSearch = context.knobs.boolean(label: 'Show Search Input', initialValue: true);
                          final inverted = context.knobs.boolean(label: 'Inverted (Dark Menu)', initialValue: false);

                          final showStartIcon = context.knobs.boolean(label: 'Show Start Icon', initialValue: false);
                          final hasError = context.knobs.boolean(label: 'Show Error State', initialValue: false);

                          final selectOptions = [
                            const MitumbaSelectOption(value: 'nbo', label: 'Nairobi', subtitle: 'Capital city of Kenya', group: 'East Africa', icon: Icon(Icons.location_city)),
                            const MitumbaSelectOption(value: 'msa', label: 'Mombasa', subtitle: 'Coastal port city', group: 'East Africa', icon: Icon(Icons.beach_access)),
                            const MitumbaSelectOption(value: 'kla', label: 'Kampala', subtitle: 'Capital city of Uganda', group: 'East Africa', icon: Icon(Icons.location_city)),
                            const MitumbaSelectOption(value: 'dar', label: 'Dar es Salaam', subtitle: 'Coastal port city', group: 'East Africa', icon: Icon(Icons.beach_access), disabled: true),
                            const MitumbaSelectOption(value: 'lon', label: 'London', subtitle: 'Capital of UK', group: 'Europe', icon: Icon(Icons.cloud)),
                            const MitumbaSelectOption(value: 'par', label: 'Paris', subtitle: 'City of light', group: 'Europe', icon: Icon(Icons.favorite)),
                          ];

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaSelect(
                                label: context.knobs.stringOrNull(label: 'Label', initialValue: 'Shipment Destination'),
                                placeholder: context.knobs.string(label: 'Placeholder Hint', initialValue: 'Choose a city...'),
                                value: multiple ? const ['nbo'] : 'nbo',
                                options: selectOptions,
                                onChange: (_) {},
                                size: size,
                                rounding: rounding,
                                multiple: multiple,
                                showSearch: showSearch,
                                inverted: inverted,
                                disabled: context.knobs.boolean(label: 'Disabled', initialValue: false),
                                loading: context.knobs.boolean(label: 'Loading', initialValue: false),
                                startIcon: showStartIcon ? const Icon(Icons.map) : null,
                                error: hasError ? 'Please select a valid shipping zone' : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaGlass',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Panel',
                        builder: (context) {
                          final rounding = context.knobs.object.dropdown(
                            label: 'Rounding',
                            options: MitumbaGlassRounding.values,
                            labelBuilder: (r) => r.name,
                            initialOption: MitumbaGlassRounding.large,
                          );
                          final blur = context.knobs.double.slider(label: 'Blur sigmaX/Y', initialValue: 24, min: 0, max: 64);
                          final opacity = context.knobs.double.slider(label: 'Opacity', initialValue: 0.5, min: 0.0, max: 1.0);
                          final hasBorder = context.knobs.boolean(label: 'Border', initialValue: true);

                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: MitumbaGlass(
                                blur: blur,
                                opacity: opacity,
                                rounding: rounding,
                                border: hasBorder,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'GLASSMORPHISM',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: MitumbaColors.green,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Optical Depth Panel',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: MitumbaColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Experience high-end design aesthetics with real-time blur and light-leak shine overlays.',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14,
                                          color: MitumbaColors.textPrimary.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          MitumbaPrimaryButton(
                                            label: 'EXPLORE',
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 12),
                                          const MitumbaChip(label: 'PREMIUM'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                name: 'Marketplace',
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
                    name: 'STIScoreChip',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final score = context.knobs.int.slider(label: 'Score', initialValue: 85, min: 0, max: 100);
                          return Center(
                            child: STIScoreChip(score: score),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'STIBreakdownPanel',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final score = context.knobs.int.slider(label: 'Score', initialValue: 85, min: 0, max: 100);
                          final fulfillment = context.knobs.double.slider(label: 'Fulfillment Rate', initialValue: 0.96, min: 0.0, max: 1.0);
                          final accuracy = context.knobs.double.slider(label: 'Accuracy Rate', initialValue: 0.98, min: 0.0, max: 1.0);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                width: 340,
                                child: STIBreakdownPanel(
                                  score: score,
                                  fulfillmentRate: fulfillment,
                                  accuracyRate: accuracy,
                                  avgResponseHours: 1.5,
                                  daysActive: 140,
                                  recentEvents: const [
                                    STIEvent(
                                      type: 'positive',
                                      reason: 'Fast shipping on #2984',
                                      timestamp: '3 hours ago',
                                      pointsChange: 2,
                                    ),
                                    STIEvent(
                                      type: 'negative',
                                      reason: 'Late response on thread',
                                      timestamp: '1 day ago',
                                      pointsChange: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'StoreCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final name = context.knobs.string(label: 'Store Name', initialValue: 'Gikomba Luxury');
                          final subtitle = context.knobs.stringOrNull(label: 'Subtitle', initialValue: '12 active listings');
                          final hasClick = context.knobs.boolean(label: 'Actionable', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: StoreCard(
                                  name: name,
                                  subtitle: subtitle,
                                  onClick: hasClick ? () {} : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ListingCardSkeleton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => const Center(
                          child: SizedBox(
                            width: 200,
                            child: ListingCardSkeleton(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ListingImageGallery',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Gallery',
                        builder: (context) {
                          final hasImages = context.knobs.boolean(label: 'Has Images', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: ListingImageGallery(
                                  images: hasImages
                                      ? const [
                                          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
                                          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
                                          'https://images.unsplash.com/photo-1440133590402-88b9e67d4f9b?w=400',
                                        ]
                                      : const [],
                                  title: 'Vintage Sneakers',
                                ),
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
                name: 'Pages',
                children: [
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
                ],
              ),
              WidgetbookCategory(
                name: 'Navigation',
                children: [
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
                    name: 'MitumbaBreadcrumb',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaBreadcrumb(
                                items: [
                                  MitumbaBreadcrumbItem(label: 'Home', onTap: () {}),
                                  MitumbaBreadcrumbItem(label: 'Catalog', onTap: () {}),
                                  MitumbaBreadcrumbItem(label: 'Menswear', onTap: () {}),
                                  const MitumbaBreadcrumbItem(label: 'Jackets'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaPagination',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Pages',
                        builder: (context) {
                          final count = context.knobs.int.slider(label: 'Total Pages', initialValue: 10, min: 1, max: 20);
                          final active = context.knobs.int.slider(label: 'Active Page', initialValue: 4, min: 1, max: 20);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaPagination(
                                count: count,
                                page: active <= count ? active : count,
                                onChange: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaStepper',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Process',
                        builder: (context) {
                          final activeStep = context.knobs.int.slider(label: 'Active Step', initialValue: 1, min: 0, max: 2);
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                              child: MitumbaStepper(
                                activeStep: activeStep,
                                steps: const [
                                  MitumbaStepOption(label: 'Details', subtitle: 'Step 1'),
                                  MitumbaStepOption(label: 'Shipping', subtitle: 'Step 2'),
                                  MitumbaStepOption(label: 'Payment'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaTabs',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Tabs',
                        builder: (context) {
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant',
                            options: MitumbaTabsVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: MitumbaTabsVariant.primary,
                          );
                          final activeVal = context.knobs.object.dropdown(
                            label: 'Active Value',
                            options: const ['all', 'jackets', 'shoes'],
                            initialOption: 'all',
                          );

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaTabs(
                                value: activeVal,
                                variant: variant,
                                onChange: (_) {},
                                tabs: const [
                                  MitumbaTabOption(label: 'All Items', value: 'all', icon: Icon(Icons.grid_view)),
                                  MitumbaTabOption(label: 'Jackets', value: 'jackets', icon: Icon(Icons.checkroom)),
                                  MitumbaTabOption(label: 'Shoes', value: 'shoes', icon: Icon(Icons.shopping_bag_outlined)),
                                  MitumbaTabOption(label: 'Disabled Tab', value: 'disabled', disabled: true),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'TopNav',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Full Header',
                        builder: (context) {
                          final hasAnnouncement = context.knobs.boolean(label: 'Has Announcement', initialValue: true);
                          final cartCount = context.knobs.int.slider(label: 'Cart Items Count', initialValue: 3, min: 0, max: 10);
                          final isAuthenticated = context.knobs.boolean(label: 'Is Authenticated', initialValue: true);

                          return Align(
                            alignment: Alignment.topCenter,
                            child: TopNav(
                              announcement: hasAnnouncement ? const Text('Free delivery on orders above KES 5,000!') : null,
                              cartCount: cartCount,
                              isAuthenticated: isAuthenticated,
                              user: const TopNavUser(name: 'Isaac Stanley'),
                              links: const [
                                TopNavLink(label: 'Home', href: '/', active: true),
                                TopNavLink(label: 'Shop', href: '/shop'),
                                TopNavLink(label: 'About', href: '/about'),
                              ],
                              onSearchSubmit: (_) {},
                              onCartClick: () {},
                              onAuthClick: () {},
                              onProfileClick: () {},
                            ),
                          );
                        },
                      ),
                      WidgetbookUseCase(
                        name: 'Responsive Preview',
                        builder: (context) {
                          final hasAnnouncement = context.knobs.boolean(label: 'Has Announcement', initialValue: true);
                          final cartCount = context.knobs.int.slider(label: 'Cart Items Count', initialValue: 3, min: 0, max: 10);
                          final isAuthenticated = context.knobs.boolean(label: 'Is Authenticated', initialValue: true);

                          return ResponsiveDevicePreview(
                            builder: (context, constraints) => TopNav(
                              announcement: hasAnnouncement ? const Text('Free delivery on orders above KES 5,000!') : null,
                              cartCount: cartCount,
                              isAuthenticated: isAuthenticated,
                              user: const TopNavUser(name: 'Isaac Stanley'),
                              links: const [
                                TopNavLink(label: 'Home', href: '/', active: true),
                                TopNavLink(label: 'Shop', href: '/shop'),
                                TopNavLink(label: 'About', href: '/about'),
                              ],
                              onSearchSubmit: (_) {},
                              onCartClick: () {},
                              onAuthClick: () {},
                              onProfileClick: () {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Feedback',
                children: [
                  WidgetbookComponent(
                    name: 'MitumbaSkeleton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Variants',
                        builder: (context) {
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant',
                            options: MitumbaSkeletonVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: MitumbaSkeletonVariant.rounded,
                          );
                          final width = context.knobs.double.slider(label: 'Width', initialValue: 200, min: 20, max: 400);
                          final height = context.knobs.double.slider(label: 'Height', initialValue: 40, min: 10, max: 400);

                          return Center(
                            child: MitumbaSkeleton(
                              variant: variant,
                              width: width,
                              height: height,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaBanner',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final severity = context.knobs.object.dropdown(
                            label: 'Severity',
                            options: MitumbaBannerSeverity.values,
                            labelBuilder: (v) => v.name,
                            initialOption: MitumbaBannerSeverity.info,
                          );
                          final title = context.knobs.string(label: 'Title', initialValue: 'Payment in Escrow');
                          final message = context.knobs.stringOrNull(label: 'Message', initialValue: "KES 5,200 is securely held. We'll release it once you confirm delivery.");
                          final hasClose = context.knobs.boolean(label: 'Show Close Button', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaBanner(
                                title: title,
                                message: message,
                                severity: severity,
                                onClose: hasClose ? () {} : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaModal',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final title = context.knobs.string(label: 'Title', initialValue: 'Payment Processing');
                          final subtitle = context.knobs.stringOrNull(label: 'Subtitle', initialValue: 'Transacting with Mitumba Escrow');
                          final loading = context.knobs.boolean(label: 'Loading Overlay', initialValue: false);

                          return Center(
                            child: MitumbaModal(
                              title: title,
                              subtitle: subtitle,
                              loading: loading,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('This is the content within the MitumbaModal container.'),
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
                name: 'Layout',
                children: [
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
                    name: 'PageContainer',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final maxWidth = context.knobs.object.dropdown(
                            label: 'Max Width',
                            options: PageContainerMaxWidth.values,
                            labelBuilder: (w) => w.name,
                            initialOption: PageContainerMaxWidth.lg,
                          );
                          final noPadding = context.knobs.boolean(label: 'No Padding', initialValue: false);
                          return PageContainer(
                            maxWidth: maxWidth,
                            noPadding: noPadding,
                            child: Container(
                              color: MitumbaColors.greenLight,
                              height: 200,
                              alignment: Alignment.center,
                              child: Text(
                                'PageContainer Content Area (maxWidth: ${maxWidth.name})',
                                style: const TextStyle(color: MitumbaColors.green),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'SectionHeader',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          final align = context.knobs.object.dropdown(
                            label: 'Alignment',
                            options: SectionHeaderAlign.values,
                            labelBuilder: (a) => a.name,
                            initialOption: SectionHeaderAlign.left,
                          );
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant Scale',
                            options: SectionHeaderVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: SectionHeaderVariant.standard,
                          );
                          final hasOverline = context.knobs.boolean(label: 'Show Overline', initialValue: true);
                          final hasSubtitle = context.knobs.boolean(label: 'Show Subtitle', initialValue: true);
                          final hasAction = context.knobs.boolean(label: 'Show Action Button', initialValue: true);

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SectionHeader(
                              title: context.knobs.string(label: 'Title', initialValue: 'Vintage Outfits'),
                              subtitle: hasSubtitle ? context.knobs.string(label: 'Subtitle', initialValue: 'Browse through our premium, hand-picked vintage jackets and pants.') : null,
                              overline: hasOverline ? context.knobs.string(label: 'Overline', initialValue: 'New Arrivals') : null,
                              align: align,
                              variant: variant,
                              actionLabel: hasAction ? 'SEE ALL' : null,
                              onAction: () {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaDivider',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final orientation = context.knobs.object.dropdown(
                            label: 'Orientation',
                            options: MitumbaDividerOrientation.values,
                            labelBuilder: (o) => o.name,
                            initialOption: MitumbaDividerOrientation.horizontal,
                          );
                          final thickness = context.knobs.double.slider(label: 'Thickness', initialValue: 1.0, min: 1.0, max: 10.0);
                          final useBrandColor = context.knobs.boolean(label: 'Use Green Brand Color', initialValue: false);

                          return Center(
                            child: Container(
                              width: orientation == MitumbaDividerOrientation.horizontal ? 300 : 24,
                              height: orientation == MitumbaDividerOrientation.horizontal ? 24 : 300,
                              alignment: Alignment.center,
                              child: MitumbaDivider(
                                orientation: orientation,
                                thickness: thickness,
                                color: useBrandColor ? MitumbaColors.green : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaGrid',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Responsive Grid',
                        builder: (context) {
                          final colCountXs = context.knobs.int.input(label: 'XS Columns', initialValue: 2);
                          final colCountSm = context.knobs.int.input(label: 'SM Columns', initialValue: 3);
                          final colCountMd = context.knobs.int.input(label: 'MD Columns', initialValue: 4);
                          final colCountLg = context.knobs.int.input(label: 'LG Columns', initialValue: 6);
                          final customGap = context.knobs.double.slider(label: 'Custom Spacing Gap', initialValue: 16.0, min: 4.0, max: 32.0);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: MitumbaGrid(
                              gap: customGap,
                              columns: MitumbaGridColumns(
                                xs: colCountXs,
                                sm: colCountSm,
                                md: colCountMd,
                                lg: colCountLg,
                              ),
                              children: List.generate(12, (index) {
                                return Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: MitumbaColors.greenLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MitumbaColors.green),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cell $index',
                                    style: const TextStyle(color: MitumbaColors.green, fontWeight: FontWeight.bold),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ProfileCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Card',
                        builder: (context) {
                          final showSubtitle = context.knobs.boolean(label: 'Show Subtitle', initialValue: true);
                          final showRoles = context.knobs.boolean(label: 'Show Roles', initialValue: true);
                          final showAction = context.knobs.boolean(label: 'Show Action Button', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: ProfileCard(
                                  name: context.knobs.string(label: 'Name', initialValue: 'Isaac Stanley'),
                                  subtitle: showSubtitle ? context.knobs.string(label: 'Subtitle', initialValue: 'Verified Seller • Nairobi, KE') : null,
                                  avatarUrl: context.knobs.stringOrNull(label: 'Avatar URL', initialValue: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                                  roles: showRoles ? const [
                                    ProfileCardRole(label: 'Seller', color: 'primary'),
                                    ProfileCardRole(label: 'Vazi Stylist', color: 'secondary'),
                                  ] : const [],
                                  actionLabel: showAction ? 'EDIT PROFILE' : null,
                                  onAction: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ProfileNavList',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Menu List',
                        builder: (context) {
                          final badgeCount = context.knobs.int.slider(label: 'Messages Badge Count', initialValue: 4, min: 0, max: 10);
                          final hasClickable = context.knobs.boolean(label: 'Items Clickable', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 360,
                                child: ProfileNavList(
                                  items: [
                                    ProfileNavItem(
                                      label: 'My Orders',
                                      icon: const Icon(Icons.shopping_bag_outlined),
                                      onClick: hasClickable ? () {} : null,
                                    ),
                                    ProfileNavItem(
                                      label: 'Inbox Messages',
                                      icon: const Icon(Icons.mail_outline),
                                      onClick: hasClickable ? () {} : null,
                                      badge: badgeCount > 0 ? badgeCount : null,
                                    ),
                                    ProfileNavItem(
                                      label: 'Saved Looks',
                                      icon: const Icon(Icons.favorite_border),
                                      onClick: hasClickable ? () {} : null,
                                    ),
                                    ProfileNavItem(
                                      label: 'Help & Support',
                                      icon: const Icon(Icons.help_outline),
                                      onClick: hasClickable ? () {} : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'FormCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive Form Box',
                        builder: (context) {
                          final showIcon = context.knobs.boolean(label: 'Show Header Icon', initialValue: true);
                          final showSubtitle = context.knobs.boolean(label: 'Show Subtitle', initialValue: true);
                          final errorText = context.knobs.stringOrNull(label: 'Error Alert Text');

                          return Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: FormCard(
                                title: context.knobs.string(label: 'Title', initialValue: 'Verify Mobile Phone'),
                                subtitle: showSubtitle ? context.knobs.string(label: 'Subtitle', initialValue: 'We have sent a verification code to +254 712 *** 789.') : null,
                                icon: showIcon ? const Icon(Icons.sms_outlined) : null,
                                error: errorText,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MitumbaTextField(
                                      label: 'Verification Code',
                                      hint: 'Enter 6-digit code',
                                      value: '',
                                      onChange: (_) {},
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: MitumbaPrimaryButton(
                                        label: 'SUBMIT CODE',
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaErrorState',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          final type = context.knobs.object.dropdown(
                            label: 'Error Type',
                            options: MitumbaErrorType.values,
                            labelBuilder: (t) => t.name,
                            initialOption: MitumbaErrorType.general,
                          );
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant',
                            options: MitumbaErrorVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: MitumbaErrorVariant.standard,
                          );
                          return Center(
                            child: SizedBox(
                              width: 500,
                              child: MitumbaErrorState(
                                title: context.knobs.string(label: 'Title', initialValue: 'Connection Lost'),
                                subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'Check your network details.'),
                                type: type,
                                variant: variant,
                                onRetry: () {},
                                onBack: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaOfflineBanner',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return Center(
                            child: SizedBox(
                              width: 400,
                              child: MitumbaOfflineBanner(
                                isOffline: context.knobs.boolean(label: 'Is Offline', initialValue: true),
                                onRetry: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'DestructiveConfirmDialog',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final blockers = context.knobs.boolean(label: 'Has Blockers', initialValue: false)
                              ? ['You still have active payouts pending', 'There are unresolved buyer disputes']
                              : const <String>[];
                          return Center(
                            child: DestructiveConfirmDialog(
                              open: context.knobs.boolean(label: 'Open', initialValue: true),
                              onClose: () {},
                              title: context.knobs.string(label: 'Title', initialValue: 'Delete Shop permanently'),
                              description: context.knobs.string(label: 'Description', initialValue: 'This action is completely irreversible and deletes all shop catalog data.'),
                              confirmPhrase: context.knobs.string(label: 'Confirm Phrase', initialValue: 'DELETE'),
                              requireTotp: context.knobs.boolean(label: 'Require TOTP', initialValue: true),
                              blockers: blockers,
                              onConfirm: ({code}) async {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'VAZI AI Stylist',
                children: [
                  WidgetbookComponent(
                    name: 'VAZIBadge',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final size = context.knobs.object.dropdown(
                            label: 'Size',
                            options: VAZIBadgeSize.values,
                            labelBuilder: (s) => s.name,
                            initialOption: VAZIBadgeSize.small,
                          );
                          return Center(
                            child: VAZIBadge(size: size),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'VAZIOutfitCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final isMultiCity = context.knobs.boolean(label: 'Multi-City', initialValue: false);
                          final sellersCount = context.knobs.int.input(label: 'Sellers Count', initialValue: 2);
                          final price = context.knobs.int.input(label: 'Price (KES)', initialValue: 5400);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 320,
                                child: VAZIOutfitCard(
                                  outfitName: context.knobs.string(label: 'Outfit Name', initialValue: 'Weekend Brunch Chic'),
                                  items: const [
                                    VAZIOutfitItem(
                                      listingId: '1',
                                      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
                                      garmentType: 'top',
                                      priceKes: 1800,
                                      sellerName: 'Jacket Shop',
                                    ),
                                    VAZIOutfitItem(
                                      listingId: '2',
                                      imageUrl: 'https://images.unsplash.com/photo-1559551409-dadc959f76b8?w=400',
                                      garmentType: 'bottom',
                                      priceKes: 2200,
                                      sellerName: 'Denim Depot',
                                    ),
                                    VAZIOutfitItem(
                                      listingId: '3',
                                      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
                                      garmentType: 'shoes',
                                      priceKes: 1400,
                                      sellerName: 'Sneaker Head',
                                    ),
                                  ],
                                  totalPriceKes: price,
                                  sellersCount: sellersCount,
                                  isMultiCity: isMultiCity,
                                  onTap: () {},
                                  onBuyAll: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'VAZIOutfitCardSkeleton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 320,
                              child: VAZIOutfitCardSkeleton(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'VAZIFeedSection',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Grid Feed',
                        builder: (context) {
                          final loading = context.knobs.boolean(label: 'Loading Skeletons', initialValue: false);

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: VAZIFeedSection(
                                loading: loading,
                                outfits: [
                                  VAZIOutfitCard(
                                    outfitName: 'Weekend Chill',
                                    items: const [
                                      VAZIOutfitItem(
                                        listingId: '1',
                                        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
                                        garmentType: 'top',
                                        priceKes: 1800,
                                        sellerName: 'Shop A',
                                      ),
                                    ],
                                    totalPriceKes: 1800,
                                    sellersCount: 1,
                                    onTap: () {},
                                  ),
                                  VAZIOutfitCard(
                                    outfitName: 'Street Vibe',
                                    items: const [
                                      VAZIOutfitItem(
                                        listingId: '2',
                                        imageUrl: 'https://images.unsplash.com/photo-1559551409-dadc959f76b8?w=400',
                                        garmentType: 'bottom',
                                        priceKes: 2200,
                                        sellerName: 'Shop B',
                                      ),
                                    ],
                                    totalPriceKes: 2200,
                                    sellersCount: 1,
                                    onTap: () {},
                                  ),
                                ],
                                onSeeAll: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'CompleteThisLookPanel',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Recommendations',
                        builder: (context) {
                          final loading = context.knobs.boolean(label: 'Loading Skeletons', initialValue: false);

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CompleteThisLookPanel(
                                loading: loading,
                                outfits: [
                                  VAZIOutfitCard(
                                    outfitName: 'Chic Style',
                                    items: const [
                                      VAZIOutfitItem(
                                        listingId: '1',
                                        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
                                        garmentType: 'top',
                                        priceKes: 2000,
                                        sellerName: 'Shop C',
                                      ),
                                    ],
                                    totalPriceKes: 2000,
                                    sellersCount: 1,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'VAZIShowcase',
                    useCases: [
                      WidgetbookUseCase(
                        name: '3D Feed',
                        builder: (context) {
                          return VAZIShowcase(
                            outfits: [
                              VAZIShowcaseOutfit(
                                id: 'o1',
                                modelMediaUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
                                modelMediaType: VAZIMediaType.image,
                                items: const [
                                  VAZIShowcaseItem(
                                    id: 'i1',
                                    title: 'Over-sized Graphic Tee',
                                    price: 1800,
                                    imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=200',
                                  ),
                                  VAZIShowcaseItem(
                                    id: 'i2',
                                    title: 'Cuffed Cargo Trousers',
                                    price: 3000,
                                    imageUrl: 'https://images.unsplash.com/photo-1559551409-dadc959f76b8?w=200',
                                  ),
                                ],
                                totalPrice: 4800,
                              ),
                              VAZIShowcaseOutfit(
                                id: 'o2',
                                modelMediaUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
                                modelMediaType: VAZIMediaType.image,
                                items: const [
                                  VAZIShowcaseItem(
                                    id: 'i3',
                                    title: 'Floral Summer Dress',
                                    price: 3200,
                                    imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=200',
                                  ),
                                  VAZIShowcaseItem(
                                    id: 'i4',
                                    title: 'Vintage Leather Sandals',
                                    price: 2000,
                                    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
                                  ),
                                ],
                                totalPrice: 5200,
                              ),
                            ],
                            onItemClick: (_) {},
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'VAZIHeroSpotlight',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Featured Models',
                        builder: (context) {
                          final title = context.knobs.string(label: 'Title', initialValue: 'VAZI Featured');

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: VAZIHeroSpotlight(
                              title: title,
                              outfits: const [
                                VAZIHeroOutfit(
                                  id: 'outfit-1',
                                  modelMediaUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
                                  modelMediaType: 'image',
                                  modelAlt: 'Summer look',
                                  name: 'Summer Breeze Look',
                                  totalPrice: 4500,
                                  items: [
                                    VAZIShowcaseItem(id: 'item-1', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100', price: 2000, title: 'Shirt'),
                                    VAZIShowcaseItem(id: 'item-2', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=100', price: 2500, title: 'Pants'),
                                  ],
                                ),
                                VAZIHeroOutfit(
                                  id: 'outfit-2',
                                  modelMediaUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400',
                                  modelMediaType: 'image',
                                  modelAlt: 'Urban style',
                                  name: 'Streetwear Fusion',
                                  totalPrice: 6200,
                                  items: [
                                    VAZIShowcaseItem(id: 'item-3', imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=100', price: 3200, title: 'Jacket'),
                                    VAZIShowcaseItem(id: 'item-4', imageUrl: 'https://images.unsplash.com/photo-1559551409-dadc959f76b8?w=100', price: 3000, title: 'Sneakers'),
                                  ],
                                ),
                              ],
                              onShopLook: (_) {},
                              onItemClick: (_) {},
                              onSeeAll: () {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Data Visualizations',
                children: [
                  WidgetbookComponent(
                    name: 'StatsCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Variants',
                        builder: (context) {
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant',
                            options: StatsCardVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: StatsCardVariant.standard,
                          );
                          final trendDirection = context.knobs.object.dropdown(
                            label: 'Trend Direction',
                            options: const ['up', 'down', 'neutral'],
                            initialOption: 'up',
                          );
                          final showTrend = context.knobs.boolean(label: 'Show Trend', initialValue: true);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 280,
                                child: StatsCard(
                                  label: context.knobs.string(label: 'Label', initialValue: 'Total Sales'),
                                  value: context.knobs.string(label: 'Value', initialValue: '124,500'),
                                  unit: context.knobs.string(label: 'Unit', initialValue: 'KES'),
                                  icon: const Icon(Icons.show_chart),
                                  variant: variant,
                                  trend: showTrend
                                      ? StatsCardTrend(
                                          direction: trendDirection,
                                          percent: 18.0,
                                          label: 'vs last week',
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ActivityFeed',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Timeline',
                        builder: (context) {
                          final variant = context.knobs.object.dropdown(
                            label: 'Variant',
                            options: ActivityFeedVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: ActivityFeedVariant.standard,
                          );
                          final showTimeline = context.knobs.boolean(label: 'Show Timeline Line', initialValue: true);
                          final loading = context.knobs.boolean(label: 'Loading Skeletons', initialValue: false);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: ActivityFeed(
                              loading: loading,
                              variant: variant,
                              showTimeline: showTimeline,
                              events: const [
                                ActivityEvent(
                                  id: '1',
                                  type: ActivityType.order,
                                  title: 'Order Completed',
                                  subtitle: 'Seller shipped order #8492 via G4S.',
                                  timestamp: '2 min ago',
                                ),
                                ActivityEvent(
                                  id: '2',
                                  type: ActivityType.sti_change,
                                  title: 'STI Rating Increased',
                                  subtitle: 'Seller rating rose to 9.2/10!',
                                  timestamp: '1 hour ago',
                                ),
                                ActivityEvent(
                                  id: '3',
                                  type: ActivityType.payout,
                                  title: 'Payout Disbursed',
                                  subtitle: 'M-PESA transaction of KES 8,400 completed.',
                                  timestamp: '1 day ago',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Selections',
                children: [
                  WidgetbookComponent(
                    name: 'MitumbaDatePicker',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Shipping Date');
                          final hint = context.knobs.string(label: 'Hint', initialValue: 'Pick date');
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 280,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return MitumbaDatePicker(
                                      value: DateTime.now(),
                                      label: label,
                                      hint: hint,
                                      disabled: disabled,
                                      onChange: (_) {},
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaCheckbox',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Agree to terms and conditions');
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
                          final indeterminate = context.knobs.boolean(label: 'Indeterminate', initialValue: false);

                          return Center(
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return MitumbaCheckbox(
                                  checked: context.knobs.boolean(label: 'Checked State', initialValue: false),
                                  label: label,
                                  disabled: disabled,
                                  indeterminate: indeterminate,
                                  onChange: (val) {},
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaRadio',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Select Option');
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

                          return Center(
                            child: MitumbaRadio(
                              selected: context.knobs.boolean(label: 'Selected State', initialValue: true),
                              value: 'value',
                              label: label,
                              disabled: disabled,
                              onChange: (_) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaSwitch',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Toggle Dark Mode');
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

                          return Center(
                            child: MitumbaSwitch(
                              on: context.knobs.boolean(label: 'Switch State', initialValue: false),
                              label: label,
                              disabled: disabled,
                              onChange: (_) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaSlider',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Single Value',
                        builder: (context) {
                          final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Volume Level');
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
                          final stepValue = context.knobs.double.slider(label: 'Step', initialValue: 1.0, min: 1.0, max: 10.0);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaSlider(
                                value: context.knobs.double.slider(label: 'Slider Value', initialValue: 45.0, min: 0.0, max: 100.0),
                                label: label,
                                disabled: disabled,
                                step: stepValue,
                                onChange: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                      WidgetbookUseCase(
                        name: 'Range Values',
                        builder: (context) {
                          final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MitumbaSlider(
                                rangeValue: const RangeValues(25.0, 75.0),
                                min: 0.0,
                                max: 100.0,
                                label: 'Price Bounds (KES)',
                                disabled: disabled,
                                onChange: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'StylePicker',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Grid Picker',
                        builder: (context) {
                          final cols = context.knobs.int.input(label: 'Columns', initialValue: 2);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: StylePicker(
                              title: 'Navigation Layout',
                              subtitle: 'Select your preferred main header visual styling.',
                              value: 'top',
                              columns: cols,
                              options: const [
                                StylePickerOption(
                                  id: 'top',
                                  label: 'Top Nav Standard',
                                  description: 'Static horizontal navigation header',
                                  preview: Center(child: Text('Top Nav')),
                                ),
                                StylePickerOption(
                                  id: 'sidebar',
                                  label: 'Sidebar Collapsible',
                                  description: 'Slide-out vertical panel',
                                  preview: Center(child: Text('Sidebar Nav')),
                                ),
                              ],
                              onChange: (_) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Commerce',
                children: [
                  WidgetbookComponent(
                    name: 'PriceTag',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final price = context.knobs.double.slider(label: 'Price (KES)', initialValue: 4500, min: 0, max: 100000);
                          final strikethrough = context.knobs.boolean(label: 'Strikethrough', initialValue: false);
                          final size = context.knobs.object.dropdown(
                            label: 'Size',
                            options: ['small', 'medium', 'large'],
                            initialOption: 'medium',
                          );
                          final color = context.knobs.object.dropdown(
                            label: 'Color',
                            options: ['default', 'green', 'earth'],
                            initialOption: 'default',
                          );

                          return Center(
                            child: PriceTag(
                              priceKes: price,
                              size: size,
                              color: color,
                              strikethrough: strikethrough,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'DeliveryBadge',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final type = context.knobs.object.dropdown(
                            label: 'Type',
                            options: ['same-city', 'intercity'],
                            initialOption: 'same-city',
                          );
                          final days = context.knobs.stringOrNull(label: 'Estimated Days', initialValue: '1-2 days');

                          return Center(
                            child: DeliveryBadge(
                              type: type,
                              estimatedDays: days,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'EscrowStatusBanner',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final status = context.knobs.object.dropdown(
                            label: 'Status',
                            options: EscrowStatus.values,
                            labelBuilder: (s) => s.name,
                            initialOption: EscrowStatus.funded,
                          );
                          final amount = context.knobs.double.slider(label: 'Amount (KES)', initialValue: 5200, min: 0, max: 50000);
                          final hours = context.knobs.int.slider(label: 'Hours Remaining', initialValue: 18, min: 1, max: 72);

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: EscrowStatusBanner(
                                status: status,
                                amountKes: amount,
                                hoursRemaining: hours,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'CartItem',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final qty = context.knobs.int.slider(label: 'Qty', initialValue: 1, min: 1, max: 10);
                          final size = context.knobs.string(label: 'Selected Size', initialValue: 'M');

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: CartItem(
                                  imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
                                  title: 'Vintage Denim Jacket',
                                  subtitle: 'Blue / Stonewash',
                                  status: 'IN STOCK',
                                  priceKes: 3200,
                                  size: size,
                                  availableSizes: const ['S', 'M', 'L'],
                                  quantity: qty,
                                  onRemove: () {},
                                  onQuantityChange: (_) {},
                                  onSizeChange: (_) {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'RaiseDisputeModal',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final orderId = context.knobs.string(label: 'Order ID', initialValue: '29841');
                          final submitting = context.knobs.boolean(label: 'Submitting State', initialValue: false);

                          return Center(
                            child: RaiseDisputeModal(
                              orderShortId: orderId,
                              submitting: submitting,
                              onSubmit: (_) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'DisputeEvidenceGallery',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return const SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            child: DisputeEvidenceGallery(
                              evidence: [
                                DisputeEvidenceItem(
                                  type: 'image',
                                  content: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100',
                                  uploaderRole: UploaderRole.buyer,
                                  createdAt: '3 hours ago',
                                ),
                                DisputeEvidenceItem(
                                  type: 'text',
                                  content: 'Package arrived open with item missing.',
                                  uploaderRole: UploaderRole.buyer,
                                  createdAt: '3 hours ago',
                                ),
                                DisputeEvidenceItem(
                                  type: 'text',
                                  content: 'Double-sealed bag dispatched via rider.',
                                  uploaderRole: UploaderRole.seller,
                                  createdAt: '1 hour ago',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'SellerDisputeResponseCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final reason = context.knobs.string(label: 'Reason', initialValue: 'Damaged Item');
                          final desc = context.knobs.string(label: 'Description', initialValue: 'The buyer claims the jacket is ripped.');
                          final submitting = context.knobs.boolean(label: 'Submitting State', initialValue: false);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: SellerDisputeResponseCard(
                              reason: reason,
                              description: desc,
                              submitting: submitting,
                              onAccept: () {},
                              onContest: (_, __) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'OrderSummaryCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final total = context.knobs.double.slider(label: 'Total (KES)', initialValue: 6200, min: 0, max: 20000);
                          final label = context.knobs.string(label: 'Action Label', initialValue: 'Checkout');
                          final loading = context.knobs.boolean(label: 'Loading State', initialValue: false);
                          final trustLine = context.knobs.stringOrNull(label: 'Trust Line', initialValue: 'Escrow Protected Payment');

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: OrderSummaryCard(
                                  items: const [
                                    OrderSummaryItem(label: 'Subtotal', amountKes: 6400),
                                    OrderSummaryItem(label: 'Delivery', amountKes: 300),
                                    OrderSummaryItem(label: 'Discounts', amountKes: 500, isDiscount: true),
                                  ],
                                  totalKes: total,
                                  actionLabel: label,
                                  onAction: () {},
                                  loading: loading,
                                  trustLine: trustLine,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'OrderCard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          final title = context.knobs.string(label: 'Title', initialValue: 'Vintage Denim Set + Boots');
                          final price = context.knobs.double.slider(label: 'Total (KES)', initialValue: 7400, min: 0, max: 20000);
                          final delivery = context.knobs.double.slider(label: 'Delivery Fee (KES)', initialValue: 350, min: 0, max: 1000);
                          final status = context.knobs.object.dropdown(
                            label: 'Status',
                            options: OrderCardStatus.values,
                            labelBuilder: (s) => s.name,
                            initialOption: OrderCardStatus.shipped,
                          );

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 340,
                                child: OrderCard(
                                  orderShortId: 'tr894',
                                  title: title,
                                  imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
                                  totalKes: price,
                                  deliveryFeeKes: delivery,
                                  status: status,
                                  createdAt: '2 days ago',
                                  onClick: () {},
                                ),
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
                name: 'Forms',
                children: [
                  WidgetbookComponent(
                    name: 'MitumbaPhoneInput',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          return Center(
                            child: SizedBox(
                              width: 320,
                              child: MitumbaPhoneInput(
                                value: context.knobs.string(label: 'Value', initialValue: '712345678'),
                                onChanged: (val) {},
                                label: context.knobs.stringOrNull(label: 'Label', initialValue: 'Phone Number'),
                                error: context.knobs.stringOrNull(label: 'Error', initialValue: null),
                                disabled: context.knobs.boolean(label: 'Disabled', initialValue: false),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaOTPInput',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          return Center(
                            child: MitumbaOTPInput(
                              value: context.knobs.string(label: 'Initial Value (6 chars)', initialValue: ''),
                              onChanged: (val) {},
                              onComplete: (otp) {},
                              error: context.knobs.boolean(label: 'Error Shake', initialValue: false),
                              loading: context.knobs.boolean(label: 'Loading', initialValue: false),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaImageUploader',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          final maxImages = context.knobs.double.slider(label: 'Max Images', initialValue: 6, min: 1, max: 12).toInt();
                          final variant = context.knobs.object.dropdown(
                            label: 'Layout Mode',
                            options: ImageUploaderVariant.values,
                            labelBuilder: (v) => v.name,
                            initialOption: ImageUploaderVariant.grid,
                          );
                          return Center(
                            child: SizedBox(
                              width: 400,
                              child: MitumbaImageUploader(
                                images: const [
                                  UploadedImage(id: '1', url: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100', status: UploadedImageStatus.done, isPrimary: true),
                                  UploadedImage(id: '2', url: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=100', status: UploadedImageStatus.uploading, isPrimary: false),
                                  UploadedImage(id: '3', url: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=100', status: UploadedImageStatus.error, isPrimary: false),
                                ],
                                maxImages: maxImages,
                                variant: variant,
                                onAddTap: () {},
                                onRemove: (_) {},
                                onReorder: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'MitumbaSearchBar',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Interactive',
                        builder: (context) {
                          return Center(
                            child: SizedBox(
                              width: 360,
                              child: MitumbaSearchBar(
                                value: context.knobs.string(label: 'Value', initialValue: ''),
                                onChanged: (val) {},
                                onSubmit: (q) {},
                                placeholder: context.knobs.string(label: 'Placeholder', initialValue: 'Search items...'),
                                suggestions: const ['Nike shoes', 'Vintage jacket', 'Levi Jeans'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'AddAddressModal',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return Center(
                            child: AddAddressModal(
                              open: context.knobs.boolean(label: 'Open', initialValue: true),
                              onClose: () {},
                              onSave: (_) {},
                              saving: context.knobs.boolean(label: 'Saving', initialValue: false),
                              error: context.knobs.stringOrNull(label: 'Save Error', initialValue: null),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'TwoFactorMethodList',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return Center(
                            child: SizedBox(
                              width: 400,
                              child: TwoFactorMethodList(
                                methods: const [
                                  TwoFactorMethodView(id: '1', type: TwoFactorMethodType.totp, label: 'Google Authenticator', enabled: true, isPrimary: true, pending: false, lastUsedAt: '2 hours ago'),
                                  TwoFactorMethodView(id: '2', type: TwoFactorMethodType.sms, label: '+254 712 *** 678', enabled: false, isPrimary: false, pending: true),
                                ],
                                loading: context.knobs.boolean(label: 'Loading', initialValue: false),
                                onAdd: () {},
                                onEnable: (_) {},
                                onDisable: (_) {},
                                onDelete: (_) {},
                                onSetPrimary: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'AddTwoFactorMethodModal',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) {
                          return Center(
                            child: AddTwoFactorMethodModal(
                              open: context.knobs.boolean(label: 'Open', initialValue: true),
                              onClose: () {},
                              availableTypes: const [TwoFactorMethodType.totp, TwoFactorMethodType.passkey, TwoFactorMethodType.sms],
                              onSelectType: (_) {},
                            ),
                          );
                        },
                      ),
                    ],
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
          MaterialThemeAddon(
            themes: [
              WidgetbookTheme(
                name: 'Mitumba Light',
                data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: MitumbaColors.green,
                    primary: MitumbaColors.green,
                    secondary: MitumbaColors.earth,
                    brightness: Brightness.light,
                  ),
                  fontFamily: 'Nunito',
                ),
              ),
              WidgetbookTheme(
                name: 'Mitumba Dark',
                data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: MitumbaColors.green,
                    primary: MitumbaColors.green,
                    secondary: MitumbaColors.earth,
                    brightness: Brightness.dark,
                  ),
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          ViewportAddon([
            IosViewports.iPhone13,
            AndroidViewports.samsungGalaxyA50,
            IosViewports.iPadAir4,
          ]),
        ],
      ),
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
