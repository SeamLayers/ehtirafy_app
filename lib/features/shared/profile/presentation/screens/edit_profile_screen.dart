import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
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

  final Color _primaryGold = const Color(0xFFC8A44F);
  final Color _darkText = const Color(0xFF2B2B2B);
  final Color _lightText = const Color(0xFF888888);

  final Color _inputBorder = const Color(0xFFE0E0E0);

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
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'profile.menu.edit_profile'.tr(),
                style: TextStyle(
                  color: _darkText,
                  fontSize: 18.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: _darkText,
                  size: 20.sp,
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final data = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'bio': _bioController.text,
                    };
                    context.read<ProfileCubit>().updateProfile(data);
                  },
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
                          ),
                        );
                      }
                      return Text(
                        'save'.tr(),
                        style: TextStyle(
                          color: _primaryGold,
                          fontSize: 16.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section - Using initials instead of photo
                  Center(
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_primaryGold, const Color(0xFFD4AF37)],
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryGold.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(
                            state is ProfileLoaded
                                ? state.userProfile.name
                                : '',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Form Fields
                  _buildSectionTitle('profile.edit.full_name'.tr()),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle('email'.tr()),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    readOnly: true,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14.sp,
                        color: _lightText,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'profile.edit.email_read_only'.tr(),
                        style: TextStyle(
                          color: _lightText,
                          fontSize: 12.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle('profile.edit.phone'.tr()),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle('profile.edit.bio'.tr()),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _bioController,
                    icon: Icons.edit_note_rounded,
                    maxLines: 4,
                    hint: 'profile.edit.bio_hint'.tr(),
                    alignTop: true,
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '${_bioController.text.length}/500',
                      style: TextStyle(
                        color: _lightText,
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _darkText,
        fontSize: 14.sp,
        fontFamily: 'Cairo',
        fontWeight: FontWeight.w600,
      ),
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
        color: readOnly ? const Color(0xFFF5F5F5) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: readOnly ? Colors.transparent : _inputBorder,
          width: 1,
        ),
        boxShadow: readOnly
            ? []
            : [
                BoxShadow(
                  color: const Color(0x08000000),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: alignTop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: alignTop ? 16.h : 0,
            ),
            child: Icon(icon, color: _primaryGold, size: 22.sp),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: alignTop ? 8.h : 4.h),
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                maxLines: maxLines,
                style: TextStyle(
                  color: readOnly ? _lightText : _darkText,
                  fontSize: 15.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: _lightText.withOpacity(0.7),
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

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
