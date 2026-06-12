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
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
            spreadRadius: -2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionRow(
            icon: Icons.calendar_today_rounded,
            label: AppStrings.contractDateLabel.tr(),
            value: DateFormat('d MMMM yyyy', localeCode).format(contract.date),
          ),
          _buildDivider(),
          _buildSectionRow(
            icon: Icons.location_on_rounded,
            label: AppStrings.contractLocationLabel.tr(),
            value: contract.location,
          ),
          if (contract.daysAvailability.isNotEmpty) ...[
            _buildDivider(),
            _buildSectionRow(
              icon: Icons.event_available_rounded,
              label: AppStrings.contractDaysAvailability.tr(),
              value: contract.daysAvailability.join(', '),
            ),
          ],
          _buildDivider(),
          _buildSectionRow(
            icon: Icons.payments_rounded,
            label: AppStrings.contractBudgetLabel.tr(),
            value:
                '${NumberFormat('#,###').format(contract.budget)} ${AppStrings.bookingCurrency.tr()}',
            valueColor: AppColors.gold,
            valueSize: 16.sp,
            valueWeight: FontWeight.w700,
            iconColor: AppColors.gold,
          ),
          if (contract.description.trim().isNotEmpty) ...[
            _buildDivider(),
            _buildSectionRow(
              icon: Icons.notes_rounded,
              label: AppStrings.contractDescriptionLabel.tr(),
              value: contract.description,
              stacked: true,
              maxLines: 6,
            ),
          ],
          _buildDivider(),
          _buildCounterpartyInfo(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Divider(color: AppColors.grey200, height: 1.h, thickness: 1),
    );
  }

  /// A section row following the section pattern: a leading rounded icon
  /// badge + label (textSecondary) + value (textPrimary). When [stacked] is
  /// true the value is rendered below the label for long text (description).
  Widget _buildSectionRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Color iconColor = AppColors.gold,
    double? valueSize,
    FontWeight valueWeight = FontWeight.w600,
    bool stacked = false,
    int maxLines = 3,
  }) {
    final iconBadge = Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 18.sp),
    );

    final labelWidget = Text(
      label,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'Cairo',
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    final valueWidget = Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: valueColor ?? AppColors.textPrimary,
        fontFamily: 'Cairo',
        fontSize: valueSize ?? 14.sp,
        fontWeight: valueWeight,
        height: 1.5,
      ),
    );

    if (stacked) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconBadge,
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                SizedBox(height: AppSpacing.xs),
                valueWidget,
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconBadge,
        SizedBox(width: AppSpacing.sm),
        labelWidget,
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: valueWidget,
          ),
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
                Icons.chat_bubble_rounded,
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
