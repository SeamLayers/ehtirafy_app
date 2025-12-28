import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_text_field.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_state.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_selector.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  iconAsset: 'assets/icons/camera_icon.svg',
                  title: AppStrings.authSignupTitle.tr(),
                  subtitle: AppStrings.authSignupSubtitle.tr(),
                ),
                SizedBox(height: 24.h),
                const _SignupForm(),
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
  String _selectedSex = 'male';
  String _selectedMaterialStatus = 'single';
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

          context.go(
            '/auth/otp?phone=${Uri.encodeComponent(_phoneController.text)}',
            extra: {
              'signupParams': {
                'fullName': _fullNameController.text,
                'email': _emailController.text,
                'phone': _phoneController.text,
                'password': _passwordController.text,
                'passwordConfirmation': _confirmPasswordController.text,
                'sex': _selectedSex,
                'maritalStatus': _selectedMaterialStatus,
                'countryCode': _selectedCountry.dialCode,
              },
              'otp': state.otp,
            },
          );
        } else if (state is SignupError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failureKey.tr())));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              label: AppStrings.authFullNameLabel.tr(),
              hint: AppStrings.authFullNameHint.tr(),
              controller: _fullNameController,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              label: AppStrings.authEmailLabel.tr(),
              hint: AppStrings.authEmailHint.tr(),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              label: AppStrings.authPhoneLabel.tr(),
              hint: AppStrings.authPhoneHint.tr(),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              prefixWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 12.w),
                  GestureDetector(
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
                    child: Row(
                      children: [
                        Text(
                          _selectedCountry.flag,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '+${_selectedCountry.dialCode}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.grey600),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 24.h,
                    color: Colors.grey[300],
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              label: AppStrings.authPasswordLabel.tr(),
              hint: AppStrings.authPasswordHint.tr(),
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              label: AppStrings.authConfirmPasswordLabel.tr(),
              hint: AppStrings.authConfirmPasswordHint.tr(),
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            SizedBox(height: 16.h),
            // Sex Selector
            AuthSelector<String>(
              label: AppStrings.authSexLabel.tr(),
              groupValue: _selectedSex,
              items: [
                AuthSelectorItem(
                  label: AppStrings.authMale.tr(),
                  value: 'male',
                ),
                AuthSelectorItem(
                  label: AppStrings.authFemale.tr(),
                  value: 'female',
                ),
              ],
              onChanged: (value) => setState(() => _selectedSex = value),
            ),
            SizedBox(height: 16.h),
            // Material Status Selector
            AuthSelector<String>(
              label: AppStrings.authMaritalStatusLabel.tr(),
              groupValue: _selectedMaterialStatus,
              items: [
                AuthSelectorItem(
                  label: AppStrings.authSingle.tr(),
                  value: 'single',
                ),
                AuthSelectorItem(
                  label: AppStrings.authMarried.tr(),
                  value: 'married',
                ),
              ],
              onChanged: (value) =>
                  setState(() => _selectedMaterialStatus = value),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.authPasswordRequirements.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              text: AppStrings.authSignupButton.tr(),
              // Use builder to access the form state validation if needed, but controllers are here
              onPressed: () {
                // Basic validation
                if (_fullNameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _phoneController.text.isEmpty ||
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

                context.read<SignupCubit>().sendOtp(
                  _phoneController.text,
                  _selectedCountry.dialCode,
                );
              },
              isLoading:
                  state
                      is SignupLoading, // Kept this line as it's good practice and not explicitly removed
            ),
            SizedBox(height: 16.h),
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
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/auth/login'),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.h),
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
