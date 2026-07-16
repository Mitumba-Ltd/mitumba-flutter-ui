import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';

/// Step configuration for [MitumbaStepper].
class MitumbaStepOption {
  const MitumbaStepOption({
    required this.label,
    this.subtitle,
  });

  /// Primary label for the step.
  final String label;

  /// Optional secondary description.
  final String? subtitle;
}

/// A premium, living Stepper widget for progress tracking.
class MitumbaStepper extends StatelessWidget {
  const MitumbaStepper({
    super.key,
    required this.activeStep,
    required this.steps,
  });

  /// The current active step (0-indexed).
  final int activeStep;

  /// Array of step configurations.
  final List<MitumbaStepOption> steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final bool isFirst = index == 0;
        final bool isLast = index == steps.length - 1;

        final bool isCompleted = index < activeStep;
        final bool isActive = index == activeStep;

        // Connector lines logic
        final bool leftSolid = index > 0 && index <= activeStep;
        final bool rightSolid = index < activeStep;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle and Connector Row
              Row(
                children: [
                  // Left connector
                  Expanded(
                    child: isFirst
                        ? const SizedBox()
                        : _StepperConnectorLine(solid: leftSolid),
                  ),

                  // Circle
                  _StepIcon(
                    index: index + 1,
                    active: isActive,
                    completed: isCompleted,
                  ),

                  // Right connector
                  Expanded(
                    child: isLast
                        ? const SizedBox()
                        : _StepperConnectorLine(solid: rightSolid),
                  ),
                ],
              ),
              const SizedBox(height: MitumbaSpacing.base),

              // Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MitumbaTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    color: isActive ? MitumbaColors.textPrimary : MitumbaColors.textSecondary,
                  ),
                ),
              ),
              if (step.subtitle != null) ...[
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    step.subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: MitumbaTypography.fontFamily,
                      fontSize: 10,
                      color: MitumbaColors.textDisabled,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({
    required this.index,
    required this.active,
    required this.completed,
  });

  final int index;
  final bool active;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    Color getBgColor() {
      if (completed) return MitumbaColors.green;
      if (active) return MitumbaColors.info;
      return MitumbaColors.background;
    }

    Color getTextColor() {
      if (completed || active) return MitumbaColors.white;
      return MitumbaColors.textDisabled;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 39.6 : 36, // active scales by 1.1 (36 * 1.1 = 39.6)
      height: active ? 39.6 : 36,
      decoration: BoxDecoration(
        color: getBgColor(),
        shape: BoxShape.circle,
        border: active || completed ? null : Border.all(color: MitumbaColors.divider),
        boxShadow: active ? MitumbaShadows.card : null,
      ),
      alignment: Alignment.center,
      child: completed
          ? const Icon(
              Icons.check,
              size: 20,
              color: MitumbaColors.white,
            )
          : Text(
              '$index',
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: getTextColor(),
              ),
            ),
    );
  }
}

class _StepperConnectorLine extends StatelessWidget {
  const _StepperConnectorLine({required this.solid});
  final bool solid;

  @override
  Widget build(BuildContext context) {
    if (solid) {
      return const Divider(
        height: 2,
        thickness: 2,
        color: MitumbaColors.green,
        indent: 0,
        endIndent: 0,
      );
    }

    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: const _DashedLinePainter(color: MitumbaColors.divider),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 4.0;
    const double dashSpace = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
