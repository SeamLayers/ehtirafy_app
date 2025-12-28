import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import '../../../settings/presentation/pages/contact_us_screen.dart';
import '../../../settings/presentation/pages/privacy_policy_screen.dart';
import '../../../settings/presentation/pages/terms_conditions_screen.dart';
import '../widgets/profile_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: Text(
          'profile.menu.settings'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go('/auth/login');
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              ProfileTile(
                title: 'settings.change_password'.tr(),
                icon: Icons.lock_outline,
                onTap: () {
                  // Navigate to Change Password
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'settings.language'.tr(),
                icon: Icons.language,
                onTap: () {
                  // Navigate to Language Selection
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'settings.notifications'.tr(),
                icon: Icons.notifications_outlined,
                onTap: () {
                  // Navigate to Notification Settings
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'Debug FCM Token',
                icon: Icons.bug_report,
                onTap: () {
                  context.push('/debug/token');
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'settings.help_support'.tr(),
                icon: Icons.help_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  );
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'settings.privacy_policy'.tr(),
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
              ProfileTile(
                title: 'settings.terms_conditions'.tr(),
                icon: Icons.description_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TermsConditionsScreen(),
                    ),
                  );
                },
              ),
              ProfileTile(
                title: 'settings.terms_conditions'.tr(),
                icon: Icons.description_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TermsConditionsScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
              ProfileTile(
                title: 'profile.menu.logout'.tr(),
                icon: Icons.logout_rounded,
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  final cubit = context.read<ProfileCubit>();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('profile.logout_dialog.title'.tr()),
                      content: Text('profile.logout_dialog.message'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('cancel'.tr()),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            cubit.logout();
                          },
                          child: Text(
                            'profile.menu.logout'.tr(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
