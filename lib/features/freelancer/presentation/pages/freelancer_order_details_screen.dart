import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/financial_pledge_section.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';
import '../../domain/entities/freelancer_order_entity.dart';
import '../cubit/freelancer_orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';

class FreelancerOrderDetailsScreen extends StatefulWidget {
  final FreelancerOrderEntity order;

  const FreelancerOrderDetailsScreen({super.key, required this.order});

  @override
  State<FreelancerOrderDetailsScreen> createState() =>
      _FreelancerOrderDetailsScreenState();
}

class _FreelancerOrderDetailsScreenState
    extends State<FreelancerOrderDetailsScreen> {
  late ContractDetailsCubit _contractCubit;
  ContractDetailsEntity? _details;

  @override
  void initState() {
    super.initState();
    _contractCubit = sl<ContractDetailsCubit>();
    _contractCubit.getContractDetails(widget.order.id);
  }

  @override
  void dispose() {
    _contractCubit.close();
    super.dispose();
  }

  // Getters to abstract data source (Order vs Details)
  FreelancerOrderStatus get status {
    if (_details != null) {
      if (_details!.status == ContractStatus.completed) {
        return FreelancerOrderStatus.completed;
      }
      if (_details!.status == ContractStatus.cancelled ||
          _details!.status == ContractStatus.rejected ||
          _details!.status == ContractStatus.archived) {
        return FreelancerOrderStatus.cancelled;
      }
      if (_details!.status == ContractStatus.inProgress ||
          _details!.status == ContractStatus.awaitingAdminReview) {
        return FreelancerOrderStatus.inProgress;
      }
      if (_details!.status == ContractStatus.pendingPayment) {
        return FreelancerOrderStatus.inProgress;
      }
    }
    return widget.order.status;
  }

  String get serviceTitle =>
      _details?.serviceTitle ?? widget.order.serviceTitle;
  String get location => _details?.location ?? widget.order.location;
  DateTime get eventDate => _details?.date ?? widget.order.eventDate;
  double get price => _details?.budget ?? widget.order.price;
  String get clientName => _details?.customerName ?? widget.order.clientName;
  // Note: ContractDetailsEntity uses customerImage, but FreelancerOrderEntity uses clientImage
  // We should check if we have customerImage in _details
  String get clientImage => _details?.customerImage ?? widget.order.clientImage;
  String get description => _details?.description ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contractCubit,
      child: BlocConsumer<ContractDetailsCubit, ContractDetailsState>(
        listener: (context, state) {
          if (state is ContractDetailsSuccess) {
            setState(() {
              _details = state.contract;
            });
            // If contract is completed via action, pop or show success
            if (state.contract.status == ContractStatus.completed &&
                widget.order.status != FreelancerOrderStatus.completed) {
              Navigator.of(context).pop();
            }
          }
          if (state is ContractDetailsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: state is ContractDetailsLoading && _details == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    )
                  : Column(
                      children: [
                        _buildHeader(context),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (status == FreelancerOrderStatus.pending)
                                  _buildNewRequestBanner(context),
                                if (status == FreelancerOrderStatus.inProgress)
                                  _buildStatusDateRow(context),
                                if (status == FreelancerOrderStatus.inProgress)
                                  _buildTitle(context),
                                SizedBox(height: 16.h),
                                if (status == FreelancerOrderStatus.pending)
                                  _buildRequestedServiceCard(context),
                                if (status == FreelancerOrderStatus.pending)
                                  SizedBox(height: 16.h),
                                if (status == FreelancerOrderStatus.pending)
                                  _buildBookingDetailsCard(context),
                                if (status == FreelancerOrderStatus.pending)
                                  SizedBox(height: 16.h),
                                if (status == FreelancerOrderStatus.pending)
                                  _buildClientMessageCard(context),
                                _buildClientInfoCard(context),
                                SizedBox(height: 16.h),
                                if (status ==
                                    FreelancerOrderStatus.inProgress) ...[
                                  _buildDescriptionCard(context),
                                  SizedBox(height: 16.h),
                                  _buildDetailsCard(context),
                                  SizedBox(height: 16.h),
                                  _buildPaymentStatusCard(context),
                                ],
                                if (status == FreelancerOrderStatus.pending)
                                  _buildReminderCard(context),
                                SizedBox(height: 100.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              bottomNavigationBar: _buildBottomActions(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final title = status == FreelancerOrderStatus.pending
        ? 'مراجعة طلب حجز'
        : 'تفاصيل العقد';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Row(
            children: [
              RtlBackButton(color: Colors.white, size: 20.sp),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
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

  Widget _buildNewRequestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.gold, Color(0xFFB8944F)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.32),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'طلب حجز جديد!',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'تم الاستلام منذ ساعة',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDateRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'منذ 3 أيام',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.info.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: AppColors.info,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'جاري العمل',
                style: TextStyle(
                  color: AppColors.info,
                  fontSize: 12.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Text(
        serviceTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          height: 1.40,
        ),
      ),
    );
  }

  Widget _buildRequestedServiceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخدمة المطلوبة',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [AppColors.gold, Color(0xFFB8944F)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          price.toInt().toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.gold,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'ريال',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.05),
        border: Border.all(
          width: 1,
          color: AppColors.gold.withValues(alpha: 0.45),
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_note_outlined,
                color: AppColors.gold,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'تفاصيل الحجز المطلوبة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildBookingDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'تاريخ المناسبة',
            value: DateFormat('dd MMMM yyyy', 'ar').format(eventDate),
          ),
          SizedBox(height: 12.h),
          _buildBookingDetailRow(
            context,
            icon: Icons.access_time_outlined,
            label: 'وقت البدء المتوقع',
            value: '18:00 مساءً',
          ),
          SizedBox(height: 12.h),
          _buildBookingDetailRow(
            context,
            icon: Icons.location_on_outlined,
            label: 'الموقع',
            value: location,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 1,
          color: AppColors.gold.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.gold, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientMessageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.message_outlined,
                color: AppColors.gold,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'رسالة العميل',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(width: 1, color: AppColors.grey200),
            ),
            child: Text(
              'السلام عليكم، نحتاج تغطية كاملة لحفل الزفاف من الساعة 6 مساءً حتى 12 منتصف الليل. الحفل سيكون في قاعة الأفراح الكبرى ونتوقع حضور 300 ضيف. نرغب في الحصول على صور عالية الجودة للحفل بالكامل بالإضافة إلى فيديو تريلر. شكراً لكم.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات العميل',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              UserAvatar(
                name: clientName,
                imageUrl: clientImage,
                size: 48,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            color: AppColors.gold, size: 16.sp),
                        SizedBox(width: 2.w),
                        Text(
                          '4.8',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.gold,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.43,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '(12 طلب)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status == FreelancerOrderStatus.pending) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(width: 1, color: AppColors.grey200),
                    ),
                    child: Center(
                      child: Text(
                        'عضو منذ 2023',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(width: 1, color: AppColors.grey200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '12',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.43,
                              ),
                        ),
                        Text(
                          'طلب سابق',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(width: 1, color: AppColors.gold),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline,
                        color: AppColors.gold, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'عرض الملف الشخصي',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    if (description.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined,
                  color: AppColors.gold, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'الوصف',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              height: 1.63,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            icon: Icons.location_on_outlined,
            label: 'الموقع',
            value: location,
          ),
          Divider(color: AppColors.grey200, height: 24.h),
          _buildDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'التاريخ',
            value: DateFormat('dd MMMM yyyy', 'ar').format(eventDate),
          ),
          Divider(color: AppColors.grey200, height: 24.h),
          _buildPriceRow(context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.gold, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.attach_money, color: AppColors.gold, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المبلغ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    price.toInt().toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.gold,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.56,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'ريال',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        border: Border.all(
          width: 1,
          color: AppColors.success.withValues(alpha: 0.45),
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الدفع',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'تم إيداع المبلغ لدى عدسة المناسبات',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.success,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'المبلغ محفوظ بشكل آمن وسيتم تحويله لك بعد تسليم الخدمة واستلام العميل.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        border: Border.all(
          width: 1,
          color: AppColors.info.withValues(alpha: 0.30),
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.63,
                ),
                children: const [
                  TextSpan(
                    text: 'تذكير: ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        'تأكد من توفرك في التاريخ والوقت قبل قبول الطلب. بعد القبول، سيتم إرسال إشعار للعميل لإتمام الدفع.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptOrderWithPledge(BuildContext context) async {
    final accepted = await showFinancialPledgeAgreementDialog(
      context,
      role: FinancialPledgeRole.advertiser,
      agreementAr: 'أقر وأوافق على هذا التعهد المالي قبل قبول العقد.',
      agreementEn:
          'I confirm and agree to this financial pledge before accepting the contract.',
    );

    if (!context.mounted || !accepted) return;

    context.read<FreelancerOrdersCubit>().acceptOrder(widget.order.id);
    context.pop();
  }

  Widget _buildBottomActions(BuildContext context) {
    if (status == FreelancerOrderStatus.pending) {
      return Container(
        padding: EdgeInsets.only(
          top: 17.h,
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1, color: AppColors.grey200),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _acceptOrderWithPledge(context),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'قبول الطلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Reject order
                  context.read<FreelancerOrdersCubit>().rejectOrder(
                    widget.order.id,
                  );
                  context.pop();
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(width: 1.5, color: AppColors.error),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'رفض الطلب',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 15.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // In Progress actions
    return Container(
      padding: EdgeInsets.only(
        top: 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 24.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1, color: AppColors.grey200),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Chat with client
              context.push(
                '/chat/conversation',
                extra: {
                  'id': widget.order.id,
                  'name': clientName,
                  'image': clientImage,
                  'userType': 'freelancer',
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(width: 1.5, color: AppColors.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'مراسلة العميل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'تأكيد التسليم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    content: Text(
                      'هل أنت متأكد من رغبتك في تسليم الخدمة وإتمام العقد؟',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close dialog
                        },
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Deliver service (Complete contract)
                          // Use ContractDetailsCubit to update status
                          _contractCubit.completeContract(
                            widget.order.id,
                            isPhotographer: true,
                          );
                          Navigator.of(dialogContext).pop(); // Close dialog
                        },
                        child: const Text(
                          'تأكيد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تسليم الخدمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
