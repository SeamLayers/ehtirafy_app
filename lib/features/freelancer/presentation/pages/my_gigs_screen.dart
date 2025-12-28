import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import '../cubit/freelancer_gigs_cubit.dart';
import '../cubit/freelancer_gigs_state.dart';
import '../../domain/entities/gig_entity.dart';

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
        backgroundColor: const Color(0xFFF9F9F9),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocConsumer<FreelancerGigsCubit, FreelancerGigsState>(
                listener: (context, state) {
                  if (state is FreelancerGigAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إضافة الخدمة بنجاح')),
                    );
                    context.read<FreelancerGigsCubit>().loadGigs();
                  } else if (state is FreelancerGigAddError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is FreelancerGigsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FreelancerGigsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<FreelancerGigsCubit>().loadGigs(),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FreelancerGigsLoaded) {
                    if (state.gigs.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<FreelancerGigsCubit>().loadGigs(),
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: state.gigs.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
            if (result == true) {
              context.read<FreelancerGigsCubit>().loadGigs();
            }
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            AppStrings.freelancerGigsAddFirstGig.tr(),
            style: const TextStyle(color: Colors.white),
          ),
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
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: const BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.freelancerGigsTitle.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGigCard(BuildContext context, GigEntity gig) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        gig.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: ShapeDecoration(
                        color: _getStatusColor(gig.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        _getStatusText(gig.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Description
                Text(
                  gig.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF888888),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ريال',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF888888),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      gig.price.toInt().toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider and action buttons
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: Color(0xFFE5E5E5)),
              ),
            ),
            child: Row(
              children: [
                // Delete button
                GestureDetector(
                  onTap: () => _showDeleteDialog(context, gig.id),
                  child: Container(
                    width: 38.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFDC3545),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: const Color(0xFFDC3545),
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Edit button
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await context.push(
                        '/freelancer/gigs/create',
                        extra: gig,
                      );
                      if (result == true) {
                        context.read<FreelancerGigsCubit>().loadGigs();
                      }
                    },
                    child: Container(
                      height: 32.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: AppColors.primary),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
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
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          SizedBox(width: 4.w),
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

  Color _getStatusColor(GigStatus status) {
    switch (status) {
      case GigStatus.active:
        return const Color(0xFF28A745);
      case GigStatus.pending:
        return const Color(0xFFFFC107);
      case GigStatus.inactive:
        return const Color(0xFF6C757D);
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
      child: Container(
        width: 349.w,
        padding: EdgeInsets.all(32.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2, color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Icon(
                Icons.work_outline,
                size: 40.sp,
                color: const Color(0xFF888888),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.freelancerGigsEmptyState.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF2B2B2B),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.freelancerGigsEmptyStateSubtitle.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF888888),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () async {
                final result = await context.push('/freelancer/gigs/create');
                if (result == true) {
                  context.read<FreelancerGigsCubit>().loadGigs();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: ShapeDecoration(
                  color: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  AppStrings.freelancerGigsAddFirstGig.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String gigId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الخدمة'),
        content: const Text('هل أنت متأكد من حذف هذه الخدمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<FreelancerGigsCubit>().deleteGig(gigId);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
