import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import '../cubit/freelancer_gigs_cubit.dart';
import '../cubit/freelancer_gigs_state.dart';
import '../../domain/entities/gig_entity.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';

class MyGigsScreen extends StatefulWidget {
  const MyGigsScreen({super.key});

  @override
  State<MyGigsScreen> createState() => _MyGigsScreenState();
}

class _MyGigsScreenState extends State<MyGigsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FreelancerGigsCubit>().loadGigs();
  }

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
              child: BlocBuilder<FreelancerGigsCubit, FreelancerGigsState>(
                builder: (context, state) {
                  if (state is FreelancerGigsLoading) {
                    return Center(
                      child: SizedBox(
                        width: 38.w,
                        height: 38.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is FreelancerGigsError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<FreelancerGigsCubit>().loadGigs(),
                    );
                  }

                  if (state is FreelancerGigsLoaded) {
                    if (state.gigs.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<FreelancerGigsCubit>().loadGigs(),
                      color: AppColors.gold,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.xxl + AppSpacing.lg,
                        ),
                        itemCount: state.gigs.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final gig = state.gigs[index];
                          return _buildGigCard(context, gig);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await context.push('/freelancer/gigs/create');
            if (!context.mounted) return;
            if (result == true) {
              context.read<FreelancerGigsCubit>().loadGigs();
            }
          },
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 4,
          highlightElevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.textLight),
          label: Text(
            AppStrings.freelancerGigsAddFirstGig.tr(),
            style: TextStyle(
              color: AppColors.textLight,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
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
            color: AppColors.dark.withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          child: Row(
            children: [
              RtlBackButton(color: Colors.white, size: 20.sp),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.freelancerGigsTitle.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGigCard(BuildContext context, GigEntity gig) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        gig.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _buildStatusChip(gig.status),
                  ],
                ),
                SizedBox(height: AppSpacing.xs + 2.h),
                // Description
                Text(
                  gig.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.sm + 2.h),
                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'ريال',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: AppColors.gold,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            gig.price.toInt().toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: AppColors.gold,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider and action buttons
          Container(
            padding: EdgeInsets.all(AppSpacing.sm + 4.w),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: AppColors.grey200),
              ),
            ),
            child: Row(
              children: [
                // Delete button
                GestureDetector(
                  onTap: () => _showDeleteDialog(context, gig.id),
                  child: Container(
                    width: 40.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      border: Border.all(
                        width: 1,
                        color: AppColors.error.withValues(alpha: 0.40),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                // Edit button
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await context.push(
                        '/freelancer/gigs/create',
                        extra: gig,
                      );
                      if (!context.mounted) return;
                      if (result == true) {
                        context.read<FreelancerGigsCubit>().loadGigs();
                      }
                    },
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.08),
                        border: Border.all(
                          width: 1,
                          color: AppColors.primary.withValues(alpha: 0.55),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تعديل',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                              height: 1.43,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.edit_outlined,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(GigStatus status) {
    final Color color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.xs + 2.w),
          Text(
            _getStatusText(status),
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(GigStatus status) {
    switch (status) {
      case GigStatus.active:
        return AppColors.success;
      case GigStatus.pending:
        return AppColors.warning;
      case GigStatus.inactive:
        return AppColors.grey600;
    }
  }

  String _getStatusText(GigStatus status) {
    switch (status) {
      case GigStatus.active:
        return 'نشط';
      case GigStatus.pending:
        return 'قيد المراجعة';
      case GigStatus.inactive:
        return 'غير نشط';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: EmptyStateWidget(
        message: AppStrings.freelancerGigsEmptyState.tr(),
        subMessage: AppStrings.freelancerGigsEmptyStateSubtitle.tr(),
        icon: Icons.work_outline,
        retryText: AppStrings.freelancerGigsAddFirstGig.tr(),
        onRetry: () async {
          final result = await context.push('/freelancer/gigs/create');
          if (!context.mounted) return;
          if (result == true) {
            context.read<FreelancerGigsCubit>().loadGigs();
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String gigId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 22.sp,
              ),
            ),
            SizedBox(width: AppSpacing.sm + 2.w),
            Expanded(
              child: Text(
                'حذف الخدمة',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه الخدمة؟',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<FreelancerGigsCubit>().deleteGig(gigId);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              backgroundColor: AppColors.error.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(
              'حذف',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
