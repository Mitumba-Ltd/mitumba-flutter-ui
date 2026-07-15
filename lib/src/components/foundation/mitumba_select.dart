import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

enum MitumbaSelectSize { small, medium, large }
enum MitumbaSelectRounding { pill, rounded, square }

/// Technical representation of a selectable option.
class MitumbaSelectOption {
  const MitumbaSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.group,
    this.disabled = false,
  });

  /// Technical value for the option.
  final dynamic value;

  /// Primary display text.
  final String label;

  /// Secondary supporting text.
  final String? subtitle;

  /// Leading icon.
  final Widget? icon;

  /// Optional grouping label.
  final String? group;

  /// Whether the option is disabled.
  final bool disabled;
}

/// A premium, living Select/Dropdown primitive with precision scaling and rich menu picker.
class MitumbaSelect extends StatefulWidget {
  const MitumbaSelect({
    super.key,
    required this.value,
    this.name,
    this.label,
    this.placeholder,
    required this.options,
    required this.onChange,
    this.size = MitumbaSelectSize.medium,
    this.rounding = MitumbaSelectRounding.rounded,
    this.multiple = false,
    this.loading = false,
    this.error,
    this.disabled = false,
    this.showSearch = false,
    this.inverted = false,
    this.startIcon,
    this.displayValue,
  });

  /// Selected value(s). Can be a List for multiple selection, or a single value.
  final dynamic value;

  /// Technical name.
  final String? name;

  /// Label text displayed above the select field.
  final String? label;

  /// Placeholder when no value is selected.
  final String? placeholder;

  /// Array of selectable options.
  final List<MitumbaSelectOption> options;

  /// Called when selection changes.
  final ValueChanged<dynamic> onChange;

  /// Scale standard: small(32), medium(42), large(52).
  final MitumbaSelectSize size;

  /// Corner geometry: pill, rounded, square.
  final MitumbaSelectRounding rounding;

  /// Whether multiple values can be selected.
  final bool multiple;

  /// Shows a loading indicator.
  final bool loading;

  /// Shows an error message below the field.
  final String? error;

  /// Prevents user interaction.
  final bool disabled;

  /// Support for a search field inside the menu picker.
  final bool showSearch;

  /// Support for a high-contrast dark menu picker.
  final bool inverted;

  /// Leading icon.
  final Widget? startIcon;

  /// Manual override for the value display text.
  final String? displayValue;

  @override
  State<MitumbaSelect> createState() => _MitumbaSelectState();
}

class _MitumbaSelectState extends State<MitumbaSelect> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Basic setup for structure — to be refined in subsequent commits
    final height = widget.size == MitumbaSelectSize.small
        ? 32.0
        : (widget.size == MitumbaSelectSize.large ? 52.0 : 42.0);

    double radiusValue = MitumbaRadius.md;
    if (widget.rounding == MitumbaSelectRounding.pill) {
      radiusValue = MitumbaRadius.full;
    } else if (widget.rounding == MitumbaSelectRounding.square) {
      radiusValue = MitumbaRadius.xs;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              widget.label!.toUpperCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        InkWell(
          onTap: widget.disabled || widget.loading ? null : () {},
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radiusValue),
              border: Border.all(color: MitumbaColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (widget.startIcon != null) ...[
                  widget.startIcon!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.displayValue ?? widget.placeholder ?? 'Select Option',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
