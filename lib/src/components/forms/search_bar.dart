import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';

/// Search bar with optional suggestions dropdown.
class MitumbaSearchBar extends StatefulWidget {
  const MitumbaSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onSubmit,
    this.placeholder = 'Search...',
    this.suggestions,
    this.onSuggestionClick,
    this.focusNode,
    this.controller,
  });

  /// The current search query value.
  final String value;

  /// Called when the search query changes.
  final ValueChanged<String> onChanged;

  /// Called when the search is submitted.
  final ValueChanged<String> onSubmit;

  /// Placeholder text for the input.
  final String placeholder;

  /// Optional list of search suggestions.
  final List<String>? suggestions;

  /// Called when a suggestion is clicked.
  final ValueChanged<String>? onSuggestionClick;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Optional controller.
  final TextEditingController? controller;

  @override
  State<MitumbaSearchBar> createState() => _MitumbaSearchBarState();
}

class _MitumbaSearchBarState extends State<MitumbaSearchBar> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant MitumbaSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
    if (_isFocused) {
      _updateSuggestions();
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_focusNode.hasFocus) {
      _showSuggestions();
    } else {
      // Delay to allow suggestion click callback to register
      Future.delayed(const Duration(milliseconds: 200), () {
        _hideSuggestions();
      });
    }
  }

  void _showSuggestions() {
    _hideSuggestions();
    if (widget.suggestions == null || widget.suggestions!.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: _layerLink.leaderSize?.width ?? 300,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, (_layerLink.leaderSize?.height ?? 42) + 4),
            child: Material(
              elevation: 4,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: MitumbaColors.surface,
                  border: Border.all(color: MitumbaColors.divider),
                  borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  boxShadow: MitumbaShadows.elevated,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.suggestions!.map((suggestion) {
                    return InkWell(
                      onTap: () {
                        widget.onSuggestionClick?.call(suggestion);
                        _controller.text = suggestion;
                        widget.onChanged(suggestion);
                        _focusNode.unfocus();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: MitumbaColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateSuggestions() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    } else if (_isFocused) {
      _showSuggestions();
    }
  }

  void _hideSuggestions() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideSuggestions();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _isFocused ? MitumbaColors.green : MitumbaColors.divider;
    final double borderWidth = _isFocused ? 2.0 : 1.0;

    final List<BoxShadow> shadows = _isFocused
        ? [
            BoxShadow(
              color: MitumbaColors.green.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ]
        : [];

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 42.0,
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: shadows,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: MitumbaColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmit,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MitumbaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: widget.placeholder,
                  hintStyle: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: MitumbaColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (widget.value.isNotEmpty) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  widget.onChanged('');
                },
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: MitumbaColors.textDisabled,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
