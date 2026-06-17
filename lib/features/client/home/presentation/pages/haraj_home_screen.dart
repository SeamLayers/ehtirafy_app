import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_feed_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_feed_state.dart';
import 'package:ehtirafy_app/features/client/home/presentation/widgets/haraj_ad_card.dart';

/// Haraj-style home: a branded top bar, a pinned scrollable category tab
/// strip, and a list of advertisement cards. The "All" tab shows every ad;
/// selecting a category filters the list.
class HarajHomeScreen extends StatelessWidget {
  const HarajHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeFeedCubit>()..load(),
      child: const _HarajHomeView(),
    );
  }
}

class _HarajHomeView extends StatelessWidget {
  const _HarajHomeView();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<HomeFeedCubit, HomeFeedState>(
                builder: (context, state) {
                  if (state is HomeFeedLoading || state is HomeFeedInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }
                  if (state is HomeFeedError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    );
                  }
                  if (state is HomeFeedLoaded) {
                    return Column(
                      children: [
                        _CategoryStrip(state: state),
                        Expanded(child: _buildList(context, state)),
                      ],
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

  Widget _buildList(BuildContext context, HomeFeedLoaded state) {
    if (state.isAdsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      );
    }
    if (state.ads.isEmpty) {
      return RefreshIndicator(
        color: AppColors.gold,
        onRefresh: () => context.read<HomeFeedCubit>().refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 80.h),
            CustomEmptyState(
              title: state.selectedCategoryId == null
                  ? AppStrings.homeFeedEmptyTitle.tr()
                  : AppStrings.homeFeedCategoryEmpty.tr(),
              message: AppStrings.homeFeedEmptyMessage.tr(),
              icon: Icons.inbox_outlined,
              iconSize: 44,
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () => context.read<HomeFeedCubit>().refresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
        itemCount: state.ads.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => HarajAdCard(ad: state.ads[index]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.dark, AppColors.textPrimary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: Row(
            children: [
              Icon(Icons.camera_alt_rounded, color: AppColors.gold, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                'app_name'.tr(),
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => context.push('/notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.30)),
        ),
        child: Icon(icon, color: AppColors.gold, size: 20.sp),
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  final HomeFeedLoaded state;

  const _CategoryStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final cubit = context.read<HomeFeedCubit>();

    // Build chip list: "All" first, then every category.
    final chips = <Widget>[
      _CategoryChip(
        label: AppStrings.homeFeedAll.tr(),
        selected: state.selectedCategoryId == null,
        onTap: () => cubit.selectCategory(null),
      ),
      ...state.categories.map(
        (CategoryEntity c) => _CategoryChip(
          label: c.getLocalizedName(locale),
          selected: state.selectedCategoryId == c.id,
          onTap: () => cubit.selectCategory(c.id),
        ),
      ),
    ];

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 52.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: chips.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (context, index) => chips[index],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.grey100,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected
                ? AppColors.gold
                : AppColors.grey200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontSize: 13.sp,
            fontFamily: 'Cairo',
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
