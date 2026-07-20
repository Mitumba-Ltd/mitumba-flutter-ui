import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

class OrderMessageAttachment extends StatelessWidget {
  const OrderMessageAttachment({
    super.key,
    required this.orderShortId,
    required this.listingTitle,
    this.listingImageUrl,
    required this.amount,
    required this.status,
  });

  final String orderShortId;
  final String listingTitle;
  final String? listingImageUrl;
  final double amount;
  final String status;

  String _formatAmount(double val) {
    final str = val.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? MitumbaColors.border.withOpacity(0.2) : MitumbaColors.divider;
    final textColor = isDark ? Colors.white : MitumbaColors.textPrimary;
    final subtitleColor = isDark ? MitumbaColors.textSecondary.withOpacity(0.7) : MitumbaColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(MitumbaSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(MitumbaRadius.md),
        border: Border.all(color: dividerColor),
      ),
      margin: const EdgeInsets.only(bottom: MitumbaSpacing.sm),
      child: Row(
        children: [
          if (listingImageUrl != null && listingImageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(MitumbaRadius.sm),
              child: Image.network(
                listingImageUrl!,
                width: 48.0,
                height: 48.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 48.0,
                  height: 48.0,
                  color: isDark ? Colors.white10 : Colors.black12,
                  child: Icon(Icons.image, size: 20.0, color: subtitleColor),
                ),
              ),
            ),
            const SizedBox(width: MitumbaSpacing.base),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Order #$orderShortId',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeXs,
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  listingTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeSm,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'KES ${_formatAmount(amount)} · $status',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeXs,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
