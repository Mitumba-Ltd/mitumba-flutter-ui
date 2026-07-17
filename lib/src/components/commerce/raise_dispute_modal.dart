import 'dart:io';
import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../feedback/mitumba_modal.dart';
import '../foundation/mitumba_select.dart';
import '../foundation/mitumba_text_field.dart';
import '../foundation/mitumba_primary_button.dart';

class DisputeData {
  const DisputeData({
    required this.reason,
    required this.description,
    required this.desiredResolution,
    required this.evidenceFiles,
  });

  final String reason;
  final String description;
  final String desiredResolution;
  final List<File> evidenceFiles;
}

/// Raise Dispute modal window for buyers to file claims on orders.
class RaiseDisputeModal extends StatefulWidget {
  const RaiseDisputeModal({
    super.key,
    required this.orderShortId,
    required this.onSubmit,
    this.submitting = false,
    this.onClose,
  });

  final String orderShortId;
  final ValueChanged<DisputeData> onSubmit;
  final bool submitting;
  final VoidCallback? onClose;

  @override
  State<RaiseDisputeModal> createState() => _RaiseDisputeModalState();
}

class _RaiseDisputeModalState extends State<RaiseDisputeModal> {
  String? _reason;
  String _description = '';
  String? _resolution;
  final List<File> _files = [];

  bool get _isValid {
    return _reason != null &&
        _description.length >= 10 &&
        _description.length <= 2000 &&
        _resolution != null;
  }

  void _handleSubmit() {
    if (!_isValid || widget.submitting) return;
    widget.onSubmit(
      DisputeData(
        reason: _reason!,
        description: _description,
        desiredResolution: _resolution!,
        evidenceFiles: _files,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const reasonOptions = [
      MitumbaSelectOption(value: 'not_received', label: 'Item not received'),
      MitumbaSelectOption(value: 'not_as_described', label: 'Not as described'),
      MitumbaSelectOption(value: 'damaged', label: 'Item arrived damaged'),
      MitumbaSelectOption(value: 'counterfeit', label: 'Counterfeit item'),
      MitumbaSelectOption(value: 'wrong_item', label: 'Wrong item sent'),
    ];

    const resolutionOptions = [
      MitumbaSelectOption(value: 'refund', label: 'Refund'),
      MitumbaSelectOption(value: 'replacement', label: 'Replacement'),
      MitumbaSelectOption(value: 'partial_refund', label: 'Partial Refund'),
    ];

    return MitumbaModal(
      title: 'Raise a Dispute',
      subtitle: 'Order #${widget.orderShortId}',
      loading: widget.submitting,
      onClose: widget.onClose,
      actions: MitumbaPrimaryButton(
        label: 'Submit Dispute',
        onPressed: _handleSubmit,
        disabled: !_isValid || widget.submitting,
        size: ButtonSize.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reason Selector
          const Text(
            'REASON FOR DISPUTE',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: MitumbaColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          MitumbaSelect(
            value: _reason,
            options: reasonOptions,
            onChange: (val) => setState(() => _reason = val as String),
            placeholder: 'Select a reason',
          ),
          const SizedBox(height: MitumbaSpacing.lg),

          // Desired Resolution
          const Text(
            'DESIRED RESOLUTION',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: MitumbaColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          MitumbaSelect(
            value: _resolution,
            options: resolutionOptions,
            onChange: (val) => setState(() => _resolution = val as String),
            placeholder: 'Select desired resolution',
          ),
          const SizedBox(height: MitumbaSpacing.lg),

          // Description
          MitumbaTextField(
            label: 'Detailed Description',
            hint: 'Explain what happened in detail...',
            value: _description,
            onChange: (val) => setState(() => _description = val),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_description.length} / 2000',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: MitumbaColors.textDisabled,
              ),
            ),
          ),
          const SizedBox(height: MitumbaSpacing.lg),

          // Evidence File Upload Preview Area
          const Text(
            'EVIDENCE PHOTOS',
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
              // Photo previews
              ..._files.map((file) {
                return Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        border: Border.all(color: MitumbaColors.divider),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        child: file.path.startsWith('http')
                            ? Image.network(file.path, fit: BoxFit.cover)
                            : Image.file(file, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: () => setState(() => _files.remove(file)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // Add photos CTA
              if (_files.length < 6)
                InkWell(
                  onTap: () {
                    // For mock/test support, add a mock file path
                    setState(() {
                      _files.add(File('evidence_mock_${_files.length + 1}.jpg'));
                    });
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MitumbaColors.divider,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: MitumbaColors.textDisabled,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
