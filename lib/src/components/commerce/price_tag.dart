import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

/// Premium currency indicator displaying formatted KES values.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.priceKes,
    this.size = 'medium',
    this.color = 'default',
    this.strikethrough = false,
  });

  /// Currency value in KES.
  final double priceKes;

  /// Render scale size: 'small' | 'medium' | 'large'
  final String size;

  /// Custom coloring: 'green' | 'earth' | 'default'
  final String color;

  /// Adds a strikeout line.
  final bool strikethrough;

  TextStyle _getTextStyle() {
    double fontSize = MitumbaTypography.fontSizeBase;
    FontWeight fontWeight = FontWeight.w700;

    if (size == 'small') {
      fontSize = MitumbaTypography.fontSizeSm;
      fontWeight = FontWeight.w600;
    } else if (size == 'large') {
      fontSize = MitumbaTypography.fontSizeXl;
      fontWeight = FontWeight.w800;
    }

    Color textColor = MitumbaColors.textPrimary;
    if (color == 'green') {
      textColor = MitumbaColors.green;
    } else if (color == 'earth') {
      textColor = MitumbaColors.earth;
    }

    return TextStyle(
      fontFamily: 'Nunito',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: strikethrough ? textColor.withValues(alpha: 0.7) : textColor,
      decoration: strikethrough ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedNumber = priceKes.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Text(
      'KES $formattedNumber',
      semanticsLabel: 'Price: KES $formattedNumber',
      style: _getTextStyle(),
    );
  }
}
