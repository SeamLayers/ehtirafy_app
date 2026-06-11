import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.gold,
                            AppColors.gold.withValues(alpha: 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'home_categories.title'.tr(),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'home_categories.subtitle'.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.16),
                      AppColors.gold.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  'home_categories.count_badge'.tr(
                    namedArgs: {'count': '${categories.length}'},
                  ),
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
        SizedBox(height: AppSpacing.md),
        if (categories.isEmpty)
          _buildEmptyState()
        else
          SizedBox(
            height: 164.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gold.withValues(alpha: 0.09), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.20),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.22),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.category_rounded,
                size: 28.sp,
                color: AppColors.gold,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'home_categories.empty_state'.tr(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
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
              color: palette[0].withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(1.3.w),
          padding: EdgeInsets.all(13.w),
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
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: palette[0].withValues(alpha: 0.16),
                      ),
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
                  Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palette[0].withValues(alpha: 0.10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.north_west_rounded,
                      color: palette[0],
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.textPrimary,
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: palette[0].withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: palette[0].withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  'home_categories.browse'.tr(),
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
