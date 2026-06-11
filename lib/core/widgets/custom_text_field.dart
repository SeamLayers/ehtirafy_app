import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.obscureText,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Disabled surface stays subtle and on-theme; enabled inputs fall back to
    // the global inputDecorationTheme fillColor.
    final disabledFill =
        isDark ? AppColors.grey800.withValues(alpha: 0.5) : AppColors.grey100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 2.w, bottom: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4.w,
                height: 16.h,
                margin: EdgeInsetsDirectional.only(end: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: enabled ? 1 : 0.4),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: enabled
                        ? theme.textTheme.labelLarge?.color
                        : AppColors.textSecondary,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? isPassword,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: isPassword ? 1 : maxLines,
          enabled: enabled,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.gold,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            prefixIconColor: AppColors.gold,
            filled: true,
            fillColor: enabled ? null : disabledFill,
            isDense: false,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
