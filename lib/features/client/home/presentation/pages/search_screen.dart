import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_cubit.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_state.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>()..loadSearchHistory(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return _buildLoading();
                  } else if (state is SearchError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          state.message.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  } else if (state is SearchLoaded) {
                    final hasActiveSearch = state.searchResults != null;
                    return Column(
                      children: [
                        if (hasActiveSearch) _buildTypeTabs(context, state),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (state.isSearching) {
                                return _buildLoading();
                              }
                              if (hasActiveSearch) {
                                return _buildSearchResults(
                                  context,
                                  state.searchResults!,
                                );
                              }
                              return _buildHistoryView(context, state);
                            },
                          ),
                        ),
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

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          child: Row(
            children: [
              // Search is a bottom-nav tab root, so only show a back button
              // when this screen was actually pushed onto a navigator.
              if (Navigator.of(context).canPop()) ...[
                _HeaderIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppColors.gold,
                        size: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              cursorColor: AppColors.gold,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                              ),
                              onSubmitted: (query) {
                                if (query.isNotEmpty) {
                                  context.read<SearchCubit>().search(query);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: AppStrings.searchHint.tr(),
                                hintStyle: TextStyle(
                                  color: AppColors.grey400,
                                  fontSize: 14.sp,
                                  fontFamily: 'Cairo',
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            );
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            context.read<SearchCubit>().clearSearchResults();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: const BoxDecoration(
                              color: AppColors.grey100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.grey600,
                              size: 18.w,
                            ),
                          ),
                        ),
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

  Widget _buildHistoryView(BuildContext context, SearchLoaded state) {
    if (state.searchHistory.isEmpty) {
      return const CustomEmptyState(
        title: 'ابحث عن إعلانات أو معلِنين',
        icon: Icons.search_rounded,
        iconSize: 44,
      );
    }

    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: AppColors.gold,
                  size: 20.w,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.searchRecentSearches.tr(),
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.read<SearchCubit>().clearHistory(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.gold,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'مسح الكل',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        ...state.searchHistory.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildHistoryItem(context, item),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, SearchResultEntity item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          _searchController.text = item.title;
          context.read<SearchCubit>().search(item.title);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.grey200),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.history_rounded, color: AppColors.grey500, size: 20.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<SearchCubit>().deleteFromHistory(item.title),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.grey400,
                    size: 18.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTabs(BuildContext context, SearchLoaded state) {
    const tabs = <MapEntry<String, String>>[
      MapEntry('all', AppStrings.searchTypeAll),
      MapEntry('freelancer', AppStrings.searchTypeFreelancer),
      MapEntry('service', AppStrings.searchTypeService),
      MapEntry('work', AppStrings.searchTypeWork),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs) ...[
              _buildTypeTab(
                context,
                label: tab.value.tr(),
                isActive: state.selectedType == tab.key,
                onTap: () => context.read<SearchCubit>().setType(tab.key),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTab(
    BuildContext context, {
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.gold : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive ? AppColors.gold : AppColors.grey200,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    List<SearchResultEntity> results,
  ) {
    if (results.isEmpty) {
      return CustomEmptyState(
        title: AppStrings.searchNoResults.tr(),
        icon: Icons.search_off_rounded,
        iconSize: 44,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: results.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return _buildResultCard(context, results[index]);
      },
    );
  }

  void _onResultTap(BuildContext context, SearchResultEntity result) {
    switch (result.type) {
      case 'freelancer':
        context.push('/freelancer/${result.freelancerId ?? result.id}');
        break;
      case 'service':
        context.push(
          '/advertisement/${result.id}',
          extra: {
            'freelancerId': result.freelancerId,
            'freelancerName': result.title,
          },
        );
        break;
      case 'work':
        context.push('/work/${result.id}');
        break;
      case 'history':
        _searchController.text = result.title;
        context.read<SearchCubit>().search(result.title);
        break;
      default:
        context.push('/freelancer/${result.freelancerId ?? result.id}');
    }
  }

  Widget _buildResultCard(BuildContext context, SearchResultEntity result) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => _onResultTap(context, result),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              const BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              UserAvatar(
                name: result.title,
                imageUrl: result.imageUrl,
                size: 60,
                fontSize: 20.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (result.category != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        result.category!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                    if (result.rating != null) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.gold,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              result.rating!.toStringAsFixed(1),
                              style: TextStyle(
                                color: AppColors.dark,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            if (result.reviewsCount != null &&
                                result.reviewsCount! > 0) ...[
                              SizedBox(width: 4.w),
                              Text(
                                '(${result.reviewsCount})',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (result.type == 'service' && result.price != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        '${result.price}',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.grey400,
                size: 16.w,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18.w),
        ),
      ),
    );
  }
}
