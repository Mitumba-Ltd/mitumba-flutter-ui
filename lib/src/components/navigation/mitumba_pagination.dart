import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';

/// A premium, living Pagination widget for list paging.
class MitumbaPagination extends StatelessWidget {
  const MitumbaPagination({
    super.key,
    required this.count,
    required this.page,
    required this.onChange,
  });

  /// The total number of pages.
  final int count;

  /// The current page (1-indexed).
  final int page;

  /// Callback fired when the page changes.
  final ValueChanged<int> onChange;

  List<dynamic> _generatePageNumbers() {
    if (count <= 7) {
      return List.generate(count, (i) => i + 1);
    }

    final List<dynamic> pages = [];
    pages.add(1);

    // If current page is close to start
    if (page <= 4) {
      pages.addAll([2, 3, 4, 5, '...', count]);
    }
    // If current page is close to end
    else if (page >= count - 3) {
      pages.addAll(['...', count - 4, count - 3, count - 2, count - 1, count]);
    }
    // If current page is in middle
    else {
      pages.addAll(['...', page - 1, page, page + 1, '...', count]);
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pageNumbers = _generatePageNumbers();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Prev button
        _PaginationArrowButton(
          icon: Icons.chevron_left,
          disabled: page == 1,
          onTap: () => onChange(page - 1),
        ),
        const SizedBox(width: MitumbaSpacing.xs),

        // Page buttons
        ...pageNumbers.map((p) {
          if (p == '...') {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.xs),
              child: Text(
                '...',
                style: TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MitumbaColors.textDisabled,
                ),
              ),
            );
          }

          final int pageNum = p as int;
          final bool isSelected = pageNum == page;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: _PaginationNumberButton(
              pageNum: pageNum,
              isSelected: isSelected,
              onTap: () => onChange(pageNum),
            ),
          );
        }),
        const SizedBox(width: MitumbaSpacing.xs),

        // Next button
        _PaginationArrowButton(
          icon: Icons.chevron_right,
          disabled: page == count,
          onTap: () => onChange(page + 1),
        ),
      ],
    );
  }
}

class _PaginationNumberButton extends StatefulWidget {
  const _PaginationNumberButton({
    required this.pageNum,
    required this.isSelected,
    required this.onTap,
  });

  final int pageNum;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_PaginationNumberButton> createState() => _PaginationNumberButtonState();
}

class _PaginationNumberButtonState extends State<_PaginationNumberButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool selected = widget.isSelected;

    Color getBgColor() {
      if (selected) {
        return _isHovered ? MitumbaColors.greenDark : MitumbaColors.green;
      }
      return _isHovered ? MitumbaColors.background : MitumbaColors.transparent;
    }

    Color getTextColor() {
      if (selected) {
        return MitumbaColors.white;
      }
      return _isHovered ? MitumbaColors.green : MitumbaColors.textSecondary;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: getBgColor(),
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
            boxShadow: selected ? MitumbaShadows.card : null,
          ),
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered && !selected ? -2.0 : 0.0)
            ..scale(_isHovered && !selected ? 1.1 : 1.0),
          transformAlignment: Alignment.center,
          child: Text(
            '${widget.pageNum}',
            style: TextStyle(
              fontFamily: MitumbaTypography.fontFamily,
              fontSize: MitumbaTypography.fontSizeSm,
              fontWeight: FontWeight.bold,
              color: getTextColor(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaginationArrowButton extends StatefulWidget {
  const _PaginationArrowButton({
    required this.icon,
    required this.disabled,
    required this.onTap,
  });

  final IconData icon;
  final bool disabled;
  final VoidCallback onTap;

  @override
  State<_PaginationArrowButton> createState() => _PaginationArrowButtonState();
}

class _PaginationArrowButtonState extends State<_PaginationArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
          border: Border.all(color: MitumbaColors.divider),
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          size: 18,
          color: MitumbaColors.textDisabled,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
            border: Border.all(
              color: _isHovered ? MitumbaColors.green : MitumbaColors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: 18,
            color: _isHovered ? MitumbaColors.green : MitumbaColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
