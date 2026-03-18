import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import '../cubit/freelancer_portfolio_cubit.dart';
import '../cubit/freelancer_portfolio_state.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import 'package:ehtirafy_app/core/widgets/empty_state_widget.dart';
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
        backgroundColor: const Color(0xFFF9F9F9),
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FreelancerPortfolioLoading) {
                        return const Center(child: CircularProgressIndicator());
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
            if (result == true) {
              context.read<FreelancerPortfolioCubit>().loadPortfolio();
            }
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
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
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: const BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              RtlBackButton(color: Colors.white, size: 20.sp),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.freelancerPortfolioTitle.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w), // Balance for back button
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
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 0.h, bottom: 0.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
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
        if (result == true) {
          context.read<FreelancerPortfolioCubit>().loadPortfolio();
        }
      },
      onLongPress: () => _showDeleteDialog(context, item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D000000),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF5F5F5),
                  child: AppCachedNetworkImage(
                    imageUrl: item.image ?? 'https://picsum.photos/400/400',
                    fit: BoxFit.cover,
                    memCacheWidth: 512,
                    memCacheHeight: 512,
                    errorWidget: Icon(Icons.image, color: Colors.grey, size: 32.sp),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 10.sp,
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
        title: Text(AppStrings.deleteConfirmation.tr()),
        content: Text(AppStrings.deletePortfolioItemConfirmation.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              context.read<FreelancerPortfolioCubit>().deletePortfolioItem(
                item.id,
              );
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              AppStrings.delete.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
