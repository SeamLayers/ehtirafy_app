import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../../domain/entities/freelancer_order_entity.dart';
import '../cubit/freelancer_orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FreelancerOrderDetailsScreen extends StatelessWidget {
  final FreelancerOrderEntity order;

  const FreelancerOrderDetailsScreen({super.key, required this.order});

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.status == FreelancerOrderStatus.pending)
                      _buildNewRequestBanner(context),
                    if (order.status == FreelancerOrderStatus.inProgress)
                      _buildStatusDateRow(context),
                    if (order.status == FreelancerOrderStatus.inProgress)
                      _buildTitle(context),
                    SizedBox(height: 16.h),
                    if (order.status == FreelancerOrderStatus.pending)
                      _buildRequestedServiceCard(context),
                    if (order.status == FreelancerOrderStatus.pending)
                      SizedBox(height: 16.h),
                    if (order.status == FreelancerOrderStatus.pending)
                      _buildBookingDetailsCard(context),
                    if (order.status == FreelancerOrderStatus.pending)
                      SizedBox(height: 16.h),
                    if (order.status == FreelancerOrderStatus.pending)
                      _buildClientMessageCard(context),
                    _buildClientInfoCard(context),
                    SizedBox(height: 16.h),
                    if (order.status == FreelancerOrderStatus.inProgress) ...[
                      _buildDescriptionCard(context),
                      SizedBox(height: 16.h),
                      _buildDetailsCard(context),
                      SizedBox(height: 16.h),
                      _buildPaymentStatusCard(context),
                    ],
                    if (order.status == FreelancerOrderStatus.pending)
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
  }

  Widget _buildHeader(BuildContext context) {
    final title = order.status == FreelancerOrderStatus.pending
        ? 'مراجعة طلب حجز'
        : 'تفاصيل العقد';

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
                    title,
                    textAlign: TextAlign.center,
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

  Widget _buildNewRequestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        children: [
          Text(
            'طلب حجز جديد!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'تم الاستلام منذ ساعة',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
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
        Text(
          'منذ 3 أيام',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF888888),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: ShapeDecoration(
            color: const Color(0xFF17A2B8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'جاري العمل',
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
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Text(
        order.serviceTitle,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: const Color(0xFF2B2B2B),
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _buildRequestedServiceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخدمة المطلوبة',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'ريال',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF888888),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          order.price.toInt().toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.gold,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.40,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 56.w,
                height: 56.h,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 28.sp,
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
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0x0CC8A44F),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC8A44F)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الحجز المطلوبة',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 12.h),
          _buildBookingDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'تاريخ المناسبة',
            value: DateFormat('dd MMMM yyyy', 'ar').format(order.eventDate),
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
            value: order.location,
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
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF888888),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFFC8A44F), size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildClientMessageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.message_outlined,
                color: const Color(0xFF888888),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'رسالة العميل',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: ShapeDecoration(
              color: const Color(0xFFF9F9F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'السلام عليكم، نحتاج تغطية كاملة لحفل الزفاف من الساعة 6 مساءً حتى 12 منتصف الليل. الحفل سيكون في قاعة الأفراح الكبرى ونتوقع حضور 300 ضيف. نرغب في الحصول على صور احترافية للحفل بالكامل بالإضافة إلى فيديو تريلر. شكراً لكم.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF2B2B2B),
                fontSize: 16.sp,
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
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات العميل',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.clientName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          '★ 4.8',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.gold,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(12 طلب)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF888888),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFF17A2B8), Color(0xFF138496)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          if (order.status == FreelancerOrderStatus.pending) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'عضو منذ 2023',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '12',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF2B2B2B),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                        ),
                        Text(
                          'طلب سابق',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF888888),
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
              height: 36.h,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF17A2B8)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Center(
                child: Text(
                  'عرض الملف الشخصي',
                  style: TextStyle(
                    color: const Color(0xFF17A2B8),
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الوصف',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'نحتاج تصوير احترافي لمنتجاتنا الجديدة للاستخدام في التسويق الرقمي',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
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
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            icon: Icons.location_on_outlined,
            label: 'الموقع',
            value: order.location,
          ),
          Divider(color: const Color(0xFFE5E5E5), height: 24.h),
          _buildDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'التاريخ',
            value: DateFormat('dd MMMM yyyy', 'ar').format(order.eventDate),
          ),
          Divider(color: const Color(0xFFE5E5E5), height: 24.h),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF888888),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
        Icon(icon, color: const Color(0xFF888888), size: 20.sp),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المبلغ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF888888),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    order.price.toInt().toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.gold,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.56,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'ريال',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF888888),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.attach_money, color: const Color(0xFF888888), size: 20.sp),
      ],
    );
  }

  Widget _buildPaymentStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0x0C28A745),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF28A745)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الدفع',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'تم إيداع المبلغ لدى احترافي',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF28A745),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'المبلغ محفوظ بشكل آمن وسيتم تحويله لك بعد تسليم الخدمة واستلام العميل.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF888888),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xFF28A745),
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0x1917A2B8),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x3316A2B8)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF888888),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.63,
                ),
                children: const [
                  TextSpan(
                    text: 'تذكير: ',
                    style: TextStyle(
                      color: Color(0xFF2B2B2B),
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

  Widget _buildBottomActions(BuildContext context) {
    if (order.status == FreelancerOrderStatus.pending) {
      return Container(
        padding: EdgeInsets.only(
          top: 17.h,
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Accept order
                  context.read<FreelancerOrdersCubit>().acceptOrder(order.id);
                  context.pop();
                },
                child: Container(
                  height: 48.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF28A745),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'قبول الطلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
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
                  context.read<FreelancerOrdersCubit>().rejectOrder(order.id);
                  context.pop();
                },
                child: Container(
                  height: 48.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Color(0xFFDC3545),
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: const Color(0xFFDC3545),
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'رفض الطلب',
                        style: TextStyle(
                          color: const Color(0xFFDC3545),
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Chat with client
              context.push(
                '/chat/conversation',
                extra: {
                  'id': order.id,
                  'name': order.clientName,
                  'image': order.clientImage,
                  'userType': 'freelancer',
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'مراسلة العميل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
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
              final cubit = context.read<FreelancerOrdersCubit>();
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
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Deliver service (Complete contract)
                          cubit.completeOrder(order.id);
                          Navigator.of(dialogContext).pop(); // Close dialog
                          context.pop(); // Close screen
                        },
                        child: Text(
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
              height: 48.h,
              decoration: ShapeDecoration(
                color: const Color(0xFF28A745),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تسليم الخدمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
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
