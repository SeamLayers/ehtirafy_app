import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_text_field.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_state.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/country_code_picker_dialog.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupCubit>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                  title: AppStrings.authSignupTitle.tr(),
                  subtitle: AppStrings.authSignupSubtitle.tr(),
                ),
                SizedBox(height: AppSpacing.lg),
                const _SignupForm(),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // UI State
  Country _selectedCountry = const Country(
    name: 'Saudi Arabia',
    code: 'SA',
    dialCode: '966',
    flag: '🇸🇦',
  );

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupOtpSent) {
          // Show OTP if available (for debugging/fake backend)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP: ${state.otp}'),
              duration: const Duration(seconds: 10),
            ),
          );

          context.push(
            '/auth/otp?phone=${Uri.encodeComponent(_phoneController.text)}',
            extra: {
              'signupParams': {
                'fullName': _fullNameController.text,
                'email': _emailController.text,
                'phone': _phoneController.text,
                'password': _passwordController.text,
                'passwordConfirmation': _confirmPasswordController.text,
                'countryCode': _selectedCountry.dialCode,
              },
              'otp': state.otp,
            },
          );
        } else if (state is SignupSuccess) {
          // Role selection removed: every user registers as a standard user
          // and lands on the unified home shell.
          context.go('/home');
        } else if (state is SignupError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failureKey.tr())));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.grey800
                      : AppColors.grey200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.06),
                    blurRadius: 24.r,
                    offset: Offset(0, 10.h),
                    spreadRadius: -6.r,
                  ),
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                    spreadRadius: -4.r,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    label: AppStrings.authFullNameLabel.tr(),
                    hint: AppStrings.authFullNameHint.tr(),
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AuthTextField(
                    label: AppStrings.authEmailLabel.tr(),
                    hint: AppStrings.authEmailHint.tr(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AuthTextField(
                    label: 'auth.phoneLabelOptional'.tr(),
                    hint: AppStrings.authPhoneHint.tr(),
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 12.w),
                        InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CountryCodePickerDialog(
                                onCountrySelected: (country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 4.h,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _selectedCountry.flag,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '+${_selectedCountry.dialCode}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.grey600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 24.h,
                          color: AppColors.grey300,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AuthTextField(
                    label: AppStrings.authPasswordLabel.tr(),
                    hint: AppStrings.authPasswordHint.tr(),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AuthTextField(
                    label: AppStrings.authConfirmPasswordLabel.tr(),
                    hint: AppStrings.authConfirmPasswordHint.tr(),
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16.sp,
                          color: AppColors.gold,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            AppStrings.authPasswordRequirements.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.grey400
                                  : AppColors.grey700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: AppStrings.authSignupButton.tr(),
              // Use builder to access the form state validation if needed, but controllers are here
              onPressed: () {
                // Basic validation (phone is optional per App Store guideline 5.1.1)
                if (_fullNameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppStrings.validationRequired.tr())),
                  );
                  return;
                }

                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppStrings.validationPasswordMismatch.tr()),
                    ),
                  );
                  return;
                }

                // If the user provided a phone number, verify it via OTP.
                // Otherwise create the account directly. Role selection has
                // been removed — everyone registers as a standard user.
                if (_phoneController.text.trim().isEmpty) {
                  context.read<SignupCubit>().signup(
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    phone: '',
                    password: _passwordController.text,
                    passwordConfirmation: _confirmPasswordController.text,
                    userType: 'client',
                    countryCode: _selectedCountry.dialCode,
                    deviceToken: '6666666',
                  );
                } else {
                  context.read<SignupCubit>().sendOtp(
                    _phoneController.text,
                    _selectedCountry.dialCode,
                  );
                }
              },
              isLoading:
                  state
                      is SignupLoading, // Kept this line as it's good practice and not explicitly removed
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.grey300.withValues(alpha: 0.7),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Icon(
                    Icons.diamond_outlined,
                    size: 14.sp,
                    color: AppColors.gold.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.grey300.withValues(alpha: 0.7),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.authHaveAccount.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.authLoginNow.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/auth/login'),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.authTermsPrefix.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.authTerms.tr(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.gold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    TextSpan(
                      text: AppStrings.authAnd.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.authPrivacy.tr(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.gold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
