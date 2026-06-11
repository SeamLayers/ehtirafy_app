import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import '../../../settings/presentation/pages/contact_us_screen.dart';
import '../../../settings/presentation/pages/platform_fees_screen.dart';
import '../../../settings/presentation/pages/privacy_policy_screen.dart';
import '../../../settings/presentation/pages/safety_center_screen.dart';
import '../../../settings/presentation/pages/terms_conditions_screen.dart';
import '../widgets/profile_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 8.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.dark, Color(0xFF2B2B2B)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'profile.menu.settings'.tr(),
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 17.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            leading: RtlBackButton(
              color: AppColors.textLight,
              onPressed: () => context.pop(),
            ),
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
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!GuestMode.isGuest) ...[
                _SettingsCard(
                  children: [
                    ProfileTile(
                      title: 'settings.change_password'.tr(),
                      icon: Icons.lock_outline,
                      onTap: () {
                        // Navigate to Change Password
                      },
                    ),
                    SizedBox(height: AppSpacing.sm + 4.h),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
              ],
              _SettingsCard(
                children: [
                  ProfileTile(
                    title: 'settings.language'.tr(),
                    icon: Icons.language,
                    onTap: () => _showLanguageSheet(context),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              _SettingsCard(
                children: [
                  ProfileTile(
                    title: 'settings_x.contact_us'.tr(),
                    icon: Icons.help_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactUsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.sm + 4.h),
                  ProfileTile(
                    title: 'settings_x.privacy_policy'.tr(),
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
                  SizedBox(height: AppSpacing.sm + 4.h),
                  ProfileTile(
                    title: 'settings_x.terms_of_use'.tr(),
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
                  SizedBox(height: AppSpacing.sm + 4.h),
                  ProfileTile(
                    title: 'settings_x.safety_center'.tr(),
                    icon: Icons.shield_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SafetyCenterScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.sm + 4.h),
                  ProfileTile(
                    title: 'settings_x.platform_fees'.tr(),
                    icon: Icons.account_balance_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PlatformFeesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (!GuestMode.isGuest) ...[
                SizedBox(height: AppSpacing.xl),
                ProfileTile(
                  title: 'profile.menu.logout'.tr(),
                  icon: Icons.logout_rounded,
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
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
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a bottom sheet allowing the user to switch the app language.
  ///
  /// The currently active locale (compared against [BuildContext.locale]) is
  /// marked with a check icon. Selecting an option persists the choice via
  /// easy_localization, which rebuilds the app automatically.
  void _showLanguageSheet(BuildContext context) {
    final Locale currentLocale = context.locale;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        Widget buildOption({
          required String label,
          required Locale locale,
        }) {
          final bool isSelected =
              currentLocale.languageCode == locale.languageCode;
          return ListTile(
            leading: Icon(
              Icons.language,
              color: isSelected ? AppColors.gold : AppColors.grey200,
            ),
            title: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.dark,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: AppColors.gold, size: 20.r)
                : null,
            onTap: () {
              context.setLocale(locale);
              Navigator.pop(sheetContext);
            },
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildOption(
                  label: 'العربية',
                  locale: const Locale('ar', 'SA'),
                ),
                buildOption(
                  label: 'English',
                  locale: const Locale('en', 'US'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Premium grouped surface that hosts a set of [ProfileTile]s with soft,
/// gold-tinted elevation and a subtle border.
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
