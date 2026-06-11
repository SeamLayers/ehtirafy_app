import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/profile_tile.dart';
import '../widgets/role_switcher_card.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/entities/user_role.dart'
    as auth_role;

/// Shared AppBar used across both the authenticated and guest profile views.
/// Centered Cairo title on the dark brand surface with a soft rounded base and
/// a subtle gold-tinted shadow for a premium, non-harsh elevation.
PreferredSizeWidget _buildProfileAppBar() {
  return AppBar(
    backgroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    title: Text(
      'profile.title'.tr(),
      style: TextStyle(
        color: AppColors.textLight,
        fontSize: 17.sp,
        fontFamily: 'Cairo',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.textPrimary, AppColors.dark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24.r),
        bottomRight: Radius.circular(24.r),
      ),
    ),
  );
}

class SharedProfileScreen extends StatefulWidget {
  const SharedProfileScreen({super.key});

  @override
  State<SharedProfileScreen> createState() => _SharedProfileScreenState();
}

class _SharedProfileScreenState extends State<SharedProfileScreen> {
  UserRole? _previousRole;

  @override
  Widget build(BuildContext context) {
    // Guests can open the profile to reach settings & privacy, but they have
    // no account data — show a "login now" card instead of hitting the API.
    if (GuestMode.isGuest) {
      return const _GuestProfileView();
    }
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadUserProfile(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go('/auth/login');
          } else if (state is ProfileLoaded) {
            final newRole = state.userProfile.currentRole;

            // Sync RoleCubit with the new role from profile
            final authRole = newRole == UserRole.freelancer
                ? auth_role.UserRole.freelancer
                : auth_role.UserRole.client;

            sl<RoleCubit>().select(authRole);

            // Navigate if role changed (not first load)
            if (_previousRole != null && _previousRole != newRole) {
              if (newRole == UserRole.freelancer) {
                context.go('/freelancer/dashboard');
              } else {
                context.go('/home');
              }
            }

            _previousRole = newRole;
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: _buildProfileAppBar(),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                );
              } else if (state is ProfileError) {
                return ErrorStateWidget(
                  message: state.message,
                  retryText: 'retry'.tr(),
                  onRetry: () =>
                      context.read<ProfileCubit>().loadUserProfile(),
                );
              } else if (state is ProfileLoaded ||
                  state is ProfileRoleSwitching) {
                final user = (state is ProfileLoaded)
                    ? state.userProfile
                    : (state as ProfileRoleSwitching).userProfile;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoleSwitcherCard(currentRole: user.currentRole),
                          SizedBox(height: AppSpacing.lg),
                          ProfileHeader(user: user),
                          SizedBox(height: AppSpacing.lg),
                          ProfileMenu(currentRole: user.currentRole),
                          SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                    if (state is ProfileRoleSwitching)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.dark.withValues(alpha: 0.35),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadowLight,
                                    blurRadius: 18,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const CircularProgressIndicator(
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

/// Profile screen shown to guests (no account). Surfaces settings & privacy
/// (non-account features) and prompts login instead of showing account data.
class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildProfileAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LoginNowCard(),
            SizedBox(height: AppSpacing.lg),
            // Settings (privacy, terms, contact, language, etc.) — open to all.
            ProfileTile(
              title: 'profile.menu.settings'.tr(),
              icon: Icons.settings_outlined,
              onTap: () => context.push('/profile/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginNowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.textPrimary, AppColors.dark],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold.withValues(alpha: 0.22),
                  AppColors.gold.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.person_outline_rounded,
                color: AppColors.gold, size: 38.sp),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'guest.profileGreeting'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'guest.profileMessage'.tr(),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textLight.withValues(alpha: 0.72),
              fontSize: 13.sp,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/auth/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.textLight,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'guest.login'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go('/auth/signup'),
            child: Text(
              'guest.createAccount'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
