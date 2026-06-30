import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Data submitted from [BuyerOnboardingPage].
class BuyerOnboardingData {
  const BuyerOnboardingData({required this.displayName, required this.county, required this.phone});

  /// Buyer's display name.
  final String displayName;

  /// Selected county.
  final String county;

  /// Phone number (without +254 prefix).
  final String phone;
}

/// All 47 Kenya counties.
const kenyaCounties = [
  'Baringo','Bomet','Bungoma','Busia','Elgeyo-Marakwet','Embu','Garissa',
  'Homa Bay','Isiolo','Kajiado','Kakamega','Kericho','Kiambu','Kilifi',
  'Kirinyaga','Kisii','Kisumu','Kitui','Kwale','Laikipia','Lamu','Machakos',
  'Makueni','Mandera','Marsabit','Meru','Migori','Mombasa',"Murang'a",
  'Nairobi','Nakuru','Nandi','Narok','Nyamira','Nyandarua','Nyeri',
  'Samburu','Siaya','Taita-Taveta','Tana River','Tharaka-Nithi','Trans Nzoia',
  'Turkana','Uasin Gishu','Vihiga','Wajir','West Pokot',
];

/// Buyer onboarding page — collects display name, county, and phone.
///
/// Mirrors the web `BuyerOnboardingPage` from `@mitumba/ui`.
///
/// ```dart
/// BuyerOnboardingPage(
///   onComplete: (data) => print(data.displayName),
/// )
/// ```
class BuyerOnboardingPage extends StatefulWidget {
  const BuyerOnboardingPage({
    super.key,
    required this.onComplete,
    this.loading = false,
    this.error,
    this.counties,
    this.initialData,
  });

  /// Called when the form is submitted.
  final ValueChanged<BuyerOnboardingData> onComplete;

  /// Whether submission is in progress.
  final bool loading;

  /// Error message.
  final String? error;

  /// Selectable counties (defaults to all 47).
  final List<String>? counties;

  /// Pre-filled data.
  final BuyerOnboardingData? initialData;

  @override
  State<BuyerOnboardingPage> createState() => _BuyerOnboardingPageState();
}

class _BuyerOnboardingPageState extends State<BuyerOnboardingPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  String? _county;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialData?.displayName ?? '');
    _phoneCtrl = TextEditingController(text: widget.initialData?.phone ?? '');
    _county = widget.initialData?.county;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool get _isValid => _nameCtrl.text.trim().isNotEmpty && _county != null && _phoneCtrl.text.trim().length >= 9;

  void _submit() {
    if (!_isValid) return;
    widget.onComplete(BuyerOnboardingData(
      displayName: _nameCtrl.text.trim(),
      county: _county!,
      phone: _phoneCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final counties = widget.counties ?? kenyaCounties;

    return Scaffold(
      backgroundColor: MitumbaColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(MitumbaSpacing.lg),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: EdgeInsets.all(MitumbaSpacing.xxl),
              decoration: BoxDecoration(
                color: MitumbaColors.surface,
                borderRadius: BorderRadius.circular(MitumbaRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Welcome to Mitumba', style: MitumbaTypography.h4, textAlign: TextAlign.center),
                  SizedBox(height: MitumbaSpacing.xs),
                  Text(
                    'Tell us a bit about yourself to get started.',
                    style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MitumbaSpacing.xxl),
                  if (widget.error != null) ...[
                    Container(
                      padding: EdgeInsets.all(MitumbaSpacing.base),
                      decoration: BoxDecoration(
                        color: MitumbaColors.errorLight,
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                      ),
                      child: Text(widget.error!, style: MitumbaTypography.body2.copyWith(color: MitumbaColors.error)),
                    ),
                    SizedBox(height: MitumbaSpacing.lg),
                  ],
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Display name',
                      hintText: 'e.g. Amina K.',
                      helperText: 'This is how sellers will see you',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: MitumbaSpacing.lg),
                  DropdownButtonFormField<String>(
                    value: _county,
                    decoration: InputDecoration(
                      labelText: 'County',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
                    ),
                    items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _county = v),
                  ),
                  SizedBox(height: MitumbaSpacing.lg),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      hintText: '712 345 678',
                      helperText: 'For delivery updates and M-Pesa payments',
                      prefixText: '+254 ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: MitumbaSpacing.xxxl),
                  ElevatedButton(
                    onPressed: widget.loading || !_isValid ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MitumbaColors.green,
                      foregroundColor: MitumbaColors.white,
                      padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.base),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
                    ),
                    child: Text(widget.loading ? 'Setting up...' : 'Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
