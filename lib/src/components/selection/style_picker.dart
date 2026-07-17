import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

/// Individual option representing a selectable theme/layout/variant in [StylePicker].
class StylePickerOption {
  const StylePickerOption({
    required this.id,
    required this.label,
    this.description,
    required this.preview,
  });

  /// Unique identifier of the option.
  final String id;

  /// Human-readable label.
  final String label;

  /// Detailed subtext descriptor.
  final String? description;

  /// Miniature visualization/preview widget.
  final Widget preview;
}

/// StylePicker — generic visual variant selector displaying mini-previews.
class StylePicker extends StatelessWidget {
  const StylePicker({
    super.key,
    required this.options,
    required this.value,
    required this.onChange,
    this.title,
    this.subtitle,
    this.columns = 2,
  });

  /// Selection options.
  final List<StylePickerOption> options;

  /// Currently selected option ID.
  final String value;

  /// Callback fired immediately upon clicking an option card.
  final ValueChanged<String> onChange;

  /// Header title text.
  final String? title;

  /// Header subtext.
  final String? subtitle;

  /// Grid column configurations.
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header info
        if (title != null || subtitle != null) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeBase,
                    fontWeight: FontWeight.w700,
                    color: MitumbaColors.textPrimary,
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
          const SizedBox(height: 20),
        ],

        // Grid builder layout
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final int columnsCount = width < 600 ? 1 : columns;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnsCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4, // ratio of card width to height
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return _StylePickerCard(
                  option: option,
                  isSelected: value == option.id,
                  onSelect: () => onChange(option.id),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _StylePickerCard extends StatefulWidget {
  const _StylePickerCard({
    required this.option,
    required this.isSelected,
    required this.onSelect,
  });

  final StylePickerOption option;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  State<_StylePickerCard> createState() => _StylePickerCardState();
}

class _StylePickerCardState extends State<_StylePickerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.isSelected
        ? MitumbaColors.green
        : (_isHovered ? MitumbaColors.green : MitumbaColors.border);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onSelect,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isSelected ? MitumbaColors.greenLight : MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            border: Border.all(
              color: borderColor,
              width: 2.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Preview Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: MitumbaColors.background,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.scale(
                        scale: 0.85,
                        alignment: Alignment.bottomCenter,
                        child: widget.option.preview,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: widget.isSelected ? MitumbaColors.green : MitumbaColors.divider,
              ),

              // Description and title footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.option.label,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeSm,
                              fontWeight: FontWeight.w700,
                              color: MitumbaColors.textPrimary,
                              height: 1.1,
                            ),
                          ),
                          if (widget.option.description != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.option.description!,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 10,
                                color: MitumbaColors.textSecondary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.isSelected) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_circle,
                        color: MitumbaColors.green,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
