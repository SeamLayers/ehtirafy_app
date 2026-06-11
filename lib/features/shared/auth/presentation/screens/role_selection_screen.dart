import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---- Header ----
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold,
                      AppColors.gold.withValues(alpha: 0.75),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.30),
                      blurRadius: 18.r,
                      offset: Offset(0, 8.h),
                      spreadRadius: -4.r,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.textLight,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'roleSelection.title'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'roleSelection.subtitle'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: BlocBuilder<RoleCubit, RoleState>(
                  builder: (context, state) {
                    final cubit = context.read<RoleCubit>();
                    final selected = cubit.selected;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.gold.withValues(alpha: 0.10),
                                      AppColors.gold.withValues(alpha: 0.02),
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isDark ? AppColors.grey900 : Colors.white,
                                      isDark
                                          ? AppColors.grey900
                                          : AppColors.grey50,
                                    ],
                                  ),
                            borderColor: isDark
                                ? AppColors.grey700
                                : AppColors.grey200,
                          ),
                          SizedBox(height: AppSpacing.md),
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
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.gold.withValues(alpha: 0.10),
                                      AppColors.gold.withValues(alpha: 0.02),
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isDark ? AppColors.grey900 : Colors.white,
                                      isDark
                                          ? AppColors.grey900
                                          : AppColors.grey50,
                                    ],
                                  ),
                            borderColor: isDark
                                ? AppColors.grey700
                                : AppColors.grey200,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.lg),
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
                          roleState is RoleSwitching ||
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
              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'roleSelection.footerNote'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.18),
                  blurRadius: 22.r,
                  offset: Offset(0, 10.h),
                  spreadRadius: -6.r,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 14.r,
                  offset: Offset(0, 6.h),
                  spreadRadius: -4.r,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: gradient,
              border: Border.all(
                color: selected ? AppColors.gold : borderColor,
                width: selected ? 2.w : 1.w,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.30),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                  spreadRadius: -2.r,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        role == UserRole.client
                            ? Icons.person_search
                            : Icons.camera_alt,
                        color: selected ? AppColors.textLight : AppColors.grey600,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: selected ? AppColors.gold : null,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _SelectIndicator(selected: selected),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _Badge(label: badge1, highlight: selected),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _Badge(label: badge2, highlight: selected),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectIndicator extends StatelessWidget {
  final bool selected;
  const _SelectIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.gold : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.gold : AppColors.grey300,
          width: 2.w,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Icon(Icons.check_rounded, size: 16.sp, color: AppColors.textLight)
          : null,
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
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.gold.withValues(alpha: 0.12)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: highlight
              ? AppColors.gold.withValues(alpha: 0.30)
              : AppColors.grey200,
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14.sp,
            color: highlight ? AppColors.gold : AppColors.grey500,
          ),
          SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: highlight ? AppColors.gold : AppColors.grey600,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
