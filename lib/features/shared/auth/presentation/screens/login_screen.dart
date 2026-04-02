import 'package:flutter/gestures.dart';
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
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_state.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  iconAsset: 'assets/images/logocanon.png',
                  title: AppStrings.authWelcomeBack.tr(),
                  subtitle: AppStrings.authLoginSubtitle.tr(),
                ),
                SizedBox(height: 24.h),
                const _LoginForm(),
                SizedBox(height: 24.h),
                SizedBox(height: 24.h),
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
            SizedBox(height: 16.h),
            AuthTextField(
              label: AppStrings.authPasswordLabel.tr(),
              hint: AppStrings.authPasswordHint.tr(),
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push('/auth/forgot-password'),
                child: Text(
                  AppStrings.authForgotPassword.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              text: AppStrings.authLoginButton.tr(),
              onPressed: () => _handleLogin(context, cubit),
              isLoading: state is LoginLoading,
            ),
            SizedBox(height: 16.h),
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
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/auth/signup'),
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

