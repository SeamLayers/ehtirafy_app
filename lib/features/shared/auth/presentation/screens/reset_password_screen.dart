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
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/reset_password_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/reset_password_state.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: _ResetPasswordView(email: email),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  final String email;

  const _ResetPasswordView({required this.email});

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    iconAsset: 'assets/icons/camera_icon.svg', // Reusing icon
                    title: AppStrings.authResetPasswordTitle.tr(),
                    subtitle: AppStrings.authResetPasswordSubtitle.tr(),
                  ),
                  SizedBox(height: 32.h),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) {
                      if (state is ResetPasswordSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.go('/auth/login');
                      } else if (state is ResetPasswordError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          AuthTextField(
                            label: AppStrings.authOtpLabel.tr(),
                            hint: AppStrings.authOtpHint.tr(),
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.validationRequired.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          AuthTextField(
                            label: AppStrings.authPasswordLabel.tr(),
                            hint: AppStrings.authPasswordHint.tr(),
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.validationRequired.tr();
                              }
                              if (value.length < 8) {
                                return AppStrings.validationPasswordLength.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          AuthTextField(
                            label: AppStrings.authConfirmPasswordLabel.tr(),
                            hint: AppStrings.authConfirmPasswordHint.tr(),
                            controller: _confirmPasswordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.validationRequired.tr();
                              }
                              if (value != _passwordController.text) {
                                return AppStrings.validationPasswordMismatch
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.h),
                          PrimaryButton(
                            text: AppStrings.authResetPasswordButton.tr(),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .resetPassword(
                                      email: widget.email,
                                      otp: _otpController.text,
                                      password: _passwordController.text,
                                      passwordConfirmation:
                                          _confirmPasswordController.text,
                                    );
                              }
                            },
                            isLoading: state is ResetPasswordLoading,
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
      ),
    );
  }
}
