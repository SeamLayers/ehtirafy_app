import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestCardBase extends StatelessWidget {
  final VoidCallback onTap;
  final Widget avatar;
  final Widget title;
  final Widget subtitle;
  final Widget statusBadge;
  final Widget price;
  final Widget timeAgo;
  final Widget? footer;

  const RequestCardBase({
    super.key,
    required this.onTap,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.statusBadge,
    required this.price,
    required this.timeAgo,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18.r);

    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: AppColors.gold.withValues(alpha: 0.06),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.shadowLight.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    avatar,
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          SizedBox(height: AppSpacing.sm),
                          subtitle,
                          SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(child: statusBadge),
                              SizedBox(width: AppSpacing.sm),
                              Flexible(child: price),
                            ],
                          ),
                          SizedBox(height: AppSpacing.sm),
                          timeAgo,
                        ],
                      ),
                    ),
                  ],
                ),
                if (footer != null) ...[
                  SizedBox(height: AppSpacing.md),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.grey100,
                  ),
                  SizedBox(height: AppSpacing.md),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
