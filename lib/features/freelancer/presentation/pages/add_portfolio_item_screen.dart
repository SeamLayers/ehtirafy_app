import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/core/widgets/custom_text_field.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import '../cubit/freelancer_portfolio_cubit.dart';
import '../cubit/freelancer_portfolio_state.dart';
import '../../domain/entities/portfolio_item_entity.dart';

class AddPortfolioItemScreen extends StatefulWidget {
  final PortfolioItemEntity? portfolioItem;

  const AddPortfolioItemScreen({super.key, this.portfolioItem});

  @override
  State<AddPortfolioItemScreen> createState() => _AddPortfolioItemScreenState();
}

class _AddPortfolioItemScreenState extends State<AddPortfolioItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _pickedImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.portfolioItem != null) {
        context.read<FreelancerPortfolioCubit>().loadPortfolioItemDetails(
          widget.portfolioItem!.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: BlocListener<FreelancerPortfolioCubit, FreelancerPortfolioState>(
        listener: (context, state) {
          if (state is FreelancerPortfolioItemDetailsLoaded) {
            _titleController.text = state.item.title;
            _descriptionController.text = state.item.description;
            if (state.item.image != null && state.item.image!.isNotEmpty) {
              setState(() {
                _existingImageUrl = state.item.image;
              });
            }
          } else if (state is FreelancerPortfolioItemAdded) {
            context.pop(true);
          } else if (state is FreelancerPortfolioError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Card
                        _buildInfoBanner(),
                        SizedBox(height: AppSpacing.lg),

                        // Image Upload Section at top
                        _buildImageUploadWidget(),
                        SizedBox(height: AppSpacing.lg),

                        CustomTextField(
                          controller: _titleController,
                          label: AppStrings.freelancerPortfolioWorkTitle.tr(),
                          hint: 'مثال: جلسة تصوير زفاف',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال عنوان العمل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md),
                        CustomTextField(
                          controller: _descriptionController,
                          label: AppStrings.freelancerPortfolioWorkDescription
                              .tr(),
                          hint: 'وصف مختصر للعمل...',
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال وصف العمل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.lg),
                        _buildNoteCard(context),
                        SizedBox(height: AppSpacing.xl),
                        _buildSubmitButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.25),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.image_outlined,
              color: AppColors.info,
              size: 20.sp,
            ),
          ),
          SizedBox(width: AppSpacing.sm + 4.w),
          Expanded(
            child: Text(
              'أضف أفضل أعمالك لجذب العملاء المزيد',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: AppSpacing.md),
          child: Row(
            children: [
              RtlBackButton(color: Colors.white, size: 20.sp),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إضافة عمل في المحفظة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'اعرض أفضل أعمالك',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.gold.withValues(alpha: 0.9),
                          fontSize: 12.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Widget _buildImageUploadWidget() {
    final bool hasPicked = _pickedImage != null;
    final bool hasExisting =
        _existingImageUrl != null && _existingImageUrl!.isNotEmpty;
    final bool hasImage = hasPicked || hasExisting;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: ShapeDecoration(
          color: hasImage
              ? AppColors.grey100
              : AppColors.gold.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: hasImage ? 1.w : 1.8.w,
              color: hasImage
                  ? AppColors.grey200
                  : AppColors.gold.withValues(alpha: 0.55),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: hasPicked
            ? _buildPickedImagePreview()
            : hasExisting
            ? _buildExistingImagePreview()
            : _buildUploadPlaceholder(),
      ),
    );
  }

  Widget _buildPickedImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Image.file(_pickedImage!, fit: BoxFit.cover),
        ),
        _buildEditChip(),
      ],
    );
  }

  Widget _buildExistingImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: AppCachedNetworkImage(
            imageUrl: _existingImageUrl!,
            fit: BoxFit.cover,
            memCacheWidth: 1024,
            memCacheHeight: 1024,
            errorWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 32.sp,
                  color: AppColors.grey400,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'خطأ في تحميل الصورة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildEditChip(),
      ],
    );
  }

  /// Subtle "change image" affordance shown over a selected image.
  Widget _buildEditChip() {
    return PositionedDirectional(
      bottom: AppSpacing.sm,
      end: AppSpacing.sm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.dark.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 14.sp, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              AppStrings.freelancerPortfolioSelectImages.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 32.sp,
            color: AppColors.gold,
          ),
        ),
        SizedBox(height: AppSpacing.sm + 4.h),
        Text(
          AppStrings.freelancerPortfolioUploadImages.tr(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            AppStrings.freelancerPortfolioUploadHint.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 9.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                AppColors.gold,
                Color(0xFFB8923F),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.28),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  size: 16.sp, color: Colors.white),
              SizedBox(width: 6.w),
              Text(
                AppStrings.freelancerPortfolioSelectImages.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.info_outline,
              color: AppColors.gold,
              size: 20.sp,
            ),
          ),
          SizedBox(width: AppSpacing.sm + 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.freelancerPortfolioImportantNote.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.freelancerPortfolioReviewNote.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<FreelancerPortfolioCubit, FreelancerPortfolioState>(
      builder: (context, state) {
        final isLoading = state is FreelancerPortfolioItemAdding;

        return PrimaryButton(
          text: AppStrings.freelancerGigsSubmitForReview.tr(),
          isLoading: isLoading,
          onPressed: _submitForm,
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // For new items, image is required by the API
      if (widget.portfolioItem == null && _pickedImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يرجى اختيار صورة للعمل')));
        return;
      }

      if (widget.portfolioItem != null) {
        context.read<FreelancerPortfolioCubit>().updatePortfolioItem(
          id: widget.portfolioItem!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          imagePath: _pickedImage?.path,
        );
      } else {
        context.read<FreelancerPortfolioCubit>().addPortfolioItem(
          title: _titleController.text,
          description: _descriptionController.text,
          imagePath: _pickedImage?.path,
        );
      }
    }
  }
}
