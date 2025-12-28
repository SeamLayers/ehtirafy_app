import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_cubit.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_state.dart';

class RateServiceScreen extends StatefulWidget {
  final String freelancerId;
  final String freelancerName;
  final String serviceName;
  final String advertisementId;

  const RateServiceScreen({
    super.key,
    required this.freelancerId,
    required this.freelancerName,
    required this.serviceName,
    required this.advertisementId,
  });

  @override
  State<RateServiceScreen> createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends State<RateServiceScreen> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار تقييم',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<ReviewsCubit>().addRate(
      ratedUserId: widget.freelancerId,
      advertisementId: widget.advertisementId,
      rating: _rating,
      comment: _commentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFF2B2B2B),
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'تقييم الخدمة',
          style: TextStyle(
            color: const Color(0xFF2B2B2B),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ReviewsCubit, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewsLoading) {
            setState(() => _isSubmitting = true);
          } else if (state is ReviewsActionSuccess) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إرسال التقييم بنجاح',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
                ),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else if (state is ReviewsError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),

              // Freelancer info card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.gold,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.freelancerName,
                      style: TextStyle(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.serviceName,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Rating prompt
              Text(
                'كيف كانت تجربتك؟',
                style: TextStyle(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'يساعد تقييمك الآخرين في اختيار المصور المناسب',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // Star rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _rating = (index + 1).toDouble());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(
                        index < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.gold,
                        size: 44.sp,
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 8.h),

              // Rating text
              Text(
                _getRatingText(),
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),

              SizedBox(height: 32.h),

              // Comment field
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اكتب تعليقك (اختياري)',
                      style: TextStyle(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'شاركنا رأيك عن الخدمة...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFFEEEEEE),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFFEEEEEE),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        color: const Color(0xFF2B2B2B),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    disabledBackgroundColor: AppColors.gold.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating.toInt()) {
      case 1:
        return 'سيء';
      case 2:
        return 'مقبول';
      case 3:
        return 'جيد';
      case 4:
        return 'جيد جداً';
      case 5:
        return 'ممتاز';
      default:
        return '';
    }
  }
}
