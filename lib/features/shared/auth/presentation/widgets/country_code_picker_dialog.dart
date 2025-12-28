import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

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
    return Container(
      height: 0.7.sh,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search country or code',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCountries.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  leading: Text(
                    country.flag,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  title: Text(country.name),
                  trailing: Text(
                    '+${country.dialCode}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
