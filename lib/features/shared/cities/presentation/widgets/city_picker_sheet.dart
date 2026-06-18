import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../../domain/entities/city_entity.dart';
import '../cubits/cities_cubit.dart';
import '../cubits/cities_state.dart';

/// Shows a searchable bottom sheet of Saudi cities and resolves to the chosen
/// [CityEntity], or null if dismissed. When [includeAllOption] is true an
/// "All cities" row is shown first; selecting it resolves to null *via the
/// [onAll] callback path* — callers that need a clear-filter action should
/// pass [includeAllOption] and treat the special result.
Future<CityEntity?> showCityPickerSheet(
  BuildContext context, {
  CityEntity? selected,
  bool includeAllOption = false,
}) {
  return showModalBottomSheet<CityEntity?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => sl<CitiesCubit>()..loadCities(),
      child: _CityPickerSheet(
        selected: selected,
        includeAllOption: includeAllOption,
      ),
    ),
  );
}

/// Sentinel returned when the user picks the "All cities" row. Callers compare
/// the result identity against [kAllCities] to detect a clear-filter request.
const CityEntity kAllCities = CityEntity(nameAr: '__all__', nameEn: '__all__');

class _CityPickerSheet extends StatefulWidget {
  final CityEntity? selected;
  final bool includeAllOption;

  const _CityPickerSheet({this.selected, required this.includeAllOption});

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CityEntity> _filter(List<CityEntity> cities) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return cities;
    return cities
        .where(
          (c) =>
              c.nameAr.toLowerCase().contains(q) ||
              c.nameEn.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              AppStrings.cityPickerTitle.tr(),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppStrings.cityPickerSearchHint.tr(),
                hintStyle: TextStyle(
                  color: AppColors.grey500,
                  fontFamily: 'Cairo',
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.gold,
                  size: 20.sp,
                ),
                filled: true,
                fillColor: AppColors.grey100,
                contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: AppColors.gold),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: BlocBuilder<CitiesCubit, CitiesState>(
                builder: (context, state) {
                  if (state is CitiesLoading || state is CitiesInitial) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      ),
                    );
                  }
                  if (state is CitiesError) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.cityPickerError.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () =>
                                context.read<CitiesCubit>().loadCities(),
                            child: Text(AppStrings.contractsChatsRetry.tr()),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is CitiesLoaded) {
                    final cities = _filter(state.cities);
                    final showAll =
                        widget.includeAllOption && _query.trim().isEmpty;
                    if (cities.isEmpty && !showAll) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          AppStrings.cityPickerNoResults.tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                            fontSize: 13.sp,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: cities.length + (showAll ? 1 : 0),
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppColors.grey100),
                      itemBuilder: (context, index) {
                        if (showAll && index == 0) {
                          return _CityTile(
                            label: AppStrings.cityPickerAll.tr(),
                            selected: widget.selected == null,
                            onTap: () => Navigator.of(context).pop(kAllCities),
                          );
                        }
                        final city = cities[showAll ? index - 1 : index];
                        final isSelected =
                            widget.selected != null &&
                            widget.selected!.nameEn == city.nameEn;
                        return _CityTile(
                          label: city.getLocalizedName(locale),
                          selected: isSelected,
                          onTap: () => Navigator.of(context).pop(city),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CityTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18.sp,
              color: selected ? AppColors.gold : AppColors.grey500,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.gold : AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 18.sp, color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}
