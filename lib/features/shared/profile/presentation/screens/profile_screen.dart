import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/rtl_back_button.dart';

class ProfileScreen extends StatelessWidget {
  final bool isClient;
  const ProfileScreen({super.key, required this.isClient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          AppStrings.profileTitle.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        leading: Navigator.of(context).canPop()
            ? const RtlBackButton()
            : null,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          _buildHeaderCard(context, theme),
          SizedBox(height: AppSpacing.lg),
          _buildMenuCard(
            context,
            theme,
            isRtl: isRtl,
            children: [
              _MenuItem(
                icon: Icons.history_rounded,
                title: AppStrings.profileTransactions.tr(),
                onTap: () {},
              ),
              _buildDivider(),
              _MenuItem(
                icon: Icons.settings_outlined,
                title: AppStrings.profileSettings.tr(),
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _buildMenuCard(
            context,
            theme,
            isRtl: isRtl,
            children: [
              _MenuItem(
                icon: Icons.logout_rounded,
                title: AppStrings.profileLogout.tr(),
                isDestructive: true,
                showTrailing: false,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            AppColors.gold,
            AppColors.gold.withValues(alpha: 0.82),
            const Color(0xFFD4AF37),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Premium gold avatar placeholder
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textLight,
              border: Border.all(
                color: AppColors.textLight.withValues(alpha: 0.85),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'م',
              style: TextStyle(
                color: AppColors.gold,
                fontFamily: 'Cairo',
                fontSize: 40.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Role badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.dark.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: AppColors.textLight.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isClient
                      ? Icons.person_outline_rounded
                      : Icons.camera_alt_outlined,
                  color: AppColors.textLight,
                  size: 16.sp,
                ),
                SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    isClient
                        ? AppStrings.profileClientRole.tr()
                        : AppStrings.profileFreelancerRole.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'Cairo',
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    ThemeData theme, {
    required bool isRtl,
    required List<Widget> children,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey900 : AppColors.textLight,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.grey800
              : AppColors.grey200,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 64.w, end: AppSpacing.md),
      child: const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grey200,
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final bool showTrailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = isDestructive ? AppColors.error : AppColors.gold;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: 22.sp),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? AppColors.error
                        : theme.textTheme.titleMedium?.color,
                  ),
                ),
              ),
              if (showTrailing)
                Icon(
                  // chevron_right_rounded auto-mirrors under RTL (points left),
                  // so no manual isRtl swap is needed (avoids a double-flip).
                  Icons.chevron_right_rounded,
                  color: AppColors.grey400,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
