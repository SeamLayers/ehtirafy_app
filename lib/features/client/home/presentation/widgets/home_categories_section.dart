import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';

class HomeCategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String locale;

  const HomeCategoriesSection({
    super.key,
    required this.categories,
    this.locale = 'ar',
  });

  // Emoji mapping based on category name
  String _getCategoryEmoji(String nameEn) {
    final lower = nameEn.toLowerCase();
    if (lower.contains('party') ||
        lower.contains('parties') ||
        lower.contains('event')) {
      return '🎉';
    } else if (lower.contains('wedding') || lower.contains('marriage')) {
      return '💍';
    } else if (lower.contains('food') || lower.contains('restaurant')) {
      return '🍽️';
    } else if (lower.contains('real estate') ||
        lower.contains('property') ||
        lower.contains('house')) {
      return '🏠';
    } else if (lower.contains('product')) {
      return '📦';
    } else if (lower.contains('portrait') || lower.contains('session')) {
      return '📸';
    } else if (lower.contains('organiz')) {
      return '🎉';
    }
    return '📷'; // Default camera emoji
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفئات',
                    style: TextStyle(
                      color: const Color(0xFF2B2B2B),
                      fontSize: 18.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'اختر نوع الخدمة المناسبة لمناسبتك',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF8D8D8D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  '${categories.length} فئة',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 11.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (categories.isEmpty)
          _buildEmptyState()
        else
          SizedBox(
            height: 164.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryCard(
                  emoji: _getCategoryEmoji(category.nameEn),
                  title: category.getLocalizedName(locale),
                  categoryId: category.id,
                  categoryName: category.getLocalizedName(locale),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 154.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gold.withValues(alpha: 0.09), Colors.white],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.20),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_rounded, size: 34.sp, color: AppColors.gold),
            SizedBox(height: 8.h),
            Text(
              'لا توجد فئات متاحة',
              style: TextStyle(
                color: const Color(0xFF6F6F6F),
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String emoji;
  final String title;
  final int categoryId;
  final String categoryName;

  const _CategoryCard({
    required this.emoji,
    required this.title,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [const Color(0xFFC8A44F), const Color(0xFFB08A34)],
      [const Color(0xFF2E6B92), const Color(0xFF194867)],
      [const Color(0xFF0F8B8D), const Color(0xFF0A6E70)],
      [const Color(0xFF7A5EA8), const Color(0xFF5C4484)],
    ];
    final palette = gradients[categoryId % gradients.length];

    return GestureDetector(
      onTap: () {
        context.push(
          '/category/$categoryId',
          extra: {'categoryName': categoryName},
        );
      },
      child: Container(
        width: 146.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette[0], palette[1]],
          ),
          boxShadow: [
            BoxShadow(
              color: palette[0].withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(1.3.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          palette[0].withValues(alpha: 0.2),
                          palette[1].withValues(alpha: 0.12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: 24.sp,
                        shadows: [
                          Shadow(
                            color: palette[1].withValues(alpha: 0.14),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.north_west_rounded,
                    color: palette[0],
                    size: 18.sp,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: palette[0].withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'استعرض',
                  style: TextStyle(
                    color: palette[0],
                    fontSize: 10.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
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
