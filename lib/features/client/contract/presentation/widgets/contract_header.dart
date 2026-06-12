import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContractHeader extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractHeader({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Colors.white,
            AppColors.gold.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
            spreadRadius: -2.r,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.serviceTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    if (contract.serviceCategory.trim().isNotEmpty) ...[
                      SizedBox(height: AppSpacing.sm),
                      _buildCategoryChip(),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _buildStatusBadge(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(2.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: _buildAvatarImage(),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    final image = contract.photographerImage;
    final hasImage = image.isNotEmpty && image.startsWith('http');
    if (hasImage) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
      );
    }
    return _buildAvatarFallback();
  }

  Widget _buildAvatarFallback() {
    final name = contract.photographerName.trim();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, Color(0xFFD4AF37)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textLight,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_rounded,
            size: 14.r,
            color: AppColors.gold,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              contract.serviceCategory,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.gold,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');
    final canonical = canonicalBackendContractStatus(
      contract.contractStatus ?? contract.status.name,
    );
    final ui = backendContractStatusUi(canonical);
    final subtitle = backendStatusSubtitle(canonical, isArabic: isArabic);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ui.softColor,
        border: Border.all(color: ui.color.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: ui.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(ui.icon, color: ui.color, size: 14.r),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  canonical,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: ui.color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
