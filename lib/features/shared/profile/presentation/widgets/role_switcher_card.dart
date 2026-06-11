import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../../../shared/auth/domain/entities/user_role.dart' as auth_role;
import '../manager/profile_cubit.dart';
import '../../../../shared/auth/presentation/cubits/role_cubit.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class RoleSwitcherCard extends StatefulWidget {
  final UserRole currentRole;

  const RoleSwitcherCard({super.key, required this.currentRole});

  @override
  State<RoleSwitcherCard> createState() => _RoleSwitcherCardState();
}

class _RoleSwitcherCardState extends State<RoleSwitcherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotation;
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSwitchTap() async {
    if (_isSwitching) return;
    
    setState(() => _isSwitching = true);
    
    await _animationController.forward();
    
    if (mounted) {
      // Switch role through RoleCubit for proper navigation
          final newRole = widget.currentRole == UserRole.client
            ? auth_role.UserRole.freelancer
            : auth_role.UserRole.client;
      
      // Update via RoleCubit
      sl<RoleCubit>().switchRole(newRole);
      
      // Also update ProfileCubit for UI consistency
      context.read<ProfileCubit>().toggleRole();
    }
    
    await _animationController.reverse();
    
    if (mounted) {
      setState(() => _isSwitching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClient = widget.currentRole == UserRole.client;

    // Build the display text based on current role
    final browsingText = isClient
        ? 'role_card.browsing_as_client'.tr()
        : 'role_card.browsing_as_photographer'.tr();

    final switchText = isClient
        ? 'role_card.switch_to_photographer_mode'.tr()
        : 'role_card.switch_to_client_mode'.tr();

    // Per-role accent: gold for photographer, info-blue for client.
    final Color roleAccent = isClient ? AppColors.info : AppColors.gold;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -1.0),
            end: const Alignment(1.0, 1.0),
            colors: [
              AppColors.gold.withValues(alpha: 0.14),
              AppColors.gold.withValues(alpha: 0.04),
              Colors.white,
            ],
          ),
          shadows: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: AppColors.gold.withValues(alpha: 0.45),
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Header Row with role info
            Row(
              children: [
                // Animated Icon Container
                AnimatedBuilder(
                  animation: _iconRotation,
                  builder: (context, child) => Transform.rotate(
                    angle: _iconRotation.value * 3.14159,
                    child: child,
                  ),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gold.withValues(alpha: 0.28),
                          AppColors.gold.withValues(alpha: 0.10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.30),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isClient
                          ? Icons.person_outline
                          : Icons.camera_alt_outlined,
                      color: AppColors.gold,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm + 4.w),
                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Browsing as text
                      Text(
                        browsingText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      // Role badge with animated indicator
                      Row(
                        children: [
                          _buildAnimatedDot(isClient),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              isClient
                                  ? 'role_card.role_client'.tr()
                                  : 'role_card.role_photographer'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                // Role Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: roleAccent,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: roleAccent.withValues(alpha: 0.30),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    isClient
                        ? 'role_card.role_client'.tr()
                        : 'role_card.role_photographer'.tr(),
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 11.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            // Switch Button with animation
            GestureDetector(
              onTap: _isSwitching ? null : _onSwitchTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: _isSwitching
                        ? [
                            AppColors.gold.withValues(alpha: 0.6),
                            const Color(0xFFD4B85A).withValues(alpha: 0.6),
                          ]
                        : [AppColors.gold, const Color(0xFFD4B85A)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: _isSwitching
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSwitching)
                      SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.textLight),
                          strokeWidth: 2,
                        ),
                      )
                    else
                      Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.textLight,
                        size: 22.sp,
                      ),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        _isSwitching ? 'role_card.switching'.tr() : switchText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  Widget _buildAnimatedDot(bool isClient) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final Color dotColor = isClient ? AppColors.info : AppColors.gold;
        return Container(
          width: 8.w * value,
          height: 8.w * value,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // Trigger rebuild to loop animation
        if (mounted) setState(() {});
      },
    );
  }
}
