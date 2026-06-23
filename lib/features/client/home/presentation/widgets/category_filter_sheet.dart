import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';

/// Haraj-style "browse / filter by category" sheet, opened from the home
/// header's grid icon. Shows an "All" option plus every category as a card in
/// a 2-column grid. Tapping a category reports its id (null for "All") to
/// [onSelect] and closes the sheet — the home feed then filters in place,
/// exactly like tapping a tab in the pinned category strip.
Future<void> showCategoryFilterSheet(
  BuildContext context, {
  required List<CategoryEntity> categories,
  required int? selectedId,
  required ValueChanged<int?> onSelect,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => _CategoryFilterSheet(
      categories: categories,
      selectedId: selectedId,
      onSelect: onSelect,
    ),
  );
}

class _CategoryFilterSheet extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelect;

  const _CategoryFilterSheet({
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  void _pick(BuildContext context, int? id) {
    Navigator.of(context).pop();
    onSelect(id);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return DraggableScrollableSheet(
      initialChildSize: 0.86,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Grab handle.
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 12.w, 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.gold,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        AppStrings.categoryFilterTitle.tr(),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.grey600,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1.55,
                  ),
                  // +1 for the leading "All" card.
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _CategoryCard(
                        label: AppStrings.homeFeedAll.tr(),
                        icon: Icons.apps_rounded,
                        selected: selectedId == null,
                        onTap: () => _pick(context, null),
                      );
                    }
                    final c = categories[index - 1];
                    return _CategoryCard(
                      label: c.getLocalizedName(locale),
                      icon: _iconForIndex(index - 1),
                      selected: selectedId == c.id,
                      onTap: () => _pick(context, c.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// A small rotating set of tasteful icons so the flat category list still
  /// reads as a varied, visual grid (the API has no per-category image).
  IconData _iconForIndex(int i) {
    const icons = <IconData>[
      Icons.celebration_rounded,
      Icons.camera_alt_rounded,
      Icons.meeting_room_rounded,
      Icons.restaurant_rounded,
      Icons.music_note_rounded,
      Icons.local_florist_rounded,
      Icons.chair_rounded,
      Icons.cake_rounded,
      Icons.lightbulb_rounded,
      Icons.card_giftcard_rounded,
    ];
    return icons[i % icons.length];
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold.withValues(alpha: 0.10)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.grey200,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: selected ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.gold, size: 22.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? AppColors.gold : AppColors.textPrimary,
                  fontSize: 13.5.sp,
                  fontFamily: 'Cairo',
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
