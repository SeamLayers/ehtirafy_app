import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/entities/user_role.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';

import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_state.dart';

class RoleSelectionScreen extends StatelessWidget {
  final Map<String, dynamic>? signupData;

  const RoleSelectionScreen({super.key, this.signupData});

  @override
  Widget build(BuildContext context) {
    // We need both RoleCubit (for selection UI) and SignupCubit (for API action)
    // If signupData is present, we are in registration flow.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RoleCubit>()),
        BlocProvider(create: (_) => sl<SignupCubit>()),
      ],
      child: _RoleSelectionView(signupData: signupData),
    );
  }
}

class _RoleSelectionView extends StatelessWidget {
  final Map<String, dynamic>? signupData;
  const _RoleSelectionView({this.signupData});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'roleSelection.title'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'roleSelection.subtitle'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: BlocBuilder<RoleCubit, RoleState>(
                  builder: (context, state) {
                    final cubit = context.read<RoleCubit>();
                    final selected = cubit.selected;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _RoleCard(
                            role: UserRole.client,
                            selected: selected == UserRole.client,
                            title: 'roleSelection.clientTitle'.tr(),
                            subtitle: 'roleSelection.clientSubtitle'.tr(),
                            description: 'roleSelection.clientDesc'.tr(),
                            badge1: 'roleSelection.clientBadge1'.tr(),
                            badge2: 'roleSelection.clientBadge2'.tr(),
                            onTap: () => cubit.select(UserRole.client),
                            gradient: (selected == UserRole.client)
                                ? LinearGradient(
                                    colors: [
                                      AppColors.gold.withValues(alpha: 0.07),
                                      Colors.transparent,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [Colors.white, AppColors.grey100],
                                  ),
                            borderColor: AppColors.grey300,
                          ),
                          SizedBox(height: 16.h),
                          _RoleCard(
                            role: UserRole.freelancer,
                            selected: selected == UserRole.freelancer,
                            title: 'roleSelection.freelancerTitle'.tr(),
                            subtitle: 'roleSelection.freelancerSubtitle'.tr(),
                            description: 'roleSelection.freelancerDesc'.tr(),
                            badge1: 'roleSelection.freelancerBadge1'.tr(),
                            badge2: 'roleSelection.freelancerBadge2'.tr(),
                            onTap: () => cubit.select(UserRole.freelancer),
                            gradient: (selected == UserRole.freelancer)
                                ? LinearGradient(
                                    colors: [
                                      AppColors.gold.withValues(alpha: 0.07),
                                      Colors.transparent,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [Colors.white, AppColors.grey100],
                                  ),
                            borderColor: AppColors.grey300,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(height: 24.h),
              BlocConsumer<SignupCubit, SignupState>(
                listener: (context, signupState) {
                  if (signupState is SignupSuccess) {
                    // Saves role locally as well
                    context
                        .read<RoleCubit>()
                        .save(); // We should await this or just let it happen?
                    // Ideally we want to ensure role is saved in prefs too if that's what RoleCubit does.
                    // But RoleCubit.save() emits RoleSaved.

                    // We might need to listen to RoleCubit too if we want to wait for local save.
                    // But usually successful signup implies we can go home.
                    // However, the requested flow is: Signup API call on this screen.

                    // Let's trigger role save first or parallel?
                    // Actually, if signup success, we are logged in.
                    context.go('/home');
                  } else if (signupState is SignupError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(signupState.failureKey.tr())),
                    );
                  }
                },
                builder: (context, signupState) {
                  return BlocBuilder<RoleCubit, RoleState>(
                    builder: (context, roleState) {
                      final roleCubit = context.read<RoleCubit>();
                      final isSaving =
                          roleState is RoleSaving ||
                          signupState is SignupLoading;

                      return PrimaryButton(
                        text: 'roleSelection.confirm'.tr(),
                        isLoading: isSaving,
                        onPressed: isSaving
                            ? () {}
                            : () async {
                                final selectedRole = roleCubit.selected;
                                if (signupData != null) {
                                  // Registration Flow
                                  final data = Map<String, dynamic>.from(
                                    signupData!,
                                  );
                                  data['userType'] = selectedRole
                                      .name; // 'client' or 'freelancer'

                                  // Call Signup API
                                  context.read<SignupCubit>().signup(
                                    fullName: data['fullName'],
                                    email: data['email'],
                                    phone: data['phone'],
                                    password: data['password'],
                                    passwordConfirmation:
                                        data['passwordConfirmation'],
                                    sex: data['sex'],
                                    materialStatus: data['maritalStatus'],
                                    userType: data['userType'],
                                    countryCode: data['countryCode'],
                                    deviceToken: '6666666',
                                  );

                                  // Also save preference locally
                                  roleCubit.save();
                                } else {
                                  // Just switching role flow (if accessed from settings)
                                  roleCubit.save();
                                  context.go('/home');
                                }
                              },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'roleSelection.footerNote'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final String title;
  final String subtitle;
  final String description;
  final String badge1;
  final String badge2;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final Color borderColor;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badge1,
    required this.badge2,
    required this.onTap,
    required this.gradient,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border.all(
            color: selected ? AppColors.gold : borderColor,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: selected
                          ? [
                              AppColors.gold,
                              AppColors.gold.withValues(alpha: 0.8),
                            ]
                          : [AppColors.grey100, AppColors.grey200],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    role == UserRole.client
                        ? Icons.person_search
                        : Icons.camera_alt,
                    color: selected ? Colors.white : AppColors.grey600,
                    size: 32.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _Badge(label: badge1, highlight: selected),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _Badge(label: badge2, highlight: selected),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool highlight;
  const _Badge({required this.label, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.gold.withValues(alpha: 0.1)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: highlight ? AppColors.gold : AppColors.grey600,
        ),
      ),
    );
  }
}
