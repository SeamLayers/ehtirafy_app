import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';

class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class CountryCodePickerDialog extends StatefulWidget {
  final Function(Country) onCountrySelected;

  const CountryCodePickerDialog({super.key, required this.onCountrySelected});

  @override
  State<CountryCodePickerDialog> createState() =>
      _CountryCodePickerDialogState();
}

class _CountryCodePickerDialogState extends State<CountryCodePickerDialog> {
  // Sample list - in a real app this would be more comprehensive
  final List<Country> _allCountries = [
    const Country(
      name: 'Saudi Arabia',
      code: 'SA',
      dialCode: '966',
      flag: '🇸🇦',
    ),
    const Country(name: 'Egypt', code: 'EG', dialCode: '20', flag: '🇪🇬'),
    const Country(
      name: 'United Arab Emirates',
      code: 'AE',
      dialCode: '971',
      flag: '🇦🇪',
    ),
    const Country(name: 'Kuwait', code: 'KW', dialCode: '965', flag: '🇰🇼'),
    const Country(name: 'Qatar', code: 'QA', dialCode: '974', flag: '🇶🇦'),
    const Country(name: 'Bahrain', code: 'BH', dialCode: '973', flag: '🇧🇭'),
    const Country(name: 'Oman', code: 'OM', dialCode: '968', flag: '🇴🇲'),
    const Country(name: 'Jordan', code: 'JO', dialCode: '962', flag: '🇯🇴'),
  ];

  late List<Country> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.dialCode.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 0.7.sh,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 24.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          // Search field
          TextField(
            controller: _searchController,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search country or code',
              hintStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.gold,
                size: 22.r,
              ),
              filled: true,
              fillColor: AppColors.grey100,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.grey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.gold, width: 1.5.w),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14.h,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Country list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _filteredCountries.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: () {
                      widget.onCountrySelected(country);
                      Navigator.pop(context);
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.r,
                              height: 40.r,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: Text(
                                country.flag,
                                style: TextStyle(fontSize: 22.sp),
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                country.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                '+${country.dialCode}',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
