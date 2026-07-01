import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Sort options for search filters.
enum FilterSort { relevant, newest, priceAsc, priceDesc }

const _sortLabels = {
  FilterSort.relevant: 'Relevant',
  FilterSort.newest: 'Newest',
  FilterSort.priceAsc: 'Price: Low to High',
  FilterSort.priceDesc: 'Price: High to Low',
};

/// State for [SearchFilterSheet].
class FilterState {
  const FilterState({
    this.categories = const [],
    this.conditions = const [],
    this.priceRange,
    this.city,
    this.sort = FilterSort.relevant,
    this.vaziOnly = false,
  });

  final List<String> categories;
  final List<String> conditions;
  final RangeValues? priceRange;
  final String? city;
  final FilterSort sort;
  final bool vaziOnly;

  FilterState copyWith({
    List<String>? categories,
    List<String>? conditions,
    RangeValues? priceRange,
    String? city,
    FilterSort? sort,
    bool? vaziOnly,
    bool clearCity = false,
    bool clearPriceRange = false,
  }) {
    return FilterState(
      categories: categories ?? this.categories,
      conditions: conditions ?? this.conditions,
      priceRange: clearPriceRange ? null : (priceRange ?? this.priceRange),
      city: clearCity ? null : (city ?? this.city),
      sort: sort ?? this.sort,
      vaziOnly: vaziOnly ?? this.vaziOnly,
    );
  }
}

/// Default category options.
const defaultCategories = ['Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Shoes', 'Bags', 'Accessories', 'Kids'];

/// Default condition options.
const defaultConditions = ['New', 'Like New', 'Good', 'Fair'];

/// Default city options.
const defaultCities = ['Nairobi', 'Mombasa', 'Kisumu', 'Eldoret', 'Nakuru', 'Kisii'];

/// Search filter bottom sheet with chips, sliders, toggles.
///
/// Mirrors the web `SearchFilterSheet` from `@mitumba/ui`.
///
/// Show it using `showSearchFilterSheet(context, ...)`.
class SearchFilterSheet extends StatelessWidget {
  const SearchFilterSheet({
    super.key,
    required this.filters,
    required this.onFiltersChange,
    required this.onApply,
    required this.onClear,
    this.resultCount,
  });

  final FilterState filters;
  final ValueChanged<FilterState> onFiltersChange;
  final VoidCallback onApply;
  final VoidCallback onClear;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(MitumbaRadius.xxl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DragHandle(),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg, vertical: MitumbaSpacing.md),
              children: [
                _SortSection(sort: filters.sort, onChanged: (v) => onFiltersChange(filters.copyWith(sort: v))),
                SizedBox(height: MitumbaSpacing.xl),
                _ChipSection(title: 'Categories', options: defaultCategories, selected: filters.categories, onToggle: (v) {
                  final next = filters.categories.contains(v) ? (List<String>.from(filters.categories)..remove(v)) : [...filters.categories, v];
                  onFiltersChange(filters.copyWith(categories: next));
                }),
                SizedBox(height: MitumbaSpacing.xl),
                _ChipSection(title: 'Condition', options: defaultConditions, selected: filters.conditions, onToggle: (v) {
                  final next = filters.conditions.contains(v) ? (List<String>.from(filters.conditions)..remove(v)) : [...filters.conditions, v];
                  onFiltersChange(filters.copyWith(conditions: next));
                }),
                SizedBox(height: MitumbaSpacing.xl),
                _PriceSection(range: filters.priceRange ?? const RangeValues(0, 20000), onChanged: (v) => onFiltersChange(filters.copyWith(priceRange: v))),
                SizedBox(height: MitumbaSpacing.xl),
                _ChipSection(title: 'Location', options: [...defaultCities, 'All'], selected: [filters.city ?? 'All'], onToggle: (v) {
                  onFiltersChange(v == 'All' ? filters.copyWith(clearCity: true) : filters.copyWith(city: v));
                }),
                SizedBox(height: MitumbaSpacing.xl),
                _VaziToggle(value: filters.vaziOnly, onChanged: (v) => onFiltersChange(filters.copyWith(vaziOnly: v))),
              ],
            ),
          ),
          _Footer(onClear: onClear, onApply: onApply, resultCount: resultCount),
        ],
      ),
    );
  }
}

/// Shows the search filter sheet as a modal bottom sheet.
Future<void> showSearchFilterSheet(
  BuildContext context, {
  required FilterState filters,
  required ValueChanged<FilterState> onFiltersChange,
  required VoidCallback onApply,
  required VoidCallback onClear,
  int? resultCount,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SearchFilterSheet(
      filters: filters,
      onFiltersChange: onFiltersChange,
      onApply: () { Navigator.pop(context); onApply(); },
      onClear: onClear,
      resultCount: resultCount,
    ),
  );
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: MitumbaSpacing.md, bottom: MitumbaSpacing.sm),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: MitumbaColors.border,
          borderRadius: BorderRadius.circular(MitumbaRadius.full),
        ),
      ),
    );
  }
}

class _SortSection extends StatelessWidget {
  const _SortSection({required this.sort, required this.onChanged});
  final FilterSort sort;
  final ValueChanged<FilterSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('Sort By'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: FilterSort.values.map((s) => GestureDetector(
            onTap: () => onChanged(s),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.sm),
              child: Row(
                children: [
                  Radio<FilterSort>(
                    value: s,
                    groupValue: sort,
                    onChanged: (v) { if (v != null) onChanged(v); },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: MitumbaSpacing.md),
                  Text(_sortLabels[s]!, style: MitumbaTypography.body2),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _ChipSection extends StatelessWidget {
  const _ChipSection({required this.title, required this.options, required this.selected, required this.onToggle});
  final String title;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title),
        Wrap(
          spacing: MitumbaSpacing.sm,
          runSpacing: MitumbaSpacing.sm,
          children: options.map((o) {
            final isSelected = selected.contains(o);
            return FilterChip(
              label: Text(o),
              selected: isSelected,
              onSelected: (_) => onToggle(o),
              selectedColor: MitumbaColors.greenLight,
              checkmarkColor: MitumbaColors.green,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.range, required this.onChanged});
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('Price Range'),
        RangeSlider(
          values: range,
          min: 0,
          max: 20000,
          divisions: 200,
          activeColor: MitumbaColors.green,
          onChanged: onChanged,
        ),
        Semantics(
          label: 'Price range: KES ${range.start.round()} to KES ${range.end.round()}',
          child: Text(
            'KES ${range.start.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')} – KES ${range.end.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}',
            style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _VaziToggle extends StatelessWidget {
  const _VaziToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('VAZI Eligible Only', style: MitumbaTypography.body2)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: MitumbaColors.green,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onClear, required this.onApply, this.resultCount});
  final VoidCallback onClear;
  final VoidCallback onApply;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MitumbaSpacing.lg),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: MitumbaColors.divider))),
      child: Row(
        children: [
          Expanded(child: TextButton(onPressed: onClear, child: const Text('Clear All'))),
          SizedBox(width: MitumbaSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: MitumbaColors.green,
                foregroundColor: MitumbaColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
              ),
              child: Text(resultCount != null ? 'Show $resultCount Results' : 'Show Results'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MitumbaSpacing.md),
      child: Text(text, style: MitumbaTypography.body2.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}
