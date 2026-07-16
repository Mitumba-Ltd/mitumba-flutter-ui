import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

/// Size variants for [VAZIBadge].
enum VAZIBadgeSize {
  small,
  medium,
}

/// A compact, stylized chip badge indicating VAZI curation.
class VAZIBadge extends StatelessWidget {
  const VAZIBadge({
    super.key,
    this.size = VAZIBadgeSize.small,
  });

  final VAZIBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final bool isLarge = size == VAZIBadgeSize.medium;

    return Semantics(
      label: 'VAZI Curation Badge',
      container: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 10.0 : 8.0,
          vertical: isLarge ? 3.2 : 2.0,
        ),
        decoration: BoxDecoration(
          color: MitumbaColors.earthLight,
          borderRadius: BorderRadius.circular(MitumbaRadius.full),
          border: Border.all(
            color: MitumbaColors.earth.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: isLarge ? 13.0 : 11.0,
              color: MitumbaColors.earth,
            ),
            const SizedBox(width: 4.0),
            Text(
              'VAZI',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: isLarge ? 11.0 : 9.0,
                fontWeight: FontWeight.w900,
                color: MitumbaColors.earth,
                letterSpacing: 0.06 * 10.0, // 0.06em conversion
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
