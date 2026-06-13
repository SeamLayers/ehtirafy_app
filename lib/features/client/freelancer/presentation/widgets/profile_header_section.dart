import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/share/app_share_bottom_sheet.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/profile_info_card.dart';

class ProfileHeaderSection extends StatelessWidget {
  final FreelancerEntity freelancer;

  const ProfileHeaderSection({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return SizedBox(
      height: 380.h, // Approx height to cover header + card overlap
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Layer 1: Background Header
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.dark, AppColors.textPrimary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.25),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Subtle gold glow accent for a premium feel
                Positioned(
                  top: -40.h,
                  right: isRtl ? null : -30.w,
                  left: isRtl ? -30.w : null,
                  child: Container(
                    width: 160.r,
                    height: 160.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0.22),
                          AppColors.gold.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.freelancerProfileTitle.tr(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontFamily: 'Cairo',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        _CircleIconButton(
                          icon: Icons.share_rounded,
                          onPressed: () => AppShareBottomSheet.show(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Layer 2: The Floating Profile Card
          Positioned(
            top: 140.h,
            left: 24.w,
            right: 24.w,
            child: ProfileInfoCard(freelancer: freelancer),
          ),
        ],
      ),
    );
  }
}

/// Glassy circular icon button used in the dark profile header.
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textLight.withValues(alpha: 0.12),
            border: Border.all(
              color: AppColors.textLight.withValues(alpha: 0.22),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.textLight,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
