import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';

import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';

class HomeStatsSection extends StatelessWidget {
  final AppStatistics? statistics;

  const HomeStatsSection({super.key, this.statistics});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatMeta(
        label: 'home_stats.label_project'.tr(),
        value: statistics != null ? '${statistics!.contractsCount}+' : '2.5K+',
        hint: 'home_stats.hint_completed'.tr(),
        icon: Icons.work_outline_rounded,
      ),
      _StatMeta(
        label: 'home_stats.label_rating'.tr(),
        value: statistics != null ? '${statistics!.ratingAvg}' : '4.8+',
        hint: 'home_stats.hint_client_average'.tr(),
        icon: Icons.auto_awesome_rounded,
      ),
      _StatMeta(
        label: 'home_stats.label_beneficiary'.tr(),
        value: statistics != null ? '+${statistics!.usersCount}' : '+500',
        hint: 'home_stats.hint_trusted_client'.tr(),
        icon: Icons.groups_2_outlined,
      ),
    ];

    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
        itemCount: stats.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) =>
            _StatCard(stat: stats[index], index: index),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatMeta stat;
  final int index;

  const _StatCard({required this.stat, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palettes = [
      (AppColors.gold, const Color(0xFFFFF7E2)),
      (AppColors.info, const Color(0xFFEFF6FF)),
      (const Color(0xFF0F8B8D), const Color(0xFFE8FAFA)),
    ];
    final palette = palettes[index % palettes.length];
    final accent = palette.$1;
    final tint = palette.$2;

    return Container(
      width: 138.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Colors.white, tint.withValues(alpha: 0.55)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 10),
          ),
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Subtle decorative glow in the trailing corner.
            PositionedDirectional(
              top: -18.h,
              end: -18.w,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                14.w,
                14.h,
                14.w,
                14.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          accent.withValues(alpha: 0.28),
                          accent.withValues(alpha: 0.16),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(stat.icon, color: accent, size: 20.sp),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    stat.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Cairo',
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        stat.hint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMeta {
  final String label;
  final String value;
  final String hint;
  final IconData icon;

  const _StatMeta({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
  });
}
