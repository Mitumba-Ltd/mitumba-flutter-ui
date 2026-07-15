import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

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
  bool _isOpen = false;

  void _showOptionsPicker() async {
    setState(() => _isOpen = true);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.inverted ? MitumbaColors.backgroundDark : MitumbaColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(MitumbaRadius.lg)),
      ),
      builder: (context) {
        return _MitumbaSelectMenuSheet(
          initialValue: widget.value,
          options: widget.options,
          multiple: widget.multiple,
          showSearch: widget.showSearch,
          inverted: widget.inverted,
          placeholder: widget.placeholder,
          onApply: (newVal) {
            widget.onChange(newVal);
            Navigator.pop(context);
          },
        );
      },
    );
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;
    final isClickable = !widget.disabled && !widget.loading;

    final double height = widget.size == MitumbaSelectSize.small
        ? 32.0
        : (widget.size == MitumbaSelectSize.large ? 52.0 : 42.0);
    final double fontSize = widget.size == MitumbaSelectSize.small ? 12.0 : (widget.size == MitumbaSelectSize.large ? 16.0 : 14.0);
    final double iconSize = widget.size == MitumbaSelectSize.small ? 18.0 : (widget.size == MitumbaSelectSize.large ? 24.0 : 20.0);

    double radiusValue = MitumbaRadius.md;
    if (widget.rounding == MitumbaSelectRounding.pill) {
      radiusValue = MitumbaRadius.full;
    } else if (widget.rounding == MitumbaSelectRounding.square) {
      radiusValue = MitumbaRadius.xs;
    }

    Color activeBorderColor = MitumbaColors.divider;
    if (hasError) {
      activeBorderColor = MitumbaColors.error;
    } else if (_isOpen) {
      activeBorderColor = MitumbaColors.green;
    }

    final double borderWidth = (hasError || _isOpen) ? 2.0 : 1.0;

    final hasValue = widget.value != null &&
        (widget.multiple
            ? (widget.value is List && (widget.value as List).isNotEmpty)
            : (widget.value is! List && widget.value != ''));

    Widget renderDisplay() {
      if (widget.displayValue != null) {
        return Text(
          widget.displayValue!,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: MitumbaColors.textPrimary,
          ),
        );
      }

      if (!hasValue) {
        return Text(
          widget.placeholder ?? 'Select option',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: MitumbaColors.textDisabled,
          ),
        );
      }

      if (widget.multiple) {
        final count = (widget.value as List).length;
        return Text(
          'Selected $count items',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: MitumbaColors.textPrimary,
          ),
        );
      }

      final option = widget.options.firstWhere(
        (opt) => opt.value == widget.value,
        orElse: () => MitumbaSelectOption(value: widget.value, label: widget.value.toString()),
      );

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (option.icon != null) ...[
            IconTheme(
              data: IconThemeData(color: MitumbaColors.textSecondary, size: iconSize),
              child: option.icon!,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            option.label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: MitumbaColors.textPrimary,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: EdgeInsets.only(
              bottom: 4,
              left: widget.rounding == MitumbaSelectRounding.pill ? 16 : 8,
            ),
            child: Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: hasError ? MitumbaColors.error : MitumbaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        GestureDetector(
          onTap: isClickable ? _showOptionsPicker : null,
          child: Opacity(
            opacity: widget.disabled ? 0.5 : 1.0,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: widget.disabled ? MitumbaColors.background : MitumbaColors.surface,
                borderRadius: BorderRadius.circular(radiusValue),
                border: Border.all(color: activeBorderColor, width: borderWidth),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.rounding == MitumbaSelectRounding.pill ? 16 : 12,
              ),
              child: Row(
                children: [
                  if (widget.startIcon != null) ...[
                    IconTheme(
                      data: IconThemeData(color: MitumbaColors.textSecondary, size: iconSize),
                      child: widget.startIcon!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: renderDisplay()),
                  if (widget.loading) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          hasError ? MitumbaColors.error : MitumbaColors.green,
                        ),
                      ),
                    ),
                  ] else ...[
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: _isOpen ? MitumbaColors.green : MitumbaColors.textSecondary,
                        size: iconSize,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: widget.rounding == MitumbaSelectRounding.pill ? 16 : 8,
            ),
            child: Text(
              widget.error!,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MitumbaColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MitumbaSelectMenuSheet extends StatefulWidget {
  const _MitumbaSelectMenuSheet({
    required this.initialValue,
    required this.options,
    required this.multiple,
    required this.showSearch,
    required this.inverted,
    required this.onApply,
    this.placeholder,
  });

  final dynamic initialValue;
  final List<MitumbaSelectOption> options;
  final bool multiple;
  final bool showSearch;
  final bool inverted;
  final String? placeholder;
  final ValueChanged<dynamic> onApply;

  @override
  State<_MitumbaSelectMenuSheet> createState() => _MitumbaSelectMenuSheetState();
}

class _MitumbaSelectMenuSheetState extends State<_MitumbaSelectMenuSheet> {
  late dynamic _currentValue;
  String _searchTerm = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.multiple) {
      _currentValue = widget.initialValue is List
          ? List.from(widget.initialValue)
          : (widget.initialValue != null ? [widget.initialValue] : []);
    } else {
      _currentValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onOptionTapped(MitumbaSelectOption option) {
    if (option.disabled) return;
    if (widget.multiple) {
      setState(() {
        final list = _currentValue as List;
        if (list.contains(option.value)) {
          list.remove(option.value);
        } else {
          list.add(option.value);
        }
      });
    } else {
      widget.onApply(option.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeText = widget.inverted ? MitumbaColors.white : MitumbaColors.textPrimary;
    final themeSecondary = widget.inverted ? MitumbaColors.textDisabled : MitumbaColors.textSecondary;

    final filtered = widget.options.where((opt) {
      if (_searchTerm.isEmpty) return true;
      return opt.label.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          (opt.subtitle?.toLowerCase().contains(_searchTerm.toLowerCase()) ?? false);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: widget.inverted ? MitumbaColors.textSecondary : MitumbaColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (widget.showSearch) ...[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _searchTerm = val),
                  style: TextStyle(color: themeText, fontFamily: 'Nunito'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: themeSecondary),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: themeSecondary, fontFamily: 'Nunito'),
                    isDense: true,
                    filled: true,
                    fillColor: widget.inverted ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.03),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No options found',
                        style: TextStyle(color: themeSecondary, fontFamily: 'Nunito'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final option = filtered[index];
                        final isSelected = widget.multiple
                            ? (_currentValue as List).contains(option.value)
                            : _currentValue == option.value;

                        final List<Widget> itemWidgets = [];

                        final hasGroupHeader = option.group != null &&
                            (index == 0 || filtered[index - 1].group != option.group);

                        if (hasGroupHeader) {
                          itemWidgets.add(
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
                              child: Text(
                                option.group!.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: themeSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          );
                        }

                        itemWidgets.add(
                          InkWell(
                            onTap: option.disabled ? null : () => _onOptionTapped(option),
                            child: Opacity(
                              opacity: option.disabled ? 0.4 : 1.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                color: isSelected
                                    ? (widget.inverted ? Colors.white.withOpacity(0.08) : MitumbaColors.green.withOpacity(0.08))
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    if (widget.multiple) ...[
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: option.disabled
                                            ? null
                                            : (_) => _onOptionTapped(option),
                                        activeColor: MitumbaColors.green,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    if (option.icon != null) ...[
                                      IconTheme(
                                        data: IconThemeData(color: themeSecondary, size: 20),
                                        child: option.icon!,
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.label,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                              color: isSelected && !widget.multiple && !widget.inverted
                                                  ? MitumbaColors.green
                                                  : themeText,
                                            ),
                                          ),
                                          if (option.subtitle != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              option.subtitle!,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 12,
                                                color: themeSecondary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (!widget.multiple && isSelected)
                                      const Icon(
                                        Icons.check,
                                        color: MitumbaColors.green,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: itemWidgets,
                        );
                      },
                    ),
            ),
            if (widget.multiple)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => widget.onApply(_currentValue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MitumbaColors.green,
                    foregroundColor: MitumbaColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'DONE',
                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
