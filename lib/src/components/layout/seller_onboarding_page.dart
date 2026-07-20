import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';
import '../foundation/mitumba_text_field.dart';

class SellerOnboardingData {
  SellerOnboardingData({
    this.fullName = '',
    this.phone = '',
    this.idNumber = '',
    this.profilePhotoUrl = '',
    this.county = '',
    this.town = '',
    this.sellerType = 'individual',
    this.businessName = '',
    this.kraPin = '',
    this.businessDescription = '',
    List<String>? categories,
    List<String>? conditionGrades,
    this.deliveryMethod = 'self',
    this.priceRangeMin = 200,
    this.priceRangeMax = 5000,
    this.storeName = '',
    this.storeTagline = '',
    this.storeLogoUrl = '',
    this.storeBannerUrl = '',
  })  : categories = categories ?? const [],
        conditionGrades = conditionGrades ?? const [];

  String fullName;
  String phone;
  String idNumber;
  String profilePhotoUrl;
  String county;
  String town;
  String sellerType; // 'individual' | 'business'
  String businessName;
  String kraPin;
  String businessDescription;
  List<String> categories;
  List<String> conditionGrades;
  String deliveryMethod;
  double priceRangeMin;
  double priceRangeMax;
  String storeName;
  String storeTagline;
  String storeLogoUrl;
  String storeBannerUrl;

  SellerOnboardingData copyWith({
    String? fullName,
    String? phone,
    String? idNumber,
    String? profilePhotoUrl,
    String? county,
    String? town,
    String? sellerType,
    String? businessName,
    String? kraPin,
    String? businessDescription,
    List<String>? categories,
    List<String>? conditionGrades,
    String? deliveryMethod,
    double? priceRangeMin,
    double? priceRangeMax,
    String? storeName,
    String? storeTagline,
    String? storeLogoUrl,
    String? storeBannerUrl,
  }) {
    return SellerOnboardingData(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      county: county ?? this.county,
      town: town ?? this.town,
      sellerType: sellerType ?? this.sellerType,
      businessName: businessName ?? this.businessName,
      kraPin: kraPin ?? this.kraPin,
      businessDescription: businessDescription ?? this.businessDescription,
      categories: categories ?? this.categories,
      conditionGrades: conditionGrades ?? this.conditionGrades,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      priceRangeMin: priceRangeMin ?? this.priceRangeMin,
      priceRangeMax: priceRangeMax ?? this.priceRangeMax,
      storeName: storeName ?? this.storeName,
      storeTagline: storeTagline ?? this.storeTagline,
      storeLogoUrl: storeLogoUrl ?? this.storeLogoUrl,
      storeBannerUrl: storeBannerUrl ?? this.storeBannerUrl,
    );
  }
}

class SellerOnboardingPage extends StatefulWidget {
  const SellerOnboardingPage({
    super.key,
    this.currentStep = 0,
    this.onStepChange,
    this.onComplete,
    this.loading = false,
    this.error,
    this.initialData,
    this.theme = 'mitumba-light',
    this.heroImageUrl,
    this.onProfilePhotoUpload,
    this.onStoreLogoUpload,
    this.onStoreBannerUpload,
  });

  final int currentStep;
  final ValueChanged<int>? onStepChange;
  final ValueChanged<SellerOnboardingData>? onComplete;
  final bool loading;
  final String? error;
  final SellerOnboardingData? initialData;
  final String theme; // 'mitumba-light' | 'mitumba-dark'
  final String? heroImageUrl;
  final Future<String> Function()? onProfilePhotoUpload;
  final Future<String> Function()? onStoreLogoUpload;
  final Future<String> Function()? onStoreBannerUpload;

  @override
  State<SellerOnboardingPage> createState() => _SellerOnboardingPageState();
}

class _SellerOnboardingPageState extends State<SellerOnboardingPage> {
  late int _step;
  late SellerOnboardingData _data;

  // Uploading indicators
  bool _uploadingProfile = false;
  bool _uploadingLogo = false;
  bool _uploadingBanner = false;

