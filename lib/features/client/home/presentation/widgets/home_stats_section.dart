import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';

import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';

class HomeStatsSection extends StatelessWidget {
  final AppStatistics? statistics;

  const HomeStatsSection({super.key, this.statistics});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatMeta(
        label: 'مشروع',
        value: statistics != null ? '${statistics!.contractsCount}+' : '2.5K+',
        hint: 'منجز',
        icon: Icons.work_outline_rounded,
      ),
      _StatMeta(
        label: 'تقييم',
        value: statistics != null ? '${statistics!.ratingAvg}' : '4.8+',
        hint: 'متوسط العملاء',
        icon: Icons.auto_awesome_rounded,
      ),
      _StatMeta(
        label: 'مستفيد',
        value: statistics != null ? '+${statistics!.usersCount}' : '+500',
        hint: 'عميل موثوق',
        icon: Icons.groups_2_outlined,
      ),
    ];

    return SizedBox(
      height: 142.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: stats.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
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
      (const Color(0xFFC8A44F), const Color(0xFFFFF7E2)),
      (const Color(0xFF3A6EA5), const Color(0xFFEFF6FF)),
      (const Color(0xFF0F8B8D), const Color(0xFFE8FAFA)),
    ];
    final palette = palettes[index % palettes.length];

    return Container(
      width: 126.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.$1.withValues(alpha: 0.14), Colors.white],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: palette.$1.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: palette.$1.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: palette.$1.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(stat.icon, color: palette.$1, size: 18.sp),
          ),
          SizedBox(height: 7.h),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF888888),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          const Spacer(),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: palette.$1.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                stat.hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.$1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
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
