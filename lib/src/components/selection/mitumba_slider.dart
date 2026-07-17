import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

/// Premium custom Slider widget supporting single or range selections.
class MitumbaSlider extends StatefulWidget {
  const MitumbaSlider({
    super.key,
    this.value,
    this.rangeValue,
    required this.onChange,
    this.min = 0.0,
    this.max = 100.0,
    this.step,
    this.label,
    this.disabled = false,
    this.showTooltip = true,
  }) : assert(value != null || rangeValue != null, 'Either value or rangeValue must be provided');

  /// Active single value of the slider.
  final double? value;

  /// Active range value bounds. If provided, renders as a RangeSlider.
  final RangeValues? rangeValue;

  /// Triggered on slide drag event. Receives [double] or [RangeValues].
  final Function(dynamic) onChange;

  /// Lower bound.
  final double min;

  /// Upper bound.
  final double max;

  /// Step increment value.
  final double? step;

  /// Optional text label shown above the slider.
  final String? label;

  /// Disables slide interaction.
  final bool disabled;

  /// Shows standard value label tooltip on drag.
  final bool showTooltip;

  @override
  State<MitumbaSlider> createState() => _MitumbaSliderState();
}

class _MitumbaSliderState extends State<MitumbaSlider> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRange = widget.rangeValue != null;

    final sliderTheme = theme.copyWith(
      sliderTheme: SliderThemeData(
        activeTrackColor: MitumbaColors.green,
        inactiveTrackColor: MitumbaColors.divider.withValues(alpha: 0.2),
        trackHeight: 6.0,
        thumbColor: MitumbaColors.white,
        overlappingShapeStrokeColor: Colors.transparent,
        valueIndicatorColor: MitumbaColors.green,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: MitumbaColors.white,
        ),
        thumbShape: _CustomThumbShape(
          disabled: widget.disabled,
          isHovered: _isHovered,
        ),
        rangeThumbShape: _CustomRangeThumbShape(
          disabled: widget.disabled,
          isHovered: _isHovered,
        ),
      ),
    );

    Widget sliderWidget;
    if (isRange) {
      sliderWidget = RangeSlider(
        values: widget.rangeValue!,
        min: widget.min,
        max: widget.max,
        divisions: widget.step != null
            ? ((widget.max - widget.min) / widget.step!).round()
            : null,
        onChanged: widget.disabled
            ? null
            : (values) => widget.onChange(values),
        labels: widget.showTooltip
            ? RangeLabels(
                widget.rangeValue!.start.toStringAsFixed(0),
                widget.rangeValue!.end.toStringAsFixed(0),
              )
            : null,
      );
    } else {
      sliderWidget = Slider(
        value: widget.value!,
        min: widget.min,
        max: widget.max,
        divisions: widget.step != null
            ? ((widget.max - widget.min) / widget.step!).round()
            : null,
        onChanged: widget.disabled
            ? null
            : (val) => widget.onChange(val),
        label: widget.showTooltip ? widget.value!.toStringAsFixed(0) : null,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: MitumbaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Theme(
            data: sliderTheme,
            child: sliderWidget,
          ),
        ],
      ),
    );
  }
}

class _CustomThumbShape extends RoundSliderThumbShape {
  const _CustomThumbShape({
    required this.disabled,
    required this.isHovered,
  }) : super(enabledThumbRadius: 10.0);

  final bool disabled;
  final bool isHovered;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = MitumbaColors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = disabled ? MitumbaColors.divider : MitumbaColors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final radius = isHovered ? 12.0 : 10.0;

    // Draw shadow
    canvas.drawCircle(center, radius, Paint()..color = Colors.black.withValues(alpha: 0.1));

    // Draw thumb body
    canvas.drawCircle(center, radius - 1.0, paint);
    canvas.drawCircle(center, radius - 1.0, borderPaint);
  }
}

class _CustomRangeThumbShape extends RoundRangeSliderThumbShape {
  const _CustomRangeThumbShape({
    required this.disabled,
    required this.isHovered,
  }) : super(enabledThumbRadius: 10.0);

  final bool disabled;
  final bool isHovered;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = MitumbaColors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = disabled ? MitumbaColors.divider : MitumbaColors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final radius = isHovered ? 12.0 : 10.0;

    // Draw shadow
    canvas.drawCircle(center, radius, Paint()..color = Colors.black.withValues(alpha: 0.1));

    // Draw thumb body
    canvas.drawCircle(center, radius - 1.0, paint);
    canvas.drawCircle(center, radius - 1.0, borderPaint);
  }
}
