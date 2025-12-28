import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';

class HomeStatsSection extends StatelessWidget {
  final AppStatistics? statistics;

  const HomeStatsSection({super.key, this.statistics});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _StatCard(
            label: 'مشروع',
            value: statistics != null
                ? '${statistics!.contractsCount}+'
                : '2.5K+',
            icon: Icons.work_outline,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'تقييم',
            value: statistics != null ? '${statistics!.ratingAvg}' : '4.8+',
            icon: Icons.star_border,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'مستفيد',
            value: statistics != null ? '+${statistics!.usersCount}' : '+500',
            icon: Icons.camera_alt_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
