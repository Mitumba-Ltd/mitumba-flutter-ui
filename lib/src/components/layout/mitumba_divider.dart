import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

/// Alignment orientation for [MitumbaDivider].
enum MitumbaDividerOrientation {
  horizontal,
  vertical,
}

/// A style-compliant divider line matching Mitumba brand colors and thickness.
class MitumbaDivider extends StatelessWidget {
  const MitumbaDivider({
    super.key,
    this.orientation = MitumbaDividerOrientation.horizontal,
    this.thickness = 1.0,
    this.color,
    this.indent,
    this.endIndent,
  });

  /// Orientation of the divider. Defaults to [MitumbaDividerOrientation.horizontal].
  final MitumbaDividerOrientation orientation;

  /// Thickness of the divider line. Defaults to 1.0.
  final double thickness;

  /// Custom color for the divider. Defaults to [MitumbaColors.divider].
  final Color? color;

  /// Amount of empty space before the divider.
  final double? indent;

  /// Amount of empty space after the divider.
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? MitumbaColors.divider;

    if (orientation == MitumbaDividerOrientation.vertical) {
      return VerticalDivider(
        width: thickness,
        thickness: thickness,
        color: dividerColor,
        indent: indent,
        endIndent: endIndent,
      );
    } else {
      return Divider(
        height: thickness,
        thickness: thickness,
        color: dividerColor,
        indent: indent,
        endIndent: endIndent,
      );
    }
  }
}
