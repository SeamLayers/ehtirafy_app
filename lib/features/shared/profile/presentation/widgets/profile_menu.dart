import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_tile.dart';

class ProfileMenu extends StatelessWidget {
  final UserRole currentRole;

  const ProfileMenu({super.key, required this.currentRole});

  @override
  Widget build(BuildContext context) {
    final isClient = currentRole == UserRole.client;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isClient) ...[
            ProfileTile(
              title: 'profile.menu.my_gigs'.tr(),
              icon: Icons.work_outline,
              onTap: () {
                context.push('/freelancer/gigs');
              },
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileTile(
              title: 'profile.menu.portfolio'.tr(),
              icon: Icons.photo_library_outlined,
              onTap: () {
                context.push('/freelancer/portfolio');
              },
            ),
            SizedBox(height: AppSpacing.sm),
          ],
          ProfileTile(
            title: 'profile.menu.edit_profile'.tr(),
            icon: Icons.edit_outlined,
            onTap: () {
              context.push('/profile/edit');
            },
          ),
          SizedBox(height: AppSpacing.sm),
          ProfileTile(
            title: 'profile.menu.settings'.tr(),
            icon: Icons.settings_outlined,
            onTap: () {
              context.push('/profile/settings');
            },
          ),
          SizedBox(height: AppSpacing.sm),
          ProfileTile(
            title: 'profile.logout'.tr(),
            icon: Icons.logout,
            isDestructive: true,
            onTap: () {
              // Capture the cubit from the current context
              final profileCubit = context.read<ProfileCubit>();

              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Text(
                    AppStrings.profileLogoutConfirmationTitle.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  content: Text(
                    AppStrings.profileLogoutConfirmationMessage.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        profileCubit.logout();
                      },
                      child: Text(
                        AppStrings.confirm.tr(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: AppSpacing.sm),
          ProfileTile(
            title: 'profile_menu_x.delete_account'.tr(),
            icon: Icons.delete_forever,
            isDestructive: true,
            onTap: () {
              final profileCubit = context.read<ProfileCubit>();

              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Text(
                    'profile_menu_x.delete_account_dialog_title'.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  content: Text(
                    'profile_menu_x.delete_account_dialog_message'.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        final state = profileCubit.state;
                        if (state is ProfileLoaded) {
                          profileCubit.deleteAccount(
                            state.userProfile.id.toString(),
                          );
                        }
                      },
                      child: Text(
                        'profile_menu_x.confirm_delete'.tr(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
