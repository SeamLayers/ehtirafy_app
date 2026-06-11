import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import '../cubit/freelancer_portfolio_cubit.dart';
import '../cubit/freelancer_portfolio_state.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

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
              child:
                  BlocBuilder<
                    FreelancerPortfolioCubit,
                    FreelancerPortfolioState
                  >(
                    builder: (context, state) {
                      // Load if initial
                      if (state is FreelancerPortfolioInitial) {
                        context
                            .read<FreelancerPortfolioCubit>()
                            .loadPortfolio();
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.gold,
                            ),
                          ),
                        );
                      }

                      if (state is FreelancerPortfolioLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.gold,
                            ),
                          ),
                        );
                      }

                      if (state is FreelancerPortfolioError) {
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () => context
                              .read<FreelancerPortfolioCubit>()
                              .loadPortfolio(),
                        );
                      }

                      if (state is FreelancerPortfolioLoaded) {
                        if (state.items.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return _buildPortfolioGrid(context, state.items);
                      }

                      return SizedBox.fromSize(size: Size.zero);
                    },
                  ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.push('/freelancer/portfolio/add');
            if (!context.mounted) return;
            if (result == true) {
              context.read<FreelancerPortfolioCubit>().loadPortfolio();
            }
          },
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 4,
          highlightElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.add_rounded, color: AppColors.textLight, size: 28.sp),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Row(
            children: [
              RtlBackButton(color: AppColors.textLight, size: 20.sp),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.freelancerPortfolioTitle.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40.w), // Balance for back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: EmptyStateWidget(
        message: AppStrings.freelancerPortfolioEmptyTitle.tr(),
        subMessage: AppStrings.freelancerPortfolioEmptySubtitle.tr(),
        icon: Icons.photo_library_outlined,
        retryText: AppStrings.freelancerPortfolioAddWork.tr(),
        onRetry: () async {
          final result = await context.push('/freelancer/portfolio/add');
          if (!context.mounted) return;
          if (result == true) {
            context.read<FreelancerPortfolioCubit>().loadPortfolio();
          }
        },
      ),
    );
  }

  Widget _buildPortfolioGrid(
    BuildContext context,
    List<PortfolioItemEntity> items,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.82,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildPortfolioItem(context, item);
        },
      ),
    );
  }

  Widget _buildPortfolioItem(BuildContext context, PortfolioItemEntity item) {
    return GestureDetector(
      onTap: () async {
        final result = await context.push(
          '/freelancer/portfolio/add',
          extra: item,
        );
        if (!context.mounted) return;
        if (result == true) {
          context.read<FreelancerPortfolioCubit>().loadPortfolio();
        }
      },
      onLongPress: () => _showDeleteDialog(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.grey200, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.grey100,
                  child: AppCachedNetworkImage(
                    imageUrl: item.image ?? 'https://picsum.photos/400/400',
                    fit: BoxFit.cover,
                    memCacheWidth: 512,
                    memCacheHeight: 512,
                    errorWidget: Icon(
                      Icons.image_outlined,
                      color: AppColors.grey400,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.sm + 2.w),
                color: AppColors.textLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PortfolioItemEntity item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          AppStrings.deleteConfirmation.tr(),
          style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          AppStrings.deletePortfolioItemConfirmation.tr(),
          style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              context.read<FreelancerPortfolioCubit>().deletePortfolioItem(
                item.id,
              );
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(
              AppStrings.delete.tr(),
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