  final List<String> _counties = const [
    'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet', 'Embu', 'Garissa',
    'Homa Bay', 'Isiolo', 'Kajiado', 'Kakamega', 'Kericho', 'Kiambu', 'Kilifi',
    'Kirinyaga', 'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia', 'Lamu', 'Machakos',
    'Makueni', 'Mandera', 'Marsabit', 'Meru', 'Migori', 'Mombasa', "Murang'a",
    'Nairobi', 'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua', 'Nyeri',
    'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River', 'Tharaka-Nithi', 'Trans Nzoia',
    'Turkana', 'Uasin Gishu', 'Vihiga', 'Wajir', 'West Pokot'
  ];

  final List<String> _categories = const [
    "Women's Wear", "Men's Wear", "Kids & Baby", 'Shoes', 'Bags & Accessories',
    'Sportswear', 'Traditional & Cultural', 'Vintage & Retro'
  ];

  @override
  void initState() {
    super.initState();
    _step = widget.currentStep;
    _data = widget.initialData ?? SellerOnboardingData();
  }

  @override
  void didUpdateWidget(covariant SellerOnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      setState(() {
        _step = widget.currentStep;
      });
    }
  }

  int _computeStiScore() {
    int score = 0;
    if (_data.fullName.trim().isNotEmpty) score += 8;
    if (_data.phone.trim().isNotEmpty) score += 10;
    if (_data.idNumber.trim().isNotEmpty) score += 12;
    if (_data.profilePhotoUrl.isNotEmpty) score += 8;
    if (_data.county.isNotEmpty) score += 5;
    if (_data.kraPin.trim().isNotEmpty) score += 10;
    if (_data.businessDescription.trim().isNotEmpty) score += 4;
    if (_data.categories.isNotEmpty) score += 5;
    if (_data.conditionGrades.isNotEmpty) score += 3;
    if (_data.storeName.trim().isNotEmpty) score += 8;
    if (_data.storeLogoUrl.isNotEmpty) score += 4;
    if (_data.storeBannerUrl.isNotEmpty) score += 3;
    return score < 35 ? 35 : score;
  }

  bool _isStepValid() {
    if (_step == 0) return true;
    if (_step == 1) {
      return _data.fullName.trim().isNotEmpty &&
          _data.phone.trim().isNotEmpty &&
          _data.idNumber.trim().isNotEmpty &&
          _data.county.isNotEmpty;
    }
    if (_step == 2) {
      if (_data.sellerType == 'business') {
        return _data.businessName.trim().isNotEmpty;
      }
      return true;
    }
    if (_step == 3) {
      return _data.categories.isNotEmpty && _data.conditionGrades.isNotEmpty;
    }
    if (_step == 4) {
      return _data.storeName.trim().isNotEmpty;
    }
    return true;
  }

  void _advance() {
    if (!_isStepValid()) return;
    final nextStep = _step + 1;
    setState(() {
      _step = nextStep;
    });
    widget.onStepChange?.call(nextStep);
  }

  void _back() {
    final prevStep = _step - 1;
    setState(() {
      _step = prevStep;
    });
    widget.onStepChange?.call(prevStep);
  }

  void _finish() {
    widget.onComplete?.call(_data);
  }

  Future<void> _uploadProfilePhoto() async {
    if (widget.onProfilePhotoUpload == null) return;
    setState(() => _uploadingProfile = true);
    try {
      final url = await widget.onProfilePhotoUpload!();
      setState(() {
        _data.profilePhotoUrl = url;
      });
    } finally {
      setState(() => _uploadingProfile = false);
    }
  }

  Future<void> _uploadStoreLogo() async {
    if (widget.onStoreLogoUpload == null) return;
    setState(() => _uploadingLogo = true);
    try {
      final url = await widget.onStoreLogoUpload!();
      setState(() {
        _data.storeLogoUrl = url;
      });
    } finally {
      setState(() => _uploadingLogo = false);
    }
  }

  Future<void> _uploadStoreBanner() async {
    if (widget.onStoreBannerUpload == null) return;
    setState(() => _uploadingBanner = true);
    try {
      final url = await widget.onStoreBannerUpload!();
      setState(() {
        _data.storeBannerUrl = url;
      });
    } finally {
      setState(() => _uploadingBanner = false);
    }
  }

  String _getInitials() {
    if (_data.fullName.trim().isEmpty) return '?';
    final parts = _data.fullName.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme == 'mitumba-dark';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final bgColor = isDark ? MitumbaColors.backgroundDark : MitumbaColors.background;
    final surfaceColor = isDark ? MitumbaColors.surfaceDark : MitumbaColors.surface;
    final textColor = isDark ? Colors.white : MitumbaColors.textPrimary;
    final subtitleColor = isDark ? MitumbaColors.divider : MitumbaColors.textSecondary;

    final double progressPct = _step >= 1 && _step <= 4 ? (_step / 5) * 100 : 0;
    final stiScore = _computeStiScore();

    // Text details based on steps
    String panelTitle = 'Start selling on Mitumba';
    String panelSubtitle = 'Join thousands of Kenyan sellers building trusted businesses on Mitumba.';

    if (_step >= 1 && _step <= 4) {
      panelTitle = 'Almost there';
      panelSubtitle = 'Your information builds your Seller Trust Index — the foundation of buyer confidence.';
    } else if (_step == 5) {
      panelTitle = "You're all set!";
      panelSubtitle = 'Your store is ready. Start listing your items and grow your STI score.';
    }

    Widget buildUploaderAvatar({
      required String value,
      required String initials,
      required bool uploading,
      required VoidCallback onUpload,
      required String label,
      double size = 96,
    }) {
      return Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: size / 2,
                backgroundColor: MitumbaColors.greenLight,
                backgroundImage: value.isNotEmpty ? NetworkImage(value) : null,
                child: value.isEmpty
                    ? Text(
                        initials,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size * 0.35,
                          fontWeight: FontWeight.bold,
                          color: MitumbaColors.green,
                        ),
                      )
                    : null,
              ),
              if (uploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(MitumbaColors.green),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: uploading ? null : onUpload,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: MitumbaColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value.isNotEmpty ? 'Tap to replace' : label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: MitumbaTypography.fontSizeXs,
              color: subtitleColor,
            ),
          ),
        ],
      );
    }

    Widget buildFormContent() {
      if (_step == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Start selling on Mitumba',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeXl,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.sm),
            Text(
              'Set up your seller profile in 5 quick steps. Your information builds your STI (Seller Trust Index) — the score that makes buyers confident to purchase from you.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeBase,
                color: subtitleColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxxl),
            ...[
              'Your identity — name, phone, ID, location',
              'Your business — type and KRA PIN',
              'What you sell — categories and grades',
              'Your store — name, logo, banner',
            ].asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final text = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: MitumbaSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: MitumbaColors.greenLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$idx',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: MitumbaColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: MitumbaSpacing.md),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          color: subtitleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: MitumbaSpacing.xxl),
            MitumbaPrimaryButton(
              label: "Let's get started",
              onPressed: _advance,
            ),
          ],
        );
      }

      if (_step == 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your identity',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'This information is used for KYC verification and is never shown publicly.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),
            buildUploaderAvatar(
              value: _data.profilePhotoUrl,
              initials: _getInitials(),
              uploading: _uploadingProfile,
              onUpload: _uploadProfilePhoto,
              label: 'Upload profile photo',
            ),
            const SizedBox(height: MitumbaSpacing.xl),
            MitumbaTextField(
              label: 'Full name',
              hint: 'e.g. John Doe',
              value: _data.fullName,
              onChange: (val) => setState(() => _data.fullName = val),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            MitumbaTextField(
              label: 'Phone number (M-Pesa)',
              hint: 'e.g. 0712 345 678',
              value: _data.phone,
              onChange: (val) => setState(() => _data.phone = val),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            MitumbaTextField(
              label: 'National ID / Passport number',
              hint: 'e.g. 12345678',
              value: _data.idNumber,
              onChange: (val) => setState(() => _data.idNumber = val),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            DropdownButtonFormField<String>(
              value: _data.county.isEmpty ? null : _data.county,
              decoration: InputDecoration(
                labelText: 'County *',
                labelStyle: const TextStyle(fontFamily: 'Nunito'),
                fillColor: surfaceColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MitumbaRadius.md),
                ),
              ),
              items: _counties
                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Nunito'))))
                  .toList(),
              onChanged: (val) => setState(() => _data.county = val ?? ''),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            MitumbaTextField(
              label: 'Town / area',
              hint: 'e.g. Westlands, Nairobi',
              value: _data.town,
              onChange: (val) => setState(() => _data.town = val),
            ),
          ],
        );
      }

      if (_step == 2) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your business',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Tell buyers who they\'re buying from.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),
            Text(
              'I am selling as *',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: MitumbaSpacing.md,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'individual',
                      groupValue: _data.sellerType,
                      onChanged: (val) => setState(() => _data.sellerType = val!),
                    ),
                    Text('Individual', style: TextStyle(fontFamily: 'Nunito', color: textColor)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'business',
                      groupValue: _data.sellerType,
                      onChanged: (val) => setState(() => _data.sellerType = val!),
                    ),
                    Text('Registered business', style: TextStyle(fontFamily: 'Nunito', color: textColor)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            if (_data.sellerType == 'business') ...[
              MitumbaTextField(
                label: 'Business / trading name',
                hint: 'e.g. Nairobi Thrift Hub',
                value: _data.businessName,
                onChange: (val) => setState(() => _data.businessName = val),
              ),
              const SizedBox(height: MitumbaSpacing.lg),
            ],
            MitumbaTextField(
              label: 'KRA PIN (optional)',
              hint: 'e.g. A012345678B',
              value: _data.kraPin,
              onChange: (val) => setState(() => _data.kraPin = val),
              helperText: 'Optional — adding your KRA PIN boosts your STI score by +10 points',
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            MitumbaTextField(
              label: 'About your business (optional)',
              hint: 'We source premium secondhand clothes...',
              value: _data.businessDescription,
              onChange: (val) => setState(() {
                if (val.length <= 300) _data.businessDescription = val;
              }),
              multiline: true,
              rows: 3,
              helperText: '${_data.businessDescription.length}/300',
            ),
          ],
        );
      }

      if (_step == 3) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What you sell',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Helps buyers find you. Select everything that applies.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),
            Text(
              'Categories *',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.sm),
            Wrap(
              spacing: MitumbaSpacing.sm,
              runSpacing: MitumbaSpacing.sm,
              children: _categories.map((cat) {
                final isSelected = _data.categories.contains(cat);
                return FilterChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: isSelected ? Colors.white : textColor,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: MitumbaColors.green,
                  checkmarkColor: Colors.white,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _data.categories = [..._data.categories, cat];
                      } else {
                        _data.categories = _data.categories.where((c) => c != cat).toList();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: MitumbaSpacing.xl),
            Text(
              'Condition grades you typically sell *',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['A', 'B', 'C'].map((grade) {
                final isSelected = _data.conditionGrades.contains(grade);
                final label = grade == 'A'
                    ? 'Grade A — Like new'
                    : grade == 'B'
                        ? 'Grade B — Good condition'
                        : 'Grade C — Fair / visible wear';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: FilterChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: isSelected ? Colors.white : textColor,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: MitumbaColors.green,
                    checkmarkColor: Colors.white,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _data.conditionGrades = [..._data.conditionGrades, grade];
                        } else {
                          _data.conditionGrades = _data.conditionGrades.where((g) => g != grade).toList();
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: MitumbaSpacing.xl),
            Text(
              'Delivery method *',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'self',
                  groupValue: _data.deliveryMethod,
                  onChanged: (val) => setState(() => _data.deliveryMethod = val!),
                ),
                Text('I arrange my own delivery', style: TextStyle(fontFamily: 'Nunito', color: textColor)),
              ],
            ),
            const SizedBox(height: MitumbaSpacing.xl),
            Text(
              'Typical price range (KES) — optional',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            RangeSlider(
              values: RangeValues(_data.priceRangeMin, _data.priceRangeMax),
              min: 0,
              max: 50000,
              divisions: 500,
              labels: RangeLabels(
                'KES ${_data.priceRangeMin.round()}',
                'KES ${_data.priceRangeMax.round()}',
              ),
              activeColor: MitumbaColors.green,
              onChanged: (values) {
                setState(() {
                  _data.priceRangeMin = values.start;
                  _data.priceRangeMax = values.end;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('KES ${_data.priceRangeMin.round()}', style: TextStyle(fontFamily: 'Nunito', color: subtitleColor)),
                Text('KES ${_data.priceRangeMax.round()}', style: TextStyle(fontFamily: 'Nunito', color: subtitleColor)),
              ],
            ),
          ],
        );
      }

      if (_step == 4) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your store',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'This is your public face on Mitumba.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeSm,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),

            // Store Banner Uploader
            GestureDetector(
              onTap: _uploadingBanner ? null : _uploadStoreBanner,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: MitumbaColors.background,
                  borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                  border: Border.all(
                    color: _data.storeBannerUrl.isNotEmpty ? MitumbaColors.green : MitumbaColors.divider,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  image: _data.storeBannerUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(_data.storeBannerUrl), fit: BoxFit.cover)
                      : null,
                ),
                alignment: Alignment.center,
                child: _data.storeBannerUrl.isNotEmpty
                    ? Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: const Text('Replace', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined, color: MitumbaColors.textSecondary, size: 32),
                          const SizedBox(height: 4),
                          Text('Upload store banner',
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: subtitleColor)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.lg),

            // Logo uploader
            buildUploaderAvatar(
              value: _data.storeLogoUrl,
              initials: _getInitials(),
              uploading: _uploadingLogo,
              onUpload: _uploadStoreLogo,
              label: 'Store logo',
              size: 72,
            ),
            const SizedBox(height: MitumbaSpacing.xl),
            MitumbaTextField(
              label: 'Store name *',
              hint: 'e.g. NairobiKicks',
              value: _data.storeName,
              onChange: (val) => setState(() => _data.storeName = val),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
            MitumbaTextField(
              label: 'Store tagline (optional)',
              hint: 'Premium thrift items...',
              value: _data.storeTagline,
              onChange: (val) => setState(() {
                if (val.length <= 60) _data.storeTagline = val;
              }),
              helperText: '${_data.storeTagline.length}/60',
            ),
          ],
        );
      }

      if (_step == 5) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle_outline, color: MitumbaColors.green, size: 72),
            const SizedBox(height: MitumbaSpacing.xl),
            Text(
              "You're all set!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeXl,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.sm),
            Text(
              "Your seller profile is ready. Here's your starting STI score:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeBase,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),

            // Score Panel
            Center(
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(MitumbaSpacing.xl),
                decoration: BoxDecoration(
                  color: MitumbaColors.greenLight,
                  borderRadius: BorderRadius.circular(MitumbaRadius.xl),
                ),
                child: Column(
                  children: [
                    Text(
                      '$stiScore',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: MitumbaColors.green,
                      ),
                    ),
                    const Text(
                      '/ 100 — Starting STI',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: MitumbaColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),

            // Score breakdown details
            ...[
              {'label': 'Identity verified', 'pts': 38, 'done': _data.fullName.isNotEmpty && _data.phone.isNotEmpty && _data.idNumber.isNotEmpty},
              {'label': 'Profile photo added', 'pts': 8, 'done': _data.profilePhotoUrl.isNotEmpty},
              {'label': 'KRA PIN provided', 'pts': 10, 'done': _data.kraPin.isNotEmpty},
              {'label': 'Store set up', 'pts': 8, 'done': _data.storeName.isNotEmpty},
              {'label': 'Logo uploaded', 'pts': 4, 'done': _data.storeLogoUrl.isNotEmpty},
              {'label': 'Banner uploaded', 'pts': 3, 'done': _data.storeBannerUrl.isNotEmpty},
            ].map((m) {
              final done = m['done'] as bool;
              final pts = m['pts'] as int;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: done ? MitumbaColors.green : MitumbaColors.divider,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          m['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: done ? textColor : subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '+$pts pts',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        color: done ? MitumbaColors.green : subtitleColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: MitumbaSpacing.giant),

            MitumbaPrimaryButton(
              label: 'Start listing my items →',
              onPressed: _finish,
            ),
          ],
        );
      }

      return const SizedBox.shrink();
    }

    if (isMobile) {
      return Scaffold(
        backgroundColor: surfaceColor,
        appBar: _step > 0 && _step < 5
            ? AppBar(
                backgroundColor: surfaceColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: MitumbaColors.green),
                  onPressed: _back,
                ),
                title: Text('Step $_step of 5', style: TextStyle(color: textColor, fontFamily: 'Nunito')),
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(MitumbaSpacing.xl),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_step >= 1 && _step <= 4) ...[
                    LinearProgressIndicator(
                      value: progressPct / 100,
                      backgroundColor: MitumbaColors.greenLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(MitumbaColors.green),
                    ),
                    const SizedBox(height: MitumbaSpacing.xl),
                  ],
                  if (widget.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: MitumbaColors.error.withOpacity(0.1),
                      child: Text(widget.error!, style: const TextStyle(color: MitumbaColors.error)),
                    ),
                    const SizedBox(height: MitumbaSpacing.md),
                  ],
                  buildFormContent(),
                  if (_step > 0 && _step < 5) ...[
                    const SizedBox(height: MitumbaSpacing.giant),
                    MitumbaPrimaryButton(
                      label: _step == 4 ? 'Finish setup' : 'Continue',
                      disabled: !_isStepValid(),
                      onPressed: _advance,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Split desktop/tablet layout
    final panelBg = widget.heroImageUrl != null
        ? DecorationImage(
            image: NetworkImage(widget.heroImageUrl!),
            fit: BoxFit.cover,
          )
        : null;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: 1000,
          height: 640,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(MitumbaRadius.xl),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Hero panel
              Container(
                width: 1000 * 0.38,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: panelBg,
                  gradient: widget.heroImageUrl == null
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [MitumbaColors.green, MitumbaColors.earth],
                        )
                      : null,
                ),
                child: Container(
                  color: widget.heroImageUrl != null ? Colors.black.withOpacity(0.4) : Colors.transparent,
                  padding: const EdgeInsets.all(MitumbaSpacing.xxxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        panelTitle,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: MitumbaSpacing.md),
                      Text(
                        panelSubtitle,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeBase,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      if (_step == 0) ...[
                        const SizedBox(height: MitumbaSpacing.xxl),
                        ...[
                          {'icon': Icons.storefront, 'text': 'Reach buyers across Kenya'},
                          {'icon': Icons.verified_user, 'text': 'Build your STI trust score'},
                          {'icon': Icons.local_shipping, 'text': 'Get paid via M-Pesa'},
                        ].map((m) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Icon(m['icon'] as IconData, color: Colors.white70),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      m['text'] as String,
                                      style: const TextStyle(fontFamily: 'Nunito', color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                      if (_step >= 1 && _step <= 4) ...[
                        const Spacer(),
                        Text(
                          'Step $_step of 5',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progressPct / 100,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                      if (_step == 5) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(MitumbaSpacing.xl),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$stiScore',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Your starting STI score',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Form content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(MitumbaSpacing.giant),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: MitumbaColors.error.withOpacity(0.1),
                          child: Text(widget.error!, style: const TextStyle(color: MitumbaColors.error)),
                        ),
                        const SizedBox(height: MitumbaSpacing.md),
                      ],
                      Expanded(
                        child: SingleChildScrollView(
                          child: buildFormContent(),
                        ),
                      ),
                      if (_step > 0 && _step < 5) ...[
                        const SizedBox(height: MitumbaSpacing.xl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: _back,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: MitumbaColors.divider),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MitumbaRadius.md),
                                ),
                              ),
                              child: const Text('Back', style: TextStyle(fontFamily: 'Nunito', color: MitumbaColors.textSecondary)),
                            ),
                            MitumbaPrimaryButton(
                              label: _step == 4 ? 'Finish setup' : 'Continue',
                              disabled: !_isStepValid(),
                              onPressed: _advance,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
