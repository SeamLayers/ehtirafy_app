import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/user_role_cubit.dart';
import '../bloc/user_role_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_spacing.dart';

/// Widget for switching between Client and Freelancer roles
class RoleSwitcherWidget extends StatelessWidget {
  const RoleSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRoleCubit, UserRoleState>(
      builder: (context, state) {
        if (state is! UserRoleLoaded) {
          return const SizedBox.shrink();
        }

        final currentRole = state.roleEntity.role;
        final isClient = currentRole == UserRole.client;

        return Container(
          margin: EdgeInsets.all(AppSpacing.lg),
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.roleCurrentLabel.tr()}: ${currentRole.displayName}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _RoleButton(
                      label: AppStrings.roleClient.tr(),
                      icon: Icons.person_outline,
                      isSelected: isClient,
                      onTap: () {
                        if (!isClient) {
                          context.read<UserRoleCubit>().switchRole(UserRole.client);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.roleSwitchedToClient.tr()),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _RoleButton(
                      label: AppStrings.roleFreelancer.tr(),
                      icon: Icons.camera_alt_outlined,
                      isSelected: !isClient,
                      onTap: () {
                        if (isClient) {
                          context.read<UserRoleCubit>().switchRole(UserRole.freelancer);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.roleSwitchedToFreelancer.tr()),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.grey100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.grey300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
