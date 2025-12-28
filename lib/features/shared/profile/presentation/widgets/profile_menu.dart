import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../manager/profile_cubit.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_tile.dart';

class ProfileMenu extends StatelessWidget {
  final UserRole currentRole;

  const ProfileMenu({super.key, required this.currentRole});

  @override
  Widget build(BuildContext context) {
    final isClient = currentRole == UserRole.client;

    return Column(
      children: [
        if (!isClient) ...[
          ProfileTile(
            title: 'profile.menu.my_gigs'.tr(),
            icon: Icons.work_outline,
            onTap: () {
              context.push('/freelancer/gigs');
            },
          ),
          SizedBox(height: 8.h),
          ProfileTile(
            title: 'profile.menu.portfolio'.tr(),
            icon: Icons.photo_library_outlined,
            onTap: () {
              context.push('/freelancer/portfolio');
            },
          ),
          SizedBox(height: 8.h),
        ],
        ProfileTile(
          title: 'profile.menu.edit_profile'.tr(),
          icon: Icons.edit_outlined,
          onTap: () {
            context.push('/profile/edit');
          },
        ),
        SizedBox(height: 8.h),
        ProfileTile(
          title: 'profile.menu.payment_methods'.tr(),
          icon: Icons.credit_card_outlined,
          onTap: () {
            context.push('/profile/wallet');
          },
        ),
        SizedBox(height: 8.h),
        ProfileTile(
          title: 'profile.menu.settings'.tr(),
          icon: Icons.settings_outlined,
          onTap: () {
            context.push('/profile/settings');
          },
        ),
        SizedBox(height: 8.h),
        ProfileTile(
          title: 'profile.logout'.tr(),
          icon: Icons.logout,
          isDestructive: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppStrings.profileLogoutConfirmationTitle.tr()),
                content: Text(AppStrings.profileLogoutConfirmationMessage.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppStrings.cancel.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<ProfileCubit>().logout();
                    },
                    child: Text(AppStrings.confirm.tr()),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
