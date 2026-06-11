import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_text_field.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/forgot_password_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.backgroundLight,
      appBar: AppBar(
        leading: const RtlBackButton(),
        title: Text(
          AppStrings.authForgotPassword.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle gold ambient wash at the top for a premium feel.
            Positioned(
              top: -60.h,
              left: -40.w,
              right: -40.w,
              child: Container(
                height: 220.h,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 0.9,
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.16 : 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      iconAsset: 'assets/images/new_logo.png',
                      title: AppStrings.authForgotPassword.tr(),
                      subtitle: AppStrings.authForgotPasswordSubtitle.tr(),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                      listener: (context, state) {
                        if (state is ForgotPasswordSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );
                          // Optionally navigate back or to verify code screen if that flow existed
                          context.push(
                            '/auth/reset-password',
                            extra: _emailController.text.trim(),
                          );
                        } else if (state is ForgotPasswordError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message.tr()),
                              backgroundColor: AppColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final cubit = context.read<ForgotPasswordCubit>();

                        return Container(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.grey900.withValues(alpha: 0.45)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.gold.withValues(alpha: 0.18)
                                  : AppColors.grey200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.06),
                                blurRadius: 18.r,
                                offset: Offset(0, 8.h),
                                spreadRadius: -4.r,
                              ),
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                label: AppStrings.authEmailLabel.tr(),
                                hint: AppStrings.authEmailHint.tr(),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                prefixWidget: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    start: 12.w,
                                    end: 8.w,
                                  ),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.gold,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),
                              PrimaryButton(
                                text: AppStrings.authSendResetLink.tr(),
                                onPressed: () {
                                  if (state is ForgotPasswordLoading) return;
                                  cubit.sendResetLink(
                                    _emailController.text.trim(),
                                  );
                                },
                                isLoading: state is ForgotPasswordLoading,
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
          ],
        ),
      ),
    );
  }
}
