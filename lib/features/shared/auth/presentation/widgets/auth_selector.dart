import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class AuthSelector<T> extends StatelessWidget {
  final String label;
  final T groupValue;
  final List<AuthSelectorItem<T>> items;
  final ValueChanged<T> onChanged;

  const AuthSelector({
    super.key,
    required this.label,
    required this.groupValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: items.map((item) {
            final isSelected = item.value == groupValue;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: GestureDetector(
                  onTap: () => onChanged(item.value),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold : Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected ? AppColors.gold : Colors.transparent,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AuthSelectorItem<T> {
  final String label;
  final T value;

  const AuthSelectorItem({required this.label, required this.value});
}
