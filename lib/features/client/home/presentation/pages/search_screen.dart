import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_cubit.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_state.dart';
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message.tr()));
                  } else if (state is SearchLoaded) {
                    if (state.isSearching) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.searchResults != null &&
                        state.searchResults!.isNotEmpty) {
                      return _buildSearchResults(context, state.searchResults!);
                    }
                    return _buildHistoryView(context, state);
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: const BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.grey600, size: 24.w),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
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
                          child: Icon(
                            Icons.close,
                            color: AppColors.grey400,
                            size: 20.w,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64.w, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              'ابحث عن مصورين أو خدمات',
              style: TextStyle(color: AppColors.grey600, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(24.w),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.searchRecentSearches.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.read<SearchCubit>().clearHistory(),
              child: Text(
                'مسح الكل',
                style: TextStyle(color: AppColors.gold, fontSize: 14.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...state.searchHistory.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildHistoryItem(context, item),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, SearchResultEntity item) {
    return GestureDetector(
      onTap: () {
        _searchController.text = item.title;
        context.read<SearchCubit>().search(item.title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(Icons.history, color: AppColors.grey400, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  context.read<SearchCubit>().deleteFromHistory(item.title),
              child: Icon(Icons.close, color: AppColors.grey400, size: 16.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    List<SearchResultEntity> results,
  ) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.w, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              'لا توجد نتائج',
              style: TextStyle(color: AppColors.grey600, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(24.w),
      itemCount: results.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildResultCard(context, results[index]);
      },
    );
  }

  Widget _buildResultCard(BuildContext context, SearchResultEntity result) {
    return GestureDetector(
      onTap: () => context.push('/freelancer/${result.id}'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            UserAvatar(name: result.title, size: 60, fontSize: 20.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (result.category != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      result.category!,
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                  if (result.rating != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.gold, size: 16.w),
                        SizedBox(width: 4.w),
                        Text(
                          result.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (result.reviewsCount != null) ...[
                          SizedBox(width: 4.w),
                          Text(
                            '(${result.reviewsCount})',
                            style: TextStyle(
                              color: AppColors.grey600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.grey400, size: 16.w),
          ],
        ),
      ),
    );
  }
}
