import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/widgets/auth_text_field.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_state.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import 'package:ehtirafy_app/core/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  iconAsset: 'assets/images/new_logo.png',
                  title: AppStrings.authWelcomeBack.tr(),
                  subtitle: AppStrings.authLoginSubtitle.tr(),
                ),
                SizedBox(height: AppSpacing.lg),
                // Premium surface card hosting the login form
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.grey900 : Colors.white,
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
                  child: const _LoginForm(),
                ),
                SizedBox(height: AppSpacing.lg),
                // _SocialDivider(),
                // SizedBox(height: 12.h),
                // _SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context, LoginCubit cubit) async {
    final currentState = cubit.state;
    if (currentState is LoginLoading) return;

    // Get device token for push notifications
    String deviceToken = '';
    try {
      // First, try to request permission if not already granted
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Then get the token
      deviceToken = await NotificationService.getToken() ?? '';

      // If still empty, try getting FCM token directly
      if (deviceToken.isEmpty) {
        deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
      }

      // Fallback for simulators (iOS Simulator doesn't support push notifications)
      // Provide a placeholder token for testing
      if (deviceToken.isEmpty) {
        deviceToken = 'simulator_device_token';
        debugPrint('Using simulator fallback token');
      }

      debugPrint('Device token for login: $deviceToken');
    } catch (e) {
      debugPrint('Failed to get device token: $e');
      // Use fallback token on error (e.g., simulator)
      deviceToken = 'simulator_device_token';
    }

    cubit.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      deviceToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // TODO: Save user/token to generic Cache Helper
          context.go('/home');
        } else if (state is LoginError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failureKey.tr())));
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              label: AppStrings.authEmailLabel.tr(),
              hint: AppStrings.authEmailHint.tr(),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: AppSpacing.md),
            AuthTextField(
              label: AppStrings.authPasswordLabel.tr(),
              hint: AppStrings.authPasswordHint.tr(),
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.xs),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push('/auth/forgot-password'),
                style: TextButton.styleFrom(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.authForgotPassword.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: AppStrings.authLoginButton.tr(),
              onPressed: () => _handleLogin(context, cubit),
              isLoading: state is LoginLoading,
            ),
            SizedBox(height: AppSpacing.lg),
            // Subtle divider before secondary actions
            Divider(
              height: 1.h,
              thickness: 1,
              color: AppColors.grey200,
            ),
            SizedBox(height: AppSpacing.md),
            // Inline text with clickable trailing action (no extra spacing)
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.authNoAccount.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.authCreateAccount.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/auth/signup'),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            // Continue as guest — browse without an account (guideline 5.1.1)
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await GuestMode.enter();
                  if (context.mounted) context.go('/home');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.gold,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: AppColors.gold.withValues(alpha: 0.08),
                ),
                icon: Icon(Icons.explore_outlined,
                    color: AppColors.gold, size: 18.sp),
                label: Text(
                  AppStrings.onboardingContinueAsGuest.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

