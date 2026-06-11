import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/rtl_back_button.dart';
import '../../../../../core/widgets/user_avatar.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadUserProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _nameController.text = state.userProfile.name;
            _emailController.text = state.userProfile.email;
            _phoneController.text = state.userProfile.phone;
            _bioController.text = state.userProfile.bio ?? '';
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            );
          }

          final String displayName =
              state is ProfileLoaded ? state.userProfile.name : '';

          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              shape: const Border(
                bottom: BorderSide(color: AppColors.grey200, width: 1),
              ),
              title: Text(
                'profile.menu.edit_profile'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              centerTitle: true,
              leadingWidth: 56.w,
              leading: RtlBackButton(onPressed: () => context.pop()),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: AppSpacing.sm),
                  child: TextButton(
                    onPressed: () {
                      final cubit = context.read<ProfileCubit>();
                      final currentState = cubit.state;

                      if (currentState is ProfileLoaded) {
                        final currentPhone = currentState.userProfile.phone;
                        final newPhone = _phoneController.text;

                        if (currentPhone != newPhone) {
                          _showOtpDialog(context, newPhone);
                          return;
                        }
                      }

                      _updateProfile(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.gold.withValues(alpha: 0.10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      minimumSize: Size(0, 36.h),
                    ),
                    child: BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileUpdateSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('profile.update_success'.tr()),
                            ),
                          );
                        } else if (state is ProfileError) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.gold,
                            ),
                          );
                        }
                        return Text(
                          'save'.tr(),
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 15.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section - Using initials instead of photo
                  Center(
                    child: UserAvatar(
                      name: displayName,
                      size: 120,
                      fontSize: 40.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  if (displayName.isNotEmpty)
                    Center(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  SizedBox(height: AppSpacing.xl),

                  // Form Card
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.grey200, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                        const BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('profile.edit.full_name'.tr()),
                        SizedBox(height: AppSpacing.sm),
                        _buildTextField(
                          controller: _nameController,
                          icon: Icons.person_outline_rounded,
                        ),
                        SizedBox(height: AppSpacing.lg),

                        _buildSectionTitle('email'.tr()),
                        SizedBox(height: AppSpacing.sm),
                        _buildTextField(
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          readOnly: true,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                'profile.edit.email_read_only'.tr(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg),

                        _buildSectionTitle('profile.edit.phone'.tr()),
                        SizedBox(height: AppSpacing.sm),
                        _buildTextField(
                          controller: _phoneController,
                          icon: Icons.phone_outlined,
                        ),
                        SizedBox(height: AppSpacing.lg),

                        _buildSectionTitle('profile.edit.bio'.tr()),
                        SizedBox(height: AppSpacing.sm),
                        _buildTextField(
                          controller: _bioController,
                          icon: Icons.edit_note_rounded,
                          maxLines: 4,
                          hint: 'profile.edit.bio_hint'.tr(),
                          alignTop: true,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            '${_bioController.text.length}/500',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    String? hint,
    bool alignTop = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? AppColors.grey100 : AppColors.grey50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: readOnly ? AppColors.grey200 : AppColors.grey300,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: alignTop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.md,
              end: AppSpacing.md,
              top: alignTop ? AppSpacing.md : 0,
            ),
            child: Icon(
              icon,
              color: readOnly ? AppColors.grey400 : AppColors.gold,
              size: 22.sp,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: AppSpacing.md,
                top: alignTop ? AppSpacing.sm : 0,
                bottom: alignTop ? AppSpacing.sm : 0,
              ),
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                maxLines: maxLines,
                style: TextStyle(
                  color: readOnly
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    String? email;

    if (currentState is ProfileLoaded) {
      email = currentState.userProfile.email;
    } else {
      email = _emailController.text;
    }

    final data = {
      'name': _nameController.text,
      'email': email,
      'phone': _phoneController.text,
      'bio': _bioController.text,
      '_method': 'PUT',
    };
    cubit.updateProfile(data);
  }

  void _showOtpDialog(BuildContext context, String phone) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'profile.edit.verifyPhoneTitle'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile.edit.otpSentMessage'.tr(args: [phone]),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.grey50,
                hintText: 'profile.edit.enterOtpHint'.tr(),
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  color: AppColors.grey400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.gold, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppStrings.cancel.tr(),
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (otpController.text.isNotEmpty) {
                // Here we normally call verify API
                // For now we assume success and proceed to update
                Navigator.pop(ctx);
                _updateProfile(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              AppStrings.confirm.tr(),
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
