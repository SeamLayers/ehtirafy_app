import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import '../cubit/freelancer_gigs_cubit.dart';
import '../cubit/freelancer_gigs_state.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/gig_entity.dart';

class CreateGigScreen extends StatefulWidget {
  final GigEntity? gig;

  const CreateGigScreen({super.key, this.gig});

  @override
  State<CreateGigScreen> createState() => _CreateGigScreenState();
}

class _CreateGigScreenState extends State<CreateGigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  CategoryEntity? _selectedCategory;

  // Days availability - Arabic day names
  final List<String> _dayOptions = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  final Map<String, String> _dayLabels = {
    'saturday': 'السبت',
    'sunday': 'الأحد',
    'monday': 'الإثنين',
    'tuesday': 'الثلاثاء',
    'wednesday': 'الأربعاء',
    'thursday': 'الخميس',
    'friday': 'الجمعة',
  };

  final Set<String> _selectedDays = {};

  // Image picker
  File? _pickedImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.gig != null) {
        context.read<FreelancerGigsCubit>().loadGigDetails(widget.gig!.id);
      } else {
        context.read<FreelancerGigsCubit>().loadGigs();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.gig != null ? 'تعديل الخدمة الحالية' : 'إضافة خدمة جديدة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.gig != null
                  ? 'قم بتعديل تفاصيل الخدمة الخاصة بك'
                  : 'قم بإنشاء حزمة خدمية احترافية',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: RtlBackButton(color: AppColors.textPrimary),
      ),
      body: BlocListener<FreelancerGigsCubit, FreelancerGigsState>(
        listener: (context, state) {
          if (state is FreelancerGigDetailsLoaded) {
            _titleController.text = state.gig.title;
            _descriptionController.text = state.gig.description;
            _priceController.text = state.gig.price.toInt().toString();

            // Handle existing image if available
            if (state.gig.coverImage.isNotEmpty) {
              _existingImageUrl = state.gig.coverImage;
            }

            // Set days availability
            setState(() {
              _selectedDays.clear();
              _selectedDays.addAll(state.gig.availability);
            });

            // Set category
            if (state.categories.isNotEmpty) {
              try {
                // Find matching category by ID
                final category = state.categories.firstWhere(
                  (c) => c.id.toString() == state.gig.category.toString(),
                  orElse: () => state.categories.first, // Fallback if mismtach?
                );
                setState(() => _selectedCategory = category);
              } catch (e) {
                // If filtering fails
              }
            }
          } else if (state is FreelancerGigAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة الخدمة بنجاح')),
            );
            context.pop(true);
          } else if (state is FreelancerGigUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث الخدمة بنجاح')),
            );
            context.pop(true);
          } else if (state is FreelancerGigAddError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is FreelancerGigUpdateError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<FreelancerGigsCubit, FreelancerGigsState>(
          builder: (context, state) {
            // Show loading while fetching gigs and categories
            if (state is FreelancerGigsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Get categories from state - handle multiple state types
            List<CategoryEntity> categories = [];
            if (state is FreelancerGigsLoaded) {
              categories = state.categories;
              debugPrint(
                'Categories loaded: ${categories.length} - ${categories.map((c) => c.nameAr).join(", ")}',
              );
            } else if (state is FreelancerGigDetailsLoaded) {
              // Ensure categories are available in this state too
              categories = state.categories;
            } else {
              debugPrint(
                'State is ${state.runtimeType}, categories may be empty',
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outlined,
                            color: AppColors.gold,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'حزمة الخدمة الواحدة = عرض واحد يمكن للعملاء طلبه',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Image Upload Section
                    _buildImageUploadWidget(),
                    SizedBox(height: 24.h),

                    // Title field
                    _buildLabel(AppStrings.freelancerGigsTitleLabel.tr()),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        AppStrings.freelancerGigsTitleHint.tr(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.validationRequired.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Description field
                    _buildLabel(AppStrings.freelancerGigsDescriptionLabel.tr()),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: _buildInputDecoration(
                        AppStrings.freelancerGigsDescriptionHint.tr(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.validationRequired.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Price field
                    _buildLabel(AppStrings.freelancerGigsPriceLabel.tr()),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        AppStrings.freelancerGigsPriceHint.tr(),
                        suffix: Text(
                          'ريال',
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.validationRequired.tr();
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'يرجى إدخال سعر صحيح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Category dropdown - using real categories from API
                    _buildLabel(AppStrings.freelancerGigsCategoryLabel.tr()),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<CategoryEntity>(
                      initialValue: _selectedCategory,
                      decoration: _buildInputDecoration('اختر التصنيف'),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.nameAr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategory = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return AppStrings.validationRequired.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Days Availability
                    _buildLabel('أيام التوفر'),
                    SizedBox(height: 8.h),
                    _buildDaysAvailabilityWidget(),
                    SizedBox(height: 32.h),

                    // Important note
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.freelancerPortfolioImportantNote
                                      .tr(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFF2B2B2B),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppStrings.freelancerPortfolioReviewNote.tr(),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: const Color(0xFF888888),
                                        fontSize: 12.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child:
                          BlocBuilder<FreelancerGigsCubit, FreelancerGigsState>(
                            builder: (context, state) {
                              final isLoading = state is FreelancerGigAdding;
                              return ElevatedButton(
                                onPressed: isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.freelancerGigsSubmitForReview
                                            .tr(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              );
                            },
                          ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDaysAvailabilityWidget() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _dayOptions.map((day) {
        final isSelected = _selectedDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDays.remove(day);
              } else {
                _selectedDays.add(day);
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFEEEEEE),
              ),
            ),
            child: Text(
              _dayLabels[day] ?? day,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2B2B2B),
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
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
            : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppCachedNetworkImage(
                  imageUrl: _existingImageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 1024,
                  memCacheHeight: 1024,
                  errorWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 32.sp, color: Colors.grey),
                      SizedBox(height: 4.h),
                      Text(
                        'خطأ في تحميل الصورة',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF2B2B2B),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFFAAAAAA), fontSize: 14.sp),
      suffixIcon: suffix != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: suffix,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validate image is selected for new gigs
      if (widget.gig == null && _pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار صورة للخدمة')),
        );
        return;
      }

      // Validate at least one day is selected
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار يوم واحد على الأقل للتوفر'),
          ),
        );
        return;
      }

      // Prepare images list
      final List<String> images = [];
      if (_pickedImage != null) {
        images.add(_pickedImage!.path);
      }

      if (widget.gig != null) {
        context.read<FreelancerGigsCubit>().updateGig(
          id: widget.gig!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory!.id.toString(),
          coverImage: _pickedImage?.path,
          availability: _selectedDays.toList(),
          images: images,
        );
      } else {
        context.read<FreelancerGigsCubit>().addGig(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory!.id.toString(),
          coverImage: _pickedImage?.path,
          availability: _selectedDays.toList(),
          images: images,
        );
      }
    }
  }
}
