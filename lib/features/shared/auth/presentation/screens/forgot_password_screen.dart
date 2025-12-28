import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO: Update icon to something more password/lock related if available
                AuthHeader(
                  iconAsset: 'assets/icons/camera_icon.svg',
                  title: AppStrings.authForgotPassword.tr(),
                  subtitle: AppStrings.authForgotPasswordSubtitle.tr(),
                ),
                SizedBox(height: 32.h),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
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
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<ForgotPasswordCubit>();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          label: AppStrings.authEmailLabel.tr(),
                          hint: AppStrings.authEmailHint.tr(),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 32.h),
                        PrimaryButton(
                          text: AppStrings.authSendResetLink.tr(),
                          onPressed: () {
                            if (state is ForgotPasswordLoading) return;
                            cubit.sendResetLink(_emailController.text.trim());
                          },
                          isLoading: state is ForgotPasswordLoading,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
