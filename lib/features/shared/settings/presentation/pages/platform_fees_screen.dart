import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import '../widgets/settings_ui_components.dart';

class PlatformFeesScreen extends StatelessWidget {
  const PlatformFeesScreen({super.key});

  static const List<String> _arabicFeeNotes = [
    'تقوم منصة ملم للمناسبات بتحصيل رسوم قدرها 1% من قيمة كل إعلان يتم عرضه.',
    'يتم تطبيق الرسوم بشكل واضح وموحد على الإعلانات المنشورة.',
  ];

  static const List<String> _englishFeeNotes = [
    'Malam Events platform collects a fee of 1% from the value of each published advertisement.',
    'The fee policy is applied clearly and consistently across published ads.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsPageScaffold(
      appBarTitle: 'رسوم المنصة / Platform Fees',
      heroIcon: Icons.receipt_long_outlined,
      heroTitle: 'سياسة رسوم واضحة',
      heroSubtitle:
          'نعرض تفاصيل الرسوم والبيانات المالية بوضوح كامل لضمان الشفافية بين جميع الأطراف.',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const [
            SettingsMetaChip(
              icon: Icons.percent_rounded,
              label: 'رسوم ثابتة 1%',
            ),
            SettingsMetaChip(
              icon: Icons.visibility_outlined,
              label: 'شفافية مالية',
            ),
            SettingsMetaChip(
              icon: Icons.approval_outlined,
              label: 'تطبيق موحد',
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gold.withValues(alpha: 0.16),
                AppColors.gold.withValues(alpha: 0.06),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.30),
                      AppColors.gold.withValues(alpha: 0.16),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.30),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.percent_rounded,
                  color: AppColors.gold,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رسوم المنصة / Platform Fee',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.75,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '1%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro: 'رسوم المنصة:',
          bullets: _arabicFeeNotes,
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro: 'Platform Fees:',
          bullets: _englishFeeNotes,
          isEnglish: true,
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsInfoTile(
          icon: Icons.account_balance_outlined,
          title: 'رقم الحساب / Account Number',
          value: '609000010006086201357',
          copyable: true,
        ),
        SizedBox(height: AppSpacing.sm),
        const SettingsInfoTile(
          icon: Icons.credit_card_outlined,
          title: 'رقم الآيبان / IBAN',
          value: 'SA3380000609608016201357',
          copyable: true,
        ),
        SizedBox(height: AppSpacing.sm),
        const SettingsInfoTile(
          icon: Icons.person_outline,
          title: 'اسم مستخدم الراجحي / Al Rajhi Username',
          value: '-',
        ),
      ],
    );
  }
}
