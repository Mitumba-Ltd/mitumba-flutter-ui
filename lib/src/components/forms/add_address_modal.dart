import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../feedback/mitumba_modal.dart';
import '../foundation/mitumba_text_field.dart';
import '../foundation/mitumba_select.dart';

const List<String> _kenyaCounties = [
  'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet', 'Embu', 'Garissa',
  'Homa Bay', 'Isiolo', 'Kajiado', 'Kakamega', 'Kericho', 'Kiambu', 'Kilifi',
  'Kirinyaga', 'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia', 'Lamu', 'Machakos',
  'Makueni', 'Mandera', 'Marsabit', 'Meru', 'Migori', 'Mombasa', "Murang'a",
  'Nairobi', 'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua', 'Nyeri',
  'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River', 'Tharaka-Nithi', 'Trans Nzoia',
  'Turkana', 'Uasin Gishu', 'Vihiga', 'Wajir', 'West Pokot',
];

/// Data model for the address form.
class AddressFormData {
  const AddressFormData({
    this.label = '',
    this.fullName = '',
    this.phone = '',
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.county = '',
    this.isDefault = false,
  });

  final String label;
  final String fullName;
  final String phone;
  final String line1;
  final String line2;
  final String city;
  final String county;
  final bool isDefault;

  AddressFormData copyWith({
    String? label,
    String? fullName,
    String? phone,
    String? line1,
    String? line2,
    String? city,
    String? county,
    bool? isDefault,
  }) {
    return AddressFormData(
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      county: county ?? this.county,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

/// AddAddressModal — inline delivery address form built on MitumbaModal.
class AddAddressModal extends StatefulWidget {
  const AddAddressModal({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSave,
    this.saving = false,
    this.error,
    this.isFirstAddress = false,
  });

  /// Whether the modal is open.
  final bool open;

  /// Close callback.
  final VoidCallback onClose;

  /// Save callback with validated form data.
  final ValueChanged<AddressFormData> onSave;

  /// Save progress indicator.
  final bool saving;

  /// Error message from save attempt.
  final String? error;

  /// Checkbox defaults to checked if this is first address.
  final bool isFirstAddress;

  @override
  State<AddAddressModal> createState() => _AddAddressModalState();
}

class _AddAddressModalState extends State<AddAddressModal> {
  late AddressFormData _form;
  final Map<String, bool> _touched = {};

  @override
  void initState() {
    super.initState();
    _form = AddressFormData(isDefault: widget.isFirstAddress);
  }

  void _updateField(String field, dynamic val) {
    setState(() {
      _touched[field] = true;
      if (field == 'label') _form = _form.copyWith(label: val as String);
      if (field == 'fullName') _form = _form.copyWith(fullName: val as String);
      if (field == 'phone') _form = _form.copyWith(phone: val as String);
      if (field == 'line1') _form = _form.copyWith(line1: val as String);
      if (field == 'line2') _form = _form.copyWith(line2: val as String);
      if (field == 'city') _form = _form.copyWith(city: val as String);
      if (field == 'county') _form = _form.copyWith(county: val as String);
      if (field == 'isDefault') _form = _form.copyWith(isDefault: val as bool);
    });
  }

  Map<String, String> _getErrors() {
    final errors = <String, String>{};
    if (_form.label.trim().isEmpty) errors['label'] = 'Label is required';
    if (_form.fullName.trim().isEmpty) errors['fullName'] = 'Full name is required';
    
    final phoneDigits = _form.phone.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 9) {
      errors['phone'] = 'Enter a valid phone number';
    }
    
    if (_form.line1.trim().isEmpty) errors['line1'] = 'Address line 1 is required';
    if (_form.city.trim().isEmpty) errors['city'] = 'City is required';
    if (_form.county.trim().isEmpty) errors['county'] = 'Please select a county';
    return errors;
  }

  void _handleSave() {
    final errors = _getErrors();
    if (errors.isNotEmpty) {
      setState(() {
        _touched['label'] = true;
        _touched['fullName'] = true;
        _touched['phone'] = true;
        _touched['line1'] = true;
        _touched['city'] = true;
        _touched['county'] = true;
      });
      return;
    }
    widget.onSave(_form);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final errors = _getErrors();
    final countyOptions = _kenyaCounties.map((c) => MitumbaSelectOption(label: c, value: c)).toList();

    return MitumbaModal(
      title: 'Add Delivery Address',
      subtitle: 'Where should we deliver your items?',
      onClose: widget.onClose,
      loading: widget.saving,
      actions: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.saving ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: MitumbaColors.green,
            disabledBackgroundColor: MitumbaColors.green.withOpacity(0.5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MitumbaRadius.md),
            ),
            elevation: 0,
          ),
          child: widget.saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Save Address',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.error != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: MitumbaSpacing.base,
                vertical: MitumbaSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: MitumbaColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
              ),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MitumbaColors.error,
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.base),
          ],
          MitumbaTextField(
            label: 'Label',
            hint: 'e.g. "Home", "Office"',
            value: _form.label,
            onChange: (val) => _updateField('label', val),
            error: _touched['label'] == true ? errors['label'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaTextField(
            label: 'Full name',
            hint: 'Recipient name',
            value: _form.fullName,
            onChange: (val) => _updateField('fullName', val),
            error: _touched['fullName'] == true ? errors['fullName'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaTextField(
            label: 'Phone number',
            hint: '0712 345 678',
            value: _form.phone,
            onChange: (val) => _updateField('phone', val),
            error: _touched['phone'] == true ? errors['phone'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaTextField(
            label: 'Address line 1',
            hint: 'Street, building',
            value: _form.line1,
            onChange: (val) => _updateField('line1', val),
            error: _touched['line1'] == true ? errors['line1'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaTextField(
            label: 'Address line 2',
            hint: 'Apartment, suite (optional)',
            value: _form.line2,
            onChange: (val) => _updateField('line2', val),
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaTextField(
            label: 'City / Town',
            hint: 'e.g. Westlands, Kisumu CBD',
            value: _form.city,
            onChange: (val) => _updateField('city', val),
            error: _touched['city'] == true ? errors['city'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.base),
          MitumbaSelect(
            label: 'County',
            value: _form.county.isEmpty ? null : _form.county,
            placeholder: 'Select county',
            options: countyOptions,
            onChange: (val) => _updateField('county', val),
            error: _touched['county'] == true ? errors['county'] : null,
          ),
          const SizedBox(height: MitumbaSpacing.md),
          Row(
            children: [
              Checkbox(
                value: _form.isDefault,
                onChanged: (val) => _updateField('isDefault', val ?? false),
                activeColor: MitumbaColors.green,
              ),
              const Expanded(
                child: Text(
                  'Set as default delivery address',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MitumbaColors.textSecondary,
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
