import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contract.serviceTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            AppStrings.contractDescriptionLabel.tr(),
            contract.description,
            isDescription: true,
          ),
          Divider(color: Colors.white10, height: 24.h),
          _buildInfoRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('d MMMM yyyy', 'ar').format(contract.date),
            icon: Icons.calendar_today_outlined,
          ),
          if (contract.daysAvailability.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _buildInfoRow(
              AppStrings.contractDaysAvailability.tr(),
              contract.daysAvailability.join(', '),
              icon: Icons.event_available,
            ),
          ],
          SizedBox(height: 16.h),
          _buildInfoRow(
            AppStrings.contractBudgetLabel.tr(),
            '${NumberFormat('#,###').format(contract.budget)} ${AppStrings.bookingCurrency.tr()}',
            icon: Icons.monetization_on_outlined,
            isBudget: true,
          ),
          Divider(color: Colors.white10, height: 24.h),
          _buildCounterpartyInfo(),
        ],
      ),
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
          style: TextStyle(color: AppColors.grey500, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: isBudget ? AppColors.success : AppColors.textPrimary,
                  fontSize: 14.sp,
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
    // Use initials if image not available or if using initials design

    final image = isFreelancer
        ? contract.customerImage
        : contract.photographerImage;

    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (image.isNotEmpty && image.startsWith('http'))
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFC8A44F), Color(0xFFD4AF37)],
                  ),
          ),
          child: (image.isNotEmpty && image.startsWith('http'))
              ? ClipOval(
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          _getInitials(name),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    _getInitials(name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: AppColors.grey500, fontSize: 12.sp),
            ),
            Text(
              name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: contract.isChatAllowed ? onChat : null,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: contract.isChatAllowed
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.grey200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: contract.isChatAllowed
                  ? AppColors.primary
                  : AppColors.grey400,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
