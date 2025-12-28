import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.portfolioItem != null) {
      _titleController.text = widget.portfolioItem!.title;
      _descriptionController.text = widget.portfolioItem!.description;
    }
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
          if (state is FreelancerPortfolioItemAdded) {
            context.pop(true);
          } else if (state is FreelancerPortfolioError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Upload Section at top
                        _buildImageUploadWidget(),
                        SizedBox(height: 24.h),

                        _buildTextField(
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
                        SizedBox(height: 16.h),
                        _buildTextField(
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
                        SizedBox(height: 24.h),
                        _buildNoteCard(context),
                        SizedBox(height: 32.h),
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
                    AppStrings.freelancerPortfolioAddWork.tr(),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF2B2B2B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFB0B0B0),
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Widget _buildImageUploadWidget() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: ShapeDecoration(
          color: const Color(0x0CC8A44F),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFC8A44F)),
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: _pickedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(_pickedImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: ShapeDecoration(
                      color: const Color(0x33C8A34E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppStrings.freelancerPortfolioUploadImages.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF2B2B2B),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.freelancerPortfolioUploadHint.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.freelancerPortfolioSelectImages.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.freelancerPortfolioImportantNote.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.freelancerPortfolioReviewNote.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF666666),
                    fontSize: 12.sp,
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

        return SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    AppStrings.freelancerGigsSubmitForReview.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
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
