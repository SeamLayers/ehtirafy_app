import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/session/auth_guard.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_feed_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_feed_state.dart';
import 'package:ehtirafy_app/features/client/home/presentation/widgets/category_filter_sheet.dart';
import 'package:ehtirafy_app/features/client/home/presentation/widgets/haraj_ad_card.dart';
import 'package:ehtirafy_app/features/shared/cities/presentation/widgets/city_picker_sheet.dart';

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
                        if (state.freelancers.isNotEmpty)
                          _FreelancersRail(freelancers: state.freelancers),
                        _CategoryStrip(state: state),
                        _RegionFilterBar(state: state),
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
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        itemCount: state.ads.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => HarajAdCard(ad: state.ads[index]),
      ),
    );
  }

  /// Haraj-style top bar: a prominent "+" add-advertisement button (right /
  /// RTL-start), the brand logo + name centered, and a grid (browse categories)
  /// + notifications cluster on the left (RTL-end).
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
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 14.h),
          child: SizedBox(
            height: 44.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Centered brand lockup: the logo mark + a crisp wordmark so
                // the app name stays legible at header size.
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/new_logo.png',
                      height: 36.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'app_name'.tr(),
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // RTL-start (right): add a new advertisement.
                    _HeaderAddButton(
                      onTap: () {
                        if (!AuthGuard.ensureAuth(context)) return;
                        context.push('/add-advertisement');
                      },
                    ),
                    // RTL-end (left): notifications + browse-by-category grid.
                    Row(
                      children: [
                        _HeaderIconButton(
                          icon: Icons.notifications_none_rounded,
                          onTap: () => context.push('/notifications'),
                        ),
                        SizedBox(width: 8.w),
                        _HeaderIconButton(
                          icon: Icons.grid_view_rounded,
                          onTap: () => _openCategoryFilter(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Opens the "browse / filter by category" sheet using the home feed's
  /// loaded categories; selecting one filters the feed in place (same effect
  /// as tapping a tab in the pinned strip).
  void _openCategoryFilter(BuildContext context) {
    final cubit = context.read<HomeFeedCubit>();
    final state = cubit.state;
    if (state is! HomeFeedLoaded) return;
    showCategoryFilterSheet(
      context,
      categories: state.categories,
      selectedId: state.selectedCategoryId,
      onSelect: cubit.selectCategory,
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

/// Prominent gold "+" button (Haraj-style) for posting a new advertisement.
class _HeaderAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gold,
              AppColors.gold.withValues(alpha: 0.82),
            ],
          ),
          borderRadius: BorderRadius.circular(13.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.40),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 26.sp),
      ),
    );
  }
}

/// Haraj-style horizontal freelancers rail shown above the category tabs.
/// Each item opens that freelancer's profile; "view all" opens the full list.
class _FreelancersRail extends StatelessWidget {
  final List<PhotographerEntity> freelancers;

  const _FreelancersRail({required this.freelancers});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.gold,
                  size: 18.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  AppStrings.homeFeedFreelancersTitle.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => context.push('/all-freelancers'),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      AppStrings.homeFeedViewAll.tr(),
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 92.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: freelancers.length,
              separatorBuilder: (_, __) => SizedBox(width: 14.w),
              itemBuilder: (context, index) {
                final f = freelancers[index];
                return GestureDetector(
                  onTap: () {
                    final id = f.freelancerId.isNotEmpty ? f.freelancerId : f.id;
                    if (id.isNotEmpty) context.push('/freelancer/$id');
                  },
                  child: SizedBox(
                    width: 64.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                          child: UserAvatar(
                            name: f.name,
                            imageUrl: f.imageUrl.isEmpty ? null : f.imageUrl,
                            size: 56,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          f.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

/// Haraj-style "المنطقة" (region) filter bar. Tapping opens the searchable
/// city picker; selecting a city filters the ads client-side. Shows a clear
/// affordance while a city is active.
class _RegionFilterBar extends StatelessWidget {
  final HomeFeedLoaded state;

  const _RegionFilterBar({required this.state});

  Future<void> _openPicker(BuildContext context) async {
    final cubit = context.read<HomeFeedCubit>();
    final picked = await showCityPickerSheet(
      context,
      selected: state.selectedCity,
      includeAllOption: true,
    );
    if (picked == null) return; // dismissed
    if (picked == kAllCities) {
      cubit.selectCity(null);
    } else {
      cubit.selectCity(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final city = state.selectedCity;
    final hasCity = city != null;
    final label = hasCity
        ? city.getLocalizedName(locale)
        : AppStrings.homeFeedRegionAll.tr();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => _openPicker(context),
            borderRadius: BorderRadius.circular(999.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: hasCity
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                  color: hasCity ? AppColors.gold : AppColors.grey200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: hasCity ? AppColors.gold : AppColors.grey600,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${AppStrings.homeFeedRegion.tr()}: $label',
                    style: TextStyle(
                      color: hasCity ? AppColors.gold : AppColors.textPrimary,
                      fontSize: 12.5.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16.sp,
                    color: hasCity ? AppColors.gold : AppColors.grey600,
                  ),
                ],
              ),
            ),
          ),
          if (hasCity)
            // Dedicated clear-filter affordance: resets to all regions.
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.read<HomeFeedCubit>().selectCity(null),
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 6.w),
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    color: AppColors.grey100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
          const Spacer(),
        ],
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

    // Build tab list: "All" first, then every category.
    final tabs = <Widget>[
      _CategoryTab(
        label: AppStrings.homeFeedAll.tr(),
        selected: state.selectedCategoryId == null,
        onTap: () => cubit.selectCategory(null),
      ),
      ...state.categories.map(
        (CategoryEntity c) => _CategoryTab(
          label: c.getLocalizedName(locale),
          selected: state.selectedCategoryId == c.id,
          onTap: () => cubit.selectCategory(c.id),
        ),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 1),
        ),
      ),
      child: SizedBox(
        height: 44.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: tabs.length,
          separatorBuilder: (_, __) => SizedBox(width: 4.w),
          itemBuilder: (context, index) => tabs[index],
        ),
      ),
    );
  }
}

/// Haraj-style category tab: text label with a gold underline indicator for
/// the active tab (no pill background).
class _CategoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.gold : AppColors.textSecondary,
                fontSize: 15.sp,
                fontFamily: 'Cairo',
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            SizedBox(height: 5.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3.h,
              width: 24.w,
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
