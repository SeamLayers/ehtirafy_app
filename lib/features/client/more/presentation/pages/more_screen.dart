import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/session/auth_guard.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/share/app_share_bottom_sheet.dart';
import 'package:ehtirafy_app/features/shared/settings/presentation/pages/platform_fees_screen.dart';

/// The "More" (المزيد) tab — a Haraj-style hub fronted by a prominent
/// "Add Advertisement / Offer" card, plus app actions and info links.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  AppSpacing.lg,
                  20.w,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AddAdvertisementCard(
                      onTap: () {
                        if (!AuthGuard.ensureAuth(context)) return;
                        context.push('/add-advertisement');
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _MenuCard(
                      children: [
                        _MoreTile(
                          icon: Icons.campaign_outlined,
                          title: AppStrings.moreMyAds.tr(),
                          onTap: () {
                            if (!AuthGuard.ensureAuth(context)) return;
                            context.push('/my-ads');
                          },
                        ),
                        _MoreTile(
                          icon: Icons.settings_outlined,
                          title: AppStrings.moreSettings.tr(),
                          onTap: () => context.push('/profile/settings'),
                        ),
                        _MoreTile(
                          icon: Icons.account_balance_outlined,
                          title: AppStrings.morePlatformFees.tr(),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlatformFeesScreen(),
                            ),
                          ),
                        ),
                        _MoreTile(
                          icon: Icons.share_outlined,
                          title: AppStrings.moreShareApp.tr(),
                          onTap: () => AppShareBottomSheet.show(context),
                          showDivider: false,
                        ),
                      ],
                    ),
                    if (GuestMode.isGuest) ...[
                      SizedBox(height: AppSpacing.lg),
                      _GuestHint(
                        onLogin: () => context.go('/auth/login'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final radius = BorderRadius.only(
      bottomLeft: Radius.circular(24.r),
      bottomRight: Radius.circular(24.r),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.18),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.dark, AppColors.textPrimary],
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: 1.5.h,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: Text(
                  AppStrings.moreTitle.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddAdvertisementCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddAdvertisementCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gold, Color(0xFFB8923F)],
          ),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.moreAddAdTitle.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.moreAddAdSubtitle.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.85),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: AppColors.gold, size: 20.sp),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.grey400,
                  size: 15.sp,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.grey100),
      ],
    );
  }
}

class _GuestHint extends StatelessWidget {
  final VoidCallback onLogin;

  const _GuestHint({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline_rounded, color: AppColors.gold, size: 22.sp),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.moreLoginToAdd.tr(),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: onLogin,
            child: Text(
              'guest.login'.tr(),
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
