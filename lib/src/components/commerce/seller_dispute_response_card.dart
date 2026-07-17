import 'dart:io';
import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';
import '../foundation/mitumba_text_field.dart';

/// Interactive Dispute response card for sellers to accept refunds or contest with evidence.
class SellerDisputeResponseCard extends StatefulWidget {
  const SellerDisputeResponseCard({
    super.key,
    required this.reason,
    required this.description,
    required this.onAccept,
    required this.onContest,
    this.submitting = false,
  });

  final String reason;
  final String description;
  final VoidCallback onAccept;
  final Function(String, List<File>) onContest;
  final bool submitting;

  @override
  State<SellerDisputeResponseCard> createState() => _SellerDisputeResponseCardState();
}

class _SellerDisputeResponseCardState extends State<SellerDisputeResponseCard> {
  bool _contestMode = false;
  String _message = '';
  final List<File> _files = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        border: Border.all(color: MitumbaColors.divider),
      ),
      padding: const EdgeInsets.all(MitumbaSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Alert Icon + Title
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: MitumbaColors.warning,
              ),
              const SizedBox(width: MitumbaSpacing.md),
              const Text(
                'Dispute Filed',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeLg,
                  fontWeight: FontWeight.w700,
                  color: MitumbaColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: MitumbaSpacing.lg),

          // Details
          Text(
            widget.reason,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: MitumbaTypography.fontSizeBase,
              color: MitumbaColors.textPrimary,
            ),
          ),
          const SizedBox(height: MitumbaSpacing.xs),
          Text(
            widget.description,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: MitumbaColors.textSecondary,
              fontSize: MitumbaTypography.fontSizeSm,
            ),
          ),
          const SizedBox(height: MitumbaSpacing.xl),

          // Action Buttons
          if (!_contestMode) ...[
            MitumbaPrimaryButton(
              label: 'Accept & Refund',
              onPressed: widget.onAccept,
              disabled: widget.submitting,
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'No impact on your trust score',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: MitumbaColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.base),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.submitting ? null : () => setState(() => _contestMode = true),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: MitumbaColors.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                ),
                child: const Text(
                  'Respond with Evidence',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    color: MitumbaColors.textPrimary,
                  ),
                ),
              ),
            ),
          ] else ...[
            MitumbaTextField(
              label: 'Your response',
              hint: 'Explain why you believe this dispute is invalid...',
              value: _message,
              onChange: (val) => setState(() => _message = val),
            ),
            const SizedBox(height: MitumbaSpacing.lg),

            // Mock Evidence picker
            const Text(
              'UPLOAD EVIDENCE',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: MitumbaColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: MitumbaSpacing.sm,
              runSpacing: MitumbaSpacing.sm,
              children: [
                ..._files.map((file) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: MitumbaColors.divider),
                      borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                  );
                }),
                InkWell(
                  onTap: () {
                    setState(() {
                      _files.add(File('evidence_mock_${_files.length + 1}.jpg'));
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: MitumbaColors.divider),
                      borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                    ),
                    child: const Icon(
                      Icons.upload_file,
                      color: MitumbaColors.textDisabled,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MitumbaSpacing.lg),

            MitumbaPrimaryButton(
              label: 'Submit Response',
              onPressed: () => widget.onContest(_message, _files),
              disabled: _message.trim().isEmpty || widget.submitting,
            ),
          ],
        ],
      ),
    );
  }
}
