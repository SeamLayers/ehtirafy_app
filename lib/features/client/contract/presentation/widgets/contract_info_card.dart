import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContractInfoCard extends StatelessWidget {
  final ContractDetailsEntity contract;
  final VoidCallback? onChat;
  final bool isFreelancer;

  const ContractInfoCard({
    super.key,
    required this.contract,
    this.onChat,
    this.isFreelancer = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeCode =
        context.locale.languageCode.toLowerCase().startsWith('ar') ? 'ar' : 'en';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
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
          _buildTitle(),
          SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            AppStrings.contractDescriptionLabel.tr(),
            contract.description,
            isDescription: true,
          ),
          _buildDivider(),
          _buildInfoRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('d MMMM yyyy', localeCode).format(contract.date),
            icon: Icons.calendar_today_outlined,
          ),
          if (contract.daysAvailability.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              AppStrings.contractDaysAvailability.tr(),
              contract.daysAvailability.join(', '),
              icon: Icons.event_available,
            ),
          ],
          SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            AppStrings.contractBudgetLabel.tr(),
            '${NumberFormat('#,###').format(contract.budget)} ${AppStrings.bookingCurrency.tr()}',
            icon: Icons.monetization_on_outlined,
            isBudget: true,
          ),
          _buildDivider(),
          _buildCounterpartyInfo(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 22.h,
          margin: EdgeInsetsDirectional.only(end: AppSpacing.sm),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gold, Color(0xFFD4AF37)],
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Expanded(
          child: Text(
            contract.serviceTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Divider(color: AppColors.grey200, height: 1.h, thickness: 1),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isDescription = false,
    IconData? icon,
    bool isBudget = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: (isBudget ? AppColors.success : AppColors.gold)
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: isBudget ? AppColors.success : AppColors.gold,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: isDescription ? 5 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isBudget ? AppColors.success : AppColors.textPrimary,
                  fontFamily: 'Cairo',
                  fontSize: isBudget ? 16.sp : 14.sp,
                  fontWeight: isBudget ? FontWeight.bold : FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterpartyInfo() {
    final name = isFreelancer
        ? contract.customerName
        : contract.photographerName;
    final label = isFreelancer
        ? AppStrings.contractCustomerName.tr()
        : AppStrings.bookingPhotographer.tr();

    final image = isFreelancer
        ? contract.customerImage
        : contract.photographerImage;

    return Row(
      children: [
        UserAvatar(
          name: name,
          imageUrl: image,
          size: 44,
          fontSize: 14.sp,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: contract.isChatAllowed ? onChat : null,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: contract.isChatAllowed
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : AppColors.grey200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: contract.isChatAllowed
                      ? AppColors.gold.withValues(alpha: 0.30)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: contract.isChatAllowed
                    ? AppColors.gold
                    : AppColors.grey400,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
