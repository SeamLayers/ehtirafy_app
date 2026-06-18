import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/financial_pledge_section.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/shared/cities/domain/entities/city_entity.dart';
import 'package:ehtirafy_app/features/shared/cities/presentation/widgets/city_picker_sheet.dart';
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
  CityEntity? _selectedCity;
  bool _hasAcceptedPledge = false;

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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.gig != null
                  ? AppStrings.addAdEditTitle.tr()
                  : AppStrings.addAdCreateTitle.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              widget.gig != null
                  ? AppStrings.addAdEditSubtitle.tr()
                  : AppStrings.addAdCreateSubtitle.tr(),
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
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const RtlBackButton(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: AppColors.grey200,
          ),
        ),
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

            // Pre-select city from the loaded ad (if the backend returned one).
            // We don't have the cities list here, so construct a CityEntity
            // straight from the ad's city names.
            if (state.gig.cityAr != null && state.gig.cityAr!.isNotEmpty) {
              setState(() {
                _selectedCity = CityEntity(
                  nameAr: state.gig.cityAr!,
                  nameEn: state.gig.cityEn ?? state.gig.cityAr!,
                );
              });
            }

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
              SnackBar(
                content: Text(AppStrings.addAdSuccess.tr()),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
            // Return into the main shell (keeps the bottom navigation and a
            // valid back stack) rather than a stranded top-level route.
            context.go('/home');
          } else if (state is FreelancerGigUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.addAdUpdated.tr())),
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
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
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
              padding: EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                          colors: [
                            AppColors.gold.withValues(alpha: 0.14),
                            AppColors.gold.withValues(alpha: 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.info_outlined,
                              color: AppColors.gold,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm + 4.w),
                          Expanded(
                            child: Text(
                              AppStrings.addAdInfoCard.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Image Upload Section
                    _buildSectionHeader(
                      Icons.image_outlined,
                      AppStrings.freelancerPortfolioUploadImages.tr(),
                    ),
                    SizedBox(height: AppSpacing.sm + 4.h),
                    _buildImageUploadWidget(),
                    SizedBox(height: AppSpacing.lg),

                    // Details card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title field
                          _buildLabel(
                            AppStrings.freelancerGigsTitleLabel.tr(),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _titleController,
                            decoration: _buildInputDecoration(
                              AppStrings.freelancerGigsTitleHint.tr(),
                              prefixIcon: Icons.title_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.validationRequired.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.md + 4.h),

                          // Description field
                          _buildLabel(
                            AppStrings.freelancerGigsDescriptionLabel.tr(),
                          ),
                          SizedBox(height: AppSpacing.sm),
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
                          SizedBox(height: AppSpacing.md + 4.h),

                          // Price field
                          _buildLabel(
                            AppStrings.freelancerGigsPriceLabel.tr(),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              AppStrings.freelancerGigsPriceHint.tr(),
                              prefixIcon: Icons.payments_outlined,
                              suffix: Text(
                                'ريال',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
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
                          SizedBox(height: AppSpacing.md + 4.h),

                          // Category dropdown - using real categories from API
                          _buildLabel(
                            AppStrings.freelancerGigsCategoryLabel.tr(),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          DropdownButtonFormField<CategoryEntity>(
                            initialValue: _selectedCategory,
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.gold,
                              size: 24.sp,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: _buildInputDecoration(
                              'اختر التصنيف',
                              prefixIcon: Icons.category_outlined,
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.nameAr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                          SizedBox(height: AppSpacing.md + 4.h),

                          // City selection (required) - long list, so we use a
                          // tappable field that opens a searchable bottom sheet
                          // instead of a dropdown.
                          _buildLabel(AppStrings.addAdCityLabel.tr()),
                          SizedBox(height: AppSpacing.sm),
                          _buildCityField(),
                          SizedBox(height: AppSpacing.md + 4.h),

                          // Days Availability
                          _buildLabel('أيام التوفر'),
                          SizedBox(height: AppSpacing.sm),
                          _buildDaysAvailabilityWidget(),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Important note
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
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
                          SizedBox(width: AppSpacing.sm + 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.freelancerPortfolioImportantNote
                                      .tr(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  AppStrings.freelancerPortfolioReviewNote.tr(),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12.sp,
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    if (widget.gig == null) ...[
                      _buildPledgeSection(),
                      SizedBox(height: AppSpacing.lg),
                    ],

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child:
                          BlocBuilder<FreelancerGigsCubit, FreelancerGigsState>(
                            builder: (context, state) {
                              final isLoading = state is FreelancerGigAdding;
                              final isPledgeAccepted =
                                  widget.gig != null || _hasAcceptedPledge;
                              return ElevatedButton(
                                onPressed:
                                    (isLoading || !isPledgeAccepted)
                                    ? null
                                    : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textLight,
                                  disabledBackgroundColor:
                                      AppColors.primary.withValues(alpha: 0.4),
                                  disabledForegroundColor:
                                      AppColors.textLight.withValues(
                                        alpha: 0.85,
                                      ),
                                  elevation: 0,
                                  shadowColor: AppColors.gold.withValues(
                                    alpha: 0.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
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
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.send_rounded,
                                            size: 18.sp,
                                            color: AppColors.textLight,
                                          ),
                                          SizedBox(width: AppSpacing.sm),
                                          Text(
                                            AppStrings
                                                .freelancerGigsSubmitForReview
                                                .tr(),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPledgeSection() {
    return FinancialPledgeSection(
      role: FinancialPledgeRole.advertiser,
      accepted: _hasAcceptedPledge,
      agreementAr: 'أقر وأوافق على هذا التعهد المالي قبل نشر الإعلان.',
      agreementEn:
          'I confirm and agree to this financial pledge before publishing the ad.',
      onAcceptedChanged: (value) {
        setState(() => _hasAcceptedPledge = value);
      },
    );
  }

  Widget _buildCityField() {
    return FormField<CityEntity>(
      initialValue: _selectedCity,
      validator: (value) {
        if (value == null) {
          return AppStrings.addAdCityRequired.tr();
        }
        return null;
      },
      builder: (field) {
        final hasError = field.hasError;
        final localeCode = context.locale.languageCode;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final city = await showCityPickerSheet(
                  context,
                  selected: _selectedCity,
                  includeAllOption: false,
                );
                if (city != null) {
                  setState(() => _selectedCity = city);
                  field.didChange(city);
                }
              },
              borderRadius: BorderRadius.circular(12.r),
              child: InputDecorator(
                isEmpty: _selectedCity == null,
                decoration: _buildInputDecoration(
                  AppStrings.addAdCityHint.tr(),
                  prefixIcon: Icons.location_on_outlined,
                ).copyWith(
                  errorText: hasError ? field.errorText : null,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.gold,
                    size: 24.sp,
                  ),
                  suffixIconConstraints: const BoxConstraints(),
                ),
                child: Text(
                  _selectedCity != null
                      ? _selectedCity!.getLocalizedName(localeCode)
                      : AppStrings.addAdCityHint.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: _selectedCity != null
                        ? AppColors.textPrimary
                        : AppColors.grey400,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDaysAvailabilityWidget() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.gold.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check_rounded,
                    size: 16.sp,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  _dayLabels[day] ?? day,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textLight
                        : AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageUploadWidget() {
    final bool hasImage =
        _pickedImage != null ||
        (_existingImageUrl != null && _existingImageUrl!.isNotEmpty);
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: ShapeDecoration(
          color: AppColors.gold.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: AppColors.gold.withValues(alpha: hasImage ? 0.3 : 0.45),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _pickedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.file(_pickedImage!, fit: BoxFit.cover),
                  ),
                  _buildEditImageBadge(),
                ],
              )
            : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: AppCachedNetworkImage(
                      imageUrl: _existingImageUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 1024,
                      memCacheHeight: 1024,
                      errorWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 32.sp,
                            color: AppColors.grey400,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'خطأ في تحميل الصورة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildEditImageBadge(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: ShapeDecoration(
                      color: AppColors.gold.withValues(alpha: 0.18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm + 4.h),
                  Text(
                    AppStrings.freelancerPortfolioUploadImages.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.freelancerPortfolioUploadHint.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 10.h,
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 16.sp,
                          color: AppColors.textLight,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppStrings.freelancerPortfolioSelectImages.tr(),
                          style: TextStyle(
                            color: AppColors.textLight,
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
              ),
      ),
    );
  }

  Widget _buildEditImageBadge() {
    return PositionedDirectional(
      bottom: AppSpacing.sm,
      end: AppSpacing.sm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.dark.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_outlined,
              size: 14.sp,
              color: AppColors.textLight,
            ),
            SizedBox(width: 6.w),
            Text(
              AppStrings.freelancerPortfolioSelectImages.tr(),
              style: TextStyle(
                color: AppColors.textLight,
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18.sp),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String hint, {
    Widget? suffix,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14.sp),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.grey500, size: 20.sp)
          : null,
      suffixIcon: suffix != null
          ? Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
              child: suffix,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  void _submitForm() {
    if (widget.gig == null && !_hasAcceptedPledge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على التعهد قبل النشر')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Validate image is selected for new gigs
      if (widget.gig == null && _pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.addAdImageRequired.tr())),
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

      // Validate a city is selected (required)
      if (_selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.addAdCityRequired.tr())),
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
          cityAr: _selectedCity!.nameAr,
          cityEn: _selectedCity!.nameEn,
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
          cityAr: _selectedCity!.nameAr,
          cityEn: _selectedCity!.nameEn,
          coverImage: _pickedImage?.path,
          availability: _selectedDays.toList(),
          images: images,
        );
      }
    }
  }
}
