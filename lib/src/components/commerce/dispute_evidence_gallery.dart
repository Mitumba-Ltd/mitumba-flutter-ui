import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

enum UploaderRole { buyer, seller, admin }

class DisputeEvidenceItem {
  const DisputeEvidenceItem({
    required this.type,
    required this.content,
    required this.uploaderRole,
    required this.createdAt,
  });

  /// 'image' | 'text'
  final String type;

  /// File URL or textual statement
  final String content;

  final UploaderRole uploaderRole;
  final String createdAt;
}

/// Dispute Evidence Gallery displaying images/text uploads grouped by buyer, seller, or admin role.
class DisputeEvidenceGallery extends StatelessWidget {
  const DisputeEvidenceGallery({
    super.key,
    required this.evidence,
  });

  final List<DisputeEvidenceItem> evidence;

  String _getRoleLabel(UploaderRole role) {
    switch (role) {
      case UploaderRole.buyer:
        return 'Buyer Evidence';
      case UploaderRole.seller:
        return 'Seller Evidence';
      case UploaderRole.admin:
        return 'Admin Evidence';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group evidence items by role
    final Map<UploaderRole, List<DisputeEvidenceItem>> grouped = {};
    for (final item in evidence) {
      grouped.putIfAbsent(item.uploaderRole, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final role = entry.key;
        final items = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: MitumbaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getRoleLabel(role),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeMd,
                  fontWeight: FontWeight.w700,
                  color: MitumbaColors.textPrimary,
                ),
              ),
              const SizedBox(height: MitumbaSpacing.base),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: MitumbaSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.type == 'image')
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MitumbaRadius.md),
                              color: MitumbaColors.background,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(MitumbaRadius.md),
                              child: Image.network(
                                item.content,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  color: MitumbaColors.textDisabled,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: MitumbaColors.earth,
                                  width: 3,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(left: MitumbaSpacing.base),
                            child: Text(
                              item.content,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: MitumbaTypography.fontSizeSm,
                                fontStyle: FontStyle.italic,
                                color: MitumbaColors.textSecondary,
                              ),
                            ),
                          ),
                        const SizedBox(height: MitumbaSpacing.xs),
                        Text(
                          item.createdAt,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: MitumbaColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
